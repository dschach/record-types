/**
 * @description Test class for RecordTypes.cls
 *
 * @author Evan Callahan
 * @author {@link [David Schach](https://github.com/dschach)}
 * @since  2021 Various enhancements and updates to use new Apex methods
 * @since  2023 Addition of methods to handle no profile-based RT permissions with permissions via permission set
 * @since  2024 Check for case insensitivity
 * @since  2026 Test efficiency increased
 * @group RecordTypes
 * @see RecordTypes
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs,PMD.NcssCount')
@IsTest
private class RecordTypesTest {
	/**
	 * @description Test various record types and names
	 * <br>We test nonexistent object names, nonexistent record type names, null values, and existing Account record type (if available)
	 * @author Evan Callahan
	 */
	@IsTest
	private static void testBogusRecTypes() {
		//Test with Bogus object

		Assert.isNull(RecordTypes.getRecordTypesForObject('Bogus'), 'Bogus object should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId(null), 'Nonexistent RecordType');
		Assert.isNull(RecordTypes.getRecordTypeNameFromId(null), 'Nonexistent RecordType');

		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Bogust', 'Bogus'), 'Bogus object should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromName('Bogust', 'Bogus'), 'Bogus object should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromId('Bogus', null), 'Bogus object should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId('bogus', null), 'Bogus object should not exist');

		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Bogus', 'Bogus'), 'Bogus object should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Bogus', 'Bogus'), 'Bogus object should not exist');

		Assert.isTrue(RecordTypes.getAvailableRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getAvailableRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getAvailableRecordTypesIdSet('Bogus').isEmpty(), 'Bogus object should not exist');

		Assert.isTrue(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');

		Assert.isNull(RecordTypes.getDefaultRecordTypeName('Bogus'), 'Bogus object should not have a record type');
		Assert.isNull(RecordTypes.getDefaultRecordTypeDevName('Bogus'), 'Bogus object should not have a record type');
		Assert.isNull(RecordTypes.getDefaultRecordTypeId('Bogus'), 'Bogus object should not have a record type');

		Assert.isFalse(RecordTypes.isRecordTypeAvailable('Bogus', 'Bogus'), 'Bogus should not have an available record type');
		Assert.isFalse(RecordTypes.isRecordTypeDefault('Bogus', 'Bogus'), 'Bogus should not have an available record type');
	}

	/**
	 * @description Test against Account, an object with record types in package testing
	 * @author Evan Callahan
	 */
	@IsTest
	private static void testAccountRecTypes() {
		assertAccountReturns('Account');
	}

	/**
	 * @description Test against account (lowercase object name) to check case insensitivity
	 * @author Evan Callahan
	 */
	@IsTest
	private static void testAccountRecTypesCaseInsensitive() {
		assertAccountReturns('account');
	}

	/**
	 * @description Shared assertions for Account tests, run once with the proper-case name and once with lowercase
	 *
	 * @param objectName Name of the object to test, in any case
	 */
	private static void assertAccountReturns(String objectName) {
		Assert.isNotNull(RecordTypes.getRecordTypesForObject(objectName), 'A real sobject should have at least Master record type');
		Assert.isNull(RecordTypes.getRecordTypeIdFromName(objectName, 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromName(objectName, 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromDevName(objectName, 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName(objectName, 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromId(objectName, null), 'Null record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId(objectName, null), 'Null record type should not exist');

		Assert.isNotNull(RecordTypes.getDefaultRecordTypeName(objectName), 'A real sobject should have at least Master record type');
		Assert.isNotNull(RecordTypes.getDefaultRecordTypeDevName(objectName), 'A real sobject should have at least Master record type');

		Assert.isNotNull(RecordTypes.getRecordTypeDevNameIdMap(objectName), 'A real sobject should return at least an empty map');

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeDevNameIdMap(objectName),
			'Should return at least an empty map, and populated one if we have record types for ' + objectName
		);
		Assert.isNotNull(RecordTypes.getAvailableRecordTypeNameIdMap(objectName), 'Should return at least an empty map, and a populated one if we have record types for ' + objectName);

		Assert.isNotNull(RecordTypes.getAvailableRecordTypesIdSet(objectName), 'Should return at least an empty set, and populated one if we have record types for ' + objectName);

		resetTest();
		Assert.isFalse(RecordTypes.getAllRecordTypesForSelectList(objectName).isEmpty(), 'Should return at least single item select list');
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @see testSObjectRecordTypeReturns
	 */
	@IsTest
	private static void testAccountRecordTypes() {
		Assert.isTrue(testSObjectRecordTypeReturns('Account'), 'Test failure checking Account');
	}

	/**
	 * @description Separate method for checking if we have Account record type, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @see testSObjectRecordTypeReturns
	 */
	@IsTest
	private static void testAccountRecordTypesLowercase() {
		Assert.isTrue(testSObjectRecordTypeReturns('account'), 'Test failure checking account (object name lowercase)');
	}

	/**
	 * @description Separate method for checking if we have Contact record type, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @see testSObjectRecordTypeReturns
	 */
	@IsTest
	private static void testContactRecordTypes() {
		Assert.isTrue(testSObjectRecordTypeReturns('contact'), 'Test failure checking Contact');
	}

	/**
	 * @description Separate method for checking if we have record types for a nonexistent object, and then testing that
	 * @author {@link [David Schach](https://github.com/dschach)}
	 * @see testSObjectRecordTypeReturns
	 */
	@IsTest
	private static void testBogusRecordTypes() {
		Assert.isTrue(testSObjectRecordTypeReturns('bogus'), 'Test failure checking Bogus object');
	}

	/**
	 * @description       Utility class for testing various objects against the `RecordTypes` library
	 *
	 * @param sobjectname Name of the object to test for record types
	 * @return            `true` if all assertions pass
	 */
	private static Boolean testSObjectRecordTypeReturns(String sobjectname) {
		List<RecordType> queriedRecordTypes = [
			SELECT Id, Name, DeveloperName
			FROM RecordType
			WHERE SObjectType = :sobjectname
		];

		RecordTypes.getRecordTypeNameIdMap(sobjectname);
		resetTest();

		RecordTypes.getRecordTypeDevNameIdMap(sobjectname);
		resetTest();

		if (!queriedRecordTypes.isEmpty()) {
			String defaultRTDevName = RecordTypes.getDefaultRecordType(sobjectName).getDeveloperName();
			//System.debug(sobjectname + ' default RT DevName = ' + defaultRTDevName);
			Assert.isTrue(
				RecordTypes.isRecordTypeDefault(sobjectName, defaultRTDevName),
				'We should have found ' + sobjectname.capitalize() + ' default RT DevName as ' + defaultRTDevName
			);

			RecordTypes.getDefaultRecordTypeDevName(sobjectname);
			resetTest();
			RecordTypes.getDefaultRecordTypeName(sobjectname);
			resetTest();
			RecordTypes.getDefaultRecordTypeId(sobjectname);
			resetTest();

			RecordType activeRT = queriedRecordTypes[0];

			Schema.RecordTypeInfo rti = RecordTypes.getRecordTypeFromId(sobjectname, activeRT.Id);
			Schema.RecordTypeInfo rti2 = RecordTypes.getRecordTypeFromId(activeRT.Id);

			Assert.areEqual(rti.getDeveloperName(), rti2.getDeveloperName(), 'Overloaded ' + sobjectname.capitalize() + ' method failed to retrieve same RTId');

			Assert.areNotEqual(null, RecordTypes.getRecordTypeDevNameFromId(activeRT.Id), 'We should have had ' + sobjectname.capitalize() + ' Record Type');
			Assert.areNotEqual(null, RecordTypes.getRecordTypeNameFromId(activeRT.Id), 'We should have had ' + sobjectname.capitalize() + ' Record Type');

			Id idFromName = RecordTypes.getRecordTypeIdFromName(sobjectname, activeRt.Name);
			Assert.areEqual(activeRT.Id, idFromName, 'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id);
			Assert.areEqual(rti.getRecordTypeId(), idFromName, 'Submitted ' + activeRT.Name + ' and expected an Id: ' + rti.getRecordTypeId());
			resetTest();

			Assert.areEqual(
				activeRT.DeveloperName,
				RecordTypes.getRecordTypeDevNameFromName(sobjectname, activeRT.Name),
				'Error - ' + sobjectname.capitalize() + ' mismatch on returned developername'
			);
			resetTest();

			Assert.areEqual(
				activeRT.Name,
				RecordTypes.getRecordTypeNameFromDevName(sobjectname, activeRT.DeveloperName),
				'Error - ' + sobjectname.capitalize() + ' mismatch on returned name'
			);
			Assert.areEqual(activeRT.Id, RecordTypes.getRecordTypeIdFromDevName(sobjectname, activeRT.DeveloperName), 'Error - ' + sobjectname.capitalize() + ' mismatch on returned Id');
			resetTest();

			Assert.areEqual(activeRT.Name, RecordTypes.getRecordTypeNameFromId(sobjectname, activeRT.Id), 'Error - ' + sobjectname.capitalize() + ' mismatch on returned name');
			resetTest();

			Assert.areEqual(
				activeRT.DeveloperName,
				RecordTypes.getRecordTypeDevNameFromId(sobjectname, activeRT.Id),
				'Error - ' + sobjectname.capitalize() + ' mismatch on returned developername'
			);
			resetTest();

			Set<String> rtNames = new Set<String>();
			Set<String> rtDevNames = new Set<String>();
			for (RecordType rt : queriedRecordTypes) {
				rtNames.add(rt.Name);
				rtDevNames.add(rt.DeveloperName);
			}

			RecordTypes.getRecordTypeIdSetFromDevNames(sobjectname, rtDevNames);
			resetTest();

			List<SelectOption> allRtOptions = RecordTypes.getAllRecordTypesForSelectList(sobjectname);
			Assert.isTrue(queriedRecordTypes.size() >= allRtOptions.size(), 'Error - ' + sobjectname.capitalize() + ' SelectList has too many items');
			resetTest();

			List<SelectOption> rtOptions = RecordTypes.getAvailableRecordTypesForSelectList(sobjectname);
			Assert.isTrue(queriedRecordTypes.size() >= rtOptions.size(), 'Error - ' + sobjectname.capitalize() + ' SelectList has too many items');
			Assert.isTrue(allRtOptions.size() >= rtOptions.size(), 'Error - The number of available ' + sobjectname.capitalize() + ' record types is wrong');
			resetTest();

			rtOptions = RecordTypes.getStringRecordTypesForSelectList(sobjectname);
			Assert.isTrue(queriedRecordTypes.size() >= rtOptions.size(), 'Error - ' + sobjectname.capitalize() + ' SelectList has too many items');
		} else {
			Integer minimumItems = objectExists(sobjectname) ? 1 : 0;
			RecordTypes.getRecordTypeIdSetFromDevNames(sobjectname, new Set<String>());
			resetTest();

			List<SelectOption> allRtOptions = RecordTypes.getAllRecordTypesForSelectList(sobjectname);
			Assert.isTrue(
				allRtOptions.size() >= minimumItems,
				'Error - ' + sobjectname.capitalize() + ' SelectList should have at least ' + minimumItems + ' item. We have ' + allRtOptions.size()
			);
			resetTest();

			List<SelectOption> rtOptions = RecordTypes.getAvailableRecordTypesForSelectList(sobjectname);
			Assert.isTrue(
				rtOptions.size() >= minimumItems,
				'Error - We should have at least ' + minimumItems + ' ' + sobjectname.capitalize() + ' available record types in the select list. We have ' + rtOptions.size()
			);
			resetTest();

			rtOptions = RecordTypes.getStringRecordTypesForSelectList(sobjectname);
			Assert.isTrue(queriedRecordTypes.size() >= rtOptions.size(), 'Error - ' + sobjectname.capitalize() + ' SelectList has too many items');
			Assert.isTrue(allRtOptions.size() >= rtOptions.size(), 'Error - We should have one ' + sobjectname.capitalize() + ' record types in the select list');
		}

		return true;
	}

	/**
	 * @description Check that an object exists with a single deferred describe, avoiding the cost of a global describe
	 *
	 * @param sobjectname Name of the object to look for
	 * @return            `true` if the object exists
	 */
	private static Boolean objectExists(String sobjectname) {
		try {
			Schema.describeSObjects(new List<String>{ sobjectname }, SObjectDescribeOptions.DEFERRED);
			return true;
		} catch (InvalidParameterValueException e) {
			return false;
		}
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}