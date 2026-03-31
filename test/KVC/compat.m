#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface CompatObj : NSObject
@property( assign) NSInteger val;
@property( retain) NSString *name;
@end

@implementation CompatObj
@end

int   main( void)
{
   CompatObj  *o;

   o = [[CompatObj new] autorelease];

   // setValue:forKey:
   [o setValue:[NSNumber numberWithInteger:42]
        forKey:@"val"];
   [o setValue:@"hello"
        forKey:@"name"];
   mulle_printf( "val: %ld\n", (long) [o val]);
   mulle_printf( "name: %s\n", [[o name] UTF8String]);

   // setValue:forKeyPath:
   [o setValue:[NSNumber numberWithInteger:99]
        forKeyPath:@"val"];
   mulle_printf( "val after keypath: %ld\n", (long) [o val]);

   return( 0);
}
