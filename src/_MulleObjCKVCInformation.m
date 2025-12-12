//
//  _MulleObjCKVCInformation.m
//  MulleObjCKVCFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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
#import "_MulleObjCKVCInformation.h"

// other files in this library
#import "NSObject+_MulleObjCKVCInformation.h"

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies
#include <ctype.h>


#ifdef DEBUG
//# define DEBUG_VERBOSE
#endif


@interface NSString( Private) < NSStringFuture>
@end


#ifndef NS_BLOCK_ASSERTIONS
static BOOL  isSupportedObjCType( char c)
{
   switch( c)
   {
   case _C_BOOL :
   case _C_CHR  :
   case _C_UCHR :
   case _C_SHT  :
   case _C_USHT :

   case _C_INT  :
   case _C_UINT :
   case _C_LNG  :
   case _C_ULNG :

   case _C_LNG_LNG :
   case _C_ULNG_LNG :

   case _C_FLT :
   case _C_DBL :
#ifdef _C_LNG_DBL
   case _C_LNG_DBL :
#endif
   case _C_CLASS :
   case _C_SEL :
   case _C_ID :
   case _C_ASSIGN_ID :
   case _C_COPY_ID   :
      return( YES);
   }
   return( NO);
}
#endif


void   _MulleObjCKVCInformationUseUnboundKeyMethod( struct _MulleObjCKVCInformation *p,
                                                    Class aClass,
                                                    BOOL isSetter)
{
   NSCParameterAssert( p->valueType == _C_ID);

   p->selector  = isSetter
                     ? @selector( handleTakeValue:forUnboundKey:)
                     : @selector( handleQueryWithUnboundKey:);

   p->implementation = [aClass instanceMethodForSelector:p->selector];
}


static BOOL   useInstanceMethod( struct _MulleObjCKVCInformation *p,
                                 Class aClass,
                                 NSString *methodName,
                                 BOOL isSetter)
{
   SEL                         sel;
   struct _mulle_objc_method   *method;
   char                        *type;
   char                        *s;

   sel    = NSSelectorFromString( methodName);
   method = mulle_objc_class_defaultsearch_method( _mulle_objc_infraclass_as_class( aClass),
                                                  (mulle_objc_methodid_t) sel);

   if( ! method)
      return( NO);

// TODO: ugly fing hack. should parse method_types properly
   type  = _mulle_objc_method_get_signature( method);

   if( ! isSetter)
      p->valueType = type[ 0];
   else
   {
      s = &type[ strlen( type)];
      while( s > type && isdigit( *--s));
      if( *s == '"')
      {
         while( s > type && *--s != '"');
         if( s > type)
            --s;
      }

      p->valueType = s[ 0];
   }

   p->selector       = sel;
   p->implementation = (IMP) _mulle_objc_method_get_implementation( method);

#ifdef DEBUG_VERBOSE
   fprintf( stderr, "method 0x%08x\n", p->selector);
#endif

   NSCParameterAssert( isSupportedObjCType( p->valueType));
   return( YES);
}


static BOOL   useInstanceVariable( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   char                      *cString;
   struct _mulle_objc_ivar   *ivar;
   mulle_objc_ivarid_t       ivarid;

   // check for instance variable
   cString = (void *) [key UTF8String];
   ivarid  = mulle_objc_uniqueid_from_string( cString);
   ivar    = _mulle_objc_infraclass_search_ivar( aClass, ivarid);
   if( ! ivar)
      return( NO);

//
// TODO: should optionally check if protected or private and issue a warning in
//       debug mode on access for protected and abort (?) on private. Let it
//       slide for release. Need to know caller for that, so here just get
//       information and store it somewhere
//
   p->offset    = _mulle_objc_ivar_get_offset( ivar);
   p->valueType = _mulle_objc_ivar_get_signature( ivar)[ 0];

#ifdef DEBUG_VERBOSE
   fprintf( stderr, "ivar %ld type:%c\n", (long) p->offset, p->valueType);
#endif
   NSCParameterAssert( isSupportedObjCType( p->valueType));
   return( YES);
}


void   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p,
                                                             Class aClass,
                                                             NSString *key,
                                                             unsigned int mask)
{
   NSString   *methodName;
   NSString   *underscoreMethodName;
   NSString   *underscoreName;

   _MulleObjCKVCInformationInitWithKey( p, key);

   methodName           = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"set", key, YES);
   underscoreMethodName = [@"_" stringByAppendingString:methodName];

   // check for _setKey
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreMethodName, YES))
         return;

   if( [aClass accessInstanceVariablesDirectly])
   {
      underscoreName = [@"_" stringByAppendingString:key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;

      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, p->key))
            return;
   }

   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, methodName, YES))
         return;

   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, YES);
}


void   __MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p,
                                                       Class aClass,
                                                       NSString *key,
                                                       unsigned int mask)
{
   NSString   *methodName;
   NSString   *underscoreMethodName;
   NSString   *underscoreName;

   _MulleObjCKVCInformationInitWithKey( p, key);

   methodName = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"set", key, YES);

   // check for _set<Key>:
   if( mask & _MulleObjCKVCMethodBit)  // sic!
      if( useInstanceMethod( p, aClass, methodName, YES))
         return;

   underscoreMethodName = [@"_" stringByAppendingString:methodName];
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreMethodName, YES))
         return;

   if( [aClass accessInstanceVariablesDirectly])
   {
      // MEMO: (nat) this is apple bug compatible
      // this should be below _underscore
      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass,key))
            return;

      underscoreName = [@"_" stringByAppendingString:key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;
   }

   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, YES);
}


/*
 *  GETTER STUFF
 */
void   __MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p,
                                                         Class aClass,
                                                         NSString *key,
                                                         unsigned int mask)
{
   NSString   *getMethodName;
   NSString   *underscoreGetMethodName;
   NSString   *underscoreName;

   _MulleObjCKVCInformationInitWithKey( p, key);

   getMethodName = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"get", key, NO);

   underscoreGetMethodName = [@"_" stringByAppendingString:getMethodName];
   if( mask & _MulleObjCKVCUnderscoreGetMethodBit)
      if( useInstanceMethod( p, aClass, underscoreGetMethodName, NO))
         return;

   underscoreName = [@"_" stringByAppendingString:key];
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreName, NO))
         return;

   if( [aClass accessInstanceVariablesDirectly])
   {
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;

      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, key))
            return;
   }

   if( mask & _MulleObjCKVCGetMethodBit)
      if( useInstanceMethod( p, aClass, getMethodName, NO))
         return;

   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, key, NO))
         return;

   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, NO);
}


/*
 * What should be done is this. Figure out the class the accessor method /instance variable
 * is defined. Figure out where valueForKey is defined. If valueForKey is nearer or at the
 * same level as the instance variable / accessor, then use valueForKey as it probably has
 * some custom logic. Otherwise use the variable / accessor
 *
 * Possibility #2 check for NSObject and EOGenericObject implementations as they are "known"
 *
 * Possibility #3 ask the class to fill in KVC value information <-- this is best!!
 * (see NSObject+NSKVCInformation)
 */
void   __MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p,
                                                   Class aClass,
                                                   NSString *key,
                                                   unsigned int mask)
{
   NSString   *getMethodName;
   NSString   *underscoreGetMethodName;
   NSString   *underscoreName;

   _MulleObjCKVCInformationInitWithKey( p, key);

   //   if( _MulleObjCKVCIsUsingDefaultMethodOfType( aClass, _MulleObjCKVCValueForKeyIndex))
   getMethodName = MulleObjCStringByCombiningPrefixAndCapitalizedKey( @"get", key, NO);

   if( mask & _MulleObjCKVCGetMethodBit)
      if( useInstanceMethod( p, aClass, getMethodName, NO))
         return;

   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, key, NO))
         return;

   // check for _getKey
   underscoreGetMethodName = [@"_" stringByAppendingString:getMethodName];
   if( mask & _MulleObjCKVCUnderscoreGetMethodBit)
      if( useInstanceMethod( p, aClass, underscoreGetMethodName, NO))
         return;

   if( mask & _MulleObjCKVCUnderscoreMethodBit)
   {
      underscoreName = [@"_" stringByAppendingString:key];
      if( useInstanceMethod( p, aClass, underscoreName, NO))
         return;
   }

   if( [aClass accessInstanceVariablesDirectly])
   {
      underscoreName = [@"_" stringByAppendingString:p->key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;

      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, key))
            return;
   }

   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, NO);
}



static inline SEL   _MulleObjCKVCSelectorForMethodType( enum _MulleObjCKVCMethodType  type)
{
   switch( type)
   {
   case _MulleObjCKVCValueForKeyIndex           : return( @selector( valueForKey:));
   case _MulleObjCKVCStoredValueForKeyIndex     : return( @selector( storedValueForKey:));
   case _MulleObjCKVCTakeValueForKeyIndex       : return( @selector( takeValue:forKey:));
   case _MulleObjCKVCTakeStoredValueForKeyIndex : return( @selector( takeStoredValue:forKey:));
   }
   return( (SEL) 0);
}


#if 0
static inline enum _MulleObjCKVCMethodType   _MulleObjCKVCMethodTypeForSelector( SEL sel)
{
   if( sel == @selector( takeStoredValue:forKey:))
       return( _MulleObjCKVCTakeStoredValueForKeyIndex);
   if( sel == @selector( takeValue:forKey:))
      return( _MulleObjCKVCTakeValueForKeyIndex);
   if( sel == @selector( valueForKey:))
      return( _MulleObjCKVCValueForKeyIndex);
   if( sel == @selector( storedValueForKey:))
      return( _MulleObjCKVCStoredValueForKeyIndex);

   return( -1);
}
#endif


BOOL  _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( Class aClass,
                                                   enum _MulleObjCKVCMethodType type,
                                                   Class referenceClass)
{
   struct _mulle_objc_method   *methodClass;
   struct _mulle_objc_method   *methodNSObject;
   mulle_objc_methodid_t       sel;

   sel            = (mulle_objc_methodid_t) _MulleObjCKVCSelectorForMethodType( type);
   methodClass    = mulle_objc_class_defaultsearch_method( _mulle_objc_infraclass_as_class( aClass), sel);  // EOFault returns nil f.e.
   methodNSObject = mulle_objc_class_defaultsearch_method( _mulle_objc_infraclass_as_class( referenceClass), sel);

   NSCParameterAssert( methodNSObject);

   if( methodClass && _mulle_objc_method_get_implementation( methodClass) ==
                     _mulle_objc_method_get_implementation( methodNSObject))
      return( YES);

   return( NO);
}


BOOL  _MulleObjCKVCIsUsingDefaultMethodOfType( Class aClass,
                                               enum _MulleObjCKVCMethodType type)
{
   return( _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( aClass, type, [NSObject class]));
}


void  __MulleObjCSetObjectValueWithAccessorForType( id obj, SEL sel, id value, IMP imp, char valueType)
{
   intptr_t   parameter;

   // so far we just do numbers
   NSCParameterAssert( ! value || [value isKindOfClass:[NSNumber class]]);

   // optimize nil path for speed and profit
   if( ! value)
   {
      switch( valueType)
      {
      case _C_BOOL     :
      case _C_CHR      :
      case _C_UCHR     :
      case _C_SHT      :
      case _C_USHT     :

      case _C_INT      :
      case _C_SEL      :
      case _C_UINT     : MulleObjCIMPCall( imp, obj, sel, 0); return;

      case _C_LNG      :
      case _C_ULNG     : MulleObjCIMPCallWithUnsignedLong( imp, obj, sel, 0); return;
      case _C_LNG_LNG  :
      case _C_ULNG_LNG : MulleObjCIMPCallWithUnsignedLongLong( imp, obj, sel, 0); return;

      case _C_FLT      : MulleObjCIMPCallWithFloat( imp, obj, sel, 0); return;
      case _C_DBL      : MulleObjCIMPCallWithDouble( imp, obj, sel, 0); return;
#ifdef _C_LNG_DBL
      case _C_LNG_DBL  : MulleObjCIMPCallWithLongDouble( imp, obj, sel, 0); return;
#endif
      default         :
         [NSException raise:NSInvalidArgumentException
                     format:@"%s failed to handle \"%c\" for -[%@ %@ %@]. I don't know what to do with it",
             __PRETTY_FUNCTION__, valueType, obj, NSStringFromSelector( sel), value];

      }
      return;
   }

   switch( valueType)
   {
   case _C_BOOL     : parameter = [value boolValue]; break;
   case _C_CHR      : parameter = [value charValue]; break;
   case _C_UCHR     : parameter = [value unsignedCharValue]; break;
   case _C_SHT      : parameter = [value shortValue]; break;
   case _C_USHT     : parameter = [value unsignedShortValue]; break;

   case _C_INT      : parameter = [value intValue]; break;
   case _C_SEL      :
   case _C_UINT     : parameter = [value unsignedIntValue]; break;

   case _C_LNG      : MulleObjCIMPCallWithLong( imp, obj, sel, [value longValue]); return;
   case _C_ULNG     : MulleObjCIMPCallWithUnsignedLong( imp, obj, sel, [value unsignedLongValue]); return;
   case _C_LNG_LNG  : MulleObjCIMPCallWithLongLong( imp, obj, sel, [value longLongValue]); return;
   case _C_ULNG_LNG : MulleObjCIMPCallWithUnsignedLongLong( imp, obj, sel, [value unsignedLongLongValue]); return;
   case _C_FLT      : MulleObjCIMPCallWithFloat( imp, obj, sel, [value floatValue]); return;
   case _C_DBL      : MulleObjCIMPCallWithDouble( imp, obj, sel, [value doubleValue]); return;
#ifdef _C_LNG_DBL
   case _C_LNG_DBL  : MulleObjCIMPCallWithLongDouble( imp, obj, sel, [value longDoubleValue]); return;
#endif
      break;

   default      :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\" for -[%@ %@ %@]. I don't know what to do with it",
          __PRETTY_FUNCTION__, valueType, obj, NSStringFromSelector( sel), value];
   }

   MulleObjCIMPCall( imp, obj, sel, (void *) parameter);
   return;
}


id   __MulleObjCGetObjectValueWithAccessorForType( id obj, SEL sel, IMP imp, char valueType)
{
   // so far we just do numbers
   switch( valueType)
   {
   case _C_BOOL      : return( [NSNumber numberWithBool:(BOOL) (intptr_t) MulleObjCIMPCall0( imp, obj, sel)]);
   case _C_CHR       : return( [NSNumber numberWithChar:(char) (intptr_t) MulleObjCIMPCall0( imp, obj, sel)]);
   case _C_UCHR      : return( [NSNumber numberWithUnsignedChar:(unsigned char) (uintptr_t) MulleObjCIMPCall0( imp, obj, sel)]);
   case _C_SHT       : return( [NSNumber numberWithShort:(short) (intptr_t) MulleObjCIMPCall0( imp, obj, sel)]);
   case _C_USHT      : return( [NSNumber numberWithUnsignedShort:(unsigned short) (uintptr_t) MulleObjCIMPCall0( imp, obj, sel)]);

   case _C_INT       : return( [NSNumber numberWithInt:(int) (intptr_t) MulleObjCIMPCall0( imp, obj, sel)]);
   case _C_SEL       :
   case _C_UINT      : return( [NSNumber numberWithUnsignedInt:(unsigned int) (uintptr_t) MulleObjCIMPCall0( imp, obj, sel)]);

   case _C_LNG       : return( [NSNumber numberWithLong:MulleObjCIMPCall0ReturningLong( imp, obj, sel)]);
   case _C_ULNG      : return( [NSNumber numberWithUnsignedLong:MulleObjCIMPCall0ReturningUnsignedLong( imp, obj, sel)]);
   case _C_LNG_LNG   : return( [NSNumber numberWithLongLong:MulleObjCIMPCall0ReturningLongLong( imp, obj, sel)]);

   case _C_ULNG_LNG  : return( [NSNumber numberWithUnsignedLongLong:MulleObjCIMPCall0ReturningUnsignedLongLong( imp, obj, sel)]);
   case _C_FLT       : return( [NSNumber numberWithFloat:MulleObjCIMPCall0ReturningFloat( imp, obj, sel)]);
   case _C_DBL       : return( [NSNumber numberWithDouble:MulleObjCIMPCall0ReturningDouble( imp, obj, sel)]);
#ifdef _C_LNG_DBL
   case _C_LNG_DBL   : return( [NSNumber numberWithLongDouble:MulleObjCIMPCall0ReturningLongDouble( imp, obj, sel)]);
#endif
   default         :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\" for -[%@ %@]. I don't know what to do with it",
          __PRETTY_FUNCTION__, valueType, [obj class], NSStringFromSelector( sel)];
   }
   return( nil);
}
