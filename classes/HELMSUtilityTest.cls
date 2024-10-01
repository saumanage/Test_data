/**
 * HELMSUtilityTest class contains test methods for HELMSUtility class.
 * @author Lee
 * @version 1.0
 * @since 2024-03-18
 */
@isTest
public class HELMSUtilityTest {
    @isTest static void testGetAccountRecordTypes() {
        
        Map<String, Id> recordTypes = HELMSUtility.AccountRecordTypes;
        
        System.assertNotEquals(null, recordTypes, 'Record types should not be null');
        System.assert(recordTypes.size() > 0, 'There should be at least one record type');
    }
}