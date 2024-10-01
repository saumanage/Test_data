@isTest
public class HELMSLeadReportAutoNotificationTest {
        @isTest static void method1(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400',DealerCode_CD__c='123456',Lead_Source__c='Brand Site');
        acc.Name = 'Test Account';
            
        insert acc;
        system.assert(acc.Id != null, 'Failed to insert account');
           
        
        opportunity opp= new opportunity(Stagename='Dealer Visit',OpportunityStatus_TXT__c='Offer to Purchase',PreferredDealerAccount_TXT__c=acc.id,Name='Response time test class', 
        LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routable_FLG__c=true,Routing_Status__c ='Failure', 
        First_Name_TXT__c='Response time test', Last_Name_TXT__c='class',LeadSource='Brand Site');
        opp.CloseDate= system.Today();
        opp.CreatedDate= system.now().addhours(-1);
        opp.LastModifiedDate=system.now();
            
            
        insert opp;
        System.assertNotEquals(null, opp.Id);
            
        opportunity opp1= new opportunity(Stagename='Dealer Visit',OpportunityStatus_TXT__c='Offer to Purchase',PreferredDealerAccount_TXT__c=acc.id,Name='Response time test class', 
        LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routable_FLG__c=true,Routing_Status__c ='Success', 
        First_Name_TXT__c='Response time test', Last_Name_TXT__c='class',LeadSource='Brand Site');
        opp1.CloseDate= system.Today();
        opp1.CreatedDate= system.now().addhours(-1);
        opp1.LastModifiedDate=system.now();

        insert opp1;
        System.assertNotEquals(null, opp1.Id);
     
        opportunity opp2= new opportunity(Stagename='Dealer Visit',OpportunityStatus_TXT__c='Offer to Purchase',PreferredDealerAccount_TXT__c=acc.id,Name='Response time test class', 
        LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345',Routable_FLG__c=true,Routing_Status__c ='', 
        First_Name_TXT__c='Response time test', Last_Name_TXT__c='class',LeadSource='Brand Site');
        opp2.CloseDate= system.Today();
        opp2.CreatedDate= system.now().addhours(-1);
        opp2.LastModifiedDate=system.now();
        
        insert opp2;
        System.assertNotEquals(null, opp2.Id);
     
        Lead leadRec = new Lead(LastName='1 NOT GIVEN',Email='call.bijay1@gmail.com',Street= '4RUNNER', Status='Manual Validation1',isConverted=true,Convertedaccountid=acc.id,Division_CD__c='A',SubDiv_TXT__c ='Honda',Is_Enrichment_Update__c=true,PreferredDealerAccount_ID__c=acc.id,PreferredDealerNumber_NUM__c='123456'); 
        Lead leadRec1 = new Lead(LastName='1 main s',Email='call.bijay1@gmail.com',Street= '4RUNNER', Status='Manual Validation',ContactKey_TXT__c='abc',Division_CD__c='A',SubDiv_TXT__c ='Honda',Is_Enrichment_Update__c=true,PreferredDealerAccount_ID__c=acc.id,PreferredDealerNumber_NUM__c='123456');
        Lead leadRec2 = new Lead(LastName='2 main s',FirstName='1 main s',Email='call.bijay1@gmail.com',Street= '4RUNNER', Status='Manual Validation',Division_CD__c='A',SubDiv_TXT__c ='Honda',Is_Enrichment_Update__c=true,PreferredDealerAccount_ID__c=acc.id,PreferredDealerNumber_NUM__c='123456');
        Lead leadRec3 = new Lead(LastName='3 main s',FirstName='1',Email='call.bijay1@gmail.com',Street= '4RUNNER', Status='Manual Validation',Division_CD__c='A',SubDiv_TXT__c ='Honda',Is_Enrichment_Update__c=true,PreferredDealerAccount_ID__c=acc.id,PreferredDealerNumber_NUM__c='123456');
        leadRec1.createdDate= system.now().addhours(-1);
        leadRec2.createdDate= system.now().addhours(-1);
        leadRec3.createdDate= system.now().addhours(-1);
        // Assert that the leads were created successfully
        /*System.assertNotEquals(null, leadRec.Id);
        System.assertNotEquals(null, leadRec1.Id);
        System.assertNotEquals(null, leadRec2.Id);
        System.assertNotEquals(null, leadRec3.Id);*/
        
        Test.startTest();
        insert leadRec;
        insert leadRec1; 
        insert leadRec2;
        insert leadRec3;
        Test.stopTest();
        HELMSLeadReportAutoNotification cs= new HELMSLeadReportAutoNotification();
        cs.report();
            
    }
}