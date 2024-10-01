global with sharing class UploadFileMock implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/JSON');
        res.setBody('{"grant_type":"client_credentials", "client_id":"'+System.Label.Client_Id+'", "client_secret":"'+System.Label.Slient_Secret+'"},{"account_id":"'+System.Label.Accountid+'"}');
        res.setStatusCode(201);
        return res;
    }
}