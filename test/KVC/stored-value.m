#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface StoreObj : NSObject
{
@public
   int   _count;
}
- (int) count;
@end

@implementation StoreObj
- (int) count { return( _count + 100); }
@end

int   main( void)
{
   StoreObj  *o;
   id        v1;
   id        v2;

   o = [[StoreObj new] autorelease];
   o->_count = 42;

   // valueForKey: finds count method → 42+100=142
   v1 = [o valueForKey:@"count"];
   mulle_printf( "valueForKey: %ld\n", (long) [v1 intValue]);

   // storedValueForKey: searches ivar first → finds _count ivar → 42
   v2 = [o storedValueForKey:@"count"];
   mulle_printf( "storedValueForKey: %ld\n", (long) [v2 intValue]);

   // takeStoredValue:forKey: sets _count ivar
   [o takeStoredValue:[NSNumber numberWithInt:7]
               forKey:@"count"];
   mulle_printf( "after takeStoredValue ivar: %d\n", o->_count);
   mulle_printf( "after takeStoredValue method: %ld\n", (long) [o count]);

   return( 0);
}
