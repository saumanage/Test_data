@IsTest
public class HelmsDealerLocatorTest {
    
    public static testMethod void testPostCallout() {
        Set<Id> setId = new Set<ID>();
        
        /*Lead_Enrichment_Callout__mdt enrichnment = new Lead_Enrichment_Callout__mdt();
        enrichnment.poi_radius__c = 50;
        enrichnment.Division__c = 'A';
        insert enrichnment;*/
        
        //List<Lead> Leadlst= new List<Lead>();
        Account ac1 = new Account(name ='abc' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
          Account ac2 = new Account(name ='abc' ,DealerCode_CD__c= '10509', ShippingLatitude=39.850583,ShippingLongitude=-74.90814, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1;
        insert ac2;
        //Lead lead1 = new Lead(LastName='Mohann',FirstName='Johnn',Is_Location_Enrichment_Done__c=false,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY', PreferredDealerAccount_ID__c = ac2.id, SalesRelatedDealerNumber__c = '10509', ServiceRelatedDealerNumber__c = '10509');
        insert lead1;
         Lead lead2 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY', PreferredDealerAccount_ID__c = ac2.id, SalesRelatedDealerNumber__c = '10509', ServiceRelatedDealerNumber__c = '10509');
        insert lead2;
        lead1.ContactKey_TXT__c = 'H12345678';
        lead1.Is_ECRM_Update_Done__c = true;
        lead1.Dealer_Assignment_Type__c = 'Proximity';
         lead1.Dealer_Assignment_Type__c = 'Sales';
          lead2.ContactKey_TXT__c = 'H123456780';
        lead2.Is_ECRM_Update_Done__c = true;
         lead2.Dealer_Assignment_Type__c = 'Service';
        update lead1;
        update lead2;
        //Leadlst.add(lead1);
        setId.add(lead1.id);
          setId.add(lead2.id);
        Test.setMock(HttpCalloutMock.class, new HelmsDealerLocatorMockTest());  
		Test.startTest();
       // HelmsDealerLocatorService.dealerLocatorService(setId);
         HelmsDealerLocatorService.updateSalesOnly(setId);
       // HelmsDealerLocatorService.updateSalesToService(setId);
        HelmsDealerLocatorService.checkDistance(setId);
        boolean abc = HelmsDealerLocatorService.checkServiceDistance(5,39.850583, -74.90814, '10509');
        
         
        
        Test.stopTest();
    }
     public static testMethod void testPostCallout2() {
        Set<Id> setId = new Set<ID>();
        
        /*Lead_Enrichment_Callout__mdt enrichnment = new Lead_Enrichment_Callout__mdt();
        enrichnment.poi_radius__c = 50;
        enrichnment.Division__c = 'A';
        insert enrichnment;*/
        
        //List<Lead> Leadlst= new List<Lead>();
        Account ac1 = new Account(name ='abc' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
          Account ac2 = new Account(name ='abc' ,DealerCode_CD__c= '10509', ShippingLatitude=39.850583,ShippingLongitude=-74.90814, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac1;
        insert ac2;
        //Lead lead1 = new Lead(LastName='Mohann',FirstName='Johnn',Is_Location_Enrichment_Done__c=false,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY', PreferredDealerAccount_ID__c = ac2.id, SalesRelatedDealerNumber__c = '10509', ServiceRelatedDealerNumber__c = '10509');
        insert lead1;
         Lead lead2 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY',PreferredDealerNumber_NUM__c = '10509', PreferredDealerAccount_ID__c = ac2.id, SalesRelatedDealerNumber__c = '10509', ServiceRelatedDealerNumber__c = '10509');
        insert lead2;
        lead1.ContactKey_TXT__c = 'H12345678';
        lead1.Is_ECRM_Update_Done__c = true;
        lead1.Dealer_Assignment_Type__c = 'Proximity';
         lead1.Dealer_Assignment_Type__c = 'Sales';
          lead2.ContactKey_TXT__c = 'H123456780';
        lead2.Is_ECRM_Update_Done__c = true;
         lead2.Dealer_Assignment_Type__c = 'Service';
        update lead1;
        update lead2;
        //Leadlst.add(lead1);
        setId.add(lead1.id);
         setId.add(lead2.id);
        Test.setMock(HttpCalloutMock.class, new HelmsDealerLocatorMockTest());  
		Test.startTest();
       // HelmsDealerLocatorService.dealerLocatorService(setId);
        // HelmsDealerLocatorService.updateSalesOnly(setId);
        HelmsDealerLocatorService.updateSalesToService(setId);
        HelmsDealerLocatorService.checkDistance(setId);
        //boolean abc = HelmsDealerLocatorService.checkServiceDistance(5,39.850583, -74.90814, '10509');
        
         
        
        Test.stopTest();
    }
    
     public static testMethod void testPostCallout1() {
        Set<Id> setId = new Set<ID>();
        
        /*Lead_Enrichment_Callout__mdt enrichnment = new Lead_Enrichment_Callout__mdt();
        enrichnment.poi_radius__c = 50;
        enrichnment.Division__c = 'A';
        insert enrichnment;*/
        
        //List<Lead> Leadlst= new List<Lead>();
        Account ac1 = new Account(name ='abc' , recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        insert ac1;
         Account ac2 = new Account(name ='abc' ,DealerCode_CD__c= '10509', ShippingLatitude=39.850583,ShippingLongitude=-74.90814, recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        insert ac2;
        //Lead lead1 = new Lead(LastName='Mohann',FirstName='Johnn',Is_Location_Enrichment_Done__c=false,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id);
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,Email='MohanJohn@gmail.com',PostalCode='90503',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY', SalesRelatedDealerNumber__c = '10509', ServiceRelatedDealerNumber__c = '10509', PreferredDealerAccount_ID__c = ac2.id);
        insert lead1;
        lead1.ContactKey_TXT__c = 'H12345678';
        lead1.Is_ECRM_Update_Done__c = true;
        update lead1;
        //Leadlst.add(lead1);
        setId.add(lead1.id);
        Test.setMock(HttpCalloutMock.class, new HelmsDealerLocatorMockTest());  
		Test.startTest();
        HelmsDealerLocatorService.dealerLocatorService(setId);
        
        Test.stopTest();
    }
    
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
        Lead lead1 = new Lead(LastName='Mohan',FirstName='John',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '206772',ServiceRelatedDealerNumber__c = '206765',PreferredDealerAccount_ID__c=ac2.id,Email='MohanJohn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY');
        Lead lead2 = new Lead(LastName='Mohann',FirstName='Johnn',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '206765',ServiceRelatedDealerNumber__c = '206772',PreferredDealerAccount_ID__c=ac3.id,Email='MohanJohnn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY');
        Lead lead3 = new Lead(LastName='Mohann',FirstName='Johnn',Latitude=39.850583,Longitude=-74.90814,SalesRelatedDealerNumber__c = '',ServiceRelatedDealerNumber__c = '',Email='MohanJohnn@gmail.com',PostalCode='08053',Division_CD__c='A',SubDiv_TXT__c='Honda',LeadProvider_ID__c = ac1.id, State = 'NY');
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
        lead1.Dealer_Assignment_Type__c = 'Proximity';
        lead2.Dealer_Assignment_Type__c = 'Proximity';
        lead3.Dealer_Assignment_Type__c = 'Proximity';
        lead1.Dealer_Assignment_Type__c = 'Sales';
        lead2.Dealer_Assignment_Type__c = 'Sales';
        lead3.Dealer_Assignment_Type__c = 'Sales';
        update lead1;
        update lead2;
        update lead3;
    }
}