/**
 * HELMSUtility class.
 * @author Lee
 * @version 1.0
 * @since 2024-03-14
 */
public class HELMSUtility {
    
    private static Map<String, Id> recordTypeMap;

    /**
     * Get the record types for the Account object.
     * @return Map<String, Id> - A map of record type names to record type IDs
     */
    public static Map<String, Id> AccountRecordTypes {
        get {
            // Only fetch the record types if they haven't been fetched already
            if(recordTypeMap == null) {
                recordTypeMap = new Map<String, Id>();
                Schema.DescribeSObjectResult describeResult = Account.sObjectType.getDescribe();
                
                for(Schema.RecordTypeInfo rtInfo : describeResult.getRecordTypeInfos()) {
                    recordTypeMap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
                }
            }
            
            return recordTypeMap;
        }
        private set;
    }
}