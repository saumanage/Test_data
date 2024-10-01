@isTest
public class HELMSDealerBroadcastMessagectrlTest 
{
   @isTest static void testHELMSDealerBroadcastMessagectrl()
   {
        List<HELMS_Dealer_Broadcast_Message__c> fetchMeta = new List<HELMS_Dealer_Broadcast_Message__c>();
        HELMS_Dealer_Broadcast_Message__c dMessage = new HELMS_Dealer_Broadcast_Message__c();
        dMessage.Name = 'Dealer BroadCase Message';
        dMessage.Message__c = 'ToDisplayDealerBroadCastMessage';
        dMessage.Start_Date__c = Date.newInstance(2022, 04, 26);
        dMessage.End_Date__c = Date.newInstance(2023, 04, 30);
        Test.startTest();
        insert dMessage;
        Test.stopTest();
        fetchMeta.add(dMessage);
        HELMSDealerBroadcastMessagectrl.fetchMetaListLwc();
        System.assertEquals(dMessage.Name, 'Dealer BroadCase Message');
    }     

    
}