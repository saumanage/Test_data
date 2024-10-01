@isTest 
public class MatchbackTest 
{
    static testMethod void testMethod1() 
    {
 opportunity opp= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
          Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='John', Last_Name_TXT__c='kiran',Phone__c='1234567890',Serial_Number__c='1111',Number_NM__c='1212',
                                  Sale_Confirmation__c=false,Division_CD__c='P',SubDiv_TXT__c='PowerEquipment',PreferredDealerNumber_NUM__c='2222',ContactKey_TXT__c='H12344');
        opp.CreatedDate= system.now();
        opp.CloseDate= system.Today();
        
        insert opp;
RDR_Sales__c rdr = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',
                                    Email_id_TXT__c='call.bijay1@gmail.com'
                                   ,Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='2222',
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
        
        insert rdr;
        Test.startTest();

            Matchback obj = new Matchback();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
        static testMethod void testMethod2() 
    {
 opportunity opp1= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
          Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='John', Last_Name_TXT__c='kiran',Phone__c='1234567890',
                                  Sale_Confirmation__c=false,Serial_Number__c='1111',Number_NM__c='1212'
                                   ,Division_CD__c='P',
                                   SubDiv_TXT__c='PowerEquipment'
                                 ,PreferredDealerNumber_NUM__c='2222768671',ContactKey_TXT__c='H12344');
        opp1.CreatedDate= system.now();
        opp1.CloseDate= system.today();
        insert opp1;
        
        opportunity opp11= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
          Email__c='call.bijay2@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='thom', Last_Name_TXT__c='thom',Phone__c='1234567890',
                                  Sale_Confirmation__c=false,Serial_Number__c='1111',Number_NM__c='1212'
                                   ,Division_CD__c='P',
                                   SubDiv_TXT__c='PowerEquipment'
                                 ,PreferredDealerNumber_NUM__c='222',ContactKey_TXT__c='H12344');
        opp11.CreatedDate= system.now();
        opp11.CloseDate= system.today();
        insert opp11;
        
RDR_Sales__c rdr2 = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',Email_id_TXT__c='call.bijay1@gmail.com'
                                   ,Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='2222136363',
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
         insert rdr2;
        RDR_Sales__c rdr21 = new RDR_Sales__c(Customer_First_Name_NUM__c='Thom',Customer_Last_Name_NM__c='Thom',Email_id_TXT__c='call.Tom@gmail.com'
                                   ,Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='22245747214',
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
         insert rdr21;
        Test.startTest();

            Matchback obj = new Matchback();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
            static testMethod void testMethod3() 
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id dealerAccRecTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         Account accTestRec = new Account(Contact_Key__c='12345',Name='Test Account123another',DealerCode_CD__c = '123',RecordTypeId=dealerAccRecTypeId
                                         );
        insert accTestRec;
        Customer_Enrichment__c cu = new Customer_Enrichment__c(Contact_Key__c='12345',Customer_Account_Id__c=accTestRec.Id);
        insert cu;
 opportunity opp1= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
          Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='John', Last_Name_TXT__c='kiran',Phone__c='',
                                  Sale_Confirmation__c=false,Serial_Number__c='1111',Number_NM__c='1212'
                                   ,Division_CD__c='P',
                                   SubDiv_TXT__c='PowerEquipment'
                                 ,PreferredDealerNumber_NUM__c='222212',ContactKey_TXT__c='12345');
        opp1.CreatedDate= system.now();
        opp1.CloseDate= system.today();
        insert opp1;
        
        opportunity opp13= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
          Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='John1e', Last_Name_TXT__c='kirann',Phone__c='1234567890',
                                  Sale_Confirmation__c=false,Serial_Number__c='1111',Number_NM__c='1212'
                                   ,Division_CD__c='P',
                                   SubDiv_TXT__c='PowerEquipment'
                                 ,PreferredDealerNumber_NUM__c='22221',ContactKey_TXT__c='1234543');
        opp13.CreatedDate= system.now();
        opp13.CloseDate= system.Today();
        insert opp13;
        
RDR_Sales__c rdr2 = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',Email_id_TXT__c='call.bijay1@gmail.com'
                                   ,Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='22221',
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
         insert rdr2;
        RDR_Sales__c rdr5 = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',Email_id_TXT__c='call.bijay1@gmail.com'
                                   ,Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='22227',
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
         insert rdr5;
        
     /*  RDR_Sales__c rdr3 = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',Email_id_TXT__c='call.bijay1@gmail.com'
                                   ,Status_Code_CD__c='04',isProcessed__c=true,
                                    Dealer_Number_NUM__c='222213',isUnwind__c=true,
                                    Customer_Address_ZIP_Code_TXT__c='12345',Telephone_Number_NUM__c='1234567890'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);        
         insert rdr3;*/
        
        List<Id> rdrList = new List<Id> ();
        rdrList.add(rdr2.Id);
        Test.startTest();

        Matchback obj = new Matchback();
        DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    static testMethod void testMethod4() 
    {
         opportunity opp= new opportunity(Stagename='Assigned to Dealer',Name='SLA test class', 
           ZipCode_TXT__c='12345',Email__c='call.bijay1@gmail.com',
        First_Name_TXT__c='John', Last_Name_TXT__c='kiran',Sale_Confirmation__c=false,Division_CD__c='P',
        SubDiv_TXT__c='PowerEquipment',PreferredDealerNumber_NUM__c='2222',ContactKey_TXT__c='1234543');
                                  
                                  
        opp.CreatedDate= system.now();
        opp.CloseDate= system.Today();
        
        insert opp;
RDR_Sales__c rdr = new RDR_Sales__c(Customer_First_Name_NUM__c='John',Customer_Last_Name_NM__c='kiran',
                                    Status_Code_CD__c='03',isProcessed__c=false,
                                    Dealer_Number_NUM__c='2222',
                                    Email_id_TXT__c='call.bijay1@gmail.com',
                                    Customer_Address_ZIP_Code_TXT__c='12'
                                   ,XPROD_DIV_CD__c='P',Serial_Number_NUM__c='1111',Vin_TXT__c='1212',Sales_Date_DT__c=system.today()-1);  
        insert rdr;
        Test.startTest();

            Matchback obj = new Matchback();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
}