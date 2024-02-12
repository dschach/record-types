/**
 * @description Test class for RecordTypes.cls
 *
 * @author Evan Callahan
 * @since  2010
 * @author {@link [David Schach](https://github.com/dschach)}
 * @since  2021 Various enhancements and updates to use new Apex methods
 * @since  2023 Addition of methods to handle no profile-based RT permissions with permissions via permission set
 * @group RecordTypes
 * @see RecordTypes
 */
@IsTest
private class RecordTypesTest {
	/**
	 * Memoize global describe, as we call it multiple times in this class
	 */
	static Map<String, Schema.SObjectType> gd {
		get {
			if (gd == null) {
				gd = Schema.getGlobalDescribe();
			}
			return gd;
		}
		set;
	}
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

		Assert.isTrue(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');
		Assert.isTrue(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty(), 'Bogus object should not exist');

		Assert.isNull(RecordTypes.getDefaultRecordTypeName('Bogus'), 'Bogus object should not have a record type');
		Assert.isNull(RecordTypes.getDefaultRecordTypeDevName('Bogus'), 'Bogus object should not have a record type');
		Assert.isNull(RecordTypes.getDefaultRecordTypeId('Bogus'), 'Bogus object should not have a record type');
	}

	/**
	 * @description Test against Account, an object with record types in package testing
	 * @author Evan Callahan
	 */
	@IsTest
	private static void testAccountRecTypes() {
		//Test with Account

		Assert.isNotNull(RecordTypes.getRecordTypesForObject('Account'), 'A real sobject should have at least Master record type');
		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Account', 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromName('Account', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromDevName('Account', 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromId('Account', null), 'Null record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId('Account', null), 'Null record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Account', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNotNull(RecordTypes.getDefaultRecordTypeName('Account'), 'A real sobject should have at least Master record type');
		Assert.isNotNull(RecordTypes.getDefaultRecordTypeDevName('Account'), 'A real sobject should have at least Master record type');

		Assert.isNotNull(RecordTypes.getRecordTypeDevNameIdMap('Account'), 'A real sobject should return at least an empty map');

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeDevNameIdMap('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeNameIdMap('Account'),
			'Should return at least an empty map, and a populated one if we have record types for Account.'
		);

		resetTest();
		Assert.isFalse(RecordTypes.getAllRecordTypesForSelectList('Account').isEmpty(), 'Should return at least single item select list');
	}

	/**
	 * @description Test against Solution, an object likely to have no record types
	 * @author Evan Callahan
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	@IsTest
	private static void testSolutionRecTypes() {
		//Test with Solution
		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Solution', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeDevNameFromName('Solution', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromDevName('Solution', 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Solution', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromId('Solution', null), 'Null record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId('Solution', null), 'Null record type should not exist');

		Assert.isNull(RecordTypes.getRecordTypeIdFromDevName('Solution', 'BogusRT'), 'BogusRT record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeIdFromName('Solution', 'BogusRT'), 'BogusRT record type should not exist');

		Assert.isNotNull(RecordTypes.getDefaultRecordTypeName('Solution'), 'A real sobject should have at least Master record type');
		Assert.isNotNull(RecordTypes.getDefaultRecordTypeDevName('Solution'), 'A real sobject should have at least Master record type');
		// For coverage, we are assuming that Solution has no record types
		RecordTypes.getDefaultRecordTypeId('Solution');

		Assert.isNotNull(RecordTypes.getRecordTypeDevNameIdMap('Solution'), 'a real sobject should return at least an empty map');

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeDevNameIdMap('Solution'),
			'Should return at least an empty map, and populated one if we have record types for Solution.'
		);
		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeNameIdMap('Solution'),
			'Should return at least an empty map, and populated one if we have record types for Solution.'
		);

		resetTest();
		Assert.isFalse(RecordTypes.getAllRecordTypesForSelectList('Solution').isEmpty(), 'Should return at least a single item select list');
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
		List<RecordType> queriedRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = :sobjectname];

		RecordTypes.getRecordTypeNameIdMap(sobjectname);
		resetTest();

		RecordTypes.getRecordTypeDevNameIdMap(sobjectname);
		resetTest();

		if (!queriedRecordTypes.isEmpty()) {
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

			Assert.areNotEqual(null, RecordTypes.getRecordTypeDevNameFromId(activeRT.Id), 'We should have had an' + sobjectname.capitalize() + ' RecordType');
			Assert.areNotEqual(null, RecordTypes.getRecordTypeNameFromId(activeRT.Id), 'We should have had an' + sobjectname.capitalize() + ' RecordType');

			Assert.areEqual(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromName(sobjectname, activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id to be returned: ' + activeRT.Id
			);
			Assert.areEqual(
				rti.getRecordTypeId(),
				RecordTypes.getRecordTypeIdFromName(sobjectname, activeRt.Name),
				'Submitted ' + activeRT.Name + ' and expected an Id: ' + rti.getRecordTypeId()
			);
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
			Assert.areEqual(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromDevName(sobjectname, activeRT.DeveloperName),
				'Error - ' + sobjectname.capitalize() + ' mismatch on returned Id'
			);
			resetTest();

			Assert.areEqual(
				activeRT.Name,
				RecordTypes.getRecordTypeNameFromId(sobjectname, activeRT.Id),
				'Error - ' + sobjectname.capitalize() + ' mismatch on returned name'
			);
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
			Integer objectExists = gd.containsKey(sobjectname) ? 1 : 0;
			RecordTypes.getRecordTypeIdSetFromDevNames(sobjectname, new Set<String>());
			resetTest();

			List<SelectOption> allRtOptions = RecordTypes.getAllRecordTypesForSelectList(sobjectname);
			Assert.areEqual(
				objectExists,
				allRtOptions.size(),
				'Error - ' + sobjectname.capitalize() + ' SelectList should have at least ' + objectExists + ' item. We have ' + allRtOptions.size()
			);
			resetTest();

			List<SelectOption> rtOptions = RecordTypes.getAvailableRecordTypesForSelectList(sobjectname);
			Assert.areEqual(
				objectExists,
				rtOptions.size(),
				'Error - We should have at least ' +
					objectExists +
					' ' +
					sobjectname.capitalize() +
					' available record types in the select list. We have ' +
					rtOptions.size()
			);
			resetTest();

			rtOptions = RecordTypes.getStringRecordTypesForSelectList(sobjectname);
			Assert.isTrue(queriedRecordTypes.size() >= rtOptions.size(), 'Error - ' + sobjectname.capitalize() + ' SelectList has too many items');
			Assert.isTrue(allRtOptions.size() >= rtOptions.size(), 'Error - We should have one ' + sobjectname.capitalize() + ' record types in the select list');
		}

		return true;
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}