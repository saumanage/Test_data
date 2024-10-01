/****************************************************************************** 
File Name:      HHELMSCRMEligible   
Created On:     26th May, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSCRMEligibleTest        
HELMS Jira Story: 
===============================================================================
Modification Log:  
*******************************************************************************
*/
@IsTest
//Creating Dealer Contact
public class HELMSCRMEligibleTest {
    @isTest static void testupdateUser() {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456'
                                        );
        insert accTestRec;
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                         AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
        insert conTestRec;
        
        conTestRec.HelmsCRMEligible_FLAG__c=true;
        update conTestRec;  
        System.assertEquals(conTestRec.HelmsCRMEligible_FLAG__c, true);
}
}