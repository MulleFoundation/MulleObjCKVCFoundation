//
//  NSObject+KeyValueCoding.h
//  MulleObjCStandardFoundation
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
#import "import.h"


@class NSArray;
@class NSString;
@class NSDictionary;


MULLE_OBJC_KVC_FOUNDATION_GLOBAL
NSString   *NSUndefinedKeyException;


@interface NSObject( _KeyValueCoding)

- (id) valueForKey:(NSString *) key;
- (void) takeValue:(id) value
            forKey:(NSString *)key;


+ (BOOL) useStoredAccessor;

- (id) storedValueForKey:(NSString *) key;

- (void) takeStoredValue:(id) value
                  forKey:(NSString *) key;

- (id) valueForKeyPath:(NSString *)keyPath;
- (void) takeValue:(id) value
        forKeyPath:(NSString *)keyPath;

- (id) handleQueryWithUnboundKey:(NSString *) key;
- (id) valueForUndefinedKey:(NSString *) key;
- (void) handleTakeValue:(id) value
           forUnboundKey:(NSString *) key;

- (void) unableToSetNilForKey:(NSString *)key ;
- (NSDictionary *) valuesForKeys:(NSArray *) keys;
- (void) takeValuesFromDictionary:(NSDictionary *) properties;

@end


@interface NSObject( _KeyValueCodingCompatibility)

// "modern" KVC interface
- (void) setValue:(id)value
           forKey:(NSString *) key;

- (void) setValue:(id)value
       forKeyPath:(NSString *) key;

- (void) setValue:(id) value
   forUndefinedKey:(NSString *) key;

- (void) setNilValueForKey:(NSString *)key;

- (NSDictionary *) dictionaryWithValuesForKeys:(NSArray *) keys;

@end

