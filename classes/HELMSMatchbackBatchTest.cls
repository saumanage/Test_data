@isTest
public class HELMSMatchbackBatchTest {
    @isTest 
    static void testHELMSMatchback(){
        
        RDR_Sales__c rdrSales = new RDR_Sales__c();
        rdrSales.Customer_First_Name_NUM__c = 'TestVinay1';
        rdrSales.Customer_Last_Name_NM__c ='TestTalapalle1';
        rdrSales.XPROD_DIV_CD__c = 'A';
        rdrSales.Telephone_Number_NUM__c = '7780190896';
        rdrSales.Primary_Driver_Email__c = 'vinay123@gmail.com';
        rdrSales.Customer_Home_Phone_Number__c = '45434343443';
        rdrSales.Primary_Driver_Home_Phone_Number__c = '7780190896';
        rdrSales.Primary_Driver_Phone_Number__c = '7780190896';
        rdrSales.Customer_Cellphone_Number__c = '7780190896';
        rdrSales.Primary_Driver_Cellphone_Number__c = '3171231234';
        rdrSales.Customer_Address_ZIP_Code_TXT__c = '65456';
        rdrSales.Email_id_TXT__c = 'testvinay@gmail.com';
        rdrSales.Sales_Date_DT__c = system.today()-1;
        rdrSales.Dealer_Number_NUM__c = '222276';
        rdrSales.Vin_TXT__c = '76876544567';
        rdrSales.Customer_Address_ZIP_Code_TXT__c = '12345';
        rdrSales.Customer_Street_Address_TXT__c = '123 Hollywood Blvd';
        
        insert rdrSales;
        
        Id hondaRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Honda Opportunity').getRecordTypeId();
        
        Opportunity opp = new Opportunity();
        opp.Name='TestVinay1 TestTalapalle1';
        opp.First_Name_TXT__c = 'TestVinay1';
        opp.Last_Name_TXT__c = 'TestTalapalle1';
        opp.Stagename='Assigned to Dealer';
        opp.Email__c='testvinay@gmail.com';
        opp.ZipCode_TXT__c='12345';
        opp.Phone__c='7780190896';
        opp.Updated_by_New_MB__c=false;
        opp.RecordTypeId=hondaRecTypeId;
        opp.Division_CD__c='A';
        opp.PreferredDealerNumber_NUM__c='222276';
        opp.CloseDate= system.today();
        opp.Street_TXT__c = '123 Hollywood Blvd';
        opp.ZipCode_TXT__c = '12345';
        
        insert opp;
        
        Matchback_New__c mB1 = new Matchback_New__c();
        mB1.Opportunity__c = opp.Id;
        mB1.RDR_Sales__c = rdrSales.Id;
        mB1.Matchback_Date__c = rdrSales.Sales_Date_DT__c;
        mB1.Matchback_Status__c = 'Matched to Dealer';
        
        insert mB1;
        
        Matchback_New__c mB2 = new Matchback_New__c();
        mB2.Opportunity__c = opp.Id;
        mB2.RDR_Sales__c = rdrSales.Id;
        mB2.Matchback_Date__c = rdrSales.Sales_Date_DT__c;
        mB2.Matchback_Status__c = 'Matched to other Dealer';
        
        insert mB2;
        
        Test.startTest();    
        HELMSMatchbackBatch matchbackBatch = new HELMSMatchbackBatch(); 
        Database.executeBatch(matchbackBatch);
        Test.stopTest();
    }
}