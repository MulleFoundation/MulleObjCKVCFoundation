#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface MultiObj : NSObject
@property( assign) NSInteger x;
@property( assign) NSInteger y;
@end

@implementation MultiObj
@end

int   main( void)
{
   MultiObj      *o;
   NSDictionary  *d;
   NSDictionary  *src;

   o = [[MultiObj new] autorelease];
   [o setX:10];
   [o setY:20];

   // valuesForKeys: returns dictionary with those keys
   d = [o valuesForKeys:[NSArray arrayWithObjects:@"x", @"y", nil]];
   mulle_printf( "x: %ld\n", (long) [[d objectForKey:@"x"] integerValue]);
   mulle_printf( "y: %ld\n", (long) [[d objectForKey:@"y"] integerValue]);

   // takeValuesFromDictionary: sets properties from dict
   src = [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInteger:30], @"x",
      [NSNumber numberWithInteger:40], @"y",
      nil];
   [o takeValuesFromDictionary:src];
   mulle_printf( "x after: %ld\n", (long) [o x]);
   mulle_printf( "y after: %ld\n", (long) [o y]);

   // dictionaryWithValuesForKeys: (compat alias for valuesForKeys:)
   d = [o dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"x", @"y", nil]];
   mulle_printf( "dict count: %ld\n", (long) [d count]);

   return( 0);
}
