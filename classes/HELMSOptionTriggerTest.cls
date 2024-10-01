/****************************************************************************** 
File Name:      HELMSOptionTrigger  
Created On:     3rd June 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSOptionTriggerTest        
HELMS Jira Story: 
===============================================================================
Modification Log:  
********************************************************************************/

@isTest
public class HELMSOptionTriggerTest {
    
    static testMethod void TestMethodOne() 
    {
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        
        Lead objLead = new Lead( FirstName = 'Test', LastName = 'Sample', Company = 'Testing Sample Co',Make_TXT__c='vhn',Dealer_Ids_ID__c='testing');  
        insert objLead;
        Id dealerAccRecTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        
        Account accTestRec11 = new Account(Name='Test Account123another',RecordTypeId=dealerAccRecTypeId1,
                                           DealerCode_CD__c=objLead.Dealer_Ids_ID__c
                                          );
        insert accTestRec11;
        Opportunity Oppr = new Opportunity(Name='YashLead123',First_Name_TXT__c='Yash',Last_Name_TXT__c='Lead123',StageName='In Conversation',Email__c='test@gmail.com',ZipCode_TXT__c='12348',
                                           PreferredDealerAccount_TXT__c=accTestRec11.Id,amount = 50000.00,
                                           PreferredDealerNumber_NUM__c='123456', External_ID__c='12345',
        Total_MSRP_AMT__c =10,MSRP_AMT__c=10, CloseDate=system.today(),Make_TXT__c =objLead.Make_TXT__c);
        // Required fields are missing: [First_Name_TXT__c, Last_Name_TXT__c]: [First_Name_TXT__c, Last_Name_TXT__c]
        listOfOpportunities.add(Oppr);
        insert listOfOpportunities;
        list<Options__c> lstcon = new list<Options__c>();
        
        Options__c objcon1 = new Options__c();
        objcon1.Name = 'Test1';
        objcon1.PriceMSRP_AMT__c = 10;
        objcon1.Opportunity_ID__c = listOfOpportunities[0].id;
        lstcon.add(objcon1);
        
        Options__c objcon2 = new Options__c();
        objcon2.Name = 'Test2';
                objcon2.PriceMSRP_AMT__c = 10;

        objcon2.Opportunity_ID__c = listOfOpportunities[0].id;
        lstcon.add(objcon2);
        
        insert lstcon;
        
        Delete objcon1;
    }
}