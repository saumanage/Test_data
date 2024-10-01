public class ModelGroupUploadHandler {
    public void addProductModelCustomObject(List<Product_Model_Master__c> listRec){
        try{
        List<Product_Model_Group__c> prodModelGrpList = new List<Product_Model_Group__c>();
        List<Product_Model__c> prodModelList = new List<Product_Model__c>();
        Map<String, Product_Model_Master__c> productModelmasterMap = new Map<String, Product_Model_Master__c>();
        Set<Id> recIds = new Set<Id>();
        for(Product_Model_Master__c rec : listRec){
            productModelmasterMap.put(rec.ID,rec); // New Map 
        }
        for (Id fieldName : productModelmasterMap.keySet()){
            Product_Model_Group__c modelGrpRec = new Product_Model_Group__c();
            modelGrpRec.Division__c = productModelmasterMap.get(fieldName).Division__c;
            modelGrpRec.Parent_Series_Group_Name__c = productModelmasterMap.get(fieldName).ParentSeriesGroupName__c;
                modelGrpRec.Name = productModelmasterMap.get(fieldName).ModelGroupName__c;
                modelGrpRec.Product_Model_Master__c = productModelmasterMap.get(fieldName).Id;
            modelGrpRec.Product_Series_Group_Name__c = productModelmasterMap.get(fieldName).SeriesGroupName__c;
                modelGrpRec.Subdivision__c = productModelmasterMap.get(fieldName).SubDivision__c;
            prodModelGrpList.add(modelGrpRec);
        }
        Database.SaveResult[] sr = Database.insert(prodModelGrpList, false);
       	for (Database.SaveResult ds : sr) {
            if (ds.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                recIds.add(ds.getId());
            }
       	}
        if(recIds.size() > 0){
            for(Product_Model_Group__c rec : [SELECT Id, Product_Model_Master__c FROM Product_Model_Group__c WHERE Id IN : recIds ]){
                Product_Model__c rec2 = new Product_Model__c();
                Id stringNewKey = rec.Product_Model_Master__c;
                if(!productModelmasterMap.isEmpty() && productModelmasterMap.containskey(stringNewKey)){
                    rec2.Product_Model_Group_Id__c = rec.Id;
                    rec2.Model_Year__c = productModelmasterMap.get(stringNewKey).ModelYear__c;
                    rec2.Model_MSRP__c = Decimal.ValueOf(productModelmasterMap.get(stringNewKey).ModelMSRP__c);
                    rec2.Model_Marketing_Name__c = productModelmasterMap.get(stringNewKey).ModelMarketingName__c;
                    rec2.Model_ID_Text__c = productModelmasterMap.get(stringNewKey).ModelID__c;
                    prodModelList.add(rec2);
                }
            }
        }
        if(prodModelList.size() > 0){
        	insert prodModelList;    
            }   
        }Catch(Exception ex) {
            Logs__c l = new Logs__c(name = 'Model Group Upload', Trigger_or_Class_Name__c = 'ModelGroupUploadHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
        }
    }
}