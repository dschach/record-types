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
	@IsTest
	static void testRecTypes() {
		//Test with Bogus object

		System.assertEquals(null, RecordTypes.getRecordType('Bogus', null), 'Bogus object should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Bogust', 'Bogus'), 'Bogus object should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromName('Bogust', 'Bogus'), 'Bogus object should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromDeveloperName('Bogus', 'Bogus'), 'Bogus object should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus'), 'Bogus object should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromId('Bogus', null), 'Bogus object should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromId('bogus', null), 'Bogus object should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus'), 'Bogus object should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Bogus', 'Bogus'), 'Bogus object should not exist');

		//Test with Account
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromDeveloperName('Account', 'Bogus'), 'Bogus record type should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Account', 'Bogus'), 'Bogus record type should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeNameFromId('Account', null), 'Null record type should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeDeveloperNameFromId('Account', null), 'Null record type should not exist');

		System.assertEquals(null, RecordTypes.getRecordTypeIdFromDeveloperName('Account', 'Bogus'), 'Bogus record type should not exist');
		System.assertEquals(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		System.assert(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		System.assert(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author David Schach
	 */
	@IsTest
	static void testAccountRecordType() {
		List<RecordType> accountRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE IsActive = TRUE AND SObjectType = 'Account'];

		RecordTypes.getRecordTypeNameIdMap('Account');
		resetTest();

		RecordTypes.getRecordTypeDevNameIdMap('Account');
		resetTest();

		if (!accountRecordTypes.isEmpty()) {
			RecordType activeRT = accountRecordTypes[0];

			Schema.RecordTypeInfo rti = RecordTypes.getRecordType('Account', activeRT.Id);

			System.assertEquals(activeRT.Id, RecordTypes.getRecordTypeIdFromName('Account', activeRt.Name), 'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id);
			System.assertEquals(rti.getRecordTypeId(), RecordTypes.getRecordTypeIdFromName('Account', activeRt.Name), 'Submitted ' + activeRT.Name + ' and expected an Id: ' + rti.getRecordTypeId());
			resetTest();

			System.assertEquals(activeRT.DeveloperName, RecordTypes.getRecordTypeDeveloperNameFromName('Account', activeRT.Name), 'Error - mismatch on returned developername');
			resetTest();

			System.assertEquals(activeRT.Name, RecordTypes.getRecordTypeNameFromDeveloperName('Account', activeRT.DeveloperName), 'Error - mismatch on returned name');
			System.assertEquals(activeRT.Id, RecordTypes.getRecordTypeIdFromDeveloperName('Account', activeRT.DeveloperName), 'Error - mismatch on returned Id');
			resetTest();

			System.assertEquals(activeRT.Name, RecordTypes.getRecordTypeNameFromId('Account', activeRT.Id), 'Error - mismatch on returned name');
			resetTest();

			System.assertEquals(activeRT.DeveloperName, RecordTypes.getRecordTypeDeveloperNameFromId('Account', activeRT.Id), 'Error - mismatch on returned developername');
			resetTest();

			Set<String> rtNames = new Set<String>();
			Set<String> rtDevNames = new Set<String>();
			for (RecordType rt : accountRecordTypes) {
				rtNames.add(rt.Name);
				rtDevNames.add(rt.DeveloperName);
			}

			RecordTypes.getRecordTypeIdSetFromDevNames('Account', rtDevNames);
			resetTest();
		}
		RecordTypes.getRecordTypeNameIdMap('Account');
		resetTest();

		List<SelectOption> rtOptions = RecordTypes.getRecordTypesForSelectList('Account');
		System.assertEquals(accountRecordTypes.size(), rtOptions.size(), 'Error - mismatch on record type count');
		resetTest();

		rtOptions = RecordTypes.getStringRecordTypesForSelectList('Account');
		System.assertEquals(accountRecordTypes.size(), rtOptions.size(), 'Error - mismatch on record type count');
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author David Schach
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}