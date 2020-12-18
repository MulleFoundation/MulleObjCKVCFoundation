//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


static void   key_value_path_dictionary_test()
{
   NSMutableDictionary   *dict;
   NSMutableDictionary   *dict2;
   NSNumber              *nr;
   NSString              *key;

   dict  = [NSMutableDictionary dictionary];
   dict2 = [NSMutableDictionary dictionary];
   [dict takeValue:dict2
            forKey:@"a"];

   nr = [NSNumber numberWithInt:1848];
   [dict takeValue:nr
        forKeyPath:@"a.b"];

   printf( "%s\n", [dict count] == 1 ? "passed" : "failed");
   printf( "%s\n", [dict valueForKeyPath:@"a.b"] == nr ? "passed" : "failed");
   [dict takeValue:nil
        forKeyPath:@"a"];
   printf( "%s\n", [dict valueForKeyPath:@"a.b"] == nil ? "passed" : "failed");
}


int  main( int argc, const char * argv[])
{
   key_value_path_dictionary_test();
   return( 0);
}
