//
//  MulleStandaloneObjCExpatFoundation.c
//  MulleObjCExpatFoundation
//
//  Created by Nat! on 03.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "MulleObjCKVCFoundation.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies
#import <MulleObjCStandardFoundation/MulleObjCFoundationSetup.h>


static void   bang( struct _mulle_objc_universe *universe,
                    void (*crunch)( void),
                    void *userinfo)
{
   struct _ns_foundation_setupconfig   setup;

   MulleObjCFoundationGetDefaultSetupConfig( &setup);
   ns_objc_universe_setup( universe, &setup.config);
}


MULLE_C_CONST_RETURN  // always returns same value (in same thread)
struct _mulle_objc_universe  *__get_or_create_mulle_objc_universe( void)
{
   struct _mulle_objc_universe   *universe;

   universe = __mulle_objc_get_universe();
   if( ! _mulle_objc_universe_is_initialized( universe))
      _mulle_objc_universe_bang( universe, bang, NULL, NULL);

   return( universe);
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

