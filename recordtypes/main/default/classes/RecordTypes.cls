/*-----------------------------------------------------------------------------------------------
 * Written by Evan Callahan, copyright (c) 2010 Groundwire
 * This program is released under the GNU General Public License. http://www.gnu.org/licenses/
 *
 * Updated by David Schach, copyright (c) 2021
 *
 * This class is meant to allow for access to Record Type information from within other classes.
 *
 * It is called statically, and therefore will supply the same information to all calls made from
 * within one transaction, or set of trigger calls. This is beneficial because this info should
 * be the same for all calls in a transaction, and by calling it statically we reduce the calls
 * that are made, making the total transaction more efficient
 -----------------------------------------------------------------------------------------------*/

/**
 * This class is meant to allow for access to Record Type information from within other classes.
 * <br>
 * It is called statically, and therefore will supply the same information to all calls made from
 * within one transaction, or set of trigger calls. This is beneficial because this info should
 * be the same for all calls in a transaction, and by calling it statically we reduce the calls
 * that are made, making the total transaction more efficient.
 * <br>
 * Usage recommendation: Always use Developer Name instead of Name, as this is more likely to be
 * hard-coded in places, while the Name is actually a label and may change (especially due to user language).
 * @author Evan Callahan
 * @since 2010
 * @author David Schach
 * @since 2021
 * @group RecordTypes
 * @see RecordTypesTest
 */
global class RecordTypes {
	/**
	 * Global schema describe
	 */
	private static Map<String, Schema.SObjectType> gd;
	/**
	 * Map of Record Types by Object name, then by Id
	 */
	@testVisible
	private static Map<String, Map<Id, Schema.RecordTypeInfo>> recordTypesById = new Map<String, Map<Id, Schema.RecordTypeInfo>>();
	/**
	 * Map of Record Types by Object name, then by Name
	 */
	@testVisible
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByName = new Map<String, Map<String, Schema.RecordTypeInfo>>();
	/**
	 * Map of Record Types by Object name, then by Developer Name
	 */
	@testVisible
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByDevName = new Map<String, Map<String, Schema.RecordTypeInfo>>();
	/**
	 * Map of Record Types by Object name, then by
	 */
	@testVisible
	private static List<Schema.Recordtypeinfo> recordTypesList = new List<Schema.Recordtypeinfo>();

	/*******************************************
	 * Gets record type maps for a new object
	 ********************************************/
	/**
	 * @description Gets record type maps for a new object
	 * @author David Schach
	 * @param  objectName SObject name
	 */
	private static void fillMapsForObject(String objectName) {
		// get the object map the first time
		if (gd == null) {
			gd = Schema.getGlobalDescribe();
		}

		// get the object description
		if (gd.containsKey(objectName)) {
			Schema.DescribeSObjectResult d = gd.get(objectName).getDescribe();
			recordTypesByName.put(objectName, d.getRecordTypeInfosByName());
			recordTypesByDevName.put(objectName, d.getRecordTypeInfosByDeveloperName());
			recordTypesById.put(objectName, d.getRecordTypeInfosById());
			recordTypesList = d.getRecordTypeInfos();
			for (integer i = recordTypesList.size() - 1; i >= 0; i--) {
				if (recordTypesList[i].getName() == 'Master' || !recordTypesList[i].isAvailable()) {
					recordTypesList.remove(i);
				}
			}
		}
	}

	//RECORD TYPE NAME SECTION
	//@param String objectName
	//@param String recordTypeName
	//@return Id, DeveloperName, RecordType object

	/**
	 * @description Given an object and RT Name, give the RecordType object
	 *              Note: Since Record Type Name is not unique, this section could give unpredicable results
	 *              If possible, DO NOT USE these methods - use DeveloperName instead
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Name (can include spaces)
	 * @return                RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromName(String objectName, String recordTypeName) {
		// make sure we have this object's record types mapped
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
	 * @description Given an object and RT Name, give the recordTypeId
	 *              Note: Since Record Type Name is not unique, this could give unpredicable results
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Name (can include spaces)
	 * @return                RecordType Id
	 */
	global static Id getRecordTypeIdFromName(String objectName, String recordTypeName) {
		// prettier-ignore
		return getRecordTypeFromName(objectName, recordTypeName)?.getRecordTypeId();
	}

	/**
	 * @description Given an object and RT Name, give the recordTypeId
	 *              Note: Since Record Type Name is not unique, this could give unpredicable results
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Name (can include spaces)
	 * @return                RecordType DeveloperName
	 */
	global static String getRecordTypeDeveloperNameFromName(String objectName, String recordTypeName) {
		// prettier-ignore
		return getRecordTypeFromName(objectName, recordTypeName)?.getDeveloperName();
	}

	//RECORD TYPE DEVELOPER NAME SECTION
	//@param String objectName
	//@param String recordTypeDeveloperName
	//@return Id, Name, RecordType object

	/**
	 * @description Given an object and RT Developer Name, give the recordTypeId
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Developer Name (cannot include spaces)
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromDeveloperName(String objectName, String recordTypeDeveloperName) {
		// make sure we have this object's record types mapped
		if (!recordTypesByDevName.containsKey(objectName)) {
			fillMapsForObject(objectName);
		}

		// now grab and return the requested object
		Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
		if (rtMap != null && rtMap.containsKey(RecordTypeDeveloperName)) {
			return rtMap.get(recordTypeDeveloperName);
		} else {
			return null;
		}
	}

	/**
	 * @description Given an object and RT Developer Name, give the Record Type Name
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Developer Name (cannot include spaces)
	 * @return                RecordType Name
	 */
	global static String getRecordTypeNameFromDeveloperName(String objectName, String recordTypeDeveloperName) {
		// prettier-ignore
		return getRecordTypeFromDeveloperName(objectName, recordTypeDeveloperName)?.getName();
	}

	/**
	 * @description Given an object and RT Developer Name, give the recordTypeId
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeName Record Type Developer Name (cannot include spaces)
	 * @return                RecordType Id
	 */
	global static Id getRecordTypeIdFromDeveloperName(String objectName, String recordTypeDeveloperName) {
		// prettier-ignore
		return getRecordTypeFromDeveloperName(objectName, recordTypeDeveloperName)?.getRecordTypeId();
	}

	//RECORD TYPE ID SECTION
	//@param String objectName
	//@param Id recordTypeId
	//@return Name, DeveloperName, RecordType object

	/**
	 * @description Given an object and RT Id, give the Record Type object
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeId   Record Type Id
	 * @return                RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromId(String objectName, Id recordTypeId) {
		// make sure we have this object's record types mapped
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
	 * @description Given an object and RT Id, give the RecordType Name
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeId   Record Type Id
	 * @return                RecordType Name
	 */
	global static String getRecordTypeNameFromId(String objectName, Id recordTypeId) {
		// prettier-ignore
		return getRecordTypeFromId(objectName, recordTypeId)?.getName();
	}

	/**
	 * @description Given an object and RT Id, give the recordType DeveloperName
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeId   Record Type Id
	 * @return                RecordType Developer Name
	 */
	global static String getRecordTypeDeveloperNameFromId(String objectName, Id recordTypeId) {
		// prettier-ignore
		return getRecordTypeFromId(objectName, recordTypeId)?.getDeveloperName();
	}

	/**
	 * @description Given an object and RT Id, give the recordType object
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @param  recordTypeId   Record Type Id
	 * @return                RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordType(String objectName, Id recordTypeId) {
		// make sure we have this object's record types mapped
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
	 * @description Gives a set of record type IDs from an object and a set of developernames
	 * @author David Schach
	 * @param  objectName        Object of interest
	 * @param  RecordTypeNameSet Set of DeveloperNames
	 * @return                   return Id set
	 */
	global static Set<Id> getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet) {
		Set<Id> recordTypeIds = new Set<Id>();

		// make sure we have this object's record types mapped
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
	 * @description Gives a map of all record type IDs by developer name for an object
	 * @author David Schach
	 * @param  objectName     SObject name
	 * @return                Map<RecordTypeDeveloperName, RecordTypeId>
	 */
	global static Map<String, Id> getRecordTypeDevNameIdMap(String objectName) {
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this object's record types mapped
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
	 * @description Gives a map of all record type IDs by name for an object
	 * @author Evan Callahan
	 * @param  objectName     SObject name
	 * @return                Map<RecordType Name, RecordTypeId>
	 */
	global static Map<String, Id> getRecordTypeNameIdMap(String objectName) {
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this object's record types mapped
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
	 * @description Make a Visualforce picklist with the RT Name displayed and the RT Id as the value
	 * @author Evan Callahan
	 * @param  objectName Object name (with __c if custom, etc)
	 * @return            Visualforce SelectOption list
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
	 * @description Make a Visualforce picklist with the RT Name displayed and the RT Name as the value
	 * @author Evan Callahan
	 * @param  objectName Object name (with __c if custom, etc)
	 * @return            Visualforce SelectOption list
	 */
	global static List<SelectOption> getStringRecordTypesForSelectList(String objectName) {
		List<SelectOption> recordTypesOptions = new List<SelectOption>();
		Map<String, Id> availRecordTypes = getRecordTypeNameIdMap(objectName);

		for (String thisRecordType : availRecordTypes.keyset()) {
			recordTypesOptions.add(new SelectOption(thisRecordType, thisRecordType));
		}

		return recordTypesOptions;
	}
}