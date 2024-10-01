@isTest
public class HELMSCityRankingDealerAccUpdateTest {
    
    @isTest static void mytestmethod(){

                Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='South West Motors',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        
        List<string> cityRanklst = new List<string>();
        City_State_Ranking__c cRank = new City_State_Ranking__c();
        cRank.City__c = 'NewYork';
        cRank.Dealer_Number__c = '123456';
        cRank.Division__c = 'P';
        cRank.Launchbox_ID__c = cRank.City__c + cRank.State__c + cRank.Division__c + cRank.Ranking__c;
        cRank.Ranking__c = 2;
        cRank.State__c = 'AB';
        insert cRank;
        
        cityRanklst.add(cRank.id);
        system.assertEquals('NewYork',cRank.City__c);
    }
}