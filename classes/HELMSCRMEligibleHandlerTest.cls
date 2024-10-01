/****************************************************************************** 
File Name:      HHELMSCRMEligibleHandler   
Created On:     27th May, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSCRMEligibleHandlerTest        
HELMS Jira Story: 
===============================================================================
Modification Log:7th June 2021 by Bandi Sujatha
*******************************************************************************
*/
@isTest
//Fetching Standard User Profile and Creating User
public class HELMSCRMEligibleHandlerTest {
    @isTest static void hELMSCRM1(){        
        Map<id,User> oldmap = new Map<id,User>();
        Map<id,User> newmap = new Map<id,User>();
        List<User> lstUser = new List<User>();
        Map<ID,Boolean> tabulUserMap=new Map<ID,Boolean>();
        Map<ID,Boolean> removetabulUserMap=new Map<ID,Boolean>();
        Profile p = [SELECT Id FROM Profile WHERE Name='HELMS Standard User']; 
        User u = new User(Alias = 'standt', Email='abc@123.com', Tableau_CRM_Permission_FLG__C=True,
                          EmailEncodingKey='UTF-8', LastName='Testing',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          ApplicationRole_NM__c='IT_Admin', 
                          UserName='standarduserHELMS@testhelmsorg.com');
        insert u;
        oldmap.put(u.id, u);
        Test.startTest();
        u.Phone = '987654321';
        u.Tableau_CRM_Permission_FLG__C =False;
        lstUser.add(u);
        update u;        
        newmap.put(u.id, u);
        SSO_Profile_Mapping__c s= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p.Id, Profile__c='HELMS Partner Community', 
                                                             UserRole__c='Dealer_Salesxx', username__c='@honda.ahmdevTest');
        insert s;
        Tableau_CRM_Plus__c t = New Tableau_CRM_Plus__c();
        t.Tableau_CRM_Plus_User__c = True;
        insert t;
        HELMSCRMEligibleHandler.TableauCRMUserPermissions(lstUser,True,True,newmap,oldmap,tabulUserMap,removetabulUserMap);
        Map<ID , String> conOppScoreMap = new Map<ID , String>();
        conOppScoreMap.put(u.id , label.HELMS_Opportunity_Score_Visibility+','+label.HELMS_Opportunity_Score_Visibility );
        
        HELMSCRMEligibleHandler.updateUserPermissions(conOppScoreMap);
        HELMSCRMEligibleHandler.RemovePermissionSetGroup(conOppScoreMap);
        System.assertEquals(u.Phone, '987654321');
        Test.stopTest();         
    }
//Assigning and Removing Tableau Permission Set
    @isTest static void HELMSCRM11(){
        
        Map<id,User> oldmap = new Map<id,User>();
        Map<id,User> newmap = new Map<id,User>();
        List<User> lstUser = new List<User>();
         Map<ID,Boolean> tabulUserMap=new Map<ID,Boolean>();
        Map<ID,Boolean> removetabulUserMap=new Map<ID,Boolean>();
        Tableau_CRM_Plus__c t = New Tableau_CRM_Plus__c();
        t.Tableau_CRM_Plus_User__c = True;
        insert t;
        Profile p = [SELECT Id FROM Profile WHERE Name='HELMS Standard User']; 
        User u = new User(Alias = 'standt', Email='abc@123.com', Tableau_CRM_Permission_FLG__C=False,
                          EmailEncodingKey='UTF-8', LastName='Testing',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          ApplicationRole_NM__c='IT_Admin', 
                          UserName='standarduserHELMS@testhelmsorg.com');
        insert u;
        oldmap.put(u.id, u);
        Test.startTest();
        u.Phone = '987654321';
        u.Tableau_CRM_Permission_FLG__C =True;
        lstUser.add(u);
        update u;        
        newmap.put(u.id, u);
        SSO_Profile_Mapping__c s= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p.Id, Profile__c='HELMS Partner Community', 
                                                             UserRole__c='Dealer_Salesxx', username__c='@honda.ahmdevTest');
        insert s;
        
        HELMSCRMEligibleHandler.TableauCRMUserPermissions(lstUser,True,True,newmap,oldmap,tabulUserMap,removetabulUserMap);
        System.assertEquals(u.Phone, '987654321');
        Test.stopTest();      
    }
    @isTest static void testupdateUser() {       
        Test.startTest();
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='HELMS Standard User']; 
        User u1 = new User(Alias = 'standt', Email='abc@123.com', UserRoleId = portalRole.Id,
                           EmailEncodingKey='UTF-8', LastName='Testing',
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles',
                           ApplicationRole_NM__c='IT_Admin', 
                           UserName='standarduserHELMS1@testhelmsorg.com');
        insert u1; 
        
        System.runAs(u1) {
            Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                             DealerCode_CD__c='123456'
                                            );
            insert accTestRec;
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false,ViewOpportunityScore_FLG__c=true);
            insert conTestRec;         
            
            conTestRec.HelmsCRMEligible_FLAG__c=true;
            conTestRec.ViewOpportunityScore_FLG__c=true;     
            update conTestRec;
            
            set<id> conids = new set<id>();
            conids.add(conTestRec.id);
            
            HELMSCRMEligibleHandler.updateUser(new Map<ID,Boolean>{Null =>true});
            
            HELMSCRMEligibleHandler.updateUser(new Map<ID,Boolean>{conTestRec.Id =>true});
            HELMSCRMEligibleHandler.updateUserPermissions(new Map<ID,String>{conTestRec.Id =>'true'});
            
          //  HELMSCRMEligibleHandler.AssignPermissionSetToUser(conids);
            HELMSCRMEligibleHandler.RemovePermissionSetGroup(new Map<ID,String>{conTestRec.Id =>'true'});
           // HELMSCRMEligibleHandler.RemovePermissionSet(conids);
           System.assertEquals(conTestRec.HelmsCRMEligible_FLAG__c, true);
            Test.stopTest();
        }   
    }
    @isTest static void testupdateUser1() {       
        Test.startTest();
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='HELMS Standard User']; 
        User u1 = new User(Alias = 'standt', Email='abc@123.com', UserRoleId = portalRole.Id,
                           EmailEncodingKey='UTF-8', LastName='Testing',
                           LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles',
                           ApplicationRole_NM__c='IT_Admin', 
                           UserName='standarduserHELMS1@testhelmsorg.com');
        insert u1; 
        
        System.runAs(u1) {
            Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                             DealerCode_CD__c='123456'
                                            );
            insert accTestRec;
            Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                             AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false, ViewOpportunityScore_FLG__c=true);
            insert conTestRec;         
            
            conTestRec.HelmsCRMEligible_FLAG__c=true;        
            update conTestRec;
            
            set<id> conids = new set<id>();
            conids.add(conTestRec.id);
            
            HELMSCRMEligibleHandler.updateUser(new Map<ID,Boolean>{Null =>true});
            
            HELMSCRMEligibleHandler.updateUser(new Map<ID,Boolean>{conTestRec.Id =>true});
            HELMSCRMEligibleHandler.updateUserPermissions(null);
            System.assertEquals(conTestRec.HelmsCRMEligible_FLAG__c, true);
            //HELMSCRMEligibleHandler.AssignPermissionSetToUser(null);
            //HELMSCRMEligibleHandler.RemovePermissionSetGroup(new Map<ID,String>{conTestRec.Id =>'true'});
            //HELMSCRMEligibleHandler.RemovePermissionSet(null);
            Test.stopTest();
        }   
    }
    
}