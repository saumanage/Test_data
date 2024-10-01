@IsTest
public class HELMSLeadDynamicAttributesCntrlTest {
    @isTest private static void ldtestmethod()
    {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        
       	Set<id> oppList= new Set<id>();
        List<Lead> leadList=new List<Lead>();
        
         Lead leadRec = new Lead(LastName='1 NOT GIVEN',Email='sur12@testing.com',Street= '4RUNNER',
                                 Status='Manual Validation',Model_TXT__c = 'xyz',PreferredDealerAccount_ID__c=accTestRec.id,
                                 LeadAdditionalInfos__c= '<LeadAdditionalInfos><LeadAdditionalInfo key="CustomerComment">Click for Lead Info</LeadAdditionalInfo></LeadAdditionalInfos>'); 
		                  
         insert leadRec;
                
        leadList.add(leadRec);
                 
         List<Lead_Additional_Attribute__c> ldAdtnlAtrbt = new List<Lead_Additional_Attribute__c>();
		 Lead_Additional_Attribute__c laddatt = new Lead_Additional_Attribute__c();
         laddatt.Attribute_Value__c = 'Red';
         laddatt.Name = 'CustomerComment';   
         laddatt.Sequence_Number__c = 1;
         insert laddatt;
            
         ldAdtnlAtrbt.add(laddatt);
       
        List<Lead_Additional_Attribute_Definition__c> ldaddattdf = new List<Lead_Additional_Attribute_Definition__c>();
		Lead_Additional_Attribute_Definition__c ldadd = new Lead_Additional_Attribute_Definition__c();
		ldadd.Name = 'CustomerComment';
		ldadd.Shared_With_Dealer__c = 'True';
		insert ldadd;
		ldaddattdf.add(ldadd);
        
        Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
        
        insert o;

        oppList.add(o.id); 
        
        Test.startTest();
        system.assertEquals('OppTest', o.First_Name_TXT__c);
        HELMSLeadDynamicAttributesCntrl.createDynamicFields(leadList);
        HELMSLeadDynamicAttributesCntrl.createOpportunityAttributes(oppList);
        Test.stopTest();
        
    }
}