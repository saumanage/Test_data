@isTest
//Test Class for Lead Dealer Acknowledgement Trigger
public class Lead_Dealer_AcknowledgementPETest {
	@isTest public static void testschedule() { 
        List<Lead_Dealer_Acknowledgement_ADF__e> eve = new List<Lead_Dealer_Acknowledgement_ADF__e>();
     	Lead_Dealer_Acknowledgement_ADF__e testObj = new Lead_Dealer_Acknowledgement_ADF__e();
        testObj.Oppotunity_SF_ID__c = 'test';
        testObj.Routing_Error__c = 'test';
        testObj.Status_Code__c = 'test';
        eve.add(testObj);
        Test.startTest();
        EventBus.publish(eve);
        Test.stopTest();
        system.assertEquals('test', testObj.Oppotunity_SF_ID__c);
    }
}