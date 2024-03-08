@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.CyclomaticComplexity')
/**
 * @description This class is allows for easy, readable access to Record Type information from other classes.
 * <br>
 * <br>Written by Evan Callahan, copyright 2010 Groundwire
 * <br>Updated by David Schach, copyright 2021-2024 X-Squared on Demand
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
 * <br>Usage recommendation: <strong>Always use DeveloperName instead of Name</strong>, as this is more likely to be
 * hard-coded in places, while the Name is actually a label and may change (especially due to user language).
 * <br>
 * An easy-to-read table with the various methods, their inputs, and their outputs is available at
 * {@link [Record Types](https://dschach.github.io/record-types/)}
 * <br>LICENSE
 * <br>Copyright Evan Callahan & David Schach
 * <br>This program is free software: you can redistribute it and/or modify it under the terms of the GNU
 * General Public License as published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 * <br>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 * <br>You should have received a copy of the GNU General Public License along with this program.  If not,
 * see <https://www.gnu.org/licenses/>.
 *
 * @author {@link [Evan Callahan](https://github.com/groundwired)}, Groundwire
 * @since 2010
 * @author {@link [David Schach](https://github.com/dschach)}, X-Squared on Demand
 * @since 2021
 * @author Nicolas Vasquez, Globant
 * @since 2022
 * @group RecordTypes
 * @see RecordTypesTest
 */
global inherited sharing class RecordTypes {
	/**
	 * @description Hold Sobject describe results as we need them
	 */
	private static Map<String, Schema.DescribeSObjectResult> sObjectDescribes = new Map<String, Schema.DescribeSObjectResult>();

	/**
	 * @description Map of Record Types by sObject name (lowercase), then by Id
	 */
	private static Map<String, Map<Id, Schema.RecordTypeInfo>> recordTypesById = new Map<String, Map<Id, Schema.RecordTypeInfo>>();

	/**
	 * @description Map of Record Types by sObject name (lowercase), then by Name
	 */
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByName = new Map<String, Map<String, Schema.RecordTypeInfo>>();

	/**
	 * @description Map of Record Types by sObject name (lowercase), then by DeveloperName
	 */
	private static Map<String, Map<String, Schema.RecordTypeInfo>> recordTypesByDevName = new Map<String, Map<String, Schema.RecordTypeInfo>>();

	/**
	 * @description List of available (to the running user) Record Type Info sObjects
	 */
	private static Map<String, List<Schema.Recordtypeinfo>> availableRecordTypesMap = new Map<String, List<Schema.Recordtypeinfo>>();

	/**
	 * @description map of all Record Types by sObject name (lowercase), including inactive and unavailable
	 */
	private static Map<String, List<Schema.RecordTypeInfo>> allRecordTypes = new Map<String, List<Schema.RecordTypeInfo>>();

	/**
	 * @description Map of default `Record Type` Ids for the running user
	 */
	private static Map<String, Id> defaultRecordTypeIds = new Map<String, Id>();

	/**
	 * @description Map of object name to the default `Schema.RecordTypeInfo` object for that object
	 */
	private static Map<String, Schema.RecordTypeInfo> defaultRecordTypes = new Map<String, Schema.RecordTypeInfo>();

	/**
	 * @description Lazy-loaded, memoized map of queried `RecordType` records by Id
	 * @return `Map<Id, RecordType>` Queried map of Record Types
	 */
	private static Map<Id, RecordType> recordTypesIdMap {
		get {
			if (recordTypesIdMap == null) {
				recordTypesIdMap = new Map<Id, RecordType>([SELECT Id, DeveloperName, Name, SobjectType FROM RecordType]);
			}
			return recordTypesIdMap;
		}
		set;
	}

	/**
	 * @description Gets record type maps for a new sObject
	 * <br>We check in each public method if the sObject has already been described so we do not eagerly load DescribeSObjectResult
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName SObject name (with __c if custom, etc)
	 */
	private static void fillMapsForObject(String objectName) {
		String sObjectName = objectName.toLowerCase();
		if (!sObjectDescribes.containsKey(sObjectName)) {
			try {
				List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(new List<String>{ sObjectName }, SObjectDescribeOptions.DEFERRED);
				sObjectDescribes.put(sObjectName, describes[0]);
			} catch (InvalidParameterValueException e) {
				return;
			}
		}
		// get the sObject description
		if (sObjectDescribes.containsKey(sObjectName)) {
			@SuppressWarnings('PMD.EagerlyLoadedDescribeSObjectResult')
			Schema.DescribeSObjectResult d = sObjectDescribes.get(sObjectName);

			Map<String, Schema.RecordTypeInfo> objectRTsByName = new Map<String, Schema.RecordTypeInfo>();
			Map<String, Schema.RecordTypeInfo> objectRTsByDevName = new Map<String, Schema.RecordTypeInfo>();
			for (Schema.RecordTypeInfo rti : d.getRecordTypeInfos()) {
				objectRTsByName.put(rti.getName().toLowerCase(), rti);
				objectRTsByDevName.put(rti.getDeveloperName().toLowerCase(), rti);
			}
			recordTypesByName.put(sObjectName, objectRTsByName);
			recordTypesByDevName.put(sObjectName, objectRTsByDevName);
			recordTypesById.put(sObjectName, d.getRecordTypeInfosById());
			List<Schema.RecordTypeInfo> recordTypesForSObject = new List<Schema.RecordTypeInfo>();
			List<Schema.RecordTypeInfo> availableRecordTypesList = new List<Schema.RecordTypeInfo>();
			for (Schema.Recordtypeinfo rt : d.getRecordTypeInfos()) {
				if (!rt.isMaster()) {
					recordTypesForSObject.add(rt);
				}
				if (rt.isActive() && rt.isAvailable() && !rt.isMaster()) {
					availableRecordTypesList.add(rt);
				}
				if (rt.isDefaultRecordTypeMapping()) {
					System.debug('Default RT is ' + rt.getName());
					defaultRecordTypeIds.put(sObjectName, rt.getRecordTypeId());
					defaultRecordTypes.put(sObjectName, rt);
				}
			}
			allRecordTypes.put(sObjectName, recordTypesForSObject);
			availableRecordTypesMap.put(sObjectName, availableRecordTypesList);
		}
	}

	/**
	 * @description      Given an sObject Name, return the default Record Type Id for the running user
	 *
	 * @param objectName SObject name (with __c if custom, etc)
	 * @return           `Id` Default Record Type Id for the running user for this object
	 */
	@SuppressWarnings('PMD.AvoidDeeplyNestedIfStmts')
	global static Schema.RecordTypeInfo getDefaultRecordType(String objectName) {
		String sObjectName = objectName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		if (recordTypesByName.containsKey(sObjectName)) {
			Schema.RecordTypeInfo defaultRT = defaultRecordTypes.get(sObjectName);
			/* if (defaultRT.isMaster()) {
				// fill the name to id map
				Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName?.get(sObjectName);
				for (Schema.RecordTypeInfo rti : rtMap?.values()) {
					if (!rti.isMaster() && rti.isAvailable() && rti.isActive()) {
						defaultRecordTypes.put(sObjectName, rti);
						defaultRecordTypeIds.put(sObjectName, rti.getRecordTypeId());
						return rti;
					}
				}
			} */
			return defaultRT;
		}
		return null;
	}

	/**
	 * @description Gives a list of all the `RecordTypeInfo` object records for an sObject
	 * <br>This list has more items than just the record types available to the running user.
	 * <br>This method has no immediately obvious uses, but perhaps an outside library will need this list for, say,
	 * a project for a LWC.
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param objectName SObject name (with __c if custom, etc)
	 * @return           `List<Schema.RecordTypeInfo>` List of all record types for the object (active and inactive)
	 */
	global static List<Schema.RecordTypeInfo> getRecordTypesForObject(String objectName) {
		String sObjectName = objectName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		if (recordTypesByName.containsKey(sObjectName)) {
			// get the record types for the object
			return recordTypesByName?.get(sObjectName)?.values();
		}
		return null;
	}

	//Default RecordType SECTION
	//@param String objectName
	//@return Id, DeveloperName, Name

	/**
	 * @description      Given an sObject Name, return the default Record Type Id for the running user
	 *
	 * @param objectName SObject name (with __c if custom, etc)
	 * @return           `Id` Default Record Type Id for the running user for this object
	 */
	global static Id getDefaultRecordTypeId(String objectName) {
		String sObjectName = objectName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		if (recordTypesByName.containsKey(sObjectName)) {
			Schema.RecordTypeInfo defaultRT = getDefaultRecordType(sObjectName);
			if (defaultRT.isMaster()) {
				return null;
			}
			return defaultRT.getRecordTypeId();
		}
		return null;
	}

	/**
	 * @description      Given an sObject Name, return the default Record Type DeveloperName for the running user
	 *
	 * @param objectName SObject name (with __c if custom, etc)
	 * @return           `String` Default Record Type DeveloperName for the running user for this object
	 */
	global static String getDefaultRecordTypeDevName(String objectName) {
		String sObjectName = objectName.toLowerCase();
		return getDefaultRecordType(sObjectName)?.getDeveloperName();
	}

	/**
	 * @description      Given an sObject Name, return the default Record Type Name for the running user
	 *
	 * @param objectName SObject name (with __c if custom, etc)
	 * @return           `String` Default Record Type Name for the running user for this object
	 */
	global static String getDefaultRecordTypeName(String objectName) {
		return getDefaultRecordType(objectName)?.getName();
	}

	//RecordType Name SECTION
	//@param String objectName
	//@param String recordTypeName
	//@return Id, DeveloperName, RecordType object

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` object
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use a method with `RecordType.DeveloperName` instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 * @example
	 * RecordTypes.getRecordTypeFromName('Account','Person Account')
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromName(String objectName, String recordTypeName) {
		String sObjectName = objectName.toLowerCase();
		String rtName = recordTypeName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// now grab and return the requested id
		//Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName.get(sObjectName);
		return recordTypesByName.get(sObjectName)?.get(rtName);
		/* 		if (rtMap != null && rtMap.containsKey(rtName)) {
			return rtMap.get(rtName);
		} else {
			return null;
		}
 */
	}

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` Id
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use a method with `RecordType.DeveloperName` instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                RecordType Id
	 * @example
	 * RecordTypes.getRecordTypeIdFromName('Account','Person Account')
	 */
	global static Id getRecordTypeIdFromName(String objectName, String recordTypeName) {
		//String sObjectName = objectName.toLowerCase();

		return getRecordTypeFromName(objectName.toLowerCase(), recordTypeName.toLowerCase())?.getRecordTypeId();
	}

	/**
	 * @description Given an sObject and `RecordType` Name, return the `RecordType` Id
	 *              <br/>Note: Since `RecordType.Name` is not unique, this section could give unpredicable results
	 *              <br/>If possible, DO NOT USE this method - use a method with `RecordType.DeveloperName` instead
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeName RecordType Name (can include spaces)
	 * @return                `RecordType.DeveloperName`
	 * @example
	 * RecordTypes.getRecordTypeDevNameFromName('Account','Person Account')
	 */
	global static String getRecordTypeDevNameFromName(String objectName, String recordTypeName) {
		String sObjectName = objectName.toLowerCase();
		return getRecordTypeFromName(objectName.toLowerCase(), recordTypeName)?.getDeveloperName();
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
		String sObjectName = objectName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByDevName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		return recordTypesByDevName.get(sObjectName)?.get(recordTypeDevName.toLowerCase());
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
		return getRecordTypeFromDevName(objectName?.toLowerCase(), recordTypeDevName?.toLowerCase())?.getName();
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
		return getRecordTypeFromDevName(objectName?.toLowerCase(), recordTypeDevName?.toLowerCase())?.getRecordTypeId();
	}

	//RecordType Id SECTION
	//@param String objectName
	//@param Id `RecordType Id`
	//@return Name, DeveloperName, RecordType object

	/**
	 * @description Given a `RecordType` Id, return the `Record Type` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  recordTypeId   RecordType Id
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromId(Id recordTypeId) {
		String sObjectName = recordTypesIdMap.get(recordTypeId)?.SobjectType.toLowerCase();
		return getRecordTypeFromId(sObjectName, recordTypeId);
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `Record Type` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeId   RecordType Id
	 * @return                `Schema.RecordTypeInfo` RecordTypeInfo object
	 */
	global static Schema.RecordTypeInfo getRecordTypeFromId(String objectName, Id recordTypeId) {
		String sObjectName = objectName.toLowerCase();
		// make sure we have this sObject's record types mapped
		if (!recordTypesById.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		return recordTypesById.get(sObjectName)?.get(recordTypeId);
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `RecordType` Name
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @param  recordTypeId   RecordType Id
	 * @return                RecordType Name
	 */
	global static String getRecordTypeNameFromId(String objectName, Id recordTypeId) {
		return getRecordTypeFromId(objectName.toLowerCase(), recordTypeId)?.getName();
	}

	/**
	 * @description Given an sObject and `RecordType` Id, return the `RecordType` DeveloperName
	 * <br>This saves a query on the `RecordType` object
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName        SObject name (with __c if custom, etc)
	 * @param  recordTypeId      RecordType Id
	 * @return                   `RecordType` DeveloperName
	 * @see getRecordTypeDevNameFromId[1]
	 */
	global static String getRecordTypeDevNameFromId(String objectName, Id recordTypeId) {
		return getRecordTypeFromId(objectName.toLowerCase(), recordTypeId)?.getDeveloperName();
	}

	/**
	 * @description Gives a set of `RecordType` Ids from an sObject and a set of `RecordType` DeveloperNames
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName           SObject name (with __c if custom, etc)
	 * @param  recordTypeDevNameSet Set of DeveloperNames
	 * @return                      `Set<Id>` All `RecordType` IDs for a given sObject
	 * @example
	 * Set<String> rtNames = new Set<String> {'Person_Account', 'Customer'};
	 * getRecordTypeIdSetFromDevNames('Account', rtNames);
	 */
	global static Set<Id> getRecordTypeIdSetFromDevNames(String objectName, Set<String> recordTypeDevNameSet) {
		String sObjectName = objectName.toLowerCase();
		Set<Id> recordTypeIds = new Set<Id>();
		Set<String> devNamesLowerCase = new Set<String>();

		// make sure we have this sObject's record types mapped
		if (!recordTypesByDevName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// fill the id set from the name set
		if (recordTypesByName.containsKey(sObjectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByDevName.get(sObjectName);
			for (String recTypeDevName : recordTypeDevNameSet) {
				if (rtMap.containsKey(recTypeDevName.toLowerCase())) {
					recordTypeIds.add(rtMap.get(recTypeDevName.toLowerCase()).getRecordTypeId());
				}
			}
		}
		return recordTypeIds;
	}

	/**
	 * @description Gives a map of all record type IDs by DeveloperName for an sObject
	 * <br>Returns Master record type if no other RTs available
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Map<String, Id>` Map<recordTypeDevName, RecordType Id>
	 */
	global static Map<String, Id> getRecordTypeDevNameIdMap(String objectName) {
		String sObjectName = objectName.toLowerCase();
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// fill the name to id map
		if (recordTypesByDevName.containsKey(sObjectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByDevName.get(sObjectName);
			for (recordTypeInfo rti : rtMap.values()) {
				if (!rti.isMaster()) {
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
		String sObjectName = objectName.toLowerCase();
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// fill the name to id map
		if (recordTypesByName.containsKey(sObjectName)) {
			Map<String, Schema.RecordTypeInfo> rtMap = recordTypesByName.get(sObjectName);
			for (Schema.RecordTypeInfo rti : rtMap.values()) {
				if (!rti.isMaster()) {
					recordTypeMap.put(rti.getName(), rti.getRecordTypeId());
				}
			}
		}
		return recordTypeMap;
	}

	/**
	 * @description Gives a map of all available (to the running user) `RecordTypeId`s by `developername` for an sObject
	 * @author Nicolas Vasquez
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2023 Use available record types map
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Map<String, Id>` Map<RecordType Name, RecordType Id>
	 */
	global static Map<String, Id> getAvailableRecordTypeDevNameIdMap(String objectName) {
		String sObjectName = objectName.toLowerCase();
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// fill the devname to id map
		if (availableRecordTypesMap.containsKey(sObjectName)) {
			for (Schema.RecordTypeInfo rti : availableRecordTypesMap.get(sObjectName)) {
				// requires permission set to cover in package tests because cannot add record type
				// to a profile when creating a scratch org
				recordTypeMap.put(rti.getDeveloperName(), rti.getRecordTypeId());
			}
		}
		return recordTypeMap;
	}

	/**
	 * @description Gives a set of all available (to the running user) `RecordTypeId`s for an sObject
	 * @author Nicolas Vasquez
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2024 Use available record types map to generate set
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Set<Id>` Map<RecordType Name, RecordType Id>
	 */
	global static Set<Id> getAvailableRecordTypesIdSet(String objectName) {
		String sObjectName = objectName.toLowerCase();
		return new Set<Id>(getAvailableRecordTypeNameIdMap(sObjectName).values());
	}

	/**
	 * @description Gives a map of all available (to the running user) `RecordTypeId`s by name for an sObject
	 * @author Nicolas Vasquez
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2023 Use available record types map
	 * @param  objectName     SObject name (with __c if custom, etc)
	 * @return                `Map<String, Id>` Map<RecordType Name, RecordType Id>
	 */
	global static Map<String, Id> getAvailableRecordTypeNameIdMap(String objectName) {
		String sObjectName = objectName.toLowerCase();
		Map<String, Id> recordTypeMap = new Map<String, Id>();
		// make sure we have this sObject's record types mapped
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}

		// fill the name to id map
		if (availableRecordTypesMap.containsKey(sObjectName)) {
			for (Schema.RecordTypeInfo rti : availableRecordTypesMap.get(sObjectName)) {
				// requires permission set to cover in package tests because cannot add record type
				// to a profile when creating a scratch org
				recordTypeMap.put(rti.getName(), rti.getRecordTypeId());
			}
		}
		return recordTypeMap;
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
	 * @description Generate map of all record type developerNames by Id & return Record Type DeveloperName
	 * <br>This is an overloaded method for efficiency, using only the Id
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @since 2022-03-29
	 * @param recordTypeId `RecordTypeId`
	 * @return `String` Record Type Name
	 * @see getRecordTypeDevNameFromId[0]
	 **/
	global static String getRecordTypeDevNameFromId(Id recordTypeId) {
		return recordTypesIdMap.get(recordTypeId)?.DeveloperName;
	}

	/**
	 * @description Make a Visualforce picklist of only available Record Types with the `RecordType` Name
	 * displayed and the `RecordType` Id as the value. No options are disabled.
	 * @author Evan Callahan
	 * @param  objectName SObject name (with __c if custom, etc)
	 * @return            `List<SelectOption>` Visualforce SelectOption list
	 * @example
	 * RecordTypes.getAvailableRecordTypesForSelectList('Account')
	 * <br><br>
	 * System.SelectOption[value="<SFID>", label="Available", disabled="false"]
	 * System.SelectOption[value="<SFID>", label="Default", disabled="false"]
	 * System.SelectOption[value="<SFID>", label="Inactive", disabled="true"]
	 */
	global static List<SelectOption> getAvailableRecordTypesForSelectList(String objectName) {
		String sObjectName = objectName.toLowerCase();
		List<SelectOption> recordTypesOptions = new List<SelectOption>();
		Map<String, Id> availRecordTypes = getAvailableRecordTypeNameIdMap(sObjectName); // never null. Can be empty.

		for (String thisRecordType : availRecordTypes.keyset()) {
			recordTypesOptions.add(new SelectOption(availRecordTypes.get(thisRecordType), thisRecordType));
		}
		if (recordTypesOptions.isEmpty() && sObjectDescribes.containsKey(sObjectName)) {
			// check the object exists
			String defaultRTName = defaultRecordTypes.get(sObjectName)?.getName();
			defaultRTName = defaultRTName == null ? '' : '--' + defaultRecordTypes.get(sObjectName)?.getName() + '--';
			recordTypesOptions.add(new SelectOption('', defaultRTName, false));
		}
		recordTypesOptions.sort();
		return recordTypesOptions;
	}

	/**
	 * @description Make a Visualforce picklist with ALL `RecordType` Names displayed and the `RecordType` Id as the value
	 * <br>Unavailable Record Types will be _disabled_ in the picklist.
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName SObject name (with __c if custom, etc)
	 * @return            `List<SelectOption>` Visualforce SelectOption list
	 */
	global static List<SelectOption> getAllRecordTypesForSelectList(String objectName) {
		String sObjectName = objectName.toLowerCase();
		return getAllRecordTypesForSelectList(sObjectName, true);
	}
	/**
	 * @description Make a Visualforce picklist with ALL `RecordType` Names displayed and the `RecordType` Id as the value
	 * <br>Unavailable Record Types can be disabled in the picklist by setting `disableUnavailable` to `true`..
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @param  objectName SObject name (with __c if custom, etc)
	 * @param  disableUnavailable Should we disable unavailable RTs in the SelectList?
	 * @return            `List<SelectOption>` Visualforce SelectOption list
	 */
	global static List<SelectOption> getAllRecordTypesForSelectList(String objectName, Boolean disableUnavailable) {
		String sObjectName = objectName.toLowerCase();
		List<SelectOption> recordTypesOptions = new List<SelectOption>();
		if (!allRecordTypes.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		if (allRecordTypes.containsKey(sObjectName)) {
			List<Schema.RecordTypeInfo> recordTypes = allRecordTypes.get(sObjectName);
			Boolean hasAvailableRT = false;
			if (recordTypes == null) {
				return recordTypesOptions;
			}
			for (Schema.RecordTypeInfo rti : recordTypes) {
				recordTypesOptions.add(new SelectOption(rti.getRecordTypeId(), rti.getName(), disableUnavailable ? !rti.isAvailable() : false));
				if (rti.isAvailable()) {
					hasAvailableRT = true;
				}
			}
			if (recordTypesOptions.isEmpty() || (disableUnavailable && !hasAvailableRT)) {
				String defaultRTName = defaultRecordTypes?.get(sObjectName)?.getName();
				defaultRTName = defaultRTName == null ? '' : '--' + defaultRecordTypes?.get(sObjectName)?.getName() + '--';
				recordTypesOptions.add(new SelectOption('', defaultRTName, false));
			}
			recordTypesOptions.sort();
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
		String sObjectName = objectName.toLowerCase();
		List<SelectOption> recordTypesOptions = new List<SelectOption>();
		Map<String, Id> availRecordTypes = getAvailableRecordTypeNameIdMap(sObjectName);
		/* if (availRecordTypes == null) {
			return recordTypesOptions;
		} */
		for (String thisRecordType : availRecordTypes.keyset()) {
			recordTypesOptions.add(new SelectOption(thisRecordType, thisRecordType));
		}
		recordTypesOptions.sort();
		return recordTypesOptions;
	}

	/**
	 * @description             Is this record type (identified by developer name) available (and active) for the current user?
	 *
	 * @param objectName        SObject name (with __c if custom, etc)
	 * @param recordTypeDevName `RecordType.DeveloperName` (cannot include spaces)
	 * @return                  `Boolean` Is this Record Type available to the running user?
	 */
	public static Boolean isRecordTypeAvailable(String objectName, String recordTypeDevName) {
		String sObjectName = objectName.toLowerCase();
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		Boolean isAvailableRT = getRecordTypeFromDevName(sObjectName, recordTypeDevName)?.isAvailable();
		return isAvailableRT ?? false;
	}

	/**
	 * @description             Is this record type (identified by developer name) the default record type for the current user?
	 *
	 * @param objectName        SObject name (with __c if custom, etc)
	 * @param recordTypeDevName `RecordType.DeveloperName` (cannot include spaces)
	 * @return                  `Boolean` Is this Record Type the default for the running user?
	 */
	public static Boolean isRecordTypeDefault(String objectName, String recordTypeDevName) {
		String sObjectName = objectName.toLowerCase();
		if (!recordTypesByName.containsKey(sObjectName)) {
			fillMapsForObject(sObjectName);
		}
		Boolean isDefaultMapping = getRecordTypeFromDevName(sObjectName, recordTypeDevName.toLowerCase())?.isDefaultRecordTypeMapping();
		return isDefaultMapping ?? false;
	}

	/* private class RTInfoWrapper {
		private String developerName;
		private String name;
		private Id recordTypeId;
		private Boolean active;
		private Boolean available;
		private Boolean isDefault;
		private Boolean master;
		
		public RTInfoWrapper(Schema.RecordTypeInfo rti){
			this.developerName = rti.getDeveloperName();
			this.name = rti.getName();
			this.recordTypeId = rti.getRecordTypeId();
			this.active = rti.isActive();
			this.available = rti.isAvailable();
			this.isDefault = rti.isDefaultRecordTypeMapping();
			this.master = rti.isMaster();
		}
	} */

	/**
	 * @description If we are running a test, clear sObject maps. We do this to avoid using @testVisible on the maps themselves
	 * <br>This is private and testvisible so it cannot be called in production code context
	 */
	@testVisible
	private static void clearMapsInTest() {
		if (Test.isRunningTest()) {
			RecordTypes.recordTypesById.clear();
			RecordTypes.recordTypesByName.clear();
			RecordTypes.recordTypesByDevName.clear();
			RecordTypes.availableRecordTypesMap.clear();
			RecordTypes.allRecordTypes.clear();
		}
	}
}