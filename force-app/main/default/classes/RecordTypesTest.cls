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
			RecordTypes.getAvailableRecordTypeNameIdMap('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
		Assert.isFalse(RecordTypes.getAvailableRecordTypeNameIdMap('Account').isEmpty(), 'We should retrieve at least one active record type');
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
			RecordTypes.getDefaultRecordTypeDevName('Account');
			resetTest();
			RecordTypes.getDefaultRecordTypeName('Account');
			resetTest();
			RecordTypes.getDefaultRecordTypeId('Account');
			resetTest();

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
		Assert.isTrue(accountRecordTypes.size() >= rtOptions.size(), 'Error - SelectList has too many items');
		resetTest();

		rtOptions = RecordTypes.getStringRecordTypesForSelectList('Account');
		Assert.isTrue(accountRecordTypes.size() >= rtOptions.size(), 'Error - SelectList has too many items');
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	@isTest
	private static void testContactRecordType() {
		List<RecordType> accountRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE IsActive = TRUE AND SObjectType = 'Contact'];

		RecordTypes.getRecordTypeNameIdMap('Contact');
		resetTest();

		RecordTypes.getRecordTypeDevNameIdMap('Contact');
		resetTest();

		if (!accountRecordTypes.isEmpty()) {
			System.debug('Contact default RTDevName: ' + RecordTypes.getDefaultRecordTypeDevName('Contact'));
			resetTest();
			System.debug('Contact default RTName: ' + RecordTypes.getDefaultRecordTypeName('Contact'));
			resetTest();
			System.debug('Contact default RTId: ' + RecordTypes.getDefaultRecordTypeId('Contact'));
			resetTest();

			RecordType activeRT = accountRecordTypes[0];

			Schema.RecordTypeInfo rti = RecordTypes.getRecordType('Contact', activeRT.Id);

			Assert.areNotEqual(null, RecordTypes.getRecordTypeDevNameFromId(activeRT.Id), 'We should have had an Contact RecordType');
			Assert.areNotEqual(null, RecordTypes.getRecordTypeNameFromId(activeRT.Id), 'We should have had an Contact RecordType');

			Assert.areEqual(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromName('Contact', activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id
			);
			Assert.areEqual(
				rti.getRecordTypeId(),
				RecordTypes.getRecordTypeIdFromName('Contact', activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id: ' + rti.getRecordTypeId()
			);
			resetTest();

			Assert.areEqual(activeRT.DeveloperName, RecordTypes.getRecordTypeDevNameFromName('Contact', activeRT.Name), 'Error - mismatch on returned developername');
			resetTest();

			Assert.areEqual(activeRT.Name, RecordTypes.getRecordTypeNameFromDevName('Contact', activeRT.DeveloperName), 'Error - mismatch on returned name');
			Assert.areEqual(activeRT.Id, RecordTypes.getRecordTypeIdFromDevName('Contact', activeRT.DeveloperName), 'Error - mismatch on returned Id');
			resetTest();

			Assert.areEqual(activeRT.Name, RecordTypes.getRecordTypeNameFromId('Contact', activeRT.Id), 'Error - mismatch on returned name');
			resetTest();

			Assert.areEqual(activeRT.DeveloperName, RecordTypes.getRecordTypeDevNameFromId('Contact', activeRT.Id), 'Error - mismatch on returned developername');
			resetTest();

			Set<String> rtNames = new Set<String>();
			Set<String> rtDevNames = new Set<String>();
			for (RecordType rt : accountRecordTypes) {
				rtNames.add(rt.Name);
				rtDevNames.add(rt.DeveloperName);
			}

			RecordTypes.getRecordTypeIdSetFromDevNames('Contact', rtDevNames);
			resetTest();
		}
		RecordTypes.getRecordTypeNameIdMap('Contact');
		resetTest();

		List<SelectOption> rtOptions = RecordTypes.getRecordTypesForSelectList('Contact');
		Assert.isTrue(accountRecordTypes.size() >= rtOptions.size(), 'Error - SelectList has too many items');
		resetTest();

		rtOptions = RecordTypes.getStringRecordTypesForSelectList('Contact');
		Assert.isTrue(accountRecordTypes.size() >= rtOptions.size(), 'Error - SelectList has too many items');
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}