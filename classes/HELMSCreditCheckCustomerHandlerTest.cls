@isTest
public class HELMSCreditCheckCustomerHandlerTest {
    
   @isTest static void myMethod(){
        
        lead mylead = new lead();
        mylead.FirstName='test1';
         mylead.LastName='test1';
         mylead.street='test1';
         mylead.City='test1'; 
        mylead.State='test1';
         mylead.postalCode='01234';
         mylead.Phone='test1';
        mylead.Email='ghouse@gmail.com';
        mylead.MiddlewareUUID__c ='3b03fa65-dad2-4de4-ab9a-3e4ecadecfaa';
        insert mylead;
        
        RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/CreditApps/'+mylead.MiddlewareUUID__c; //Request URL
    req.httpMethod = 'GET';

    RestContext.request = req;
    RestContext.response= res;

    Test.startTest();
        HELMSCreditCheckCustomerHandler.GetCustDetails();
    Test.stopTest();
    }
   @isTest static void myMethod2(){
        
        lead mylead = new lead();
        
         mylead.LastName='test1';
         mylead.street='test1';
         mylead.City='test1'; 
        mylead.State='test1';
         mylead.postalCode='12345';
         mylead.Phone='test1';
        mylead.Email='ghouse@gmail.com';
        mylead.MiddlewareUUID__c ='3b03fa65-dad2-4de4-ab9a-3e4ecadecfaa';
        insert mylead;
        
        RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/CreditApps/'+mylead.MiddlewareUUID__c; //Request URL
    req.httpMethod = 'GET';

    RestContext.request = req;
    RestContext.response= res;

    Test.startTest();
        HELMSCreditCheckCustomerHandler.GetCustDetails();
    Test.stopTest();
    }
    @isTest static void myMethod3(){
        
        lead mylead = new lead();
        mylead.FirstName='test1';
        mylead.LastName='test1';
         //mylead.street='test1';
        // mylead.City='test1'; 
        //mylead.State='test1';
       // mylead.Email='ghouse@gmail.com';
         //mylead.postalCode='78945';
        // mylead.Phone='test1';
        mylead.Email='ghouse@gmail.com';
        mylead.MiddlewareUUID__c ='3b03fa65-dad2-4de4-ab9a-3e4ecadecfaa';
        insert mylead;
        
        RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/CreditApps/'+mylead.MiddlewareUUID__c; //Request URL
    req.httpMethod = 'GET';

    RestContext.request = req;
    RestContext.response= res;

    Test.startTest();
        HELMSCreditCheckCustomerHandler.GetCustDetails();
    Test.stopTest();
    }
    @isTest static void myMethod4(){
      
        
        RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/CreditApps/22344'; //Request URL
    req.httpMethod = 'GET';

    RestContext.request = req;
    RestContext.response= res;

    Test.startTest();
        HELMSCreditCheckCustomerHandler.GetCustDetails();
    Test.stopTest();
    }

}