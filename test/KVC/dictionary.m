//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


static void   key_value_dictionary_test()
{
   NSMutableDictionary   *dict;
   NSNumber              *nr;
   NSString              *key;

   dict = [NSMutableDictionary dictionary];

   key  = [NSString stringWithUTF8String:"bar"];
   nr   = [NSNumber numberWithInt:1848];
   [dict takeValue:nr
            forKey:key];

   mulle_printf( "%s\n", [dict valueForKey:key] == nr ? "passed" : "failed");
   mulle_printf( "%s\n", [dict valueForKey:@"bar"] == nr ? "passed" : "failed");
   mulle_printf( "%s\n", [dict valueForKey:@"foo"] == nil ? "passed" : "failed");
}


int  main( int argc, const char * argv[])
{
   key_value_dictionary_test();
   return( 0);
}
