public class loadingRDRHelper {
    @future
    public static void deleteRDRRecords(Set<Id> rdrSalesRec){
        if(rdrSalesRec.size() > 0){
        	delete [SELECT Id, Name FROM RDR_Sales__c WHERE Id IN : rdrSalesRec];    
        }
    }
}