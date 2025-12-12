//
//  NSNumber+MulleObjCKVCArithmetic.m
//  MulleObjCStandardFoundation
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

#import "NSNumber+MulleObjCKVCArithmetic.h"

// other files in this library

// std-c and other dependencies


@implementation NSNumber( MulleObjCKVCArithmetic)


static int  simplify_type_for_arithmetic( int type)
{
   switch( type)
   {
   case _C_BOOL :
   case _C_CHR  :
   case _C_SHT  :
   case _C_INT  :
   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_LNG  :
   case _C_ULNG :
   case _C_LNG_LNG  :
   case _C_ULNG_LNG :
      return( _C_LNG_LNG);

   case _C_FLT     :
      return( _C_DBL);
   }
   return( type);
}


- (NSNumber *) _add:(NSNumber *) other
{
   char          *p_type;
   char          *p_other_type;
   long long     a64, b64;
   double        da, db;
#ifdef _C_LNG_DBL
   long double   lda, ldb;
#endif
   int           type;
   int           other_type;

   p_type       = [self objCType];
   p_other_type = other ? [other objCType] : @encode( int);

   NSCParameterAssert( p_type && strlen( p_type) == 1);
   NSCParameterAssert( p_other_type && strlen( p_other_type) == 1);

   type       = simplify_type_for_arithmetic( *p_type);
   other_type = simplify_type_for_arithmetic( *p_other_type);

   switch( type)
   {
   default  : goto bail;
   case _C_LNG_LNG :
      switch( other_type)
      {
      default           : goto bail;
      case _C_LNG_LNG   : goto do_64_64_add;
      case _C_DBL       : goto do_d_d_add;
#ifdef _C_LNG_DBL
      case _C_LNG_DBL   : goto do_ld_ld_add;
#endif
      }

   case _C_DBL          : goto do_d_d_add;
#ifdef _C_LNG_DBL
   case _C_LNG_DBL      : goto do_ld_ld_add;
#endif
   }

   // integer overflows to 64
do_64_64_add :
   a64 = [self longLongValue];
   b64 = [other longLongValue];
   return( [NSNumber numberWithLongLong:a64 + b64]);

do_d_d_add :
   da = [self doubleValue];
   db = [other doubleValue];
   return( [NSNumber numberWithDouble:da + db]);

#ifdef _C_LNG_DBL
do_ld_ld_add :
   lda = [self longDoubleValue];
   ldb = [other longDoubleValue];
   return( [NSNumber numberWithLongDouble:lda + ldb]);
#endif

bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objc-type");
}


- (NSNumber *) _divideByInteger:(NSUInteger) divisor
{
   char          *p_type;
   long long     a64;
   double        da;
#ifdef _C_LNG_DBL
   long double   lda;
#endif
   int           type;

   p_type = [self objCType];

   NSCParameterAssert( p_type && strlen( p_type) == 1);

   type = simplify_type_for_arithmetic( *p_type);

   switch( type)
   {
   default          : goto bail;
   case _C_LNG_LNG  : goto do_64_64_div;
   case _C_DBL      : goto do_d_d_div;
#ifdef _C_LNG_DBL
   case _C_LNG_DBL  : goto do_ld_ld_div;
#endif
   }

   // integer overflows to 64
do_64_64_div :
   a64 = [self longLongValue];
   return( [NSNumber numberWithLongLong:a64 / divisor]);

do_d_d_div :
   da = [self doubleValue];
   return( [NSNumber numberWithDouble:da / divisor]);

#ifdef _C_LNG_DBL
do_ld_ld_div :
   lda = [self longDoubleValue];
   return( [NSNumber numberWithLongDouble:lda / divisor]);
#endif

bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objc-type");
}

@end
