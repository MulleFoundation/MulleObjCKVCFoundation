//
//  NSObject+KeyValueCoding.m
//  MulleObjCKVCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSObject+KeyValueCoding.h"

// other files in this library
#import "_MulleObjCKVCInformation.h"
#import "NSObject+_MulleObjCKVCInformation.h"
#import "NSNumber+MulleObjCKVCArithmetic.h"

// std-c and other dependencies
#import <MulleObjCValueFoundation/_MulleObjCASCIIString.h>
#import <MulleObjCValueFoundation/_MulleObjCCheatingASCIIString.h>


NSString   *NSUndefinedKeyException = @"NSUndefinedKeyException";



@interface NSString( Private) < NSStringFuture>

- (NSUInteger) mulleUTF8StringLength;

@end


@implementation NSObject( _KeyValueCoding)

+ (BOOL) useStoredAccessor
{
   return( YES);
}


- (id) valueForKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   id                                value;

   [self _getKVCInformation:&kvc
                     forKey:key
                 methodType:_MulleObjCKVCValueForKeyIndex];
   value = _MulleObjCGetObjectValueWithKVCInformation( self, &kvc);
   return( value);
}


- (id) storedValueForKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   id                                value;

   [self _getKVCInformation:&kvc
                     forKey:key
                       methodType:_MulleObjCKVCStoredValueForKeyIndex];
   value = _MulleObjCGetObjectValueWithKVCInformation( self, &kvc);
   return( value);
}


- (void) takeValue:(id) value
            forKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;

   [self _getKVCInformation:&kvc
                     forKey:key
                       methodType:_MulleObjCKVCTakeValueForKeyIndex];
   _MulleObjCSetObjectValueWithKVCInformation( self, value, &kvc);
}


- (void) takeStoredValue:(id) value
                  forKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;

   [self _getKVCInformation:&kvc
                     forKey:key
                       methodType:_MulleObjCKVCTakeStoredValueForKeyIndex];
   _MulleObjCSetObjectValueWithKVCInformation( self, value, &kvc);
}


// TODO: make this a plugin format, so that one can specify
//       dynamically collection operators
enum collection_operator
{
   no_opcode = -2,
   unknown_opcode = -1,
   count_opcode = 0,
   avg_opcode,
   min_opcode,
   max_opcode,
   sum_opcode
};


static enum collection_operator  operator_opcode( char *s, size_t len)
{
   if( len < 2 || *s != '@')
      return( no_opcode);

   switch( s[ 1])
   {
   case 'a' :
      if( ! strncmp( s, "@avg", len))
         return( avg_opcode);
      break;

   case 'c' :
      if( ! strncmp( s, "@count", len))
         return( count_opcode);
      break;

   case 'm' :
      if( ! strncmp( s, "@min", len))
         return( min_opcode);
      if( ! strncmp( s, "@max", len))
         return( max_opcode);
      break;

   case 's' :
      if( ! strncmp( s, "@sum", len))
         return( sum_opcode);
      break;
   }
   return( unknown_opcode);
}


static int  handle_operator( NSString *key, char *s, size_t len, char *rest, size_t rest_len, id *obj)
{
   enum collection_operator   opcode;
   id                         element;
   NSString                   *restPath;
   id                         previous;
   id                         value;
   id                         total;
   NSUInteger                 count;

   opcode = operator_opcode( (char *) s, len);
   switch( opcode)
   {
   case unknown_opcode :
      [NSException raise:NSInvalidArgumentException
                  format:@"%@ doesn't know what to do with %@", *obj, key];
   case no_opcode :
      return( 0);

   case count_opcode :
      *obj = [NSNumber numberWithUnsignedInteger:[*obj count]];
      return( 1);

   default :
      break;
   }

   restPath = nil;
   if( rest && rest_len)
      restPath = [NSString mulleStringWithUTF8Characters:(void *) rest
                                                  length:rest_len];
   value    = nil;
   previous = nil;

   switch( (int) opcode)
   {
   case min_opcode :
   case max_opcode :
      for( element in *obj)
      {
         value = element;
         if( restPath)
            value = [element valueForKeyPath:restPath];

         if( ! previous)
         {
            previous = value;
            continue;
         }
         if( ! value)
            continue;

         switch( [previous compare:value])
         {
         case NSOrderedSame :
            continue;
         case NSOrderedAscending :
            if( opcode == max_opcode)
               previous = value;
            break;
         case NSOrderedDescending :
            if( opcode == min_opcode)
               previous = value;
            break;
         }
      }

      *obj = previous;

      return( 1);

      // specification says to add "doubles" but this is
      // wrong when dealing with money (NSDecimalNumber)

   case avg_opcode :
   case sum_opcode :
      count = 0;
      total = [NSNumber numberWithInt:0];

      for( element in *obj)
      {
         value = element;
         if( restPath)
            value = [element valueForKeyPath:restPath];

         total = [value _add:total];
         count++;
      }

      if( opcode == avg_opcode && count > 1)
         *obj = [total _divideByInteger:count];
      else
         *obj = total;
   }
   return( 1);
}


- (id) valueForKeyPath:(NSString *) keyPath
{
   NSUInteger                                    len;
   char                                          *memo;
   char                                          *s;
   char                                          *sentinel;
   char                                          *substring;
   id                                            key;
   id                                            obj;
   size_t                                        substring_len;
   struct _MulleObjCCheatingASCIIStringStorage   storage;
   mulle_flexarray( buf, char, 0x100);

   s   = (char *) [keyPath UTF8String];
   len = [keyPath mulleUTF8StringLength];

   {
      mulle_flexarray_alloc( buf, len + 1);

      strcpy( buf, s);

   // this traverse_key_path handles operators
      {
         sentinel = &buf[ len]; // last cant be dot
         memo     = buf;
         obj      = self;

         for( s = buf; s < sentinel; s++)
         {
            if( *s != '.')
               continue;

            *s            = 0;
            substring     = memo;
            substring_len = s - memo;
            memo          = s + 1;

            key  = _MulleObjCCheatingASCIIStringStorageInit( &storage, substring, substring_len);
            if( handle_operator( key, substring, substring_len, memo, &buf[ len] - memo, &obj))
            {
               mulle_flexarray_done( buf);
               return( obj);
            }

            obj = [obj valueForKey:key];
         }
         mulle_flexarray_done( buf);
      }

      *s            = 0;
      substring     = memo;
      substring_len = s - memo;

      key = _MulleObjCCheatingASCIIStringStorageInit( &storage, substring, substring_len);
      if( handle_operator( key,
                          _MulleObjCCheatingASCIIStringStorageGetStorage( &storage),
                          _MulleObjCCheatingASCIIStringStorageGetLength( &storage),
                          NULL,
                          0,
                          &obj))
      {
         return( obj);
      }
   }

   return( [obj valueForKey:key]);
}


static id   traverse_key_path( id obj,
                              char *buf,
                              size_t len,
                              struct _MulleObjCCheatingASCIIStringStorage *tmp)
{
   char     *memo;
   char     *s;
   char     *sentinel;
   char     *substring;
   id       key;
   size_t   substring_len;

   sentinel = &buf[ len];
   memo     = buf;

   for( s = buf; s < sentinel; s++)
   {
      if( *s != '.')
         continue;

      *s            = 0;
      substring     = memo;
      substring_len = s - memo;
      memo          = s + 1;

      key  = _MulleObjCCheatingASCIIStringStorageInit( tmp, substring, substring_len);
      obj = [obj valueForKey:key];
   }

   *s            = 0;
   substring     = memo;
   substring_len = s - memo;

   _MulleObjCCheatingASCIIStringStorageInit( tmp, substring, substring_len);

   return( obj);
}



- (void) takeValue:(id) value
        forKeyPath:(NSString *) keyPath
{
   NSUInteger                                    len;
   char                                          *s;
   id                                            key;
   id                                            obj;
   struct _MulleObjCCheatingASCIIStringStorage   storage;

   s   = (char *) [keyPath UTF8String];
   len = [keyPath mulleUTF8StringLength];

   mulle_flexarray_do( buf, char, 0x100, len + 1)
   {
      memcpy( buf, s, len + 1);

      obj = traverse_key_path( self, buf, len, &storage);
   }

   key  = _MulleObjCCheatingASCIIStringStorageGetObject( &storage);
   [obj takeValue:value
           forKey:key];
}


- (id) handleQueryWithUnboundKey:(NSString *) key;
{
   [NSException raise:NSUndefinedKeyException
               format:@"%@ undefined on %@", key, self];
   return( nil);
}


- (id) valueForUndefinedKey:(NSString *) key
{
   [NSException raise:NSUndefinedKeyException
               format:@"%@ undefined on %@", key, self];
   return( nil);
}


- (void) handleTakeValue:(id) value
           forUnboundKey:(NSString *) key
{
   MulleObjCThrowInvalidArgumentException( @"unbound key %@ on %@", key, self);
}


- (void) unableToSetNilForKey:(NSString *)key
{
   MulleObjCThrowInvalidArgumentException( @"unable to set nil on %@ for key %@ on %@", self,  key);
}


- (NSDictionary *) valuesForKeys:(NSArray *) keys
{
   NSMutableDictionary   *dictionary;
   NSString              *key;
   id                    value;

   dictionary = [NSMutableDictionary dictionary];
   for( key in keys)
   {
      value = [self valueForKey:key];
      if( value)
         [dictionary setObject:value
                         forKey:key];
   }
   return( dictionary);
}


- (void) takeValuesFromDictionary:(NSDictionary *) properties
{
   NSString   *key;
   id         value;

   for( key in properties)
   {
      value = [properties objectForKey:key];
      [self takeValue:value
               forKey:key];
   }
}

@end


@implementation NSObject( _KeyValueCodingCompatibility)

// "modern" KVC interface
- (void) setValue:(id)value
           forKey:(NSString *) key
{
   [self takeValue:value
            forKey:key];
}


- (void) setValue:(id)value
           forKeyPath:(NSString *) key
{
   [self takeValue:value
        forKeyPath:key];
}


- (void) setValue:(id) value
   forUndefinedKey:(NSString *) key
{
   [self handleTakeValue:value
          forUnboundKey:key];
}


- (void) setNilValueForKey:(NSString *)key
{
   [self unableToSetNilForKey:key];
}


- (NSDictionary *) dictionaryWithValuesForKeys:(NSArray *) keys
{
   return( [self valuesForKeys:keys]);
}

@end
