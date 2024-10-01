@IsTest
public class RecordIdEncryptionUtilTest {
    public static testMethod  void encryptRecordId() {
        List<Account> alist = new List<Account>();
        Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        alist.add(ac); 
        Account ac2 = new Account(name ='abc' ,  recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId()) ;
        alist.add(ac2); 
        insert alist; 
        Contact con = new Contact(LastName ='kncsl', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
        insert con; 
        List<Lead> newvalues = new List<Lead>();  
        Lead lead = new Lead(LastName='Doe1',FirstName='John',Company='Test',Status='Closed - Not Converted',StatusReason_TXT__c='Duplicate Merged',
                             Dealer_Ids_ID__c='testing',Year_YR__c='test',Model_TXT__c='demoooo',phone='7894563212',PostalCode='50081',
                             Model_ID__c='demo',Trim_TXT__c='trimmer',SubDiv_TXT__c='Acura', PreferredDealerAccount_ID__c=ac.id , ProviderDetail_TXT__c='abe:xyz:',LeadProvider_ID__c = ac2.id,
                             PreferredDealerNumber_NUM__c='301514',Division_CD__c='B',VehicleInterest_TXT__c='buy',Email='test@test.com',
                            ContactKey_TXT__c ='test',VehicleStatus_TXT__c='New',Condition_TXT__c='excellent',
                             Number_NM__c='number',Doors_TXT__c='doortxt',BodyStyle_TXT__c='bodyStyle',Odometer_TXT__c='odmeter',
                             Color_TXT__c='<colorcombination><interiorcolor>Gray</interiorcolor><exteriorcolor>Basque Red</exteriorcolor><preference>1</preference></colorcombination>',
                             OdometerStatus_TXT__c='unknown',OdometerUnits_TXT__c='kilometer');
        insert lead;
        RecordIdEncryptionUtil.encryptRecordId(lead.Id);
        RecordIdEncryptionUtil.generateRandomString(20);
       // RecordIdEncryptionUtil.encryptId();
        
    }
    
    
}