//
//  NSProxy+_MulleObjCKVCInformation.m
//  MulleObjCKVCFoundation
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
#import "import-private.h"

// other files in this library
#import "NSObject+KeyValueCoding.h"
#import "_MulleObjCKVCInformation.h"

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies


#ifdef DEBUG
//# define DEBUG_VERBOSE
#endif


@implementation NSProxy ( _MulleObjCKVCInformation)

- (void) _divineKVCInformation:(struct _MulleObjCKVCInformation *) info
                        forKey:(NSString *) key
                    methodType:(enum _MulleObjCKVCMethodType) type
{
   Class   cls;

   cls = [self class];
   switch( type)
   {
   case _MulleObjCKVCValueForKeyIndex :
#ifdef DEBUG_VERBOSE
      fprintf( stderr, "Divine ValueForKey: ");
#endif
      __MulleObjCDivineValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;

   case _MulleObjCKVCStoredValueForKeyIndex :
#ifdef DEBUG_VERBOSE
      fprintf( stderr, "Divine StoredValueForKey: ");
#endif
      __MulleObjCDivineStoredValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;

   case _MulleObjCKVCTakeValueForKeyIndex :
#ifdef DEBUG_VERBOSE
      fprintf( stderr, "Divine TakeValueForKey: ");
#endif
      __MulleObjCDivineTakeValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;

   case _MulleObjCKVCTakeStoredValueForKeyIndex :
#ifdef DEBUG_VERBOSE
      fprintf( stderr, "Divine TakeStoredValueForKey: ");
#endif
      __MulleObjCDivineTakeStoredValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;
   }
}

@end
