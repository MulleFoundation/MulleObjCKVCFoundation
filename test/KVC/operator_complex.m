//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


static void   avg_test( NSArray *array, NSString  *keypath, long long  expect)
{
   NSNumber   *result;

   result = [array valueForKeyPath:keypath];
   if( [result longLongValue] != expect)
      printf( "failed\n");
   else
      printf( "passed\n");
}


int  main( int argc, const char * argv[])
{
   avg_test( @[], @"@count.key", 0);
   avg_test( @[ @{ @"key" : [NSNumber numberWithInt:1848] }], @"@count.key", 1);
   avg_test( @[ @{ @"key": [NSNumber numberWithInt:1846] },
                @{ @"key": [NSNumber numberWithInt:1846] }], @"@count.key", 2);

   avg_test( @[], @"@avg.key", 0);
   avg_test( @[ @{ @"key": [NSNumber numberWithInt:1848] }], @"@avg.key", 1848);
   avg_test( @[ @{ @"key": [NSNumber numberWithInt:1846] },
                @{ @"key": [NSNumber numberWithInt:1850] }], @"@avg.key", 1848);

   return( 0);
}
