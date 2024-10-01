@istest
public class HELMSOpportunityECRMBatchTest {

    @istest static void testECRMBatchLoad(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HELMSAdditionalDataMock2());
        
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        
        Account Accnt = new Account(
          RecordTypeID=RecTypeId,
          FirstName='Test FName',
          LastName='Test LName',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678',
           	Contact_Key__c= 'E047819290'
        );
 
		insert Accnt;
        Account pAccnt = new Account(Name='hjadk');
        insert pAccnt;
        Opportunity o = new Opportunity();
        o.Name = 'Test Name';
        o.CloseDate = Date.newInstance(2022, 6, 15);
        o.First_Name_TXT__c = 'Test FName';
        o.Last_Name_TXT__c = 'Test LName';
        o.MobilePhone__c = '12345678';
        //o.Division_CD__c = 'A';
       	//o.SubDiv_TXT__c = 'Honda';
       	o.Make_TXT__c = 'Honda';
       	o.Model_TXT__c = 'Civic Type R';
       	o.Year_YR__c = '2020';
        o.StageName = 'Assigned to Dealer';
        o.Status__c = 'Assigned/Routed to Dealer';
        o.AccountId = Accnt.id;
        o.PreferredDealerAccount_TXT__c = pAccnt.id;
       	insert o;
        String query = 'Select id, Name, Account.Contact_Key__c, StageName, OpportunityStatus_TXT__c, ContactKey_TXT__c From Opportunity where Account.Contact_Key__c LIKE \'E%\' and StageName != \'Closed Inactive\' and StageName != \'Closed Lost\' and StageName != \'Closed Won\' ORDER BY CreatedDate desc LIMIT 1';
        HELMSOppECRMDataLoaderBatch ebc = new HELMSOppECRMDataLoaderBatch(query);
        Database.executeBatch(ebc);
        test.stopTest();
        
        lIST<Logs__c> error = [SELECT ID , 	Error_Message__c FROM Logs__c];
        if(!error.isEmpty()){
        //System.debug(error[0].Error_Message__c);
        }
    }
}