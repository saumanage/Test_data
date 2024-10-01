/****************************************************************************** 
File Name:      HELMSOptionsinsertHandlerTest  
Summary:        Test Class for HELMSOptionsinsertHandler
Created On:     21st May, 2021
Test Classes:   HELMSOpportunityHandlerTest
===============================================================================
Modification Log:  
May 21, 2021 Jim Kohs (Appirio) Initial Coding
********************************************************************************/
@isTest
public with sharing class HELMSOptionsinsertHandlerTest {

    @TestSetup
    static void setupMethod() {
        // Profile adm = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        // UserRole role1 = [SELECT Id FROM UserRole LIMIT 1];
        // User admin = new User (
        //     FirstName='admin',
        //     LastName='user',
        //     Alias = 'admin',
        //     Email = 'admin1@test.com',
        //     Username =  System.now().millisecond() + 'admin1@test.com',
        //     ProfileId = adm.Id,
        //     UserRoleId = role1.Id,
        //     TimeZoneSidKey = 'GMT',
        //     LanguageLocaleKey = 'en_US',
        //     EmailEncodingKey = 'UTF-8',
        //     LocaleSidKey = 'en_US'
        // );
        // insert admin;          

        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        lead l2 = new lead();
        l2.lastname = 'smith';
        l2.MiddlewareUUID__c ='1245'; 
        insert l2;
        
        Account ac= new Account();
        ac.name='test';
        insert ac;
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'Daffy111';
        o1.StageName = 'Acknowledged';
        o1.CloseDate = Date.today();
        o1.Options_TXT__c = makeXMLString();
        o1.LeadProvider_ID__c=ac.id;
        o1.Email__c='ym@gmail.com';
        o1.ZipCode_TXT__c='12346';
        o1.First_Name_TXT__c='smith';
        o1.Last_Name_TXT__c='Jhoesh';
        listOfOpportunities.add(o1);
        
        lead l = new lead();
        l.lastname = 'smith';
        l.MiddlewareUUID__c ='11111';
        l.Options_TXT__c = makeXMLString();
        l.Status = 'New';
        
        insert l;

        Opportunity o2 = new Opportunity();
        o2.Name = 'Daffy222';
        o2.StageName = 'Acknowledged';
        o2.CloseDate = Date.today();
        o2.Options_TXT__c = makeXMLString();
        o2.LeadProvider_ID__c=ac.id;
        o2.Email__c='gm@gmail.com';
        o2.ZipCode_TXT__c='12345';
        o2.First_Name_TXT__c='Andrew';
        o2.Last_Name_TXT__c='Jhon';
        listOfOpportunities.add(o2);

        insert listOfOpportunities;
    }

   /* @isTest
    static void test_createOptions() {
        Map<Id,Opportunity> mapOfOpportunities = new Map<Id, Opportunity>([SELECT Id, Options_TXT__c FROM Opportunity]);
        list<opportunity> ops = mapOfOpportunities.values();
        Boolean isInsert = true;
        Boolean isUpdate = false;
        HELMSOptionsinsertHandler.handleLeadInsert(ops);
    } */
    
    @isTest
    static void test_CreateOptions() {
        Map<Id,Lead> mapOfLead = new Map<Id, Lead>([SELECT Id, Options_TXT__c FROM Lead]);
        list<Lead> leads = mapOfLead.values();
        Boolean isInsert = true;
        Boolean isUpdate = false;
        HELMSOptionsinsertHandler.optionsLeadInserthandle(leads);
    }
   /*     @isTest
   static void test_createOptions1() {
        
        HELMSOptionsinsertHandler.handleLeadInsert(null);
    }  */

    private static String makeXMLString() {
        String xmlString = '';
        xmlString += '<option>';
        xmlString += '<optionname>Sport</optionname>';
        xmlString += '<stock>100</stock>';
        xmlString += '<weighting>65</weighting>';
        xmlString += '<price type="invoice" currency="USD" source="Kelley Blue Book">19500</price>';
        xmlString += '<price type="appraisal" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/>';
        xmlString += '<price type="msrp" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price>';
        xmlString += '<price type="quote" currency="USD" delta="absolute">19000</price>';
        xmlString += '<price type="offer" currency="USD" delta="relative" relativeto="invoice" source="KBB">200</price>';
        xmlString += '<price type="call" currency="USD" delta="percentage" relativeto="msrp">2</price>';
        xmlString += '<price type="asking" currency="USD" delta="percentage" relativeto="msrp">2</price>';
        xmlString += '<price type="" currency="USD" delta="percentage" relativeto="invoice" source="KBB"/>';
        xmlString += '</option>';
        

        return xmlString;
    }

}