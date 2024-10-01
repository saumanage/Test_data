@isTest class Test_LeadTriggerHandler { 
    @testSetup static void setup() {
        Filter_Words_MDT__c[] settings = new Filter_Words_MDT__c[]{};
        settings.add(new Filter_Words_MDT__c(Name = 'abc', Category_txt__c = 'Contains', Handling_txt__c = 'Reject', Check_Against__c = 'Name, Address, Email'));
        settings.add(new Filter_Words_MDT__c(Name = 'JOHN', Category_txt__c = 'Contains', Handling_txt__c = 'Reject', Check_Against__c = 'Name, Address, Email'));
        settings.add(new Filter_Words_MDT__c(Name = 'JOHN DOE', Category_txt__c = 'Contains', Handling_txt__c = 'Reject', Check_Against__c = 'Name, Address, Email'));

        insert settings;

        Id personAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account[] testAccounts = new Account[]{};
        testAccounts.add(new Account(FirstName = 'Test', LastName = 'Person', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()));
        testAccounts.add(new Account(Name ='Test Dealer', DealerCRMVendor_TXT__c = 'Test CRM', HondaDigitalSolutions_FLG__c = true, Enrichment__c = true, DealerCode_CD__c = '301545', ShippingLatitude = 39.850583, ShippingLongitude = -74.90814, RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()));
        testAccounts.add(new Account(Name='Test Provider', Lead_Source__c = 'Phone', RoutingDate_DT__c = Date.newInstance(2023, 6, 11), Routing_Date_Termination__c = System.now().addDays(1), Send_confirmation_interest_notification__c = true, Send_Invalid_Information_notification__c = true, Enrichment__c = true, RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId(), 
        DealerCode_CD__c = '123456',  Routable_FLG__c = true, SubDivision_TXT__c = 'Honda'));        
        
        insert testAccounts;

        List<Lead> leadList = new List<Lead>();
    
        leadList.add(new Lead(PreferredDealerAccount_ID__c=testAccounts[1].id,LeadProvider_ID__c=testAccounts[2].id,Is_Enrichment_Update__c=true,Email_Cache_Status__c=null,
                            ValidName_TXT__c=null,Address_Cache_Status__c=null,CustomerAccount_ID__c=testAccounts[0].Id,Triggertypecode__c='Instant',TriggerSendbyDate_DT__c=null,
                            Source_Unique_ID__c='1323123',LeadSource='Other',LastName='Windu',FirstName='Mace',Company='Test',StatusReason_TXT__c='Pending',Dealer_Ids_ID__c='301545',
                            Year_YR__c='test',Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Honda',Street= '4RUNNER',PreferredDealerNumber_NUM__c='301545',Division_CD__c='A',
                            VehicleInterest_TXT__c='buy',ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',Number_NM__c='number',Doors_TXT__c='doortxt',
                            BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                            OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer', Email='jack.b.nimble@aol.com',ValidEmail_FLG__c=true,ValidAddress_FLG__c=false,
                            ContactType_TXT__c='Home Phone',Status='New',ValidPhoneNum_FLG__c=true,ValidMobile_FLG__c=true,Deal_ID__c=null,Deal_Link__c=null,Lead_Coming_From_CRM__c=''));
        try {
             insert leadList;
             LeadTriggerHandler leadtrigger = new LeadTriggerHandler();
             leadtrigger.updateValidNameonLead(leadList);
         }catch(DMLException e) {
        }
    }
    @isTest static void testMethod1() {
        
        Lead ld = [SELECT LeadProvider_ID__r.Routing_Date_Termination__c, Id, Status, StatusReason_TXT__c, ValidEmail_FLG__c, ValidPhoneNum_FLG__c, ValidMobile_FLG__c, Email, Division_CD__c, Provider_Type__c, Is_Enrichment_Update__c, LeadProvider_ID__r.Send_confirmation_interest_notification__c, Model_TXT__c FROM Lead LIMIT 1];
        
        system.debug('Routing_Date_Termination__c ' + ld.LeadProvider_ID__r.Routing_Date_Termination__c);

        system.debug('Status ' + ld.Status);
        system.debug('Status Reason ' + ld.StatusReason_TXT__c);
        system.debug('Valid Email ' + ld.ValidEmail_FLG__c);
        system.debug('Valid Phone ' + ld.ValidPhoneNum_FLG__c);
        system.debug('Valid Mobile ' + ld.ValidMobile_FLG__c);

         /**
        system.assert(ld.Status == 'New', '1');
        system.assert(ld.ValidEmail_FLG__c == true, '2');
        system.assert(ld.Email != null, '3');
        system.assert(ld.Division_CD__c != null, '4');
        system.assert(ld.LeadProvider_ID__r.Send_confirmation_interest_notification__c == true, '5');
        system.assert(ld.Model_TXT__c == null, '6');
        */
    }

}