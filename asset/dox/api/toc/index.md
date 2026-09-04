# MulleObjCKVCFoundation Library Documentation for AI
<!-- Keywords: kvc, key-value-coding -->

## 1. Introduction & Purpose

MulleObjCKVCFoundation adds Key-Value Coding (KVC) to mulle-objc, enabling dynamic property access using string-based key paths. Allows code like `[object valueForKey:@"property.nested.value"]` to traverse object hierarchies without explicit getter methods. Implements a runtime interpretation scheme for flexible, dynamic object manipulation and introspection.

## 2. Key Concepts & Design Philosophy

- **String-Based Access**: Properties accessed by string keys rather than method calls
- **Key Path Navigation**: Support for dot-separated paths (e.g., "person.address.city")
- **Dynamic Property Resolution**: Automatically finds getters/setters or accesses instance variables
- **Accessor Customization**: Objects can customize how keys are resolved
- **Container Support**: NSArray and NSSet aggregate KVC operations over elements
- **Nil Handling**: Special handling for setting nil values and undefined keys
- **Runtime Interpretation**: No compile-time type checking; full runtime flexibility

## 3. Core API & Data Structures

### NSObject (KeyValueCoding) Category

#### Basic Value Access

- `- valueForKey:(NSString *)key` → `id`: Get value by key name
- `- setValue:(id)value forKey:(NSString *)key` → `void`: Set value by key
- `- valueForKeyPath:(NSString *)keyPath` → `id`: Get via dot-separated path
- `- setValue:(id)value forKeyPath:(NSString *)keyPath` → `void`: Set via path
- `- takeValue:(id)value forKey:(NSString *)key` → `void`: Legacy setter (alias for setValue)
- `- takeValue:(id)value forKeyPath:(NSString *)keyPath` → `void`: Legacy path setter

#### Batch Operations

- `- valuesForKeys:(NSArray *)keys` → `NSDictionary *`: Get multiple values as dict
- `- dictionaryWithValuesForKeys:(NSArray *)keys` → `NSDictionary *`: Modern API version
- `- takeValuesFromDictionary:(NSDictionary *)dict` → `void`: Set from dictionary

#### Customization Points

- `- handleQueryWithUnboundKey:(NSString *)key` → `id`: Called when key not found (query)
- `- valueForUndefinedKey:(NSString *)key` → `id`: Get undefined key (newer pattern)
- `- handleTakeValue:(id)value forUnboundKey:(NSString *)key` → `void`: Set undefined key
- `- setValue:(id)value forUndefinedKey:(NSString *)key` → `void`: Modern undefined setter
- `- unableToSetNilForKey:(NSString *)key` → `void`: Called when setting nil fails
- `- setNilValueForKey:(NSString *)key` → `void`: Customize nil handling

#### Accessor Control

- `+ useStoredAccessor` → `BOOL`: Whether to use direct ivar access (vs methods)
- `- storedValueForKey:(NSString *)key` → `id`: Direct ivar access
- `- takeStoredValue:(id)value forKey:(NSString *)key` → `void`: Direct ivar write

#### Exception

- `NSUndefinedKeyException`: Raised on undefined key access (if not handled)

### NSArray (KeyValueCoding) Category

#### Aggregate Access

- `- valueForKey:(NSString *)key` → `NSArray *`: Apply key to each element
- `- setValue:(id)value forKey:(NSString *)key` → `void`: Set key on each element
- `- valueForKeyPath:(NSString *)keyPath` → `NSArray *`: Apply path to each element
- `- setValue:(id)value forKeyPath:(NSString *)keyPath` → `void`: Set path on each

#### Aggregate Functions

- `- valueForKey:@"@count"` → `NSNumber *`: Count of elements
- `- valueForKey:@"@sum.property"` → `NSNumber *`: Sum of property values
- `- valueForKey:@"@avg.property"` → `NSNumber *`: Average of property values
- `- valueForKey:@"@min.property"` → `NSNumber *`: Minimum value
- `- valueForKey:@"@max.property"` → `NSNumber *`: Maximum value
- `- valueForKey:@"@distinctUnionOfObjects.property"` → `NSArray *`: Unique values
- `- valueForKey:@"@unionOfObjects.property"` → `NSArray *`: All values (with duplicates)
- `- valueForKey:@"@distinctUnionOfArrays.property"` → `NSArray *`: Distinct across nested arrays

### NSSet (KeyValueCoding) Category

#### Aggregate Access

- `- valueForKey:(NSString *)key` → `NSSet *`: Apply key to each member
- `- setValue:(id)value forKey:(NSString *)key` → `void`: Set key on each member

### NSObject (MulleObjCKVCArithmetic) - Arithmetic on NSNumber

#### Arithmetic Operations

- `- valueForKey:@"+property"` → `NSNumber *`: Sum from container
- `- valueForKey:@"-property"` → `NSNumber *`: Difference
- `- valueForKey:@"*property"` → `NSNumber *`: Product
- `- valueForKey:@"/property"` → `NSNumber *`: Division result

## 4. Performance Characteristics

- **Method Lookup**: O(n) where n is depth of key path
- **Ivar Access**: O(1) if useStoredAccessor returns true
- **Container Operations**: O(n) per element for arrays/sets
- **Caching**: Runtime caches accessor methods; repeated access fast
- **Memory**: No additional allocation for key access itself
- **Thread-Safety**: KVC not thread-safe; external synchronization needed

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **Use for Data Binding**: KVC excellent for UI-to-model binding
- **Avoid in Hot Loops**: String key lookup has overhead; cache method references
- **Type Validation**: Check returned types; KVC doesn't enforce type safety
- **Error Handling**: Override undefined key handlers to provide sensible defaults
- **Document Key Paths**: Keep key path strings in constants to avoid typos
- **Container Aggregates**: Use @sum, @avg for statistics on collections
- **Path Length**: Keep key paths reasonable; deep paths harder to debug

### Common Pitfalls

- **Undefined Keys**: Accessing non-existent keys raises NSUndefinedKeyException unless handled
- **Nil Values**: Setting nil can trigger unableToSetNilForKey: if not supported
- **Type Mismatches**: No type checking; nil may be returned if types incompatible
- **Performance**: Repeated lookups expensive; cache results in performance-critical code
- **Key Typos**: String-based keys won't be caught by compiler; use constants
- **Circular Paths**: Paths like "self" or circular references cause infinite loops
- **Accessor Side Effects**: Getters called via KVC may have unexpected side effects

### Idiomatic Usage

```objc
// Pattern 1: Simple key access
id name = [person valueForKey:@"name"];
[person setValue:@"Alice" forKey:@"name"];

// Pattern 2: Key paths (nested access)
id city = [person valueForKey:@"address.city"];
[person setValue:@"New York" forKeyPath:@"address.city"];

// Pattern 3: Array aggregate operations
NSNumber *count = [people valueForKey:@"@count"];
NSNumber *avgAge = [people valueForKey:@"@avg.age"];
NSArray *names = [people valueForKey:@"name"];

// Pattern 4: Batch operations
NSDictionary *values = [person dictionaryWithValuesForKeys:
    @[@"name", @"age", @"email"]];

// Pattern 5: Custom handling
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"Undefined key: %@", key);
    return nil;
}
```

## 6. Integration Examples

### Example 1: Basic Key-Value Access

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Person : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int age;
@end

@implementation Person
@end

int main() {
    Person *person = [[Person alloc] init];
    
    [person setValue:@"Alice" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:30] forKey:@"age"];
    
    NSString *name = [person valueForKey:@"name"];
    NSNumber *age = [person valueForKey:@"age"];
    
    NSLog(@"Name: %@, Age: %@", name, age);
    
    [person release];
    return 0;
}
```

### Example 2: Key Paths (Nested Access)

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Address : NSObject
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@end

@interface Person : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Address *address;
@end

int main() {
    Address *address = [[Address alloc] init];
    [address setValue:@"Paris" forKey:@"city"];
    [address setValue:@"France" forKey:@"country"];
    
    Person *person = [[Person alloc] init];
    [person setValue:@"Alice" forKey:@"name"];
    [person setValue:address forKey:@"address"];
    
    // Access nested property via key path
    NSString *city = [person valueForKeyPath:@"address.city"];
    NSLog(@"City: %@", city);  // Paris
    
    [address release];
    [person release];
    return 0;
}
```

### Example 3: Array Aggregates

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Person : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int age;
@end

int main() {
    NSMutableArray *people = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        Person *p = [[Person alloc] init];
        [p setValue:[NSString stringWithFormat:@"Person%d", i] forKey:@"name"];
        [p setValue:[NSNumber numberWithInt:20 + i] forKey:@"age"];
        [people addObject:p];
        [p release];
    }
    
    // Aggregate operations
    NSNumber *count = [people valueForKey:@"@count"];
    NSNumber *avgAge = [people valueForKey:@"@avg.age"];
    NSNumber *maxAge = [people valueForKey:@"@max.age"];
    NSArray *names = [people valueForKey:@"name"];
    
    NSLog(@"Count: %@", count);
    NSLog(@"Avg age: %@", avgAge);
    NSLog(@"Max age: %@", maxAge);
    NSLog(@"Names: %@", names);
    
    return 0;
}
```

### Example 4: Batch Operations

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Person : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, retain) NSString *email;
@end

int main() {
    Person *person = [[Person alloc] init];
    [person setValue:@"Alice" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:30] forKey:@"age"];
    [person setValue:@"alice@example.com" forKey:@"email"];
    
    // Get multiple values at once
    NSArray *keys = @[@"name", @"age", @"email"];
    NSDictionary *values = [person dictionaryWithValuesForKeys:keys];
    
    NSLog(@"Values: %@", values);
    
    // Set multiple values from dictionary
    NSDictionary *newValues = @{
        @"name": @"Bob",
        @"age": [NSNumber numberWithInt:35]
    };
    [person takeValuesFromDictionary:newValues];
    
    [person release];
    return 0;
}
```

### Example 5: Custom Undefined Key Handling

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface FlexibleObject : NSObject
{
    NSMutableDictionary *_customProperties;
}
@end

@implementation FlexibleObject
- (id)init {
    self = [super init];
    _customProperties = [[NSMutableDictionary alloc] init];
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"Accessing undefined key: %@", key);
    return [_customProperties objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Setting undefined key: %@ = %@", key, value);
    [_customProperties setObject:value forKey:key];
}

- (void)dealloc {
    [_customProperties release];
    [super dealloc];
}
@end

int main() {
    FlexibleObject *obj = [[FlexibleObject alloc] init];
    
    [obj setValue:@"custom value" forKey:@"customKey"];
    id value = [obj valueForKey:@"customKey"];
    NSLog(@"Custom value: %@", value);
    
    [obj release];
    return 0;
}
```

### Example 6: Set Operations on Collections

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Product : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) double price;
@end

int main() {
    NSMutableArray *products = [NSMutableArray array];
    
    // Create products
    for (int i = 0; i < 3; i++) {
        Product *p = [[Product alloc] init];
        [p setValue:[NSString stringWithFormat:@"Product%d", i] forKey:@"name"];
        [p setValue:[NSNumber numberWithDouble:(10.0 + i*5)] forKey:@"price"];
        [products addObject:p];
        [p release];
    }
    
    // Set a value on all elements
    [products setValue:@"Discounted" forKey:@"name"];  // Changes all names
    
    // Get values from all elements
    NSArray *names = [products valueForKey:@"name"];
    NSLog(@"All names: %@", names);
    
    return 0;
}
```

## 7. Dependencies

- MulleObjCStandardFoundation (NSObject, NSArray, NSSet, NSString, NSDictionary)
- MulleFoundationBase
