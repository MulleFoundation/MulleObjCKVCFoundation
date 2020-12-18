/*
*   This file will be regenerated by `mulle-sde reflect` and any edits will be
*   lost. Suppress generation of this file with:
*      mulle-sde environment --global \
*         set MULLE_SOURCETREE_TO_C_IMPORT_FILE DISABLE
*
*   To not generate any header files:
*      mulle-sde environment --global \
*         set MULLE_SOURCETREE_TO_C_RUN DISABLE
*/

#ifndef _MulleObjCKVCFoundation_import_h__
#define _MulleObjCKVCFoundation_import_h__

// How to tweak the following MulleObjCStandardFoundation #import
//    remove:             `mulle-sourcetree mark MulleObjCStandardFoundation no-header`
//    rename:             `mulle-sde dependency|library set MulleObjCStandardFoundation include whatever.h`
//    toggle #import:     `mulle-sourcetree mark MulleObjCStandardFoundation [no-]import`
//    toggle localheader: `mulle-sourcetree mark MulleObjCStandardFoundation [no-]localheader`
//    toggle public:      `mulle-sourcetree mark MulleObjCStandardFoundation [no-]public`
//    toggle optional:    `mulle-sourcetree mark MulleObjCStandardFoundation [no-]require`
//    remove for os:      `mulle-sourcetree mark MulleObjCStandardFoundation no-os-<osname>`
# if defined( __has_include) && __has_include("MulleObjCStandardFoundation.h")
#   import "MulleObjCStandardFoundation.h"   // MulleObjCStandardFoundation
# else
#   import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>   // MulleObjCStandardFoundation
# endif

#ifdef __has_include
# if __has_include( "_MulleObjCKVCFoundation-include.h")
#  include "_MulleObjCKVCFoundation-include.h"
# endif
#endif


#endif
