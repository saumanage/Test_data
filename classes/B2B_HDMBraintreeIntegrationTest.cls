/**************************************************************************************
@File Name      : B2B_HDMBraintreeIntegrationTest  
@Description    : This class used to create test class for B2B_HDMBraintreeIntegration
@Created By		: Imtiyaz
@Created Date   : 17/01/2024
@API Version    : 54.0
*****************************************************************************************
MODIFICATIONS – Date      | Dev Name         | Method                    | User Story 
17/01/2024                |Imtiyaz Ali       |                           |          
17/01/2024                |Rajrishi Kaushik  |                           |  
*****************************************************************************************/
@isTest
public class B2B_HDMBraintreeIntegrationTest {
    
	@isTest
    public static void unitTest(){
        Test.StartTest();
        B2B_BrainTreeIntegrationMock objMock = new B2B_BrainTreeIntegrationMock();
        objMock.isDeviceCode = true;
        Test.setMock(HTTPCalloutMock.class, objMock); 
       	B2B_HDM_API_Config__mdt hdmConfig = [SELECT Id, Client_Id__c, Client_Secret__c, Username__c, Password__c FROM B2B_HDM_API_Config__mdt LIMIT 1];
        B2B_HDMBraintreeIntegration.getDeviceCode();
        Test.StopTest();
    }
    
    @isTest
    public static void unitTest1(){
        Test.StartTest();
        B2B_BrainTreeIntegrationMock objMock = new B2B_BrainTreeIntegrationMock();
        objMock.isGetDealerAccessToken = true;
        Test.setMock(HTTPCalloutMock.class, objMock); 
        B2B_HDMBraintreeIntegration.getDealerAccessToken('dnsiossnsc', 'ujssnsni');
        B2B_HDMBraintreeIntegration.braintreeTransactionRefund('ahdbdbd', 'ynynj', '3484688', 'accessstocken', '200');
        B2B_HDMBraintreeIntegration.braintreeTransactionSearch('fghjmnb', 'bssdsdhs');
        Test.StopTest();
    }
    
    @isTest
    public static void unitTest2(){
        Test.StartTest();
        B2B_BrainTreeIntegrationMock objMock = new B2B_BrainTreeIntegrationMock();
        objMock.isBTRefund = true;
        Test.setMock(HTTPCalloutMock.class, objMock); 
        B2B_HDMBraintreeIntegration.braintreeTransactionRefund('ahdbdbd', 'ynynj', '3484688', 'accessstocken', '200');
        B2B_HDMBraintreeIntegration.braintreeTransactionSearch('fghjmnb', 'bssdsdhs');
        Test.StopTest();
    }
    
    public class B2B_BrainTreeIntegrationMock implements HTTPCalloutMock {
        public Boolean isDeviceCode;
        public Boolean isGetDealerAccessToken;
        public Boolean isBTRefund;
        
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String body = '';
            if(isDeviceCode == true) {
                body = '{"access_token":"00D8C0000004eWI!AR8AQHUbvO_rfdvu_ROQiuk9.yjCP1vdGI.LohZ2d3GWyCYYi2Jo2.gOdDmD5ggPwOIfd3mfrJlo3290i2ZociP2MGVxxMxY","instance_url":"https://americanhondamotors--pat.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D8C0000004eWIUAY/0058C000001D0bwQAC","token_type":"Bearer","issued_at":"1705480344089","signature":"GRE4pfgttpHzUHxqNkW2x18wTnMBiWaTLbMqMJuizeg="}';
            }else if(isGetDealerAccessToken == true){
                body ='{"merchantId":"2ny4v6c7xpp2fkfm","isSuccess":true,"errorMessage":null,"dealerNumber":"207617","accessToken":"access_token$sandbox$2ny4v6c7xpp2fkfm$9d6d0752c3abbf34db60721ff6c032c2"}';
            }else if(isBTRefund == true){
                body ='{"status": 200,"merchantId": "x6q6b83wjsn28t2m","credentials": {"accessToken": "access_token$sandbox$x6q6b83wjsn28t2m$d648f8a9d4523e920c631bfa31065647","refreshToken": "refresh_token$sandbox$x6q6b83wjsn28t2m$ade578dc1f20a130160a82ddf4ef9eec","tokenType": "bearer","expiresAt": "2021-07-06T09:13:40Z","scope": "read_write,shared_vault_transactions"}}';
            }
            
            response.setBody(body); 
            response.setStatusCode(200);
            return response;
        }
    }
}