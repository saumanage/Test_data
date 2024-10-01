public class RDRSoldModelCorrectionBatch implements Database.Batchable<sObject>,Schedulable{
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query='select id,CreatedDate, Model_ID__c, Model_Name_Code_CD__c, RDR_Sold_Model__c from RDR_Sales__c where Sold_Model_Processed__c=false order by CreatedDate desc limit 1000000';
        return Database.getQueryLocator(query); 
        }
    public void execute(Database.BatchableContext BC, List<RDR_Sales__c> Scope){
        RDRSalesTriggerHandler inst= new RDRSalesTriggerHandler();
        inst.rdrsalemodel(scope);
        for (RDR_Sales__c rdr: scope){
            rdr.Sold_Model_Processed__c=true;
        }
         Database.update (scope);
        
    }
    public void finish(Database.BatchableContext BC){
        
    }
    public void execute(SchedulableContext sc){
        RDRSoldModelCorrectionBatch cs = new RDRSoldModelCorrectionBatch();
        Id JobID=Database.executeBatch(cs);
    }

}