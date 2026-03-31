#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface ArrItem : NSObject
@property( assign) NSInteger score;
@end

@implementation ArrItem
@end

int   main( void)
{
   NSArray         *arr;
   NSMutableArray  *marr;
   id              obj;
   ArrItem         *a;
   ArrItem         *b;
   ArrItem         *c;

   // Empty array returns nil for any key
   arr = [NSArray array];
   obj = [arr valueForKey:@"anything"];
   mulle_printf( "empty: %s\n", obj ? "non-nil" : "nil");

   // Non-empty array with string key collects valueForKey: on each element
   // NSString responds to @"length" -> NSNumber
   arr = [NSArray arrayWithObjects:@"hi", @"hello", @"hey", nil];
   obj = [arr valueForKey:@"length"];
   // result is an NSArray of NSNumbers (lengths: 2, 5, 3)
   mulle_printf( "string-key result count: %ld\n", (long) [obj count]);

   // NSMutableArray takeValue:forKey: with NSNumber key (no assertion in takeValue:)
   a = [[ArrItem new] autorelease];
   b = [[ArrItem new] autorelease];
   [a setScore:1];
   [b setScore:2];
   marr = [NSMutableArray arrayWithObjects:a, b, nil];

   // i == count: append
   c = [[ArrItem new] autorelease];
   [c setScore:3];
   [marr takeValue:c
            forKey:(NSString *) [NSNumber numberWithInt:2]];
   mulle_printf( "after append count: %ld\n", (long) [marr count]);
   mulle_printf( "appended score: %ld\n", (long) [[marr objectAtIndex:2] score]);

   // replace at index 0
   [a setScore:99];
   [marr takeValue:a
            forKey:(NSString *) [NSNumber numberWithInt:0]];
   mulle_printf( "after replace [0] score: %ld\n", (long) [[marr objectAtIndex:0] score]);

   // nil value: remove at index 1
   [marr takeValue:nil
            forKey:(NSString *) [NSNumber numberWithInt:1]];
   mulle_printf( "after remove count: %ld\n", (long) [marr count]);

   // NSMutableArray takeValue:forKey: with string key -> on each element
   marr = [NSMutableArray arrayWithObjects:a, b, nil];
   [marr takeValue:[NSNumber numberWithInteger:50]
            forKey:@"score"];
   mulle_printf( "a score: %ld\n", (long) [a score]);
   mulle_printf( "b score: %ld\n", (long) [b score]);

   return( 0);
}
