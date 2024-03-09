/**
 * @description Test unpackaged metadata to cover additional possibilities
 *
 * @group Unpackaged Tests
 *
 * @author      David Schach
 * @since       2024
 */
@IsTest
private class UnpackagedRecordTypesTest {
	/**
	 * @description Test against Account, an object with record types in package testing, but with lowercase RT name
	 * <br>Assumes we have a record type called `Default` and tests `Default`
	 * @author Evan Callahan
	 * @author David Schach
	 */
	@IsTest
	private static void testAccountRecTypes() {
		//Test with Account

		Assert.isNotNull(RecordTypes.getRecordTypesForObject('Account'), 'A real sobject should have at least Master record type');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromName('Account', 'Default'), 'Default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeDevNameFromName('Account', 'Default'), 'Default record type should exist');

		Assert.isNotNull(RecordTypes.getRecordTypeNameFromDevName('Account', 'Default'), 'Default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'Default'), 'Default record type should exist');

		Assert.isNull(RecordTypes.getRecordTypeNameFromId('Account', null), 'Null record type should not exist');
		Assert.isNull(RecordTypes.getRecordTypeDevNameFromId('Account', null), 'Null record type should not exist');

		Assert.isNotNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'Default'), 'Default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromName('Account', 'Default'), 'Default record type should exist');

		//Assert.areEqual('Default', RecordTypes.getDefaultRecordTypeName('Account'), 'Our default Account RT should be "Default"');
		//Assert.areEqual('Default', RecordTypes.getDefaultRecordTypeDevName('Account'), 'Our default Account RT should be "Default"');

		Assert.areEqual(
			'Master',
			RecordTypes.getDefaultRecordTypeName('Account'),
			'Our default Account RT should be "Master" because we assigned via permission set'
		);
		Assert.areEqual(
			'Master',
			RecordTypes.getDefaultRecordTypeDevName('Account'),
			'Our default Account RT should be "Master" because we assigned via permission set'
		);

		Assert.isNotNull(RecordTypes.getRecordTypeDevNameIdMap('Account'), 'A real sobject should return at least an empty map');

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeDevNameIdMap('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypeNameIdMap('Account'),
			'Should return at least an empty map, and a populated one if we have record types for Account.'
		);

		Assert.isNotNull(
			RecordTypes.getAvailableRecordTypesIdSet('Account'),
			'Should return at least an empty map, and populated one if we have record types for Account.'
		);
	}

	/**
	 * @description Test against Account, an object with record types in package testing, but with lowercase RT name
	 * <br>Assumes we have a record type called `Default` and tests `default`
	 * @author Evan Callahan
	 * @author David Schach
	 */
	@IsTest
	private static void testAccountRecTypesLowercaseRT() {
		//Test with Account

		Assert.isNotNull(RecordTypes.getRecordTypesForObject('Account'), 'A real sobject should have at least Master record type');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromName('Account', 'default'), 'default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeDevNameFromName('Account', 'default'), 'default record type should exist');

		Assert.isNotNull(RecordTypes.getRecordTypeNameFromDevName('Account', 'default'), 'default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'default'), 'default record type should exist');

		Assert.isNotNull(RecordTypes.getRecordTypeIdFromDevName('Account', 'default'), 'default record type should exist');
		Assert.isNotNull(RecordTypes.getRecordTypeIdFromName('Account', 'default'), 'default record type should exist');
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
	 * @description Test for running certain methods without filling maps
	 */
	@IsTest
	static void testMethodsAfterReset() {
		resetTest();
		List<RecordType> queriedRecordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account'];
		Assert.isNotNull(RecordTypes.getRecordTypeNameFromId(queriedRecordTypes[0].Id), 'Error');
	}

	/**
	 * @description Clear all record type maps to enable using fewer test methods - reset within a method
	 * @author {@link [David Schach](https://github.com/dschach)}
	 */
	private static void resetTest() {
		RecordTypes.clearMapsInTest();
	}
}