global class HELMSHttpCalloutMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        
     
        
        datetime ndate= system.now();

string st = ndate.date()+'T13:32:21.000+0000';
st = st.replace(' 00:00:00','');

        String  respBody = '{"done":true,"nextRecordsUrl":null,"records":[{"id":"7504x00000GMOwHAAX","operation":"upsert","object":"Dealer_Division__c","createdById":"0054x000004lOmuAAE","createdDate":"'+st+'","systemModstamp":"'+st+'","state":"Open","externalIdFieldName":"DealerSubdivision_CD__c","concurrencyMode":"Parallel","contentType":"CSV","apiVersion":51.0,"jobType":"V2Ingest","contentUrl":"services/data/v51.0/jobs/ingest/7504x00000GMOwHAAX/batches","lineEnding":"CRLF","columnDelimiter":"PIPE"}]}';
             

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(respBody);
            res.setStatusCode(200);
            return res;
    }
    
    
}