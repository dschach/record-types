@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.CyclomaticComplexity')
/**
 * @description This class is allows for easy, readable access to Record Type information from other classes.
 * <br>
 * <br>Written by Evan Callahan, copyright (c) 2010 Groundwire
 * <br>Updated by David Schach, copyright (c) 2021
 * <br>
 * <br>This program is released under the GNU General Public License. http://www.gnu.org/licenses/
 * <br>
 * <br>This class is meant to allow for access to Record Type information from within other classes.
 * <br>
 * <br>It is called statically, and therefore will supply the same information to all calls made from
 * within one transaction, or set of trigger calls. This is beneficial because this info should
 * be the same for all calls in a transaction, and by calling it statically we reduce the calls
 * that are made, making the total transaction more efficient.
 * <br>
 * <br>Usage recommendation: Always use DeveloperName instead of Name, as this is more likely to be
 * hard-coded in places, while the Name is actually a label and may change (especially due to user language).
 *
 * @author {@link [Evan Callahan](https://github.com/groundwired)}, Groundwire & {@link [David Schach](https://github.com/dschach)}, X-Squared on Demand
 * @since 2010, 2021
 * @group RecordTypes
 * @see RecordTypesTest
 */
global inherited sharing class RecordTypes {
	/**
	 * @description Global schema describe
	 */
	private static Map<String, Schema.SObjectType> gd;

	/**
	 * @description Map of Record Types by sObject name, then by Id
	 */
	private static Map<String, Map<Id, Schema.RecordTypeInfo>> recordTypesById = new Map<String, Map<Id, Schema.RecordTypeInfo>>();

	/**
	 * @description Map of Record Types by sObject name, then by Name
	 */
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByName = new Map<String, Map<String, Schema.RecordTypeInfo>>();

	/**
	 * @description Map of Record Types by sObject name, then by DeveloperName
	 */
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByDevName = new Map<String, Map<String, Schema.RecordTypeInfo>>();

	/**
	 * @description List of Record Type Info sObjects
	 */
	private static List<Schema.Recordtypeinfo> recordTypesList = new List<Schema.Recordtypeinfo>();

	/**
	 * @description Map of queried `RecordType` Name by Id
	 */
	private static Map<Id, String> recordTypeNamesById;

	/**
	 * @description Map of queried `RecordType` DeveloperName by Id
	 */
	private static Map<Id, String> recordTypeDevNamesById;

	/**
	 * @description Gets record type maps for a new sObject
	 * <br>We check in each public method if the sObject has already been described so we do not eagerly load DescribeSObjectResult
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName SObject name (with __c if custom, etc)
	 */
	private static void fillMapsForObject(String objectName) {
		// get the object map the first time
		if (gd == null) {
			gd = Schema.getGlobalDescribe();
		}

		// get the sObject description
		if (gd.containsKey(objectName)) {
			@SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
			Schema.DescribeSObjectResult d = gd.get(objectName).getDescribe();
			recordTypesByName.put(objectName, d.getRecordTypeInfosByName());
			recordTypesByDevName.put(objectName, d.getRecordTypeInfosByDeveloperName());
			recordTypesById.put(objectName, d.getRecordTypeInfosById());
			recordTypesList = d.getRecordTypeInfos();
			for (Integer i = recordTypesList.size() - 1; i >= 0; i--) {
				if (recordTypesList[i].getName() == 'Master' || !recordTypesList[i].isAvailable()) {
					recordTypesList.remove(i);
				}
			}
		}
	}

	//RecordType Name SECTION
	//@param String objectName
	//@param String recordTypeName
	//@return Id, DeveloperName, RecordType object

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` object
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use `RecordType.DeveloperName` instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromName(String objectName, String recordTypeName) {
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// now grab and return the requested id
		Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
		if (rtMap != null && rtMap.containsKey(recordTypeName)) {
			return rtMap.get(recordTypeName);
		} else {
			return null;
		}
	}

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` Id
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use `RecordType.DeveloperName` instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                RecordType Id
	 * @example
	 * RecordTypes.getRecordTypeIdFromName('Account','Person Account')
	 */
	global static Id getRecordTypeIdFromName(String objectName, String recordTypeName) {
		return getRecordTypeFromName(objectName, recordTypeName)?.getRecordTypeId();
	}

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` Id
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use `RecordType.DeveloperName` methods instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                `RecordType.DeveloperName`
	 * @example
	 * RecordTypes.getRecordTypeDevNameFromName('Account','Person Account')
	 */
	global static String getRecordTypeDevNameFromName(String objectName, String recordTypeName) {
		return getRecordTypeFromName(objectName, recordTypeName)?.getDeveloperName();
	}

	//RecordType DeveloperName SECTION
	//@param String objectName
	//@param String recordTypeDevName
	//@return Id, Name, RecordType sObject

	/**
	 * @description Given an sObject and `RecordType` DeveloperName, return the `RecordType` Id
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName              SObject name (with __c if custom, etc)
	 * @param  recordTypeDevName `RecordType.DeveloperName` (cannot include spaces)
	 * @return                         `Schema.RecordTypeInfo` RecordTypeInfo object
	 * @example
	 * RecordTypes.getRecordTypeFromDevName('Account','Person_Account')
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromDevName(String objectName, String recordTypeDevName) {
		// make sure we have this sObject's record types mapped
		if (!recordTypesByDevName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// now grab and return the requested object
		Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByDevName.get(objectName);
		if (rtMap != null && rtMap.containsKey(recordTypeDevName)) {
			return rtMap.get(recordTypeDevName);
		} else {
			return null;
		}
	}

	/**
	 * @description Given an sObject and `RecordType` DeveloperName, return the `RecordType` Name
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeDevName `RecordType.DeveloperName` (cannot include spaces)
	 * @return                RecordType Name
	 * @example
	 * RecordTypes.getRecordTypeNameFromDevName('Account','Person_Account')
	 */
	global static String getRecordTypeNameFromDevName(String objectName, String recordTypeDevName) {
		return getRecordTypeFromDevName(objectName, recordTypeDevName)?.getName();
	}

	/**
	 * @description Given an sObject and `RecordType` DeveloperName, return the `RecordType` Id
	 * <br>This should be the most-used method in this class
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName              SObject name (with __c if custom, etc)
	 * @param  recordTypeDevName `RecordType.DeveloperName` (cannot include spaces)
	 * @return                         RecordType Id
	 * @example
	 * RecordTypes.getRecordTypeIdFromDevName('Account','Person_Account')
	 */
	global static Id getRecordTypeIdFromDevName(String objectName, String recordTypeDevName) {
		return getRecordTypeFromDevName(objectName, recordTypeDevName)?.getRecordTypeId();
	}

	//RecordType Id SECTION
	//@param String objectName
	//@param Id `RecordType Id`
	//@return Name, DeveloperName, RecordType object

	/**
	 * @description Given an sObject and `RecordType` Id, return the `Record Type` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeId   RecordType Id
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromId(String objectName, Id recordTypeId) {
		// make sure we have this sObject's record types mapped
		if (!recordTypesById.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// now grab and return the requested object
		Map<Id, Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
		if (rtMap != null && rtMap.containsKey(recordTypeId)) {
			return rtMap.get(recordTypeId);
		} else {
			return null;
		}
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `RecordType` Name
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeId   RecordType Id
	 * @return                RecordType Name
	 */
	global static String getRecordTypeNameFromId(String objectName, Id recordTypeId) {
		return getRecordTypeFromId(objectName, recordTypeId)?.getName();
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `RecordType` DeveloperName
	 * <br>This saves a query on the `RecordType` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName        SObject name (with __c if custom, etc)
	 * @param  recordTypeId      RecordType Id
	 * @return                   `RecordType` DeveloperName
	 */
	global static String getRecordTypeDevNameFromId(String objectName, Id recordTypeId) {
		return getRecordTypeFromId(objectName, recordTypeId)?.getDeveloperName();
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `RecordType` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeId   RecordType Id
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordType(String objectName, Id recordTypeId) {
		// make sure we have this sObject's record types mapped
		if (!recordTypesById.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// now grab and return the requested object
		Map<Id, Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
		if (rtMap != null && rtMap.containsKey(RecordTypeId)) {
			return rtMap.get(recordTypeId);
		} else {
			return null;
		}
	}

	/**
	 * @description Gives a set of `RecordType` Ids from an sObject and a set of `RecordType` Developernames
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName           Object of interest
	 * @param  recordTypeDevNameSet Set of DeveloperNames
	 * @return                      `Set<Id>` All `RecordType` IDs for a given sObject
	 * @example
	 * Set<String> rtNames = new Set<String> {'Person_Account', 'Customer'};
	 * getRecordTypeIdSetFromDevNames('Account', rtNames);
	 */
	global static Set<Id> getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet) {
		Set<Id> recordTypeIds = new Set<Id>();

		// make sure we have this sObject's record types mapped
		if (!recordTypesByDevName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// fill the id set from the name set
		if (recordTypesByName.containsKey(objectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByDevName.get(objectName);
			for (String recTypeDevName : recordTypeDevNameSet) {
				if (rtMap.containsKey(recTypeDevName)) {
					recordTypeIds.add(rtMap.get(recTypeDevName).getRecordTypeId());
				}
			}
		}
		return recordTypeIds;
	}

	/**
	 * @description Gives a map of all record type IDs by DeveloperName for an sObject
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Map<String, Id>` Map<recordTypeDevName, RecordType Id>
	 */
	global static Map<String, Id> getRecordTypeDevNameIdMap(String objectName) {
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// fill the name to id map
		if (recordTypesByDevName.containsKey(objectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByDevName.get(objectName);
			for (recordTypeInfo rti : rtMap.values()) {
				if (rti.getName() != 'Master') {
					recordTypeMap.put(rti.getDeveloperName(), rti.getRecordTypeId());
				}
			}
		}
		return recordTypeMap;
	}

	/**
	 * @description Gives a map of all `RecordType` IDs by name for an sObject
	 * @author Evan Callahan
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Map<String, Id>` Map<RecordType Name, RecordType Id>
	 */
	global static Map<String, Id> getRecordTypeNameIdMap(String objectName) {
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// fill the name to id map
		if (recordTypesByName.containsKey(objectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
			for (Schema.RecordTypeInfo rti : rtMap.values()) {
				if (rti.getName() != 'Master') {
					recordTypeMap.put(rti.getName(), rti.getRecordTypeId());
				}
			}
		}
		return recordTypeMap;
	}

	/**
	 * @description Memoized map of queried `RecordType` records by Id
	 * @return `Map<Id, RecordType>` Queried map of Record Types
	 */
	private static Map<Id, RecordType> recordTypesIdMap {
		get {
			if (recordTypesIdMap == null) {
				recordTypesIdMap = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName FROM RecordType]);
			}
			return recordTypesIdMap;
		}
		set;
	}

	/**
	 * @description Generate map of all record type names by Id & return Record Type Name
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2022-03-29
	 * @param recordTypeId `RecordTypeId`
	 * @return `String` Record Type Name
	 **/
	global static String getRecordTypeNameFromId(Id recordTypeId) {
		return recordTypesIdMap.get(recordTypeId)?.Name;
	}

	/**
	 * @description Generate map of all record type developer names by Id & return Record Type DeveloperName
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2022-03-29
	 * @param recordTypeId `RecordTypeId`
	 * @return `String` Record Type Name
	 **/
	global static String getRecordTypeDevNameFromId(Id recordTypeId) {
		return recordTypesIdMap.get(recordTypeId)?.DeveloperName;
	}

	/**
	 * @description Make a Visualforce picklist with the `RecordType` Name displayed and the `RecordType` Id as the value
	 * @author Evan Callahan
	 * @param  objectName SObject name (with __c if custom, etc)
	 * @return            `List<SelectOption>` Visualforce SelectOption list
	 */
	global static List<SelectOption> getRecordTypesForSelectList(String objectName) {
		List<SelectOption> recordTypesOptions = new List<SelectOption>();

		Map<String, Id> availRecordTypes = getRecordTypeNameIdMap(objectName);

		for (String thisRecordType : availRecordTypes.keyset()) {
			recordTypesOptions.add(new SelectOption(availRecordTypes.get(thisRecordType), thisRecordType));
		}

		return recordTypesOptions;
	}

	/**
	 * @description Make a Visualforce picklist with the `RecordType` Name displayed and the `RecordType` Name as the value
	 * @author Evan Callahan
	 * @param  objectName SObject name (with __c if custom, etc)
	 * @return            `List<SelectOption>` Visualforce SelectOption list
	 */
	global static List<SelectOption> getStringRecordTypesForSelectList(String objectName) {
		List<SelectOption> recordTypesOptions = new List<SelectOption>();
		Map<String, Id> availRecordTypes = getRecordTypeNameIdMap(objectName);

		for (String thisRecordType : availRecordTypes.keyset()) {
			recordTypesOptions.add(new SelectOption(thisRecordType, thisRecordType));
		}

		return recordTypesOptions;
	}

	/**
	 * @description If we are running a test, clear sObject maps. We do this to avoid using @testVisible on the maps
	 * <br>This is private and testvisible so it cannot be called in production code context
	 */
	@testVisible
	private static void clearMapsInTest() {
		if (Test.isRunningTest()) {
			RecordTypes.recordTypesById.clear();
			RecordTypes.recordTypesByName.clear();
			RecordTypes.recordTypesByDevName.clear();
			RecordTypes.recordTypesList.clear();
		}
	}
}