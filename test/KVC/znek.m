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

@interface Bar : NSObject
{
	NSInteger value;
}
@end

@implementation Bar
- (instancetype)initWithValue:(NSInteger)_value {
	self = [self init];
	if (self) {
		self->value = _value;
	}
	return self;
}
@end

@interface Foo : NSObject
{
	NSMutableArray *bars;
}
@end
@implementation Foo
- (instancetype)init {
	self = [super init];
	if (self) {
		self->bars = [[NSMutableArray alloc] init];
		[self->bars addObject:[[[Bar alloc] initWithValue:1] autorelease]];
		[self->bars addObject:[[[Bar alloc] initWithValue:2] autorelease]];
		[self->bars addObject:[[[Bar alloc] initWithValue:3] autorelease]];
		[self->bars addObject:[[[Bar alloc] initWithValue:4] autorelease]];
		[self->bars addObject:[[[Bar alloc] initWithValue:5] autorelease]];
	}
	return self;
}

- (void)dealloc
{
   [self->bars release];
   [super dealloc];
}
@end


int main(int argc, const char * argv[]) {
	@autoreleasepool {

		Foo *foo = [[[Foo alloc] init] autorelease];
		id l = [foo valueForKeyPath:@"bars.@avg.value"];
		printf( "l = %s\n", [l cStringDescription]);

		[foo setValue:[NSNumber numberWithInteger:0] forKeyPath:@"bars.value"];
		l = [foo valueForKeyPath:@"bars.value"];
      printf( "l = %s\n", [l cStringDescription]);
	}
	return 0;
}
