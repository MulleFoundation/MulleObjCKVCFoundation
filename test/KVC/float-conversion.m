//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>


@interface Foo : NSObject

@property( assign) float f;
@property( assign) double d;
@property( assign) long double ld;

@end


@implementation Foo

- (void) dump
{
   fprintf( stdout, "%%f\n");
   fprintf( stdout, "\tf   = %f\n", _f);
   fprintf( stdout, "\td   = %f\n", _d);
   fprintf( stdout, "\tld  = %Lf\n", _ld);

   fprintf( stdout, "%%g\n");
   fprintf( stdout, "\tf   = %g\n", _f);
   fprintf( stdout, "\td   = %g\n", _d);
   fprintf( stdout, "\tld  = %Lg\n", _ld);

   fprintf( stdout, "Mulle\n");
   fprintf( stdout, "\tf   = %0.8g\n", _f);
   fprintf( stdout, "\td   = %0.17g\n", _d);
   fprintf( stdout, "\tld  = %0.21Lg\n", _ld);

   fprintf( stdout, "Apple (does no ld)\n");
   fprintf( stdout, "\tf   = %0.7g\n", _f);
   fprintf( stdout, "\td   = %0.16g\n", _d);
   fprintf( stdout, "\tld  = %0.21Lg\n", _ld);

   // Voodoo check
   fprintf( stdout, "Mulle Accessor\n");
   fprintf( stdout, "\tf   = %0.8g\n", [self f]);
   fprintf( stdout, "\td   = %0.17g\n", [self d]);
   fprintf( stdout, "\tld  = %0.21Lg\n", [self ld]);

   // Voodoo check 2
   fprintf( stdout, "Mulle KVC Accessor\n");
   fprintf( stdout, "\tf   = %0.8g\n", [[self valueForKey:@"f"] floatValue]);
   fprintf( stdout, "\td   = %0.17g\n", [[self valueForKey:@"d"] doubleValue]);
   fprintf( stdout, "\tld  = %0.21Lg\n", [[self valueForKey:@"ld"] longDoubleValue]);
}

@end


// just a little check written when a float got printed ugly...

int  main( int argc, const char * argv[])
{
   NSNumber   *nr;
   Foo        *foo;

   nr  = [NSNumber numberWithDouble:18.48];

   foo = [Foo object];
   [foo setValue:nr
          forKey:@"f"];
   [foo setValue:nr
          forKey:@"d"];
   [foo setValue:nr
          forKey:@"ld"];

   [foo dump];

   return( 0);
}
