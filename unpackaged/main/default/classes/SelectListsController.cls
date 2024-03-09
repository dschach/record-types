/**
 * @description Class for testing `RecordTypes` picklist methods
 * <br>NOT included in the unlocked package
 * @group Unpackaged Tests
 *
 * @author      David Schach
 * @since       2024
 */
@SuppressWarnings('PMD.ApexDoc')
public with sharing class SelectListsController {
	@SuppressWarnings
	public SelectListsController() {
		selectedObjectName = '';
		gd = Schema.getGlobalDescribe();
		objectPicklist = new List<SelectOption>();
		for (String s : gd.keySet()) {
			if (s.length() <= 12 && !s.endsWithIgnoreCase('feed') && !s.endsWithIgnoreCase('share') && !gd.get(s).getDescribe().isCustom()) {
				objectPicklist.add(new SelectOption(s, gd.get(s).getDescribe().getLabel()));
			}
		}
		objectPicklist.sort();
		selectedObjectName = objectPicklist[0].getValue();
	}

	private Map<String, Schema.SObjectType> gd;
	public List<SelectOption> objectPicklist { get; private set; }
	public String selectedObjectName { get; set; }

	public List<SelectOption> getAllRTs() {
		return RecordTypes.getAllRecordTypesForSelectList(selectedObjectName);
	}
	public List<SelectOption> getAllAvailableRTs() {
		return RecordTYpes.getAvailableRecordTypesForSelectList(selectedObjectName);
	}
}