//
//  _MulleObjCInstanceVariableAccess.m
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
#import "_MulleObjCInstanceVariableAccess.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


//
// no pretenses, this is totally limited and probably just good for our fetching stuff
// don't pass in mutable objects...
//
void   _MulleObjCSetInstanceVariableForType( id p, unsigned int offset, id value, char valueType)
{
   void   *dst;
   id     old;

   dst = &((char *) p)[ offset];

   //
   // optimize the 'nil' path, it should be worth it during fetches f.e.
   // because we don't need to call objc_msgSend
   //

   if( ! value)
      switch( valueType)
      {
      case _C_BOOL     : *(BOOL *)           dst = 0; return;
      case _C_CHR      : *(char *)           dst = 0; return;
      case _C_UCHR     : *(unsigned char *)  dst = 0; return;
      case _C_SHT      : *(short *)          dst = 0; return;
      case _C_USHT     : *(unsigned short *) dst = 0; return;

      case _C_INT      : *(int *)            dst = 0; return;
      case _C_UINT     : *(unsigned int *)   dst = 0; return;
      case _C_LNG      : *(long *)           dst = 0; return;
      case _C_ULNG     : *(unsigned long *)  dst = 0; return;
      case _C_SEL      : *(SEL *)            dst = 0; return;

      case _C_LNG_LNG  : *(long long *)          dst = 0; return;
      case _C_ULNG_LNG : *(unsigned long long *) dst = 0; return;

      case _C_FLT      : *(float *)  dst = 0; return;
      case _C_DBL      : *(double *) dst = 0; return;
      case _C_LNG_DBL  : *(double *) dst = 0; return;
      case _C_COPY_ID :
         old         = *(id *) dst;
         *(id *) dst = 0;
         if( old)
            [old autorelease];   // if you crash here, better make clean your project!
         return;

      case _C_ASSIGN_ID :
         *(id *) dst = 0;
         return;

      case _C_CLASS :
      case _C_ID    :
         old         = *(id *) dst;
         *(id *) dst = 0;
         if( old)
            [old autorelease];   // if you crash here, better make clean your project!
         return;

      default  :
         [NSException raise:NSInvalidArgumentException
                     format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
      }

   switch( valueType)
   {
   case _C_BOOL : *(BOOL *)           dst = [value boolValue]; return;
   case _C_CHR  : *(char *)           dst = [value charValue]; return;
   case _C_UCHR : *(unsigned char *)  dst = [value unsignedCharValue]; return;
   case _C_SHT  : *(short *)          dst = [value shortValue]; return;
   case _C_USHT : *(unsigned short *) dst = [value unsignedShortValue]; return;

   case _C_INT  : *(int *)            dst = [value intValue]; return;
   case _C_UINT : *(unsigned int *)   dst = [value unsignedIntValue]; return;
   case _C_LNG  : *(long *)           dst = [value longValue]; return;
   case _C_ULNG : *(unsigned long *)  dst = [value unsignedLongValue]; return;

   case _C_LNG_LNG  : *(long long *)          dst = [value longLongValue]; return;
   case _C_ULNG_LNG : *(unsigned long long *) dst = [value unsignedLongLongValue]; return;

   case _C_FLT     : *(float *)       dst = [value floatValue]; return;
   case _C_DBL     : *(double *)      dst = [value doubleValue]; return;
   case _C_LNG_DBL : *(long double *) dst = [value longDoubleValue]; return;

   case _C_SEL     : *(SEL *)         dst = (SEL) [value longValue]; return;

   case _C_COPY_ID :
      old         = *(id *) dst;
      *(id *) dst = [value copy];
      if( old)
         [old autorelease];   // if you crash here, better make clean your project!
      return;

   case _C_ASSIGN_ID :
      *(id *) dst = value;
      break;

   case _C_CLASS :
   case _C_ID    :
      old         = *(id *) dst;
      *(id *) dst = [value retain];
      if( old)
         [old autorelease];   // if you crash here, better make clean your project!
      return;

   default :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
   }
}


id   _MulleObjCGetInstanceVariableForType( id p, unsigned int offset, char valueType)
{
   void   *dst;

   dst = &((char *) p)[ offset];

   switch( valueType)
   {
   case _C_BOOL : return( [NSNumber numberWithBool:*(BOOL *) dst]);
   case _C_CHR  : return( [NSNumber numberWithChar:*(char *) dst]);
   case _C_UCHR : return( [NSNumber numberWithUnsignedChar:*(unsigned char *) dst]);
   case _C_SHT  : return( [NSNumber numberWithShort:*(short *) dst]);
   case _C_USHT : return( [NSNumber numberWithUnsignedShort:*(unsigned short *) dst]);

   case _C_INT  : return( [NSNumber numberWithInt:*(int *) dst]);
   case _C_UINT : return( [NSNumber numberWithUnsignedInt:*(unsigned int *) dst]);
   case _C_LNG  : return( [NSNumber numberWithLong:*(long *) dst]);
   case _C_ULNG : return( [NSNumber numberWithUnsignedLong:*(unsigned long *) dst]);

   case _C_LNG_LNG  : return( [NSNumber numberWithLongLong:*(long long *) dst]);
   case _C_ULNG_LNG : return( [NSNumber numberWithUnsignedLongLong:*(unsigned long long *) dst]);

   case _C_FLT     : return( [NSNumber numberWithFloat:*(float *) dst]);
   case _C_DBL     : return( [NSNumber numberWithDouble:*(double *) dst]);
   case _C_LNG_DBL : return( [NSNumber numberWithLongDouble:*(long double *) dst]);

   case _C_SEL     : return( [NSNumber numberWithLong:(long) *(SEL *) dst]);

   case _C_COPY_ID :
   case _C_ASSIGN_ID :
   case _C_CLASS   :
   case _C_ID      :
      break;

   default :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
   }
   return( *(id *) dst);
}
