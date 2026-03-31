#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface SetItem : NSObject
@property( assign) NSInteger val;
@end

@implementation SetItem
@end

int   main( void)
{
   NSSet        *empty;
   NSSet        *strings;
   NSMutableSet *ms;
   SetItem      *item1;
   SetItem      *item2;
   id           result;
   NSUInteger   n;

   // Empty set returns nil
   empty = [NSSet set];
   result = [empty valueForKey:@"description"];
   mulle_printf( "empty set result: %s\n", result ? "non-nil" : "nil");

   // Non-empty set valueForKey: description - collects into set
   strings = [NSSet setWithObjects:@"hello", @"world", nil];
   result = [strings valueForKey:@"description"];
   n = [result count];
   mulle_printf( "string set descriptions count: %ld\n", (long) n);

   // NSMutableSet takeValue:forKey: using custom objects
   item1 = [[SetItem new] autorelease];
   [item1 setVal:10];
   item2 = [[SetItem new] autorelease];
   [item2 setVal:20];
   ms = [NSMutableSet setWithObjects:item1, item2, nil];

   // takeValue:forKey: sets val on each element
   [ms takeValue:[NSNumber numberWithInteger:99]
          forKey:@"val"];
   mulle_printf( "item1 val: %ld\n", (long) [item1 val]);
   mulle_printf( "item2 val: %ld\n", (long) [item2 val]);

   return( 0);
}
