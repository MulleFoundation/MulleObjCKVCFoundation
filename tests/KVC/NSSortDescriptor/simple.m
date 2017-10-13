//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{
   NSArray            *array;
   NSSortDescriptor   *descriptor;
   NSArray            *descriptors;
   NSString           *value;

   @autoreleasepool
   {
      array = @[ @{ @"a" : @"c" },  @{ @"a" : @"b" }];
      descriptor = [NSSortDescriptor sortDescriptorWithKey:@"a"
                                                 ascending:YES];
      descriptors = @[ descriptor];

      array = [array sortedArrayUsingDescriptors:descriptors];
      value = [[array objectAtIndex:1] objectForKey:@"a"];
      printf( "%s\n",  [value isEqualToString:@"c"] ? "passed" : "failed");
   }
   return( 0);
}
