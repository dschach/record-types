# Record Types

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

[Documentation](https://dschach.github.io/record-types/RecordTypes.html) (generated with [ApexDox](https://github.com/no-stack-dub-sack/apexdox-vs-code))

## Package Installation

<a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04tQm000000gf3ZIAQ">
  <img alt="Deploy to Salesforce"
       src="./media/deploy-package-to-prod.png">
</a>
<a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04tQm000000gf3ZIAQ">
  <img alt="Deploy to Salesforce Sandbox"
       src="./media/deploy-package-to-sandbox.png">
</a>

## Installation (via VCS)

Clone this repository and run

```bash
. scripts/orginit.sh
```

to set up a scratch org with the classes installed and a single Account Record Type.

To set up a scratch org without creating a Record Type, run

```bash
. scripts/orginit-norecordtypes.sh
```

## [Changelog](./CHANGELOG.md)

- 2024-02

  - Enhance SelectList methods
  - Update to API 60.0
  - Increase code coverage and test cases

- 2023-09

  - Overload getRecordTypeFromId so it doesn't require a SobjectType string
  - Release unlocked package

- 2023-08

  - Add methods to get default RecordTypeId, handling situation where no RT is on the Profile but at least one is avaialble via Permission Set.
  - Add test methods against Account and Solution objects, as we assume Solution has no defined record types. (Change for your org if you have them.)
  - Include table of all methods on documentation site

- 2022-03

  - BREAKING CHANGE: Replaced "DeveloperName" with "DevName" in all method names. Update your code to refer to the new methods.

- 2022-03

  - Add maps Id => Name and Id => DeveloperName for ease of use when wanting to refer to a record type by Id without including the object, since Id is globally unique

- 2022-01
  - Initial Release

## Code Header

Written by Evan Callahan, copyright &copy; 2010 Groundwire

- This program is released under the [GNU General Public License](./LICENSE). http://www.gnu.org/licenses/
- This class is meant to allow for access to Record Type information from within other classes.
- It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient.

Updated by David Schach, copyright &copy; X-Squared on Demand

- Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change (especially due to user language).

# Library Methods

(Full documentation at [https://dschach.github.io/record-types](https://dschach.github.io/record-types/))

## Most Common Methods

These are the most common methods to be used. They are the fastest ways to get a Record Type Id from an object name and the developer name, for example.

There are some overloaded methods included for historical purposes (the ones that accept a Record Type Id and an object name and return the developer name).
While the object name is, technically, optional, that method is faster because it does not require memoizing a SOQL query.

| Parameters / Output           | Id                             | Name                         | DeveloperName                |
| ----------------------------- | ------------------------------ | ---------------------------- | ---------------------------- |
| objectName, recordTypeName    | getRecordTypeIdFromName        |                              |                              |
| objectName, recordTypeName    |                                |                              | getRecordTypeDevNameFromName |
| objectName, recordTypeDevName | **getRecordTypeIdFromDevName** |                              |                              |
| objectName, recordTypeDevName |                                | getRecordTypeNameFromDevName |                              |
| objectName, recordTypeId      |                                | getRecordTypeNameFromId      |                              |
| objectName, recordTypeId      |                                |                              | getRecordTypeDevNameFromId   |
| recordTypeId                  |                                | getRecordTypeNameFromId      |                              |
| recordTypeId                  |                                |                              | getRecordTypeDevNameFromId   |

## Helper Methods

These methods check record types available to the current/running user.

| Parameters / Output           | Boolean (yes/no)      |
| ----------------------------- | --------------------- |
| objectName, recordTypeDevName | isRecordTypeAvailable |
| objectName, recordTypeDevName | isRecordTypeDefault   |

## Less Common Methods

The most useful of these may be the SelectList generators for Visualforce. However, if you are using LWC, you may prefer to use some of the other methods and to parse the returned list of RecordTypeInfo items yourself.

| Parameters / Output                      | Schema.RecordTypeInfo    | Set&lt;Id&gt;                  | Map&lt;String, Id&gt;              | SelectList                           |
| ---------------------------------------- | ------------------------ | ------------------------------ | ---------------------------------- | ------------------------------------ |
| recordTypeId                             | getRecordTypeFromId      |                                |                                    |                                      |
| objectName, recordTypeId                 | getRecordTypeFromId      |                                |                                    |                                      |
| objectName, recordTypeDevName            | getRecordTypeFromDevName |                                |                                    |                                      |
| objectName, Set&lt;recordTypeDevName&gt; |                          | getAvailableRecordTypesIdSet   |                                    |                                      |
| objectName, Set&lt;recordTypeDevName&gt; |                          | getRecordTypeIdSetFromDevNames |                                    |                                      |
| objectName                               |                          |                                | getRecordTypeDevNameIdMap          |                                      |
| objectName                               |                          |                                | getRecordTypeNameIdMap             |                                      |
| objectName                               |                          |                                | getAvailableRecordTypeDevNameIdMap |                                      |
| objectName                               |                          |                                | getAvailableRecordTypeNameIdMap    |                                      |
| objectName                               |                          |                                |                                    | getAllRecordTypesForSelectList       |
| objectName                               |                          |                                |                                    | getAvailableRecordTypesForSelectList |
| objectName                               |                          |                                |                                    | getStringRecordTypesForSelectList    |
