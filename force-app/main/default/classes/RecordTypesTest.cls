/**
 * @description Test class for RecordTypes.cls
 *
 * @author Evan Callahan
 * @since  2010
 * @author {@link [David Schach](https://github.com/dschach)}
 * @since  2021
 * @group RecordTypes
 * @see RecordTypes
 */
@IsTest
private class RecordTypesTest {
	/**
	 * @description Test various record types and names
	 * <br>We test nonexistent object names, nonexistent record type names, null values, and existing Account record type (if available)
	 * @author Evan Callahan
	 */
	@isTest
	private static void testRecTypes() {
		//Test with Bogus object

		Assert.areEqual(null, RecordTypes.getRecordType('Bogus', null), 'Bogus object should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeDevNameFromId(null), 'Nonexistent RecordType');
		Assert.areEqual(null, RecordTypes.getRecordTypeNameFromId(null), 'Nonexistent RecordType');

		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromName('Bogust', 'Bogus'), 'Bogus object should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeDevNameFromName('Bogust', 'Bogus'), 'Bogus object should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeNameFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeNameFromId('Bogus', null), 'Bogus object should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeDevNameFromId('bogus', null), 'Bogus object should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromName('Bogus', 'Bogus'), 'Bogus object should not exist');

		Assert.isTrue(RecordTypes.getAvailableRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getAvailableRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');

		Assert.isTrue(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');

		//Test with Account
		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeDevNameFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeNameFromDevName('Account', 'Bogus'), 'Bogus record type should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromDevName('Account', 'Bogus'), 'Bogus record type should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeNameFromId('Account', null), 'Null record type should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeDevNameFromId('Account', null), 'Null record type should not exist');

		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromDevName('Account', 'Bogus'), 'Bogus record type should not exist');
		Assert.areEqual(null, RecordTypes.getRecordTypeIdFromName('Account', 'Bogus'), 'Bogus record type should not exist');

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeDevNameIdMap('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
		Assert.isNotNull(
			RecordTYpes.getAvailableRecordTypeNameIdMap('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	@isTest
	private static void testAccountRecordType() {
		List<RecordType> accountRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE IsActive = TRUE AND SObjectType = 'Account'];

		RecordTypes.getRecordTypeNameIdMap('Account');
		resetTest();

		RecordTypes.getRecordTypeDevNameIdMap('Account');
		resetTest();

		if (!accountRecordTypes.isEmpty()) {
			RecordType activeRT = accountRecordTypes[0];

			Schema.RecordTypeInfo rti = RecordTypes.getRecordType('Account', activeRT.Id);

			Assert.areNotEqual(null, RecordTypes.getRecordTypeDevNameFromId(activeRT.Id), 'We should have had an Account RecordType');
			Assert.areNotEqual(null, RecordTypes.getRecordTypeNameFromId(activeRT.Id), 'We should have had an Account RecordType');

			Assert.areEqual(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromName('Account', activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id
			);
			Assert.areEqual(
				rti.getRecordTypeId(),
				RecordTypes.getRecordTypeIdFromName('Account', activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id: ' + rti.getRecordTypeId()
			);
			resetTest();

			Assert.areEqual(activeRT.DeveloperName, RecordTypes.getRecordTypeDevNameFromName('Account', activeRT.Name), 'Error - mismatch on returned developername');
			resetTest();

			Assert.areEqual(activeRT.Name, RecordTypes.getRecordTypeNameFromDevName('Account', activeRT.DeveloperName), 'Error - mismatch on returned name');
			Assert.areEqual(activeRT.Id, RecordTypes.getRecordTypeIdFromDevName('Account', activeRT.DeveloperName), 'Error - mismatch on returned Id');
			resetTest();

			Assert.areEqual(activeRT.Name, RecordTypes.getRecordTypeNameFromId('Account', activeRT.Id), 'Error - mismatch on returned name');
			resetTest();

			Assert.areEqual(activeRT.DeveloperName, RecordTypes.getRecordTypeDevNameFromId('Account', activeRT.Id), 'Error - mismatch on returned developername');
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
		Assert.areEqual(accountRecordTypes.size(), rtOptions.size(), 'Error - mismatch on record type count');
		resetTest();

		rtOptions = RecordTypes.getStringRecordTypesForSelectList('Account');
		Assert.areEqual(accountRecordTypes.size(), rtOptions.size(), 'Error - mismatch on record type count');
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}