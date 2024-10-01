@isTest
public class HELMSZipRankingDealerAccUpdateTest {
        @isTest static void mytestmethod(){

                Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='South West Motors',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        
        List<string> zipRanklst = new List<string>();
        Zip_Ranking__c zRank = new Zip_Ranking__c();
            zRank.Dealer_Number__c = '123456';
            zRank.Postal_Code__c = '12345';
            zRank.Division__c = 'P';
            zRank.Ranking__c = 2;
            zRank.Launchbox_ID__c = zRank.Postal_Code__c + zRank.Division__c + zRank.Ranking__c;
            insert zRank;
            
            zipRanklst.add(zRank.id);
            system.assertEquals('123456', zRank.Dealer_Number__c);
        }
}