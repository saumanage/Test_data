public class RDRSalesTriggerHandler {
    public void rdrsalemodel(List<RDR_Sales__c> lstrdr){
        Map<String, Product_Model__c> currentPMsToRealtedMId = new Map<String, Product_Model__c>();
        
        for(Product_Model__c pm : [SELECT Id, Model_ID_Text__c, Product_Model_Group_Id__r.Id, 
                                   Product_Model_Group_Id__r.Name from Product_Model__c ]){
                                       currentPMsToRealtedMId.put(pm.Model_ID_Text__c, pm);
                                   }
        for(RDR_sales__c rdr: lstrdr){
            
            if(rdr.Model_ID__c!=null && !(rdr.Model_ID__c.isNumeric()) && currentPMsToRealtedMId.containskey(rdr.Model_ID__c))    
            rdr.RDR_Sold_Model__c=currentPMsToRealtedMId.get(rdr.Model_ID__c).Product_Model_Group_Id__r.Name;
            else{
            if(rdr.Model_Name_Code_CD__c!=null && currentPMsToRealtedMId.containskey(rdr.Model_Name_Code_CD__c))    
            rdr.RDR_Sold_Model__c=currentPMsToRealtedMId.get(rdr.Model_Name_Code_CD__c).Product_Model_Group_Id__r.Name;
            }
        }
    }
}