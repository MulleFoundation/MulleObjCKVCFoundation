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
#ifdef _C_LNG_DBL
@property( assign) long double ld;
#endif
@property( retain) NSNumber *nr;

@end

@implementation Foo

- (void) dump
{
   mulle_fprintf( stderr, "c   = %d\n", _c);
   mulle_fprintf( stderr, "uc  = %u\n", _uc);
   mulle_fprintf( stderr, "s   = %d\n", _s);
   mulle_fprintf( stderr, "us  = %u\n", _us);
   mulle_fprintf( stderr, "i   = %d\n", _i);
   mulle_fprintf( stderr, "ui  = %u\n", _ui);

   mulle_fprintf( stderr, "l   = %ld\n", _l);
   mulle_fprintf( stderr, "ul  = %lu\n", _ul);
   mulle_fprintf( stderr, "ll  = %lld\n", _ll);
   mulle_fprintf( stderr, "ull = %llu\n", _ull);

   mulle_fprintf( stderr, "f   = %g\n", _f);
   mulle_fprintf( stderr, "d   = %g\n", _d);
#ifdef _C_LNG_DBL
   mulle_fprintf( stderr, "ld  = %Lg\n", _ld);
#endif
}

@end


static void   test( id obj, NSString *key)
{
   mulle_printf( "%@: %@\n", key, [[obj valueForKey:key] description]);
}


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
#ifdef _C_LNG_DBL
   [foo setValue:nr
          forKey:@"ld"];
#endif
   //   [foo dump];

   test(foo, @"c");
   test(foo, @"uc");

   test(foo, @"s");
   test(foo, @"us");

   test(foo, @"i");
   test(foo, @"ui");

   test(foo, @"l");
   test(foo, @"ul");

   test(foo, @"ll");
   test(foo, @"ull");

   test(foo, @"f");
   test(foo, @"d");
#ifdef _C_LNG_DBL
   test(foo, @"ld");
#endif
   test(foo, @"nr");

   return( 0);
}
