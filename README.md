# Record-Types

This is a project based on work by [Evan Callahan](https://github.com/groundwired) (formerly of Groundwire, and now at Salesforce) who wrote [this class](https://github.com/SalesforceFoundation/JenkinsTesting/blob/master/src/classes/RecordTypes.cls) (Repo has been deleted. Sadface.) a long time ago to reduce the number of describe calls required to work with Record Types.

I've updated the project (by pulling test code out of the main class - that's how old it was!) and have added some additional methods. The included test class has 100% coverage, so pull this into your org and get cracking!

Of note: The test code assumes that you have no record types for the Solution object. If you do, you may need to remove that test method.

## Badges

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![codecov](https://codecov.io/gh/dschach/record-types/branch/main/graph/badge.svg?token=RVhs6ab2Md)](https://codecov.io/gh/dschach/record-types)
[![CI](https://github.com/dschach/record-types/actions/workflows/ci.yml/badge.svg)](https://github.com/dschach/record-types/actions/workflows/ci.yml)
[![Scratch Org](https://github.com/dschach/record-types/actions/workflows/pr.yml/badge.svg)](https://github.com/dschach/record-types/actions/workflows/pr.yml)
[![Twitter](https://img.shields.io/twitter/follow/dschach.svg?style=social)](https://img.shields.io/twitter/follow/dschach.svg?style=social)

## The Code

The class and test class are found in this [folder](/force-app/main/default/classes/). Feel free to copy/paste directly into your org.

## Documentation

[ApexDox](https://dschach.github.io/record-types/RecordTypes.html) (generated with [ApexDox](https://github.com/no-stack-dub-sack/apexdox-vs-code))

## Installation

- Clone this repository and run `. scripts/orginit.sh` to set up a scratch org with the classes installed and a single Account Record Type.
- To set up a scratch org without creating a Record Type, run `.scripts/orginit-norecordtypes.sh`

## [Changelog](./CHANGELOG.md)

- 2023-08-18

  - Add methods to get default RecordTypeId, handling situation where no RT is on the Profile but at least one is avaialble via Permission Set.
  - Add test methods against Account and Solution objects, as we assume Solution has no defined record types. (Change for your org if you have them.)

- 2022-03-29 BREAKING CHANGE: Replaced "DeveloperName" with "DevName" in all method names. Update your code to refer to the new methods.

- 2022-03-29 Add maps Id => Name and Id => DeveloperName for ease of use when wanting to refer to a record type by Id without including the object, since Id is globally unique

- 2022-01-19 Initial Release

## Code Header

Written by Evan Callahan, copyright (c) 2010 Groundwire

- This program is released under the [GNU General Public License](./LICENSE). http://www.gnu.org/licenses/
- This class is meant to allow for access to Record Type information from within other classes.
- It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient.

Updated by David Schach, copyright (c) 2021 X-Squared on Demand

- Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change (especially due to user language).

# Library Methods

## Most Common Methods

<p>
	These are the most common methods to be used. They are the fastest ways to get a Record Type Id from an object name and the developer name, for example.
	<br />
	There are some overloaded methods included for historical purposes (the ones that accept a Record Type Id and an object name and return the developer name).
	While the object name is, technically, optional, that method is faster because it does not require memoizing a SOQL query.
</p>
| Parameters / Output           | Id                         | Name                         | DeveloperName                |
|-------------------------------|----------------------------|------------------------------|------------------------------|
| objectName, recordTypeName    | getRecordTypeIdFromName    |                              |                              |
| objectName, recordTypeName    |                            |                              | getRecordTypeDevNameFromName |
| objectName, recordTypeDevName |                            |                              | getRecordTypeFromDevName     |
| objectName, recordTypeDevName |                            | getRecordTypeNameFromDevName |                              |
| objectName, recordTypeDevName | getRecordTypeIdFromDevName |                              |                              |
| objectName, recordTypeId      |                            | getRecordTypeNameFromId      |                              |
| objectName, recordTypeId      |                            |                              | getRecordTypeDevNameFromId   |
| recordTypeId                  |                            | getRecordTypeNameFromId      |                              |
| recordTypeId                  |                            |                              | getRecordTypeDevNameFromId   |

## Less Common Methods

<p>
	These methods are used less often but may be useful.
	<br />
	The most useful of these are the SelectList generators for Visualforce. However, if you are using LWC, you may prefer to use some of the other methods and to
	parse the returned list of RecordTypeInfo items yourself.
</p>

| Parameters / Output                      | Schema.RecordTypeInfo | Map(String, Id)                    | SelectList                        | Set&lt;Id&gt;                  |
| ---------------------------------------- | --------------------- | ---------------------------------- | --------------------------------- | ------------------------------ |
| recordTypeId                             | getRecordTypeFromId   |                                    |                                   |                                |
| objectName, recordTypeId                 | getRecordTypeFromId   |                                    |                                   |                                |
| objectName, Set&lt;recordTypeDevName&gt; |                       |                                    |                                   | getRecordTypeIdSetFromDevNames |
| objectName                               |                       | getRecordTypeDevNameIdMap          |                                   |                                |
| objectName                               |                       | getRecordTypeNameIdMap             |                                   |                                |
| objectName                               |                       | getAvailableRecordTypeDevNameIdMap |                                   |                                |
| objectName                               |                       | getAvailableRecordTypeNameIdMap    |                                   |                                |
| objectName                               |                       |                                    | getRecordTypesForSelectList       |                                |
| objectName                               |                       |                                    | getAllRecordTypesForSelectList    |                                |
| objectName                               |                       |                                    | getStringRecordTypesForSelectList |                                |
