//
//  MulleStandaloneObjCExpatFoundation.c
//  MulleObjCExpatFoundation
//
//  Created by Nat! on 03.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "MulleObjCKVCFoundation.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and other dependencies
#import <MulleObjCFoundation/MulleObjCFoundationSetup.h>


__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_mulle_objc_runtime( void)
{
   struct _mulle_objc_runtime  *runtime;

   runtime = __mulle_objc_get_runtime();
   if( _mulle_objc_runtime_is_initialized( runtime))
      return( runtime);

   {
      struct _ns_foundation_setupconfig   setup;

      MulleObjCFoundationGetDefaultSetupConfig( &setup);
      return( ns_objc_create_runtime( &setup.config));
   }
}


//
// see: https://stackoverflow.com/questions/35998488/where-is-the-eprintf-symbol-defined-in-os-x-10-11/36010972#36010972
//
__attribute__((visibility("hidden")))
void __eprintf( const char* format, const char* file,
               unsigned line, const char *expr)
{
   fprintf( stderr, format, file, line, expr);
   abort();
}

