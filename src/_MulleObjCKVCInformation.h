//
//  _MulleObjCKVCInformation.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
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
#import "_MulleObjCInstanceVariableAccess.h"

#import "NSObject+KVCSupport.h"


@class NSString;


//
// this old code should be moved somewhere else
//
typedef enum
{
   _MulleObjCKVCGenericMethodOnly      = 0x0,
   _MulleObjCKVCUnderscoreMethodBit    = 0x1,
   _MulleObjCKVCMethodBit              = 0x2,
   _MulleObjCKVCUnderscoreIvarBit      = 0x4,
   _MulleObjCKVCIvarBit                = 0x8,
   _MulleObjCKVCUnderscoreGetMethodBit = 0x10,
   _MulleObjCKVCGetMethodBit           = 0x20,
   _MulleObjCKVCStandardMask           = 0x7FFF
} _MulleObjCKVCMethodMask;


void   __MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);


static inline void   _MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineStoredValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineTakeValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


BOOL   _MulleObjCKVCIsUsingDefaultMethodOfType( Class aClass, enum _MulleObjCKVCMethodType type);
BOOL   _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( Class aClass, enum _MulleObjCKVCMethodType type, Class referenceClass);
void   _MulleObjCKVCInformationUseUnboundKeyMethod( struct _MulleObjCKVCInformation *p, Class aClass, BOOL isSetter);

void   __MulleObjCSetObjectValueWithAccessorForType( id obj, SEL sel, id value, IMP imp, char valueType);
id     __MulleObjCGetObjectValueWithAccessorForType( id obj, SEL sel, IMP imp, char valueType);


static inline void   _MulleObjCSetObjectValueWithKVCInformation( id obj, id value, struct _MulleObjCKVCInformation *info)
{
   if( ! info->implementation)
   {
      _MulleObjCSetInstanceVariableForType( obj, info->offset, value, info->valueType);
      return;
   }

   switch( info->valueType)
   {
   case _C_CLASS     :
   case _C_COPY_ID   :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
      (*info->implementation)( obj, info->selector, value);
      return;
   }
   __MulleObjCSetObjectValueWithAccessorForType( obj, info->selector, value, info->implementation, info->valueType);
}


static inline id   _MulleObjCGetObjectValueWithKVCInformation( id obj, struct _MulleObjCKVCInformation *info)
{
   if( ! info->implementation)
      return( _MulleObjCGetInstanceVariableForType( obj, info->offset, info->valueType));

   switch( info->valueType)
   {
   case _C_CLASS   :
   case _C_COPY_ID :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
      return( (*info->implementation)( obj, info->selector, obj));
   }
   return( __MulleObjCGetObjectValueWithAccessorForType( obj, info->selector, info->implementation, info->valueType));
}
