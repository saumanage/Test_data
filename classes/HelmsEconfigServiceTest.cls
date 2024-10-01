@IsTest
public class HelmsEconfigServiceTest {
    
    public static testMethod void testPostCallout() {
        Set<Id> setId = new Set<ID>();
        Account ac1 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac1;
        //Lead lead1 = new Lead(LastName='Mohann',FirstName='Johnn',Is_Location_Enrichment_Done__c=false,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        insert lead1;
        lead1.ContactKey_TXT__c = 'H12345678';
        lead1.Is_ECRM_Update_Done__c = true; 
        setId.add(lead1.id);
        Test.setMock(HttpCalloutMock.class, new HelmsEconfigServiceMockTest());  
		Test.startTest();
        HelmsEconfigService.econfigAPI(setId);
        Test.stopTest();
    }
    
    
    /*
	public static testMethod void insertLeadForDealerLocator(){
        List<Account> alist = new List<Account>();
        Account ac1 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac1;
        Account ac2 = new Account(name ='Graz33itti' ,ShippingLatitude = 39.07805, ShippingLongitude=-76.94588,DealerCode_CD__c='206772',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac2;
        Account ac3 = new Account(name ='Graz33it' ,ShippingLatitude = 39.89801, ShippingLongitude=-74.93263,DealerCode_CD__c='206765',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac3;
        List<Lead> newvalues = new List<Lead>();    
        //Lead lead = new Lead(LastName='Mohan',FirstName='John',Latitude=33.840222,Longitude=-118.353171,SalesRelatedDealerNumber__c = '206772',ServiceRelatedDealerNumber__c = '206765',PreferredDealerAccount_ID__c=ac2.id,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '206772',ServiceRelatedDealerNumber__c = '206765',PreferredDealerAccount_ID__c=ac2.id,Email='MohanJohn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead2 = new Lead(LastName='Mohann',FirstName='Johnn',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '206765',ServiceRelatedDealerNumber__c = '206772',PreferredDealerAccount_ID__c=ac3.id,Email='MohanJohnn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead3 = new Lead(LastName='Mohann',FirstName='Johnn',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        newvalues.add(lead1);
        newvalues.add(lead2);
        newvalues.add(lead3);
        insert newvalues;
        //lead.ContactKey_TXT__c = 'H123456';
        lead1.ContactKey_TXT__c = 'E014607139';
        lead2.ContactKey_TXT__c = 'E014607138';
        lead3.ContactKey_TXT__c = 'H014607138';
        //lead.PreferredDealerNumber_NUM__c = '206772';
        //lead.SalesRelatedDealerNumber__c = '206772';
        //lead.ServiceRelatedDealerNumber__c = '206765';
        lead1.Is_ECRM_Update_Done__c = true;
        lead2.Is_ECRM_Update_Done__c = true;
        lead3.Is_ECRM_Update_Done__c = true;
        update lead1;
        update lead2;
        update lead3;
    }*/
}