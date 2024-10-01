@isTest
 public class HELMSDispositionRestResourceTest {
    // Implement this interface method
    static testMethod void test1Post() {
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/disposition_api/';
        req.httpMethod = 'POST';
        string jsons= '{"status": {"lead": [{"id": "DCF9E911-D415-48ED-A211-5A29374D630C","arrivaltime": "2021-11-03T04:47:00Z","autoresponse": "0","responsetime": "2021-12-05T22:21:11.083Z","lastevent": "4","currentstatus": "2"}]}}';
        req.requestBody = Blob.valueof(jsons);
        RestContext.request = req;
        RestContext.response= res;
        HELMSDispositionRestResource.disCreationLogic();
        
        Test.stopTest();   
        
       
    } 
    // Implement this interface method
    static testMethod void test2Post() {
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/disposition_api/';
        req.httpMethod = 'POST';
        string jsons= '{"status": {"lead": [{"id": "DCF9E911-D415-48ED-A211-5A29374D630C","arrivaltime": "test","autoresponse": "0","responsetime": "test","lastevent": "4","currentstatus": "2"}]}}';
        req.requestBody = Blob.valueof(jsons);
        RestContext.request = req;
        RestContext.response= res;
        HELMSDispositionRestResource.disCreationLogic();
        
        Test.stopTest();   
        
       
    } 
    
}