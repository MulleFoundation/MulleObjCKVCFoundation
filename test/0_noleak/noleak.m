#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>
#endif



@implementation Foo
@end


@implementation Foo ( Category)
@end


// just don't leak anything
main()
{
#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
   {
      MulleObjCHTMLDumpUniverseToTmp();
      MulleObjCDotdumpUniverseToTmp();
      fprintf( stderr, "universe in bad state\n");
      return( 1);
   }
#endif
   return( 0);
}
