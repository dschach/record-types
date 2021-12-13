---
layout: default
---

# RecordTypes class

This class is meant to allow for access to Record Type information from within other classes. It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient. Usage recommendation: Always use Developer Name instead of Name, as this is more likely to be hard-coded in places, while the

**Author:** David Schach

**Date:** 2021

## Related

[RecordTypesTest](https://github.com/dschach/record-types/wiki/RecordTypesTest.md)

---

## Properties

### `gd` → `Map<String, Schema.SObjectType>`

Global schema describe

### `recordTypesByDevName` → `Map<String, Schema.RecordTypeInfo>>`

Map of Record Types by Object name, then by Developer Name

### `recordTypesById` → `Map<Id, Schema.RecordTypeInfo>>`

Map of Record Types by Object name, then by Id

### `recordTypesByName` → `Map<String, Schema.RecordTypeInfo>>`

Map of Record Types by Object name, then by Name

### `recordTypesList` → `List<Schema.Recordtypeinfo>`

Map of Record Types by Object name, then by

---

## Methods

### `fillMapsForObject(String objectName)` → `void`

Gets record type maps for a new object

#### Parameters

| Param        | Description  |
| ------------ | ------------ |
| `objectName` | SObject name |

### `getRecordType(String objectName, Id recordTypeId)` → `Schema.RecordTypeInfo`

Given an object and RT Id, give the recordType object

#### Parameters

| Param          | Description    |
| -------------- | -------------- |
| `objectName`   | SObject name   |
| `recordTypeId` | Record Type Id |

#### Return

**Type**

Schema.RecordTypeInfo

**Description**

RecordTypeInfo object

### `getRecordTypeDevNameIdMap(String objectName)` → `Map<String, Id>`

Gives a map of all record type IDs by developer name for an object

#### Parameters

| Param        | Description  |
| ------------ | ------------ |
| `objectName` | SObject name |

#### Return

**Type**

Map&lt;String, Id&gt;

**Description**

Map&lt;RecordTypeDeveloperName, RecordTypeId&gt;

### `getRecordTypeDeveloperNameFromId(String objectName, Id recordTypeId)` → `String`

Given an object and RT Id, give the recordType DeveloperName

#### Parameters

| Param          | Description    |
| -------------- | -------------- |
| `objectName`   | SObject name   |
| `recordTypeId` | Record Type Id |

#### Return

**Type**

String

**Description**

RecordType Developer Name

### `getRecordTypeDeveloperNameFromName(String objectName, String recordTypeName)` → `String`

Given an object and RT Name, give the recordTypeId Note: Since Record Type Name is not unique, this could give unpredicable results

#### Parameters

| Param            | Description                           |
| ---------------- | ------------------------------------- |
| `objectName`     | SObject name                          |
| `recordTypeName` | Record Type Name (can include spaces) |

#### Return

**Type**

String

**Description**

RecordType DeveloperName

### `getRecordTypeFromDeveloperName(String objectName, String recordTypeDeveloperName)` → `Schema.RecordTypeInfo`

Given an object and RT Developer Name, give the recordTypeId

#### Parameters

| Param            | Description                                        |
| ---------------- | -------------------------------------------------- |
| `objectName`     | SObject name                                       |
| `recordTypeName` | Record Type Developer Name (cannot include spaces) |

#### Return

**Type**

Schema.RecordTypeInfo

**Description**

RecordTypeInfo object

### `getRecordTypeFromId(String objectName, Id recordTypeId)` → `Schema.RecordTypeInfo`

Given an object and RT Id, give the Record Type object

#### Parameters

| Param          | Description    |
| -------------- | -------------- |
| `objectName`   | SObject name   |
| `recordTypeId` | Record Type Id |

#### Return

**Type**

Schema.RecordTypeInfo

**Description**

RecordTypeInfo object

### `getRecordTypeFromName(String objectName, String recordTypeName)` → `Schema.RecordTypeInfo`

Given an object and RT Name, give the RecordType object Note: Since Record Type Name is not unique, this section could give unpredicable results If possible, DO NOT USE these methods - use DeveloperName instead

#### Parameters

| Param            | Description                           |
| ---------------- | ------------------------------------- |
| `objectName`     | SObject name                          |
| `recordTypeName` | Record Type Name (can include spaces) |

#### Return

**Type**

Schema.RecordTypeInfo

**Description**

RecordTypeInfo object

### `getRecordTypeIdFromDeveloperName(String objectName, String recordTypeDeveloperName)` → `Id`

Given an object and RT Developer Name, give the recordTypeId

#### Parameters

| Param            | Description                                        |
| ---------------- | -------------------------------------------------- |
| `objectName`     | SObject name                                       |
| `recordTypeName` | Record Type Developer Name (cannot include spaces) |

#### Return

**Type**

Id

**Description**

RecordType Id

### `getRecordTypeIdFromName(String objectName, String recordTypeName)` → `Id`

Given an object and RT Name, give the recordTypeId Note: Since Record Type Name is not unique, this could give unpredicable results

#### Parameters

| Param            | Description                           |
| ---------------- | ------------------------------------- |
| `objectName`     | SObject name                          |
| `recordTypeName` | Record Type Name (can include spaces) |

#### Return

**Type**

Id

**Description**

RecordType Id

### `getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet)` → `Set<Id>`

Gives a set of record type IDs from an object and a set of developernames

#### Parameters

| Param               | Description           |
| ------------------- | --------------------- |
| `objectName`        | Object of interest    |
| `RecordTypeNameSet` | Set of DeveloperNames |

#### Return

**Type**

Set&lt;Id&gt;

**Description**

return Id set

### `getRecordTypeNameFromDeveloperName(String objectName, String recordTypeDeveloperName)` → `String`

Given an object and RT Developer Name, give the Record Type Name

#### Parameters

| Param            | Description                                        |
| ---------------- | -------------------------------------------------- |
| `objectName`     | SObject name                                       |
| `recordTypeName` | Record Type Developer Name (cannot include spaces) |

#### Return

**Type**

String

**Description**

RecordType Name

### `getRecordTypeNameFromId(String objectName, Id recordTypeId)` → `String`

Given an object and RT Id, give the RecordType Name

#### Parameters

| Param          | Description    |
| -------------- | -------------- |
| `objectName`   | SObject name   |
| `recordTypeId` | Record Type Id |

#### Return

**Type**

String

**Description**

RecordType Name

### `getRecordTypeNameIdMap(String objectName)` → `Map<String, Id>`

Gives a map of all record type IDs by name for an object

#### Parameters

| Param        | Description  |
| ------------ | ------------ |
| `objectName` | SObject name |

#### Return

**Type**

Map&lt;String, Id&gt;

**Description**

Map&lt;RecordType Name, RecordTypeId&gt;

### `getRecordTypesForSelectList(String objectName)` → `List<SelectOption>`

Make a Visualforce picklist with the RT Name displayed and the RT Id as the value

#### Parameters

| Param        | Description                             |
| ------------ | --------------------------------------- |
| `objectName` | Object name (with \_\_c if custom, etc) |

#### Return

**Type**

List&lt;SelectOption&gt;

**Description**

Visualforce SelectOption list

### `getStringRecordTypesForSelectList(String objectName)` → `List<SelectOption>`

Make a Visualforce picklist with the RT Name displayed and the RT Name as the value

#### Parameters

| Param        | Description                             |
| ------------ | --------------------------------------- |
| `objectName` | Object name (with \_\_c if custom, etc) |

#### Return

**Type**

List&lt;SelectOption&gt;

**Description**

Visualforce SelectOption list

---
