KVC is a hybrid of MulleObjC and MulleObjCFoundation

It should probably move to its own library. Because it 
uses runtime information it breaks the rule, that
MulleObjCFoundation shouldn't be using mulle_objc_
C calls.
