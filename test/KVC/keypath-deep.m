#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Node : NSObject
@property( retain) NSString *label;
@property( retain) Node     *child;
@end

@implementation Node
@end

int   main( void)
{
   Node  *root;
   Node  *child;
   id    val;

   root  = [[Node new] autorelease];
   child = [[Node new] autorelease];

   [root setLabel:@"root"];
   [child setLabel:@"leaf"];
   [root setChild:child];

   // Deep key path read
   val = [root valueForKeyPath:@"child.label"];
   mulle_printf( "deep: %s\n", [val UTF8String]);

   // Deep key path write
   [root takeValue:@"updated"
        forKeyPath:@"child.label"];
   mulle_printf( "updated: %s\n", [[child label] UTF8String]);

   return( 0);
}
