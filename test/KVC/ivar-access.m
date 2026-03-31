#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface IvarFoo : NSObject
{
@public
   BOOL               _boolVal;
   char               _charVal;
   short              _shortVal;
   int                _intVal;
   long               _longVal;
   long long          _longLongVal;
   float              _floatVal;
   double             _doubleVal;
   unsigned char      _ucharVal;
   unsigned short     _ushortVal;
   unsigned int       _uintVal;
   unsigned long      _ulongVal;
   unsigned long long _ulongLongVal;
   id                 _idVal;
}
@end

@implementation IvarFoo
@end

int   main( void)
{
   IvarFoo  *foo;
   id       v;

   foo = [[IvarFoo new] autorelease];

   [foo takeValue:[NSNumber numberWithBool:YES]
           forKey:@"boolVal"];
   v = [foo valueForKey:@"boolVal"];
   mulle_printf( "bool: %ld\n", (long) [v boolValue]);

   [foo takeValue:[NSNumber numberWithChar:42]
           forKey:@"charVal"];
   v = [foo valueForKey:@"charVal"];
   mulle_printf( "char: %ld\n", (long) [v charValue]);

   [foo takeValue:[NSNumber numberWithShort:100]
           forKey:@"shortVal"];
   v = [foo valueForKey:@"shortVal"];
   mulle_printf( "short: %ld\n", (long) [v shortValue]);

   [foo takeValue:[NSNumber numberWithInt:1234]
           forKey:@"intVal"];
   v = [foo valueForKey:@"intVal"];
   mulle_printf( "int: %ld\n", (long) [v intValue]);

   [foo takeValue:[NSNumber numberWithLong:99999L]
           forKey:@"longVal"];
   v = [foo valueForKey:@"longVal"];
   mulle_printf( "long: %ld\n", (long) [v longValue]);

   [foo takeValue:[NSNumber numberWithLongLong:1234567890LL]
           forKey:@"longLongVal"];
   v = [foo valueForKey:@"longLongVal"];
   mulle_printf( "longlong: %lld\n", [v longLongValue]);

   [foo takeValue:[NSNumber numberWithFloat:3.14f]
           forKey:@"floatVal"];
   v = [foo valueForKey:@"floatVal"];
   mulle_printf( "float: %.2f\n", [v floatValue]);

   [foo takeValue:[NSNumber numberWithDouble:2.71828]
           forKey:@"doubleVal"];
   v = [foo valueForKey:@"doubleVal"];
   mulle_printf( "double: %.5f\n", [v doubleValue]);

   [foo takeValue:[NSNumber numberWithUnsignedChar:200]
           forKey:@"ucharVal"];
   v = [foo valueForKey:@"ucharVal"];
   mulle_printf( "uchar: %lu\n", (unsigned long) [v unsignedCharValue]);

   [foo takeValue:[NSNumber numberWithUnsignedShort:50000]
           forKey:@"ushortVal"];
   v = [foo valueForKey:@"ushortVal"];
   mulle_printf( "ushort: %lu\n", (unsigned long) [v unsignedShortValue]);

   [foo takeValue:[NSNumber numberWithUnsignedInt:4000000000U]
           forKey:@"uintVal"];
   v = [foo valueForKey:@"uintVal"];
   mulle_printf( "uint: %lu\n", (unsigned long) [v unsignedIntValue]);

   [foo takeValue:[NSNumber numberWithUnsignedLong:1000000UL]
           forKey:@"ulongVal"];
   v = [foo valueForKey:@"ulongVal"];
   mulle_printf( "ulong: %lu\n", (unsigned long) [v unsignedLongValue]);

   [foo takeValue:[NSNumber numberWithUnsignedLongLong:9999999999ULL]
           forKey:@"ulongLongVal"];
   v = [foo valueForKey:@"ulongLongVal"];
   mulle_printf( "ulonglong: %llu\n", [v unsignedLongLongValue]);

   [foo takeValue:@"hello"
           forKey:@"idVal"];
   v = [foo valueForKey:@"idVal"];
   mulle_printf( "id: %s\n", [v UTF8String]);

   [foo takeValue:nil
           forKey:@"idVal"];
   v = [foo valueForKey:@"idVal"];
   mulle_printf( "id-nil: %s\n", v ? "non-nil" : "nil");

   return( 0);
}
