@IsTest
public with sharing class RecordTypesTest {
	@isTest
	static void testRecTypes() {
		// try bogus object

		System.assertEquals(null, RecordTypes.getRecordType('Bogus', null));

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromName('Bogust', 'Bogus')
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeDeveloperNameFromName('Bogust', 'Bogus')
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeNameFromDeveloperName('Bogus', 'Bogus')
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus')
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeNameFromId('Bogus', null)
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeDeveloperNameFromId('bogus', null)
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromDeveloperName('Bogus', 'Bogus')
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromName('Bogus', 'Bogus')
		);

		/************
		 * Test with Opportunity
		 *************/

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromName('Opportunity', 'Bogus')
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeDeveloperNameFromName('Opportunity', 'Bogus')
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeNameFromDeveloperName('Opportunity', 'Bogus')
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromDeveloperName('Opportunity', 'Bogus')
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeNameFromId('Opportunity', null)
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeDeveloperNameFromId('Opportunity', null)
		);

		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromDeveloperName('Opportunity', 'Bogus')
		);
		System.AssertEquals(
			null,
			RecordTypes.getRecordTypeIdFromName('Opportunity', 'Bogus')
		);

		System.assert(RecordTypes.getRecordTypeDevNameIdMap('Bogus').isEmpty());
		System.assert(RecordTypes.getRecordTypeNameIdMap('Bogus').isEmpty());

		List<RecordType> opportunityRecordTypes = [
			SELECT Id, Name, DeveloperName
			FROM RecordType
			WHERE IsActive = TRUE AND SObjectType = 'Opportunity'
		];

		if (!opportunityRecordTypes.isEmpty()) {
			RecordTypes.getRecordTypeNameIdMap('Opportunity');
			clearMaps();

			RecordTypes.getRecordTypeDevNameIdMap('Opportunity');
			clearMaps();

			RecordType activeRT = opportunityRecordTypes[0];

			RecordTypes.getRecordType('Opportunity', activeRT.Id);

			System.AssertEquals(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromName('Opportunity', activeRt.Name)
			);
			clearMaps();

			System.AssertEquals(
				activeRT.DeveloperName,
				RecordTypes.getRecordTypeDeveloperNameFromName(
					'Opportunity',
					activeRT.Name
				)
			);
			clearMaps();

			System.AssertEquals(
				activeRT.Name,
				RecordTypes.getRecordTypeNameFromDeveloperName(
					'Opportunity',
					activeRT.DeveloperName
				)
			);
			System.AssertEquals(
				activeRT.Id,
				RecordTypes.getRecordTypeIdFromDeveloperName(
					'Opportunity',
					activeRT.DeveloperName
				)
			);
			clearMaps();

			System.AssertEquals(
				activeRT.Name,
				RecordTypes.getRecordTypeNameFromId('Opportunity', activeRT.Id)
			);
			clearMaps();

			System.AssertEquals(
				activeRT.DeveloperName,
				RecordTypes.getRecordTypeDeveloperNameFromId('Opportunity', activeRT.Id)
			);
			clearMaps();

			Set<String> rtNames = new Set<String>();
			Set<String> rtDevNames = new Set<String>();
			for (RecordType rt : opportunityRecordTypes) {
				rtNames.add(rt.Name);
				rtDevNames.add(rt.DeveloperName);
			}

			Set<Id> oppRtSet = RecordTypes.getRecordTypeIdSetFromDevNames(
				'Opportunity',
				rtDevNames
			);
			clearMaps();

			Map<String, Id> oppTypeMap = RecordTypes.getRecordTypeNameIdMap(
				'Opportunity'
			);
			clearMaps();

			List<SelectOption> rtOptions = RecordTypes.getRecordTypesForSelectList(
				'Opportunity'
			);
			System.assertEquals(opportunityRecordTypes.size(), rtOptions.size());
			clearMaps();

			rtOptions = RecordTypes.getStringRecordTypesForSelectList('Opportunity');
			System.assertEquals(opportunityRecordTypes.size(), rtOptions.size());
		}
	}

	private static void clearMaps() {
		RecordTypes.recordTypesById.clear();
		RecordTypes.recordTypesByName.clear();
		RecordTypes.recordTypesByDevName.clear();
		RecordTypes.recordTypesList.clear();
	}
}