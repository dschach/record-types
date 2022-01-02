/**
 * @description Test class for RecordTypes.cls
 *
 * @author Evan Callahan
 * @since  2010
 * @author David Schach
 * @group RecordTypes
 * @see RecordTypes
 */
@IsTest
public with sharing class RecordTypesTest {
	/**
	 * @description Test various record types and names
	 * <br>We test nonexistent object names, nonexistent record type names, null values, and existing Account record type (if available)
	 */
	@isTest
	static void testRecTypes() {
		//Test with Bogus object

		System.assertEquals(null, RecordTypes.getRecordType('Bogus', null));

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Bogust', 'Bogus'));
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromName('Bogust', 'Bogus'));

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromDeveloperName('Bogus', 'Bogus'));
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus'));

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromId('Bogus', null));
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromId('bogus', null));

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus'));
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Bogus', 'Bogus'));

		//Test with Account
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'));

		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromName('Account', 'Bogus'));

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromDeveloperName('Account', 'Bogus'));
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Account', 'Bogus'));

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromId('Account', null));
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromId('Account', null));

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Account', 'Bogus'));
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'));

		System.assert(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty());
		System.assert(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty());
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author David Schach
	 */
	@IsTest
	static void testAccountRecordType() {
		List<RecordType> accountRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE IsActive = TRUE AND SObjectType = 'Account'];
		System.debug(accountRecordTypes);
		RecordTypes.getRecordTypeNameIdMap('Account');
		clearMaps();

		RecordTypes.getRecordTypeDevNameIdMap('Account');
		clearMaps();

		if (!accountRecordTypes.isEmpty()) {
			RecordType activeRT = accountRecordTypes[0];

			RecordTypes.getRecordType('Account', activeRT.Id);

			System.assertEquals(activeRT.Id, RecordTypes.getRecordTypeIdFromName('Account', activeRt.Name), 'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id);
			clearMaps();

			System.assertEquals(activeRT.DeveloperName, RecordTypes.getRecordTypeDeveloperNameFromName('Account', activeRT.Name));
			clearMaps();

			System.assertEquals(activeRT.Name, RecordTypes.getRecordTypeNameFromDeveloperName('Account', activeRT.DeveloperName));
			System.assertEquals(activeRT.Id, RecordTypes.getRecordTypeIdFromDeveloperName('Account', activeRT.DeveloperName));
			clearMaps();

			System.assertEquals(activeRT.Name, RecordTypes.getRecordTypeNameFromId('Account', activeRT.Id));
			clearMaps();

			System.assertEquals(activeRT.DeveloperName, RecordTypes.getRecordTypeDeveloperNameFromId('Account', activeRT.Id));
			clearMaps();

			Set<String> rtNames = new Set<String>();
			Set<String> rtDevNames = new Set<String>();
			for (RecordType rt : accountRecordTypes) {
				rtNames.add(rt.Name);
				rtDevNames.add(rt.DeveloperName);
			}

			RecordTypes.getRecordTypeIdSetFromDevNames('Account', rtDevNames);
			clearMaps();
		}
		RecordTypes.getRecordTypeNameIdMap('Account');
		clearMaps();

		List<SelectOption> rtOptions = RecordTypes.getRecordTypesForSelectList('Account');
		System.assertEquals(accountRecordTypes.size(), rtOptions.size());
		clearMaps();

		rtOptions = RecordTypes.getStringRecordTypesForSelectList('Account');
		System.assertEquals(accountRecordTypes.size(), rtOptions.size());
	}

	/**
	 * @description Clear all record type maps to enable using fewer methods
	 * @author David Schach
	 */
	private static void clearMaps() {
		RecordTypes.recordTypesById.clear();
		RecordTypes.recordTypesByName.clear();
		RecordTypes.recordTypesByDevName.clear();
		RecordTypes.recordTypesList.clear();
	}
}