---
layout: default
---

# Classes

## [RecordTypes](https://github.com/dschach/record-types/blob/main/docs/RecordTypes.md)

This class is meant to allow for access to Record Type information from within other classes. &lt;br&gt; It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient. &lt;br&gt; Usage recommendation: Always use Developer Name instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change (especially due to user language).

## [RecordTypesTest](https://github.com/dschach/record-types/blob/main/docs/RecordTypesTest.md)

Test class for RecordTypes.cls We test nonexistent object names, nonexistent record type names, null values, and existing Account record type (if available)
