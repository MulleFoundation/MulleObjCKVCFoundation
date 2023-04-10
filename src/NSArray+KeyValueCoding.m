//
//  NSArray+KeyValueCoding.m
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
#import "MulleObjCContainerKeyValueCoding.h"

// std-c and other dependencies

@interface NSObject( _NSNumber)

- (BOOL) __isNSNumber;

@end


#define INTERPRET_NUMERIC_KEYS

@implementation NSArray( _KeyValueCoding)

- (id) valueForKey:(NSString *) key
{
   NSUInteger   n;
   NSUInteger   i;

   NSCParameterAssert( [key isKindOfClass:[NSString class]]);

   n = [self count];
   if( ! n)
      return( nil);  // i am empty

#ifdef INTERPRET_NUMERIC_KEYS
   if( [key __isNSNumber])
   {
      i = [key integerValue];
      return( [self objectAtIndex:i]);
   }
#endif

   return( MulleObjCContainerValueForKey( self, key, [NSMutableArray arrayWithCapacity:n]));
}

@end


@implementation NSMutableArray ( _KeyValueCoding)

- (void) takeValue:(id) value
            forKey:(NSString *) key
{
#ifdef INTERPRET_NUMERIC_KEYS
   NSUInteger   i;

   if( [key __isNSNumber])
   {
      i = [key integerValue];
      if( i == [self count])
      {
         if( value)
            [self addObject:value];
         return;
      }
      if( value)
         [self replaceObjectAtIndex:i
                         withObject:value];
      else
         [self removeObjectAtIndex:i];
      return;
   }
#endif
   MulleObjCContainerTakeValueForKey( self, value, key);
}

@end
