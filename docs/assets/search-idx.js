export default [
    {
        "title": "Home",
        "fileName": "index.html",
        "text": "Home Project Home Use the apexdox.homePagePath  setting to point to an HTML file that contains details about your project. The body of the HTML will show up here instead of this default!"
    },
    {
        "title": "RecordTypes",
        "fileName": "RecordTypes.html",
        "text": "RecordTypes This class is meant to allow for access to Record Type information from within other classes.  It is called statically, and therefore will supply the same information to all calls made from within one transaction, or set of trigger calls. This is beneficial because this info should be the same for all calls in a transaction, and by calling it statically we reduce the calls that are made, making the total transaction more efficient.  Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be hard-coded in places, while the Name is actually a label and may change(especially due to user language). Signature global class RecordTypes See RecordTypesTest Evan Callahan David Schach2010 RecordTypes Properties Name Signature Annotations Description gd private static Map<String, Schema.SObjectType> gd Global schema describe recordTypesById private static Map<String, Map<Id, Schema.RecordTypeInfo>> recordTypesById @testVisible Map of Record Types by Object name, then by Id recordTypesByName private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByName @testVisible Map of Record Types by Object name, then by Name recordTypesByDevName private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByDevName @testVisible Map of Record Types by Object name, then by DeveloperName recordTypesList private static List<Schema.Recordtypeinfo> recordTypesList @testVisible Map of Record Types by Object name, then by RecordTypes Methods fillMapsForObject(objectName) Gets record type maps for a new object getRecordTypeFromName(objectName, recordTypeName) Given an object and RT Name, give the RecordType object Note: Since Record Type Name is not unique, this section could give unpredicable results If possible, DO NOT USE these methods - use DeveloperName instead getRecordTypeIdFromName(objectName, recordTypeName) Given an object and RT Name, give the recordTypeId <bNote: Since Record Type Name is not unique, this could give unpredicable results getRecordTypeDeveloperNameFromName(objectName, recordTypeName) Given an object and RT Name, give the recordTypeId Note: Since Record Type Name is not unique, this could give unpredicable results getRecordTypeFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the recordTypeId getRecordTypeNameFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the Record Type Name getRecordTypeIdFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the recordTypeId getRecordTypeFromId(objectName, recordTypeId) Given an object and RT Id, give the Record Type object getRecordTypeNameFromId(objectName, recordTypeId) Given an object and RT Id, give the RecordType Name getRecordTypeDeveloperNameFromId(objectName, recordTypeId) Given an object and RT Id, give the recordType DeveloperName getRecordType(objectName, recordTypeId) Given an object and RT Id, give the recordType object getRecordTypeIdSetFromDevNames(objectName, recordTypeDevNameSet) Gives a set of record type Ids from an object and a set of developernames getRecordTypeDevNameIdMap(objectName) Gives a map of all record type IDs by developer name for an object getRecordTypeNameIdMap(objectName) Gives a map of all record type IDs by name for an object getRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RT Name displayed and the RT Id as the value getStringRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RT Name displayed and the RT Name as the value fillMapsForObject(objectName) Gets record type maps for a new object Signature private static void fillMapsForObject(String objectName) getRecordTypeFromName(objectName, recordTypeName) Given an object and RT Name, give the RecordType object Note: Since Record Type Name is not unique, this section could give unpredicable results If possible, DO NOT USE these methods - use DeveloperName instead Signature global static Schema.RecordTypeInfo getRecordTypeFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name recordTypeName Type: String Record Type Name(can include spaces) Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeIdFromName(objectName, recordTypeName) Given an object and RT Name, give the recordTypeId <bNote: Since Record Type Name is not unique, this could give unpredicable results Signature global static Id getRecordTypeIdFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name recordTypeName Type: String Record Type Name(can include spaces) Returns RecordType Id Author David Schach getRecordTypeDeveloperNameFromName(objectName, recordTypeName) Given an object and RT Name, give the recordTypeId Note: Since Record Type Name is not unique, this could give unpredicable results Signature global static String getRecordTypeDeveloperNameFromName(String objectName, String recordTypeName) Parameters objectName Type: String SObject name recordTypeName Type: String Record Type Name(can include spaces) Returns RecordType DeveloperName Author David Schach getRecordTypeFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the recordTypeId Signature global static Schema.RecordTypeInfo getRecordTypeFromDeveloperName(String objectName, String recordTypeDeveloperName) Parameters objectName Type: String SObject name recordTypeDeveloperName Type: String Record Type DeveloperName(cannot include spaces) Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeNameFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the Record Type Name Signature global static String getRecordTypeNameFromDeveloperName(String objectName, String recordTypeDeveloperName) Parameters objectName Type: String SObject name recordTypeDeveloperName Type: String Record Type DeveloperName(cannot include spaces) Returns RecordType Name Author David Schach getRecordTypeIdFromDeveloperName(objectName, recordTypeDeveloperName) Given an object and RT DeveloperName, give the recordTypeId Signature global static Id getRecordTypeIdFromDeveloperName(String objectName, String recordTypeDeveloperName) Parameters objectName Type: String SObject name recordTypeDeveloperName Type: String Record Type DeveloperName(cannot include spaces) Returns RecordType Id Author David Schach Example RecordTypes.getRecordTypeIdFromDeveloperName('Account','Person_Account') getRecordTypeFromId(objectName, recordTypeId) Given an object and RT Id, give the Record Type object Signature global static Schema.RecordTypeInfo getRecordTypeFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name recordTypeId Type: Id Record Type Id Returns RecordTypeInfo object Author David Schach getRecordTypeNameFromId(objectName, recordTypeId) Given an object and RT Id, give the RecordType Name Signature global static String getRecordTypeNameFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name recordTypeId Type: Id Record Type Id Returns RecordType Name Author David Schach getRecordTypeDeveloperNameFromId(objectName, recordTypeId) Given an object and RT Id, give the recordType DeveloperName Signature global static String getRecordTypeDeveloperNameFromId(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name recordTypeId Type: Id Record Type Id Returns RecordType DeveloperName Author David Schach getRecordType(objectName, recordTypeId) Given an object and RT Id, give the recordType object Signature global static Schema.RecordTypeInfo getRecordType(String objectName, Id recordTypeId) Parameters objectName Type: String SObject name recordTypeId Type: Id Record Type Id Returns Schema.RecordTypeInfo  RecordTypeInfo object Author David Schach getRecordTypeIdSetFromDevNames(objectName, recordTypeDevNameSet) Gives a set of record type Ids from an object and a set of developernames Signature global static Set<Id> getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet) Parameters objectName Type: String Object of interest recordTypeDevNameSet Type: Set<String> Set of DeveloperNames Returns Set<Id> Author David Schach getRecordTypeDevNameIdMap(objectName) Gives a map of all record type IDs by developer name for an object Signature global static Map<String, Id> getRecordTypeDevNameIdMap(String objectName) Parameters objectName Type: String SObject name Returns Map<RecordTypeDeveloperName, RecordTypeId> Author David Schach getRecordTypeNameIdMap(objectName) Gives a map of all record type IDs by name for an object Signature global static Map<String, Id> getRecordTypeNameIdMap(String objectName) Parameters objectName Type: String SObject name Returns Map<RecordType Name, RecordTypeId> Author Evan Callahan getRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RT Name displayed and the RT Id as the value Signature global static List<SelectOption> getRecordTypesForSelectList(String objectName) Parameters objectName Type: String Object name(with __c if custom, etc) Returns List<SelectOption>  Visualforce SelectOption list Author Evan Callahan getStringRecordTypesForSelectList(objectName) Make a Visualforce picklist with the RT Name displayed and the RT Name as the value Signature global static List<SelectOption> getStringRecordTypesForSelectList(String objectName) Parameters objectName Type: String Object name(with __c if custom, etc) Returns List<SelectOption>  Visualforce SelectOption list Author Evan Callahan"
    },
    {
        "title": "RecordTypesTest",
        "fileName": "RecordTypesTest.html",
        "text": "RecordTypesTest Test class for RecordTypes.cls Signature @IsTest public with sharing class RecordTypesTest See RecordTypes Evan Callahan David Schach2010 RecordTypesTest Methods testRecTypes() Test various record types and names We test nonexistent object names, nonexistent record type names, null values, and existing Account record type(if available) testAccountRecordType() Separate method for checking if we have Account record type, and then testing that clearMaps() Clear all record type maps to enable using fewer methods testRecTypes() Test various record types and names We test nonexistent object names, nonexistent record type names, null values, and existing Account record type(if available) Signature @isTest static void testRecTypes() testAccountRecordType() Separate method for checking if we have Account record type, and then testing that Signature @IsTest static void testAccountRecordType() Author David Schach clearMaps() Clear all record type maps to enable using fewer methods Signature private static void clearMaps() Author David Schach"
    }
];
