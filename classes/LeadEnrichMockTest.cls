@isTest
    public class LeadEnrichMockTest implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"response": {"leadId": "4623394418982912","consumer_detail": {"cid": 212368748,"contact_key": "E150363308"},"msg_code": "00", "msg_text": "SUCCESS"}}');
           
       response.setStatusCode(200);
        return response; 
    }
    }