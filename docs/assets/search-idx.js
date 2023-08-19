export default [
    {
        "title": "Home",
        "fileName": "index.html",
        "text": "Home Record Types Utilities Written by Evan Callahan, copyright(c) 2010 Groundwire This program is released under the GNU General Public License. http://www.gnu.org/licenses/ This class is meant to allow for access to Record Type information from within other classes. It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient. Updated by David Schach, copyright(c) 2021 X-Squared on Demand This class is allows for easy, readable access to Record Type information from other classes. Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change(especially due to user language). Record-Types This is a project based on work by Evan Callahan (formerly of Groundwire, and now at Salesforce) who wrote this class (Repo has been deleted. Sadface.) a long time ago to reduce the number of describe calls required to work with Record Types. I've updated the project(by pulling test code out of the main class - that's how old it was!) and have added some additional methods. The included test class has 100% coverage, so pull this into your org and get cracking! Of note: The test code assumes that you have no record types for the Solution object. If you do, you may need to remove that test method. Badges The Code The class and test class are found in this folder . Feel free to copy/paste directly into your org. Documentation ApexDox (generated with ApexDox ) Installation Clone this repository and run . scripts/orginit.sh  to set up a scratch org with the classes installed and a single Account Record Type. To set up a scratch org without creating a Record Type, run .scripts/orginit-norecordtypes.sh Changelog 2023-08-18 Add methods to get default RecordTypeId, handling situation where no RT is on the Profile but at least one is avaialble via Permission Set. Add test methods against Account and Solution objects, as we assume Solution has no defined record types.(Change for your org if you have them.) 2022-03-29 BREAKING CHANGE: Replaced \"DeveloperName\" with \"DevName\" in all method names. Update your code to refer to the new methods. 2022-03-29 Add maps Id => Name and Id => DeveloperName for ease of use when wanting to refer to a record type by Id without including the object, since Id is globally unique 2022-01-19 Initial Release"
    },
    {
        "title": "changelog",
        "fileName": "changelog.html",
        "text": "Changelog 1.2.1 (2023-08-16) Build System ApexDox:  Update ApexDox(#62 )(ae8063b ) deps-dev:  Bump @prettier/plugin-xml from 2.2.0 to 3.1.1(#56 )(d2f0a8a ) deps-dev:  Bump @prettier/plugin-xml from 3.1.1 to 3.2.0(#58 )(8ab6421 ) deps-dev:  Bump lint-staged from 13.2.0 to 13.2.1(#45 )(b8539fd ) deps-dev:  Bump lint-staged from 13.2.1 to 13.2.2(#49 )(a058181 ) deps-dev:  Bump lint-staged from 13.2.2 to 13.2.3(#52 )(f43ed99 ) deps-dev:  Bump lint-staged from 13.2.3 to 14.0.0(#59 )(3994458 ) deps-dev:  Bump prettier and prettier-plugin-apex(#53 )(1c8fa7b ) deps-dev:  Bump prettier from 2.8.4 to 2.8.5(#42 )(5e23e23 ) deps-dev:  Bump prettier from 2.8.5 to 2.8.6(#43 )(5995994 ) deps-dev:  Bump prettier from 2.8.6 to 2.8.7(#44 )(49e70d4 ) deps-dev:  Bump prettier from 2.8.7 to 2.8.8(#46 )(4511236 ) deps-dev:  Bump prettier from 3.0.0 to 3.0.1(#57 )(773c11c ) deps-dev:  Bump prettier from 3.0.1 to 3.0.2(#60 )(93c293e ) deps-dev:  Bump prettier-plugin-apex from 1.12.0 to 1.13.0(#47 )(0bbb6b5 ) deps:  Bump yaml from 2.2.1 to 2.2.2(#48 )(3bfb579 ) sfdx:  Update sfdx cli to sf cli(#61 )(eb80d9e ) Documentation ApexDox:  Update highlight.js library(b8f7630 ) Bug Fixes build:  Fix pull request GitHub action(9f55805 ) Chores linguist:  Exclude vendor js files(#50 )(9d7bcfa ) 1.2.0 (2023-03-14) Features Implement release-please(#40 )(d254692 ) Bug Fixes Bump @sideway/formula from 3.0.0 to 3.0.1(5bca1b8 ) Bump lint-staged from 13.1.1 to 13.1.2(2ef66b1 ) Bump npm from 9.4.2 to 9.5.0(174b6c7 ) PR testing only on force-app path(1395d3a ) Continuous Integration dependabot:  No scratch org on dependabot(#38 )(c8d21dc ) dependabot:  Scope dependabot PRs(dc02bba ) Build System Bump lint-staged from 13.1.2 to 13.2.0(#37 )(f981c20 ) Bump prettier from 2.8.3 to 2.8.4(d01b32f ) npm:  Bump npm from 9.4.2 to 9.5.0(#36 )(54c0f2a ) npm:  Remove npm dev-dependency(aea80de ) 1.1.0 (2023-02-08) Features API 56, new methods(#27 )(cb53adc ) Bug Fixes Bump lint-staged from 13.1.0 to 13.1.1(#25 )(ce97526 ) Bump npm from 9.4.1 to 9.4.2(#26 )(1aa9923 ) Change Active to Available(8973e2b ) Change Active to Available(76e1d0b ) Highlight 11.7(632b1fe ) Highlight 11.7 typo(8973e2b ) Miscellaneous Chores Release 1.1.0(3be676c ) 1.1.0 (2023-02-07) Features API 56, new methods(#27 )(cb53adc ) Bug Fixes bump lint-staged from 13.1.0 to 13.1.1(#25 )(ce97526 ) bump npm from 9.4.1 to 9.4.2(#26 )(1aa9923 ) Miscellaneous Chores release 1.1.0(3be676c )"
    },
    {
        "title": "RecordTypesHome",
        "fileName": "RecordTypesHome.html",
        "text": "Record Types Utilities Written by Evan Callahan, copyright(c) 2010 Groundwire This program is released under the GNU General Public License. http://www.gnu.org/licenses/ This class is meant to allow for access to Record Type information from within other classes. It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient. Updated by David Schach, copyright(c) 2021 X-Squared on Demand This class is allows for easy, readable access to Record Type information from other classes. Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change(especially due to user language)."
    },
    {
        "title": "RecordTypes",
        "fileName": "RecordTypes.html",
        "text": "RecordTypes This class is allows for easy, readable access to Record Type information from other classes.  Written by Evan Callahan, copyright(c) 2010 Groundwire Updated by David Schach, copyright(c) 2021 X-Squared on Demand  This program is released under the GNU General Public License. http://www.gnu.org/licenses/  This class is meant to allow for access to Record Type information from within other classes.  It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient.  Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change(especially due to user language). Signature global inherited sharing class RecordTypes See RecordTypesTest Author Evan Callahan , Groundwire Since 2010 Author David Schach , X-Squared on Demand Since 2021 Author Nicolas Vasquez, Globant Since 2022 RecordTypes Properties Name Signature Description allRecordTypes private static Map<String, List<Schema.RecordTypeInfo>> allRecordTypes map of all Record Types by sObject name, including inactive and unavailable availableRecordTypesMap private static Map<String, List<Schema.Recordtypeinfo>> availableRecordTypesMap List of available(to the running user) Record Type Info sObjects defaultRecordTypeIds private static Map<String, Id> defaultRecordTypeIds Map of default Record Type  Ids for the running user defaultRecordTypes private static Map<String, Schema.RecordTypeInfo> defaultRecordTypes Map of object name to the default Schema.RecordTypeInfo  object for that object gd private static Map<String, Schema.SObjectType> gd Global schema describe recordTypesByDevName private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByDevName Map of Record Types by sObject name, then by DeveloperName recordTypesById private static Map<String, Map<Id, Schema.RecordTypeInfo>> recordTypesById Map of Record Types by sObject name, then by Id recordTypesByName private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByName Map of Record Types by sObject name, then by Name recordTypesIdMap private static Map<Id, RecordType> recordTypesIdMap Lazy-loaded, memoized map of queried RecordType  records by Id RecordTypes Methods clearMapsInTest() If we are running a test, clear sObject maps. We do this to avoid using @testVisible on the maps This is private and testvisible so it cannot be called in production code context fillMapsForObject(objectName) Gets record type maps for a new sObject We check in each public method if the sObject has already been described so we do not eagerly load DescribeSObjectResult getAllRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Id as the value getAvailableRecordTypeDevNameIdMap(objectName) Gives a map of all available(to the running user) RecordTypeId s by developername  for an sObject getAvailableRecordTypeNameIdMap(objectName) Gives a map of all available(to the running user) RecordTypeId s by name for an sObject getDefaultRecordType(objectName) Given an sObject Name, return the default Record Type Id for the running user getDefaultRecordTypeDevName(objectName) Given an sObject Name, return the default Record Type DeveloperName for the running user getDefaultRecordTypeId(objectName) Given an sObject Name, return the default Record Type Id for the running user getDefaultRecordTypeName(objectName) Given an sObject Name, return the default Record Type Name for the running user getRecordType(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  object getRecordTypeDevNameFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  DeveloperName This saves a query on the RecordType  object getRecordTypeDevNameFromId(recordTypeId) Generate map of all record type developerNames by Id & return Record Type DeveloperName This is an overloaded method for efficiency, using only the Id getRecordTypeDevNameFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  Id Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  methods instead getRecordTypeDevNameIdMap(objectName) Gives a map of all record type IDs by DeveloperName for an sObject getRecordTypeFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Id getRecordTypeFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the Record Type  object getRecordTypeFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  object Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  instead getRecordTypeIdFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Id This should be the most-used method in this class getRecordTypeIdFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  Id Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  instead getRecordTypeIdSetFromDevNames(objectName, recordTypeDevNameSet) Gives a set of RecordType  Ids from an sObject and a set of RecordType  DeveloperNames getRecordTypeNameFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Name getRecordTypeNameFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  Name getRecordTypeNameFromId(recordTypeId) Generate map of all record type names by Id & return Record Type Name getRecordTypeNameIdMap(objectName) Gives a map of all RecordType  IDs by name for an sObject getRecordTypesForObject(objectName) Gives a list of all the RecordTypeInfo  object records for an sObject This list has more items than just the record types available to the running user. This method has no immediately obvious uses, but perhaps an outside library will need this list for, say, a project for a LWC. getRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Id as the value getStringRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Name as the value clearMapsInTest() If we are running a test, clear sObject maps. We do this to avoid using @testVisible on the maps This is private and testvisible so it cannot be called in production code context Signature @testVisible private static void clearMapsInTest() fillMapsForObject(objectName) Gets record type maps for a new sObject We check in each public method if the sObject has already been described so we do not eagerly load DescribeSObjectResult Signature private static void fillMapsForObject(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Author David Schach getAllRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Id as the value Signature global static List<SelectOption> getAllRecordTypesForSelectList(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns List<SelectOption>  Visualforce SelectOption list Author David Schach getAvailableRecordTypeDevNameIdMap(objectName) Gives a map of all available(to the running user) RecordTypeId s by developername  for an sObject Signature global static Map<String, Id> getAvailableRecordTypeDevNameIdMap(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Map<String, Id>  Map<RecordType Name, RecordType Id> Authors Nicolas Vasquez, David Schach Since 2023 Use available record types map getAvailableRecordTypeNameIdMap(objectName) Gives a map of all available(to the running user) RecordTypeId s by name for an sObject Signature global static Map<String, Id> getAvailableRecordTypeNameIdMap(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Map<String, Id>  Map<RecordType Name, RecordType Id> Authors Nicolas Vasquez, David Schach Since 2023 Use available record types map getDefaultRecordType(objectName) Given an sObject Name, return the default Record Type Id for the running user Signature global static Schema.RecordTypeInfo getDefaultRecordType(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Id  Default Record Type Id for the running user for this object getDefaultRecordTypeDevName(objectName) Given an sObject Name, return the default Record Type DeveloperName for the running user Signature global static String getDefaultRecordTypeDevName(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns String  Default Record Type DeveloperName for the running user for this object getDefaultRecordTypeId(objectName) Given an sObject Name, return the default Record Type Id for the running user Signature global static Id getDefaultRecordTypeId(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Id  Default Record Type Id for the running user for this object getDefaultRecordTypeName(objectName) Given an sObject Name, return the default Record Type Name for the running user Signature global static String getDefaultRecordTypeName(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns String  Default Record Type Name for the running user for this object getRecordType(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  object Signature global static Schema.RecordTypeInfo getRecordType(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeId Type: Id RecordType Id Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeDevNameFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  DeveloperName This saves a query on the RecordType  object Signature global static String getRecordTypeDevNameFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeId Type: Id RecordType Id Returns RecordType  DeveloperName See getRecordTypeDevNameFromId Author David Schach getRecordTypeDevNameFromId(recordTypeId) Generate map of all record type developerNames by Id & return Record Type DeveloperName This is an overloaded method for efficiency, using only the Id Signature global static String getRecordTypeDevNameFromId(Id recordTypeId) Parameters recordTypeId Type: Id RecordTypeId Returns String  Record Type Name See getRecordTypeDevNameFromId Author David Schach Since 2022-03-29 getRecordTypeDevNameFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  Id Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  methods instead Signature global static String getRecordTypeDevNameFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeName Type: String RecordType Name(can include spaces) Returns RecordType.DeveloperName Author David Schach Example RecordTypes.getRecordTypeDevNameFromName('Account','Person Account') getRecordTypeDevNameIdMap(objectName) Gives a map of all record type IDs by DeveloperName for an sObject Signature global static Map<String, Id> getRecordTypeDevNameIdMap(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Map<String, Id>  Map<recordTypeDevName, RecordType Id> Author David Schach getRecordTypeFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Id Signature global static Schema.RecordTypeInfo getRecordTypeFromDevName(String objectName, String recordTypeDevName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeDevName Type: String RecordType.DeveloperName (cannot include spaces) Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach Example RecordTypes.getRecordTypeFromDevName('Account','Person_Account') getRecordTypeFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the Record Type  object Signature global static Schema.RecordTypeInfo getRecordTypeFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeId Type: Id RecordType Id Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  object Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  instead Signature global static Schema.RecordTypeInfo getRecordTypeFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeName Type: String RecordType Name(can include spaces) Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeIdFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Id This should be the most-used method in this class Signature global static Id getRecordTypeIdFromDevName(String objectName, String recordTypeDevName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeDevName Type: String RecordType.DeveloperName (cannot include spaces) Returns RecordType Id Author David Schach Example RecordTypes.getRecordTypeIdFromDevName('Account','Person_Account') getRecordTypeIdFromName(objectName, recordTypeName) Given an sObject and RecordType  Name, return the RecordType  Id Note: Since RecordType.Name  is not unique, this section could give unpredicable results If possible, DO NOT USE this method - use RecordType.DeveloperName  instead Signature global static Id getRecordTypeIdFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeName Type: String RecordType Name(can include spaces) Returns RecordType Id Author David Schach Example RecordTypes.getRecordTypeIdFromName('Account','Person Account') getRecordTypeIdSetFromDevNames(objectName, recordTypeDevNameSet) Gives a set of RecordType  Ids from an sObject and a set of RecordType  DeveloperNames Signature global static Set<Id> getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeDevNameSet Type: Set<String> Set of DeveloperNames Returns Set<Id>  All RecordType  IDs for a given sObject Author David Schach Example Set<String> rtNames = new Set<String> {'Person_Account', 'Customer'}; getRecordTypeIdSetFromDevNames('Account', rtNames); getRecordTypeNameFromDevName(objectName, recordTypeDevName) Given an sObject and RecordType  DeveloperName, return the RecordType  Name Signature global static String getRecordTypeNameFromDevName(String objectName, String recordTypeDevName) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeDevName Type: String RecordType.DeveloperName (cannot include spaces) Returns RecordType Name Author David Schach Example RecordTypes.getRecordTypeNameFromDevName('Account','Person_Account') getRecordTypeNameFromId(objectName, recordTypeId) Given an sObject and RecordType  Id, return the RecordType  Name Signature global static String getRecordTypeNameFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name(with __c if custom, etc) recordTypeId Type: Id RecordType Id Returns RecordType Name Author David Schach getRecordTypeNameFromId(recordTypeId) Generate map of all record type names by Id & return Record Type Name Signature global static String getRecordTypeNameFromId(Id recordTypeId) Parameters recordTypeId Type: Id RecordTypeId Returns String  Record Type Name Author David Schach Since 2022-03-29 getRecordTypeNameIdMap(objectName) Gives a map of all RecordType  IDs by name for an sObject Signature global static Map<String, Id> getRecordTypeNameIdMap(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns Map<String, Id>  Map<RecordType Name, RecordType Id> Author Evan Callahan getRecordTypesForObject(objectName) Gives a list of all the RecordTypeInfo  object records for an sObject This list has more items than just the record types available to the running user. This method has no immediately obvious uses, but perhaps an outside library will need this list for, say, a project for a LWC. Signature global static List<Schema.RecordTypeInfo> getRecordTypesForObject(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns List<Schema.RecordTypeInfo>  List of all record types for the object(active and inactive) Author David Schach getRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Id as the value Signature global static List<SelectOption> getRecordTypesForSelectList(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns List<SelectOption>  Visualforce SelectOption list Author Evan Callahan getStringRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RecordType  Name displayed and the RecordType  Name as the value Signature global static List<SelectOption> getStringRecordTypesForSelectList(String objectName) Parameters objectName Type: String SObject name(with __c if custom, etc) Returns List<SelectOption>  Visualforce SelectOption list Author Evan Callahan"
    },
    {
        "title": "RecordTypesTest",
        "fileName": "RecordTypesTest.html",
        "text": "RecordTypesTest Test class for RecordTypes.cls Signature @IsTest private class RecordTypesTest See RecordTypes Author Evan Callahan Since 2010 Author David Schach Since 2021 Various enhancements and updates to use new Apex methods 2023 Addition of methods to handle no profile-based RT permissions with permissions via permission set RecordTypesTest Methods resetTest() Clear all record type maps to enable using fewer test methods - reset within a method testAccountRecordTypeReturns() Separate method for checking if we have Account record type, and then testing that testAccountRecTypes() Test against Account, an object with record types in package testing testBogusRecTypes() Test various record types and names We test nonexistent object names, nonexistent record type names, null values, and existing Account record type(if available) testContactRecordType() Separate method for checking if we have Account record type, and then testing that testSolutionRecTypes() Test against Solution, an object likely to have no record types resetTest() Clear all record type maps to enable using fewer test methods - reset within a method Signature private static void resetTest() Author David Schach testAccountRecordTypeReturns() Separate method for checking if we have Account record type, and then testing that Signature @isTest private static void testAccountRecordTypeReturns() Author David Schach testAccountRecTypes() Test against Account, an object with record types in package testing Signature @isTest private static void testAccountRecTypes() Author Evan Callahan testBogusRecTypes() Test various record types and names We test nonexistent object names, nonexistent record type names, null values, and existing Account record type(if available) Signature @isTest private static void testBogusRecTypes() Author Evan Callahan testContactRecordType() Separate method for checking if we have Account record type, and then testing that Signature @isTest private static void testContactRecordType() Author David Schach testSolutionRecTypes() Test against Solution, an object likely to have no record types Signature @isTest private static void testSolutionRecTypes() Authors Evan Callahan, David Schach"
    }
];
