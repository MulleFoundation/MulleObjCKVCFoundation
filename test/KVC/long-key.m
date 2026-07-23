#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


//
// Test KVC with a key longer than MULLE_ALLOCA_STACKSIZE (128 bytes)
// to exercise the mulle_alloca_do_realloc path.
//

// 300 character ivar name (underscore prefix for KVC)
@interface LongKeyFoo : NSObject
{
@public
   id   _abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnop;
}
@end

@implementation LongKeyFoo
@end


int   main( void)
{
   LongKeyFoo  *foo;
   id           v;
   NSString    *longKey;

   foo = [[LongKeyFoo new] autorelease];

   longKey = @"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnop";

   [foo takeValue:@"hello"
           forKey:longKey];
   v = [foo valueForKey:longKey];
   mulle_printf( "long-key: %s\n", [v UTF8String]);

   [foo takeValue:@"world"
           forKey:longKey];
   v = [foo valueForKey:longKey];
   mulle_printf( "long-key: %s\n", [v UTF8String]);

   [foo takeValue:nil
           forKey:longKey];
   v = [foo valueForKey:longKey];
   mulle_printf( "long-key-nil: %s\n", v ? "non-nil" : "nil");

   return( 0);
}
