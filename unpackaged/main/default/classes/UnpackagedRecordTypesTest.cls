/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
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