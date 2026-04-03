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
#ifdef _C_LNG_DBL
@property( assign) long double ld;
#endif

@end


@implementation Foo

- (void) dump
{
   mulle_fprintf( stdout, "%%f\n");
   mulle_fprintf( stdout, "\tf   = %f\n", _f);
   mulle_fprintf( stdout, "\td   = %f\n", _d);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %Lf\n", _ld);
#endif

   mulle_fprintf( stdout, "%%g\n");
   mulle_fprintf( stdout, "\tf   = %g\n", _f);
   mulle_fprintf( stdout, "\td   = %g\n", _d);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %Lg\n", _ld);
#endif
   mulle_fprintf( stdout, "Mulle\n");
   mulle_fprintf( stdout, "\tf   = %0.8g\n", _f);
   mulle_fprintf( stdout, "\td   = %0.17g\n", _d);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %0.21Lg\n", _ld);
#endif

   mulle_fprintf( stdout, "Apple (does no ld)\n");
   mulle_fprintf( stdout, "\tf   = %0.7g\n", _f);
   mulle_fprintf( stdout, "\td   = %0.16g\n", _d);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %0.21Lg\n", _ld);
#endif
   // Voodoo check
   mulle_fprintf( stdout, "Mulle Accessor\n");
   mulle_fprintf( stdout, "\tf   = %0.8g\n", [self f]);
   mulle_fprintf( stdout, "\td   = %0.17g\n", [self d]);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %0.21Lg\n", [self ld]);
#endif
   // Voodoo check 2
   mulle_fprintf( stdout, "Mulle KVC Accessor\n");
   mulle_fprintf( stdout, "\tf   = %0.8g\n", [[self valueForKey:@"f"] floatValue]);
   mulle_fprintf( stdout, "\td   = %0.17g\n", [[self valueForKey:@"d"] doubleValue]);
#ifdef _C_LNG_DBL
   mulle_fprintf( stdout, "\tld  = %0.21Lg\n", [[self valueForKey:@"ld"] longDoubleValue]);
#endif
}

@end


// just a little check written when a float got printed ugly...

int  main( int argc, const char * argv[])
{
   NSNumber   *nr;
   Foo        *foo;

   nr  = [NSNumber numberWithDouble:18.48];

   foo = [Foo instance];
   [foo setValue:nr
          forKey:@"f"];
   [foo setValue:nr
          forKey:@"d"];
#ifdef _C_LNG_DBL
   [foo setValue:nr
          forKey:@"ld"];
#endif
   [foo dump];

   return( 0);
}
