@istest
public class ModelGroupUploadHandlerTest {
//Test Method to created a Product Model Master Record
    @isTest public static void handleModelGroupUpload() {
        List<Product_Model_Master__c> recList = new List<Product_Model_Master__c>();
        Product_Model_Master__c rec = new Product_Model_Master__c();
        rec.ModelID__c = 'GL1800DAN';
        rec.ModelYear__c = '2022';
        rec.ModelGroupName__c = 'BF100';
        rec.SeriesGroupName__c = 'Outboards - 25HP-250HP';
        rec.ParentSeriesGroupName__c = 'Street';
        rec.ModelMarketingName__c = 'BF100';
        rec.ModelMSRP__c  = '12827';
        rec.SubDivision__c = 'Marine';
        rec.Division__c = 'P';
        recList.add(rec);
        insert recList;
        system.assertEquals('GL1800DAN', rec.ModelID__c);
    }
    
}