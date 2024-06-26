/**
 * @description Test class for SelectListController
 * <br>NOT included in the unlocked package
 * @group Unpackaged Tests
 *
 * @author      David Schach
 * @since       2024
 */
@IsTest
public with sharing class SelectListsControllerTest {
	@IsTest
	static void testController() {
		SelectListsController slc = new SelectListsController();
		Assert.isTrue(!slc.getAllAvailableRTs().isEmpty(), 'SelectList needs at least one availale RT');
		Assert.isTrue(!slc.getAllRTs().isEmpty(), 'SelectList needs at least one RT');
	}
}