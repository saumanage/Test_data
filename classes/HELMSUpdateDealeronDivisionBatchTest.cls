@isTest
public class HELMSUpdateDealeronDivisionBatchTest 
{
    static testMethod void mapdivision() 
    {
        List<Account> lstAccount= new List<Account>();
        List<Dealer_Division__c> lstdvsn= new List<Dealer_Division__c>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
        
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            acc.recordtypeid = recordTypeId;
            acc.DealerCode_CD__c = '105200'+i;
            lstAccount.add(acc);
            
            Dealer_Division__c divsn= new Dealer_Division__c();
            divsn.SubDiv_TXT__c = 'Honda';
            divsn.DealerSubdivision_CD__c = '105200'+i+'Honda';
            lstdvsn.add(divsn);
        }
        
        insert lstAccount;
        insert lstdvsn;
        
        Test.startTest();

            HELMSUpdateDealeronDivisionBatch obj = new HELMSUpdateDealeronDivisionBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}