# MulleObjCKVCFoundation Library Documentation for AI
<!-- Keywords: kvc, keyvalue, accessor, operator, aggregate, introspection -->

## 1. Introduction & Purpose

MulleObjCKVCFoundation adds **Key-Value Coding (KVC)** to the mulle-objc class
system. It is a runtime interpretation scheme that lets you access object
state through string-based keys and dotted key paths, e.g.
`[object valueForKey:@"person.address.city"]` as a shortcut for
`[[[object person] address] city]`.

It solves the problem of writing generic, data-driven code that must not know
the concrete class of an object at compile time: KVC routes string keys to
accessor methods or instance variables at runtime, and adds collection
operators (`@count`, `@sum`, ...) for aggregate queries.

The functionality is delivered as **categories** attached to `NSObject`,
`NSArray`, `NSMutableArray`, `NSSet`, `NSDictionary`, `NSMutableDictionary`,
`NSNumber` and `NSSortDescriptor`. It is a foundational component of the
`MulleFoundation` library collection and is built directly on top of
`MulleObjCStandardFoundation`.

## 2. Key Concepts & Design Philosophy

- **String-based access:** Properties are addressed by string keys
  (`@"name"`) instead of explicit message sends.
- **Key paths:** Keys may be joined with `.` into paths
  (`@"address.city"`); every segment is resolved with `valueForKey:`.
- **Method vs. ivar (stored) access:** A key is resolved ("divined") to
  either an accessor method (`name`, `setName:`, `get<Key>`, `_name`, ...) or
  an instance variable (`_name`). `valueForKey:` prefers accessor methods and
  falls back to ivars; `storedValueForKey:` prefers ivars and falls back to
  accessors. See the *Getter order* in section 3.8.
- **Accessor control:** The class-level `+ (BOOL) useStoredAccessor` and
  `+ (BOOL) accessInstanceVariablesDirectly` hooks decide whether ivars may
  be used at all.
- **Unbound keys:** If no accessor or ivar exists, custom hooks
  (`valueForUndefinedKey:`, `handleTakeValue:forUnboundKey:`) are called.
  The defaults raise `NSUndefinedKeyException` (get) or throw an invalid
  argument exception (set).
- **Divination + caching:** Key resolution is performed once per
  class/key/method-type and cached so repeated accesses are fast (see 3.3).
- **Container mapping:** `NSArray`/`NSSet` map a key over all elements,
  `NSDictionary` maps to `objectForKey:`.
- **Collection operators:** A path segment starting with `@` is an operator
  (`@count`, `@sum`, `@avg`, `@min`, `@max`), optionally followed by a rest
  path (`@"@sum.price"`).

## 3. Core API & Data Structures

### 3.1. `MulleObjCKVCFoundation.h`

The umbrella header. Import once:

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>
```

It re-exports every category/header of the library and defines the library
version:

```c
#define MULLE_OBJC_KVC_FOUNDATION_VERSION   ((0UL << 20) | (21 << 8) | 0)
```

(current version: 0.21.0).

### 3.2. `NSObject+KeyValueCoding.h` — the public KVC interface

This header declares the two public categories on `NSObject` plus the global
exception name:

```c
MULLE_OBJC_KVC_FOUNDATION_GLOBAL
NSString   *NSUndefinedKeyException;
```

- `NSUndefinedKeyException` — raised (as an `NSString` name) by the default
  unbound-key get handlers. Defined as `@"NSUndefinedKeyException"` in
  `NSObject+KeyValueCoding.m`.

#### `@interface NSObject( _KeyValueCoding)` — the classic "take" interface

- **Core Operations:**
  - `- (id) valueForKey:(NSString *) key;`
    Read the value identified by `key`. Resolves an accessor method or ivar,
    boxes C values into an object, and returns it. An unbound key routes to
    `valueForUndefinedKey:`.
  - `- (void) takeValue:(id) value forKey:(NSString *)key;`
    Write `value` identified by `key`. Resolves a setter or ivar, unboxes
    objects back into the C value. An unbound key routes to
    `handleTakeValue:forUnboundKey:`.
  - `- (void) takeValue:(id) value forKeyPath:(NSString *)keyPath;`
    Traverses the dot-separated path with `valueForKey:` and applies
    `takeValue:forKey:` with the last segment on the final object.
- **Stored (ivar-first) access:**
  - `- (id) storedValueForKey:(NSString *) key;`
  - `- (void) takeStoredValue:(id) value forKey:(NSString *) key;`
    Same as above, but resolve ivars before accessor methods (see 3.8 for the
    exact order).
- **Inspection / class-level control:**
  - `+ (BOOL) useStoredAccessor;`
    If a class returns `NO`, KVC will not use ivars at all and only accessor
    methods are used. Default `YES`.
- **Customization points (overridable):**
  - `- (id) handleQueryWithUnboundKey:(NSString *) key;`
    Called for an unbound *read*. Default: raise `NSUndefinedKeyException`.
  - `- (id) valueForUndefinedKey:(NSString *) key;`
    Variant used through the unbound-key method binding. Default: raise
    `NSUndefinedKeyException`.
  - `- (void) handleTakeValue:(id) value forUnboundKey:(NSString *) key;`
    Called for an unbound *write*. Default: throw invalid-argument exception.
  - `- (void) unableToSetNilForKey:(NSString *)key ;`
    Called when a `nil` value cannot be stored (default `setNilValueForKey:`
    hook). Default: throw invalid-argument exception.
- **Batch operations:**
  - `- (NSDictionary *) valuesForKeys:(NSArray *) keys;`
    Read several keys at once; returns an `NSMutableDictionary` mapping each
    key to its value (nil values are skipped).
  - `- (void) takeValuesFromDictionary:(NSDictionary *) properties;`
    Write several key/value pairs at once, looping
    `takeValue:forKey:` over the dictionary.

#### `@interface NSObject( _KeyValueCodingCompatibility)` — the "modern" `setValue` interface

Thin forwarders to the `take` interface:

- `- (void) setValue:(id)value forKey:(NSString *) key;`
  == `takeValue:forKey:`
- `- (void) setValue:(id)value forKeyPath:(NSString *) key;`
  == `takeValue:forKeyPath:`
- `- (void) setValue:(id) value forUndefinedKey:(NSString *) key;`
  == `handleTakeValue:forUnboundKey:`
- `- (void) setNilValueForKey:(NSString *)key;`
  == `unableToSetNilForKey:` (note the idiom)
- `- (NSDictionary *) dictionaryWithValuesForKeys:(NSArray *) keys;`
  == `valuesForKeys:`

### 3.3. `NSObject+KVCSupport.h` — the KVC-information machinery

This is the internal but public support layer used by `valueForKey:` etc. to
resolve a key. Most consumers never call it, but it defines the key data
types.

#### `struct _MulleObjCKVCInformation`

- **Purpose:** describes how to get/set one key on an object: via a method
  implementation+selector or via a raw ivar offset.
- **Key Fields:**
  - `id key` — the key (borrowed, not copied).
  - `IMP implementation` — resolved method implementation (0 = ivar access).
  - `SEL selector` — resolved selector for the method.
  - `int offset` — ivar byte offset (0 if none).
  - `char valueType` — storage type of the value (`_C_INT`, `_C_DBL`,
    `_C_ID`, ...).

```c
struct _MulleObjCKVCInformation
{
   id     key;
   IMP    implementation;
   SEL    selector;
   int    offset;
   char   valueType;
};
```

- **Lifecycle Functions (static inline):**
  - `static inline void _MulleObjCKVCInformationInitWithKey( struct _MulleObjCKVCInformation *p, id key)`
    Initializes with `key`, zeroes implementation/selector/offset and sets
    `valueType` to `_C_ID`.
  - `static inline void _MulleObjCKVCInformationDone( struct _MulleObjCKVCInformation *p)`
    No-op (the key is intentionally not copied/autoreleased).

#### `enum _MulleObjCKVCMethodType`

Used to select which of the four lookup flavors is wanted:

```c
enum _MulleObjCKVCMethodType
{
   _MulleObjCKVCValueForKeyIndex           = 0,
   _MulleObjCKVCTakeValueForKeyIndex       = 1,
   _MulleObjCKVCStoredValueForKeyIndex     = 2,
   _MulleObjCKVCTakeStoredValueForKeyIndex = 3
};
```

#### Category `@interface NSObject( KVCSupport)`

- `- (void) _getKVCInformation:(struct _MulleObjCKVCInformation *) kvcInfo
                        forKey:(id <NSStringFuture>) key
                    methodType:(enum _MulleObjCKVCMethodType) type;`

  Main entry: looks up the per-class per-key cache (`_mulle_objc_kvcinfo`).
  On a cache miss it divines (resolves) the information for **all four**
  method types at once, stores them in the cache, and returns the requested
  one. If the cache reports a hash conflict
  (`MULLE_OBJC_KVCINFO_CONFLICT`) it divines on demand. This is why repeated
  `valueForKey:` calls are fast.

#### Protocol `@protocol NSStringFuture < MulleObjCFuture>` and category `@interface NSObject( KVCSupportFuture) < MulleObjCFuture>`

Future-proofed API of the runtime (used by KVC internals to read UTF-8
strings and to request a re-divination):

- `- (NSUInteger) mulleUTF8StringLength;`
- `- (NSUInteger) mulleGetUTF8String:(char *) buf bufferSize:(NSUInteger) maxLength;`
- `- (void) _divineKVCInformation:(struct _MulleObjCKVCInformation *) info forKey:(id) key methodType:(enum _MulleObjCKVCMethodType) type;`

### 3.4. `MulleObjCContainerKeyValueCoding.h` — global container helpers

Standalone C functions that drive KVC over containers (`NSArray`, `NSSet`):

```c
MULLE_OBJC_KVC_FOUNDATION_GLOBAL
id   MulleObjCContainerValueForKey( id self, NSString *key, id container);

MULLE_OBJC_KVC_FOUNDATION_GLOBAL
void   MulleObjCContainerTakeValueForKey( id self, id value, NSString *key);
```

- `MulleObjCContainerValueForKey( self, key, container)` iterates over `self`
  and appends `[p valueForKey:key]` to `container` (an `NSMutableArray` or
  `NSMutableSet`). Elements yielding `nil` are stored as `[NSNull null]` so
  "missing" is distinguishable. Returns `container`.
- `MulleObjCContainerTakeValueForKey( self, value, key)` iterates over `self`
  and calls `[p takeValue:value forKey:key]` on each element.

### 3.5. `NSNumber+MulleObjCKVCArithmetic.h` — arithmetic helpers

Small routines used by the `@sum` / `@avg` collection operators. The header
cautions that "in general though, arithmetic on NSNumber is a bad idea".

```c
@interface NSNumber( MulleObjCKVCArithmetic)

- (NSNumber *) _add:(NSNumber *) other;
- (NSNumber *) _divideByInteger:(NSUInteger) divisor;

@end
```

- `_add:` — adds `other` (nil = 0), promoting

  ints → `long long`, floats → `double` (or `long double` when available);
  weak numeric types are rejected with `NSInvalidArgumentException`.
- `_divideByInteger:` — divides by the divisor using the same type promotion.

### 3.6. `NSObject+_MulleObjCKVCInformation.h` — class-level toggles

```c
@interface NSObject( _MulleObjCKVCInformation)

+ (BOOL) accessInstanceVariablesDirectly;
+ (BOOL) useStoredAccessor;

@end
```

- `+ (BOOL) accessInstanceVariablesDirectly` — if `NO`, ivars are not
  eligible during divergence. Default `YES`. (Echoes classic Mac OS X
  `NSObject` KVC.)
- `+ (BOOL) useStoredAccessor` — if `NO`, `valueForKey:`/`takeValue:forKey:`
  never fall back to ivars; only the pure method path (`type` masked to
  `_MulleObjCKVCValueForKeyIndex`/`_MulleObjCKVCTakeValueForKeyIndex`) is
  used. Default `YES`.

`NSProxy` overrides `_divineKVCInformation:` (in `NSProxy+_MulleObjCKVCInformation.m`)
to only ever use generic method lookup (no ivars) for proxied objects.

### 3.7. `_MulleObjCInstanceVariableAccess.h` — untagged ivar access

Standalone C functions to directly read/write an ivar at a raw byte offset,
converting between the C value and an object (nil writes zero the slot):

```c
void   _MulleObjCSetInstanceVariableForType( id p, unsigned int offset, id value, char valueType);
id     _MulleObjCGetInstanceVariableForType( id p, unsigned int offset, char valueType);
```

- Handles all supported `valueType`s (`_C_BOOL`, `_C_CHR`, ... `_C_DBL`,
  `_C_SEL`, `_C_ID`, `_C_ASSIGN_ID`, `_C_COPY_ID`, `_C_CLASS`).
  `_C_ID`/`_C_CLASS` ivars retain the new value (autoreleasing the previous
  one), `_C_COPY_ID` stores a copy, `_C_ASSIGN_ID` assigns without ownership.
- `_MulleObjCSetInstanceVariableForType` is also used by
  `_MulleObjCSetObjectValueWithKVCInformation` when no accessor method exists.

### 3.8. `_MulleObjCKVCInformation.h` — the "divine" resolution machinery

This is the low-level resolver (mostly internal). It defines the candidate
mask and the functions that search a class for a matching accessor or ivar.

#### `typedef enum _MulleObjCKVCMethodMask`

```c
typedef enum
{
   _MulleObjCKVCGenericMethodOnly      = 0x0,
   _MulleObjCKVCUnderscoreMethodBit    = 0x1,
   _MulleObjCKVCMethodBit              = 0x2,
   _MulleObjCKVCUnderscoreIvarBit      = 0x4,
   _MulleObjCKVCIvarBit                = 0x8,
   _MulleObjCKVCUnderscoreGetMethodBit = 0x10,
   _MulleObjCKVCGetMethodBit           = 0x20,
   _MulleObjCKVCStandardMask           = 0x7FFF
} _MulleObjCKVCMethodMask;
```

#### Core divine functions (with explicit mask)

```c
void   __MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
```

plus the `_MulleObjCDivine<Flavor>ForKeyKVCInformation` static-inline wrappers
that pass `_MulleObjCKVCStandardMask`.

**Resolution orders** (implemented in `_MulleObjCKVCInformation.m`):

- `valueForKey:` (plain get): `get<Key>:` → `<key>:` → `_get<Key>:` →
  `_<key>:` → ivar `_<key>` → ivar `<key>` → unbound (`valueForUndefinedKey:`).
- `storedValueForKey:` (stored get): `_get<Key>:` → `_<key>:` → ivar
  `_<key>` → ivar `<key>` → `get<Key>:` → `<key>:` → unbound.
- `takeValue:forKey:` (plain set): `set<Key>:` → `_set<Key>:` → ivar
  `<key>` → ivar `_<key>` → unbound (`handleTakeValue:forUnboundKey:`).
- `takeStoredValue:forKey:` (stored set): `_set<Key>:` → ivar `_<key>` →
  ivar `<key>` → `set<Key>:` → unbound.

Ivar candidates are only considered when
`[aClass accessInstanceVariablesDirectly]` holds.

#### Other exported utility functions

```c
BOOL   _MulleObjCKVCIsUsingDefaultMethodOfType( Class aClass, enum _MulleObjCKVCMethodType type);
BOOL   _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( Class aClass, enum _MulleObjCKVCMethodType type, Class referenceClass);
void   _MulleObjCKVCInformationUseUnboundKeyMethod( struct _MulleObjCKVCInformation *p, Class aClass, BOOL isSetter);

void   __MulleObjCSetObjectValueWithAccessorForType( id obj, SEL sel, id value, IMP imp, char valueType);
id     __MulleObjCGetObjectValueWithAccessorForType( id obj, SEL sel, IMP imp, char valueType);
```

- `_MulleObjCKVCIsUsingDefaultMethodOfType:` — whether the class still uses
  the `NSObject` implementation for that method type (used to decide if the
  generic mask can be narrowed).
- `_MulleObjCKVCInformationUseUnboundKeyMethod:` — binds the unbound get/set
  hook into `p` (used after all candidates failed).

#### Final dispatch (static inline)

```c
static inline void   _MulleObjCSetObjectValueWithKVCInformation( id obj, id value, struct _MulleObjCKVCInformation *info)
static inline id     _MulleObjCGetObjectValueWithKVCInformation( id obj, struct _MulleObjCKVCInformation *info)
```

- If `info->implementation` is 0, use the raw ivar path
  (`_MulleObjCSetInstanceVariableForType` / `_MulleObjCGetInstanceVariableForType`),
  else call the accessor via `__MulleObjC(Set|Get)ObjectValueWithAccessorForType`.
  The accessor-free flavor only handles `_C_CLASS`/`_C_COPY_ID`/`_C_ASSIGN_ID`/`_C_RETAIN_ID`
  directly and numbers for everything else (values must be `NSNumber`).

### 3.9. Container KVC categories (declared in `.m` files, no separate headers)

These categories implement the KVC interface on containers. Their signatures
are those of `NSObject(_KeyValueCoding)` specialized by concrete classes.

- **`NSArray( _KeyValueCoding)`** (`NSArray+KeyValueCoding.m`)
  - `- (id) valueForKey:(NSString *) key` — immediate `nil` when empty;
    otherwise maps `valueForKey:` over all elements into a new
    `NSMutableArray` (via `MulleObjCContainerValueForKey`). When
    `INTERPRET_NUMERIC_KEYS` is defined (default), a key that is an `NSNumber`
    is treated as an element index: `[array valueForKey:numericIndex]`.
- **`NSMutableArray( _KeyValueCoding)`**
  - `- (void) takeValue:(id) value forKey:(NSString *) key` — with numeric
    keys: index == count appends, index < count replaces (nil removes).
    String keys map `takeValue:forKey:` over all elements
    (`MulleObjCContainerTakeValueForKey`).
- **`NSSet( _KeyValueCoding)`** (`NSSet+KeyValueCoding.m`)
  - `- (id) valueForKey:(NSString *) key` — `nil` when empty, else maps over
    elements into a new `NSMutableSet`.
  - `- (void) takeValue:(id) value forKey:(NSString *) key` — maps over all
    members.
- **`NSDictionary( _KeyValueCoding)`** (`NSDictionary+KeyValueCoding.m`)
  - `- (id) valueForKey:(NSString *) key` — `nil` for empty key, else
    `[self objectForKey:key]`.
- **`NSMutableDictionary( _KeyValueCoding)`** (`NSMutableDictionary+KeyValueCoding.m`)
  - `- (void) takeValue:(id) value forKey:(NSString *) key` — `nil` removes
    the key, otherwise `[self setObject:value forKey:key]`.
- **`NSArray( MulleObjCKVCArithmetic)`** (`NSArray+MulleObjCKVCArithmetic.m`)
  - `- (NSNumber *) _numberValue` — sum of all elements (`_add:` fold).
  - `- (NSNumber *) _add:(NSNumber *) nr` — `nr + sum(elements)`.
  - `- (NSNumber *) _divideByInteger:(NSUInteger) divisor`.
- **`NSSortDescriptor( NSKeyValueCoding)`** (`NSSortDescriptor+NSKeyValueCoding.m`)
  - `- (NSComparisonResult) compareObject:(id) a toObject:(id) b` — compares
    `[a valueForKeyPath:_key]` with `[b valueForKeyPath:_key]` using the
    descriptor's stored selector, honoring its ascending flag. This is what
    lets `NSSortDescriptor` sort arrays of arbitrary objects by a KVC key
    path.

### 3.10. `MulleObjCDeps+MulleObjCKVCFoundation.h`

Generated metadata:

```c
@interface MulleObjCDeps( MulleObjCKVCFoundation)
@end
```

Declares the categories contributed by this library for the
`mulle-objc-list` runtime introspection tooling. No methods of its own.

### 3.11. Key paths and collection operators

`valueForKeyPath:` splits its string on `.`, then resolves each segment with
`valueForKey:` on the current object. A segment that *starts with `@`* is an
**operator** applied to the current object (expected to be a container):

- `@count` — replaces the object with `[object count]` as `NSNumber`.
  O(1).
- `@sum` — sums all elements (`_add:`). Optional rest path: `@sum.key`
  first resolves `key` on every element, then sums.
- `@avg` — like `@sum` but divides by the element count (only when count > 1).
- `@min` / `@max` — min/max of the elements (or of each element's rest-path
  value), using `[previous compare:value]`.

Any other `@`-word raises `NSInvalidArgumentException`
("doesn't know what to do with %@"). Operators may appear anywhere in a path,
e.g. `@"orders.@sum.price"`.

## 4. Performance Characteristics

- **Key resolution is cached:** the first `valueForKey:`/`takeValue:forKey:`
  for a given class+key+method-type performs a class-hierarchy method/ivar
  search ("divination"). The result is cached per class and key
  (`_mulle_objc_kvcinfo`, resolved for all 4 flavors at once). Subsequent
  calls are a hash lookup: **O(1)** amortized, with no allocation.
- **Key paths:** `valueForKeyPath:` is O(k) hash lookups, where k is the
  number of path segments. `takeValue:forKeyPath:` traverses the same way and
  then does one final write.
- **Container mapping:** `valueForKey:` / `takeValue:forKey:` on `NSArray`
  and `NSSet` are **O(n)** in the element count; they allocate a result
  container in advance (capacity = n).
- **Operators:** `@count` is O(1); `@sum`, `@avg`, `@min`, `@max` are
  **O(n)** with an extra `valueForKeyPath:` per element when a rest path is
  given.
- **Memory:** no allocations for a plain key access. Batch operations
  (`valuesForKeys:`) allocate a dictionary. Cached KVC info is stored
  per-class, not per-instance, so it is shared across instances.
- **Thread-safety:** Not thread-safe. The KVC info cache, ivar access and the
  container helpers are safe only for single-threaded use or with external
  locking.

## 5. AI Usage Recommendations & Patterns

### Best Practices

- Import `<MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>` to get the whole
  KVC API in one `#import`.
- Prefer the modern `setValue:forKey:` / `valueForKey:` pair. The classic
  `takeValue:forKey:` flavor is equivalent; don't mix both designations unless
  supporting legacy code.
- Use key paths (`@"address.city"`) and operators (`@"@sum.price"`) for
  generic data-driven code instead of hand-written nested access.
- Read batches with `dictionaryWithValuesForKeys:` / `valuesForKeys:` and
  write batches with `takeValuesFromDictionary:`.
- For objects whose state does not map to accessors/ivars, override
  `valueForUndefinedKey:` (get) and `setValue:forUndefinedKey:` (set) —
  e.g. to back arbitrary keys with an `NSMutableDictionary`.
- C-typed ivars are transparently boxed (`NSNumber`) on read and unboxed on
  write. `id`/retained ivars are retrained/copied and previous values
  autoreleased by the storage glue.
- When sorting by a property, use `NSSortDescriptor` + KVC: it resolves the
  key path on each element for you.

### Common Pitfalls

- **Unbound keys are fatal by default.** A missing key raises
  `NSUndefinedKeyException` (get) or a `NSInvalidArgumentException` (set).
  Override the hooks if a default is needed.
- **Empty containers return `nil`:** `[NSArray array] valueForKey:@"anything"`
  is `nil` (not an empty array).
- **Missing values become NSNull:** `[NSArray valueForKey:]` and `[NSSet
  valueForKey:]` store `[NSNull null]` for elements that return `nil`, so
  check with `[value isNSNull]` (or `value == nil`) when iterating results.
- **No type safety:** KVC does no type checking. Passing a non-`NSNumber`
  value to a numeric setter raises an exception; a mismatched read can return
  `nil`.
- **`takeValue:forKeyPath:`** only writes through the *last* segment; the
  leading segments are resolved with reads, so a `nil` intermediate raises
  `NSUndefinedKeyException`.
- **Do not call the internal divination functions**
  (`__MulleObjCDivine*`, `_MulleObjC*InstanceVariableForType`,
  `_getKVCInformation:`) from application code — they are implementation
  machinery that the public `valueForKey:`/`takeValue:` methods use.
- **Do not store the returned `key` of a `struct _MulleObjCKVCInformation`**
  beyond the immediate use; it is borrowed and not copied (see the `// TODO`
  in `NSObject+KVCSupport.h`).

### Idiomatic Usage

```objc
// single key read/write
id name = [person valueForKey:@"name"];
[person setValue:@"Alice"
         forKey:@"name"];

// nested read (shortcut for [[person address] city])
NSString *city = [person valueForKeyPath:@"address.city"];

// aggregate over an array of objects
NSNumber *avg = [products valueForKeyPath:@"@avg.price"];
NSNumber *sum = [products valueForKeyPath:@"@sum.price"];
NSNumber *max = [products valueForKeyPath:@"@max.price"];
NSNumber *n   = [products valueForKeyPath:@"@count"];

// batch read into a dictionary
NSDictionary *values = [person dictionaryWithValuesForKeys:@[ @"name", @"age"]];
```

## 6. Integration Examples

### Example 1: Storing and reading values (accessor- and ivar-based)

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Person : NSObject
{
@public
   int   _age;
}
@property( retain) NSString   *name;
@end

@implementation Person
@end


int   main( void)
{
   Person   *person;

   person = [[Person new] autorelease];

   // resolves to the -setName: accessor
   [person setValue:@"Alice"
            forKey:@"name"];
   // resolves to the _age ivar (no setter exists)
   [person setValue:[NSNumber numberWithInt:30]
            forKey:@"age"];

   mulle_printf( "name: %s\n", [[person valueForKey:@"name"] UTF8String]);
   mulle_printf( "age : %ld\n", (long) [[person valueForKey:@"age"] intValue]);

   // stored access reads the _age ivar directly
   mulle_printf( "age : %ld\n", (long) [[person storedValueForKey:@"age"] intValue]);
   return( 0);
}
```

### Example 2: Key paths (nested access)

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Address : NSObject
@property( retain) NSString   *city;
@property( retain) NSString   *country;
@end

@interface Person : NSObject
@property( retain) NSString   *name;
@property( retain) Address    *address;
@end

@implementation Address
@end

@implementation Person
@end


int   main( void)
{
   Person     *person;
   Address    *address;
   NSString   *city;

   address = [[Address new] autorelease];
   [address setValue:@"Paris"
             forKey:@"city"];
   [address setValue:@"France"
             forKey:@"country"];

   person = [[Person new] autorelease];
   [person setValue:@"Alice"
            forKey:@"name"];
   [person setValue:address
            forKey:@"address"];

   // valueForKeyPath: == [[person address] city]
   city = [person valueForKeyPath:@"address.city"];
   mulle_printf( "city: %s\n", [city UTF8String]);

   // write through the path
   [person takeValue:@"Rome"
        forKeyPath:@"address.city"];
   mulle_printf( "city: %s\n", [[address city] UTF8String]);
   return( 0);
}
```

### Example 3: Collection operators (@count, @sum, @avg, @max)

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

int   main( void)
{
   NSArray    *numbers;
   NSNumber   *result;

   numbers = [NSArray arrayWithObjects:[NSNumber numberWithInt:100],
                                        [NSNumber numberWithInt:200],
                                        [NSNumber numberWithInt:300],
                                        nil];

   result = [numbers valueForKeyPath:@"@count"];
   mulle_printf( "count: %ld\n", (long) [result longLongValue]);

   result = [numbers valueForKeyPath:@"@sum"];
   mulle_printf( "sum  : %ld\n", (long) [result longLongValue]);

   result = [numbers valueForKeyPath:@"@max"];
   mulle_printf( "max  : %ld\n", (long) [result longLongValue]);
   return( 0);
}
```

### Example 4: Aggregate over an object property (@avg.key / @max.key)

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Product : NSObject
@property( assign) double   price;
@end

@implementation Product
@end


int   main( void)
{
   Product    *a;
   Product    *b;
   Product    *c;
   NSArray    *products;
   NSNumber   *result;

   a = [[Product new] autorelease];
   b = [[Product new] autorelease];
   c = [[Product new] autorelease];

   [a setPrice:10.0];
   [b setPrice:20.0];
   [c setPrice:30.0];

   products = [NSArray arrayWithObjects:a, b, c, nil];

   // "@avg.price" first resolves "price" on every element, then averages
   result = [products valueForKeyPath:@"@avg.price"];
   mulle_printf( "avg price: %.1f\n", [result doubleValue]);

   result = [products valueForKeyPath:@"@max.price"];
   mulle_printf( "max price: %.1f\n", [result doubleValue]);
   return( 0);
}
```

### Example 5: Handling undefined keys with a backing dictionary

The get hook `valueForUndefinedKey:` and the set hook
`setValue:forUndefinedKey:` make an object behave like an open dictionary:

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface FlexibleObject : NSObject
{
@public
   NSMutableDictionary   *_properties;
}
- (id) valueForUndefinedKey:(NSString *) key;
- (void) setValue:(id) value
            forUndefinedKey:(NSString *) key;
- (void) dealloc;
@end


@implementation FlexibleObject

- (id) valueForUndefinedKey:(NSString *) key
{
   if( ! _properties)
      return( nil);
   return( [_properties objectForKey:key]);
}


- (void) setValue:(id) value
            forUndefinedKey:(NSString *) key
{
   if( ! _properties)
      _properties = [NSMutableDictionary dictionary];
   [_properties setObject:value
                   forKey:key];
}


- (void) dealloc
{
   [_properties release];
   [super dealloc];
}

@end


int   main( void)
{
   FlexibleObject   *obj;
   id               value;

   obj = [[FlexibleObject new] autorelease];

   // "someKey" has no accessor/ivar -> setValue:forUndefinedKey:
   [obj setValue:@"custom value"
        forKey:@"someKey"];
   // -> valueForUndefinedKey:
   value = [obj valueForKey:@"someKey"];
   mulle_printf( "value: %s\n", [value UTF8String]);
   return( 0);
}
```

### Example 6: Mapping keys over arrays and sets

```objc
#import <MulleObjCKVCFoundation/MulleObjCKVCFoundation.h>

@interface Product : NSObject
@property( retain) NSString   *name;
@end

@implementation Product
@end


int   main( void)
{
   Product          *a;
   Product          *b;
   NSMutableArray   *products;
   NSArray          *names;

   a = [[Product new] autorelease];
   b = [[Product new] autorelease];
   [a setName:@"Alpha"];
   [b setName:@"Beta"];

   products = [NSMutableArray arrayWithObjects:a, b, nil];

   // collect one key over all elements -> (NSMutableArray) @[ @"Alpha", @"Beta" ]
   names = [products valueForKey:@"name"];
   mulle_printf( "first: %s\n", [[names objectAtIndex:0] UTF8String]);

   // write one key on every element
   [products takeValue:@"Discounted"
             forKey:@"name"];
   mulle_printf( "changed: %s\n", [[a name] UTF8String]);
   return( 0);
}
```

## 7. Dependencies

Direct `mulle-sde` library dependencies (from `.mulle/etc/sourcetree/config`):

- `MulleObjCStandardFoundation`
- `mulle-objc-list`