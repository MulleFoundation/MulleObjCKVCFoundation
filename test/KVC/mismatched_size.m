//
//  main.m
//  KVCTests
//
//  Created by znek on 17.05.19.
//  Copyright © 2019 Mulle kybernetiK. All rights reserved.
//
#ifndef __MULLE_OBJC__
#import <Foundation/Foundation.h>
#else
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>
#endif

#include <stdio.h>


@interface Foo : NSObject
{
   short  _protect0;
   short  _value;
   short  _protect1;
}

- (int) value;
- (void) setValue:(int) value;

@end


@implementation Foo

- (id) init
{
   _protect0 = 0x4002;
   _protect1 = 0x2004;
   return( self);
}


- (void) dealloc
{
   if( _protect0 != 0x4002 || _protect1 != 0x2004)
   {
      fprintf( stderr, "overwrite protection triggered\n");
      abort();
   }
   [super dealloc];
}


- (int) value
{
   return( _value);
}


- (void) setValue:(int) value
{
   _value = value;
}

@end


static void   printer( char *prefix, NSInteger x)
{
   if( x > SHRT_MAX)
   {
      printf( "%s SHRT_MAX+%ld\n", prefix, (long) x - SHRT_MAX);
      return;
   }

   if( x >= SHRT_MAX / 2)
   {
      printf( "%s SHRT_MAX-%ld\n", prefix, (long) SHRT_MAX - (long) x);
      return;
   }


   if( x < SHRT_MIN / 2)
   {
      printf( "%s SHRT_MIN+%ld\n", prefix, -((long) SHRT_MIN - (long) x));
      return;
   }


   if( x < SHRT_MIN)
   {
      printf( "%s SHRT_MIN+%ld\n", prefix, -((long) x - SHRT_MIN));
      return;
   }

   printf( "%s %ld\n", prefix, (long) x);
}


void   test( NSInteger value)
{
   Foo   *foo;

   @autoreleasepool
   {
      foo = [[Foo new] autorelease];
      [foo takeValue:[NSNumber numberWithInteger:value]
              forKey:@"value"];

      printer( "1.", [[foo valueForKey:@"value"] integerValue]);
      printer( "2.", [[foo storedValueForKey:@"value"] integerValue]);
   }

   @autoreleasepool
   {
      foo = [[Foo new] autorelease];
      [foo takeStoredValue:[NSNumber numberWithInteger:value]
                    forKey:@"value"];

      printer( "3.", [[foo valueForKey:@"value"] integerValue]);
      printer( "4.", [[foo storedValueForKey:@"value"] integerValue]);
   }
}


int   main( int argc, char *argv[])
{
   test( 1848);
   test( (unsigned int) SHRT_MIN + 1848);
   return 0;
}
