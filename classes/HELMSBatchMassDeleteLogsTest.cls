@isTest 
public class HELMSBatchMassDeleteLogsTest
{
    static testMethod void testDeleteLogsMethod()
    {        
        Logs__c log = new Logs__c();
        log.name='test';
        insert log;
        
        Test.startTest();

            string query='select id from Logs__c order by CreatedDate desc';
    
            HELMSBatchMassDeleteLogs  deleteOldLogsjob = new HELMSBatchMassDeleteLogs(query);
            Id batchId = Database.executeBatch(deleteOldLogsjob ,1000);
            
        Test.stopTest();
    }
    @IsTest
    public static void testSchedulebatch()
    {
        Test.startTest();
        
        HELMSBatchMassDeleteLogs DeleteLogs= new HELMSBatchMassDeleteLogs();
        String sch = '0 0 5 * * ?';
        system.schedule('Test status Check', sch, DeleteLogs);
        Test.stopTest();
    }
}