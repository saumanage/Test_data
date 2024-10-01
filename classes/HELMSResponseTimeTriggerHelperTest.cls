@isTest
public class HELMSResponseTimeTriggerHelperTest {
    @isTest static void wholeweek(){
        account acc=new account(Timezone__c='-7',MonOpenHour__c='0000',MonCloseHour__c='2400',TueOpenHour__c='0000',
        TueCloseHour__c='2400',WedOpenHour__c='0000',WedCloseHour__c='2400',ThuOpenHour__c='0000',ThuCloseHour__c='2400',
        FriOpenHour__c='0000',FriCloseHour__c='2400',SatOpenHour__c='0000',SatCloseHour__c='2400',SunOpenHour__c='0000',
        SunCloseHour__c='2400');
        acc.Name = 'Test Account';
        insert acc;
        opportunity opp= new opportunity(Stagename='Dealer Visit',OpportunityStatus_TXT__c='Offer to Purchase',PreferredDealerAccount_TXT__c=acc.id,Name='Response time test class', 
        LeadProvider_ID__c=acc.id, Email__c='call.bijay1@gmail.com', ZipCode_TXT__c='12345', 
        First_Name_TXT__c='Response time test', Last_Name_TXT__c='class');
        opp.CloseDate= system.Today();
        opp.CreatedDate= system.now() -20;
        opp.LastModifiedDate=system.now();
        insert opp;
        List<opportunity> lstopp =new list<opportunity>();
        lstopp.add(opp);
        HELMSResponseTimeTriggerHelper.calculateTime(lstopp);
        
    }
}