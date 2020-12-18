//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


@interface Foo : NSObject

@property( assign) char c;
@property( assign) unsigned char uc;
@property( assign) short s;
@property( assign) unsigned short us;
@property( assign) int i;
@property( assign) unsigned int ui;
@property( assign) long l;
@property( assign) unsigned long ul;
@property( assign) long long ll;
@property( assign) unsigned long long ull;
@property( assign) float f;
@property( assign) double d;
@property( assign) long double ld;
@property( retain) NSNumber *nr;

@end

@implementation Foo

- (void) dump
{
   fprintf( stderr, "c   = %d\n", _c);
   fprintf( stderr, "uc  = %u\n", _uc);
   fprintf( stderr, "s   = %d\n", _s);
   fprintf( stderr, "us  = %u\n", _us);
   fprintf( stderr, "i   = %d\n", _i);
   fprintf( stderr, "ui  = %u\n", _ui);

   fprintf( stderr, "l   = %ld\n", _l);
   fprintf( stderr, "ul  = %lu\n", _ul);
   fprintf( stderr, "ll  = %lld\n", _ll);
   fprintf( stderr, "ull = %llu\n", _ull);

   fprintf( stderr, "f   = %f\n", _f);
   fprintf( stderr, "d   = %f\n", _d);
   fprintf( stderr, "ld  = %Lf\n", _ld);
}

@end


int  main( int argc, const char * argv[])
{
   Foo        *foo;
   NSNumber   *nr;

   foo = [[Foo new] autorelease];

   nr  = [NSNumber numberWithInt:1848];
   [foo setValue:nr
          forKey:@"nr"];

   [foo setValue:nr
          forKey:@"c"];
   [foo setValue:nr
          forKey:@"uc"];

   [foo setValue:nr
          forKey:@"s"];
   [foo setValue:nr
          forKey:@"us"];

   [foo setValue:nr
          forKey:@"i"];
   [foo setValue:nr
          forKey:@"ui"];

   [foo setValue:nr
          forKey:@"l"];
   [foo setValue:nr
          forKey:@"ul"];

   [foo setValue:nr
          forKey:@"ll"];
   [foo setValue:nr
          forKey:@"ull"];

   nr  = [NSNumber numberWithDouble:18.48];

   [foo setValue:nr
          forKey:@"f"];
   [foo setValue:nr
          forKey:@"d"];
   [foo setValue:nr
          forKey:@"ld"];

   //   [foo dump];

   printf( "%s\n", [[[foo valueForKey:@"c"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"uc"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"s"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"us"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"i"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"ui"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"l"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"ul"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"ll"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"ull"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"f"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"d"] description] UTF8String]);
   printf( "%s\n", [[[foo valueForKey:@"ld"] description] UTF8String]);

   printf( "%s\n", [[[foo valueForKey:@"nr"] description] UTF8String]);

   return( 0);
}
