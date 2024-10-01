/**********************************************************************
Name: B2B_HDMBraintreeIntegration
Purpose: Apex class is created for calling Braintree APIs
Created Date :  10/01/2024
Created By : Rajrishi Kaushik
*************************************************************/
public class B2B_HDMBraintreeIntegration {
    
    /*
    Created By :Rajrishi Kaushik
    Date : 10/01/2024
    Description : This method is used for getting the SF Device token to call getDealerAccessToken API.
    */
    public static DeviceCodeWrapper getDeviceCode(){
        DeviceCodeWrapper objWrapper = new DeviceCodeWrapper();
        try {           
            B2B_HDM_API_Config__mdt hdmConfig = [SELECT Id, Client_Id__c, Client_Secret__c, Username__c, Password__c FROM B2B_HDM_API_Config__mdt LIMIT 1];      
            String reqBody = 'client_id='+EncodingUtil.urlEncode(hdmConfig.Client_Id__c,'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(hdmConfig.Client_Secret__c,'UTF-8')+ '&grant_type=password&username='+ hdmConfig.Username__c + '&password='+hdmConfig.Password__c;
            
            HttpRequest request = B2B_IntegrationCallout.createHDMRequest('getDeviceCode',reqBody);
            Http http = new Http();
            HTTPResponse response = http.send(request);
            String responseBody = response.getBody();
            System.debug('responseBody :- '+ responseBody);
            
            objWrapper.status = response.getStatusCode();
            objWrapper.requestBody = reqBody;
            objWrapper.responseBody = responseBody;       
            if(response.getStatusCode() == 200){
                Map<String, Object> mapDeviceDetails = (Map<String, Object>) JSON.deserializeUntyped(responseBody); 
                objWrapper.deviceToken = String.valueOf(mapDeviceDetails.get('access_token'));
            }  
        }catch(Exception ex){
            System.debug('Exception : '+ ex.getMessage());
        }                
        return objWrapper;
    }
    
    /*
    Created By :Rajrishi Kaushik
    Date : 10/01/2024
    Description : This method is used for getting the Braintree Access Token for Dealer from SF API.
    */
    public static B2B_HDMBraintreeIntegration.ResponseWrapper getDealerAccessToken(String dealerNumber, string deviceCode){
        try {
            String reqBody = '{"dealerNumber": "'  + dealerNumber + '", "isFromHelms": "True"}';
            HttpRequest request = B2B_IntegrationCallout.createHDMRequest('getDealerAccessToken', reqBody);
            request.setHeader('Authorization', 'Bearer ' + deviceCode);
            request.setHeader('X-Honda-wl-authorization', Label.B2B_HDM_Authorization);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            String responseBody = response.getBody();
            System.debug('responseBody :- '+ responseBody);
            if(responseBody.contains('errorCode')){
                responseBody = responseBody.remove('[');
                responseBody = responseBody.remove(']');              
            }
            B2B_HDMBraintreeIntegration.ResponseWrapper dealerResponse = (ResponseWrapper) System.JSON.deserialize(responseBody, B2B_HDMBraintreeIntegration.ResponseWrapper.class);
            dealerResponse.status = response.getStatusCode();
            dealerResponse.requestBody = reqBody;
            dealerResponse.responseBody = responseBody;           
            return dealerResponse;
            
        }catch(Exception ex){
            System.debug('Exception : '+ ex.getMessage());
            System.debug('Exception stack '+ ex.getStackTraceString());
        }          
        return null;
    }
    
    // added by rajrishi - HDMP-28423 - token issue - Start
    public static B2B_HDMBraintreeIntegration.ResponseWrapper updateBTToken(String deviceCode, B2B_AccessTokenResponseWrapper accessTokenResponse){
        try {
            HttpRequest request = new HttpRequest(); 
            request.setMethod('PATCH');
            
            //set headers
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');       
            request.setHeader('Authorization', 'Bearer ' + deviceCode);
            
            //set endpoint
            request.setEndpoint('callout:B2B_HDM_Token_Credential');
            
            //set request body
            RequestWrapper objRequest = new RequestWrapper();
            objRequest.tokenResponse = accessTokenResponse;
            request.setBody(JSON.serialize(objRequest));
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            String responseBody = response.getBody();
            System.debug('responseBody :- '+ responseBody);

            if(responseBody.contains('errorCode')){
                responseBody = responseBody.remove('[');
                responseBody = responseBody.remove(']');              
            }
            B2B_HDMBraintreeIntegration.ResponseWrapper tokenResponse = (ResponseWrapper) System.JSON.deserialize(responseBody, B2B_HDMBraintreeIntegration.ResponseWrapper.class);
            tokenResponse.status = response.getStatusCode();
            tokenResponse.requestBody = JSON.serialize(objRequest);
            tokenResponse.responseBody = responseBody;           
            return tokenResponse;
        }catch(Exception ex){
            System.debug('Exception : '+ ex.getMessage());
            System.debug('Exception stack '+ ex.getStackTraceString());
        }          
        return null;        
    }

     /*
    Created By : Rajrishi Kaushik
    Date : 03/05/2024
    Description : This method is used to get the access token and refresh token by passing a merchantId and refreshToken.
    */
    public static B2B_AccessTokenResponseWrapper getRefreshToken(String merchantID,String refreshToken){
        B2B_AccessTokenResponseWrapper objAccessTokenResponseWrapper = New B2B_AccessTokenResponseWrapper();
        try{
            HttpRequest request = B2B_IntegrationCallout.createBraintreeRequest('GET','','');
            String endpoint = 'callout:Braintree_Named_Credential' + '/refreshed-tokens/merchantID/'+merchantID+'/refresh-token/'+refreshToken;
            request.setEndpoint(endpoint);
            String guId = B2B_Util.createGui();
            request.setHeader('hondaHeaderType.messageId', guId);
            request.setHeader('accept', 'application/json');
            Http http = new Http();
            HTTPResponse response = http.send(request);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){
                objAccessTokenResponseWrapper = (B2B_AccessTokenResponseWrapper) System.JSON.deserialize(response.getBody(), B2B_AccessTokenResponseWrapper.class);  
                if(response.getStatusCode() != 200){
                    objAccessTokenResponseWrapper.requestBody = request.getbody();
                    objAccessTokenResponseWrapper.responseBody = response.getbody(); 
                }            
            }else {
                objAccessTokenResponseWrapper.status = response.getStatusCode();
                objAccessTokenResponseWrapper.errorMessage = response.getStatus();
                objAccessTokenResponseWrapper.requestBody = request.getbody();
                objAccessTokenResponseWrapper.responseBody = response.getbody();
            }  
        }catch(Exception ex){
            System.debug('exception' + ex.getMessage());
            objAccessTokenResponseWrapper.errorMessage = ex.getMessage();
            objAccessTokenResponseWrapper.status = 400;
        }
        return objAccessTokenResponseWrapper;
    }

    //added by rajrishi - HDMP-28423 - token issue - Ends
    
    /*
    Created By : RajRishi Kaushik
    Date : 10/01/2024
    Description : This method is used for making a callout at braintree server for refunding of the transaction.
	*/
    public static B2B_BrainTreeTransactionResponse braintreeTransactionRefund(String customerID, String merchantID, String transactionID, String accessToken,String refundAmount){
        B2B_BrainTreeTransactionResponse objBrainTreeTransactionResponse = new B2B_BrainTreeTransactionResponse();
        try{
            String reqBody = '{"customerID": "'+customerID+'", "merchantID": "'+merchantID+'", "transactionID": "'+transactionID+'", "refundAmount": '+refundAmount+', "accessToken": "'+accessToken+'"}';            
            
            HttpRequest request = B2B_IntegrationCallout.createBraintreeRequest('POST',reqBody,'refund');
            Http http = new Http();
            HTTPResponse response = http.send(request);
            objBrainTreeTransactionResponse.requestBody = request.getBody();
            objBrainTreeTransactionResponse.responseBody = response.getBody();
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){ 
                String responseBody = response.getBody();
                Map<String,Object> mapVoidResponse = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                Integer status = Integer.valueOf(mapVoidResponse.get('status'));
                if(status == 200){
                    Map<String,Object> mapTransaction = (Map<String,Object>) mapVoidResponse.get('transaction');
                    objBrainTreeTransactionResponse = B2B_BrainTreeTransactionResponse.parseTransactionData(objBrainTreeTransactionResponse, responseBody, mapTransaction);                                                  
                }else{
                    objBrainTreeTransactionResponse.errorMessage = JSON.serialize(mapVoidResponse.get('errorMessage'));
                    objBrainTreeTransactionResponse.status = status;
                }   
            }else {
                objBrainTreeTransactionResponse.status = response.getStatusCode();
                objBrainTreeTransactionResponse.errorMessage = response.getStatus();               
            }   
        }catch(Exception ex){
            objBrainTreeTransactionResponse.errorMessage = ex.getMessage();
            objBrainTreeTransactionResponse.status = 400;           
        }
        return objBrainTreeTransactionResponse;   
    } 
    
    /*
    Created By :Rajrishi Kaushik
    Date : 10/01/2024
    Description : This method is used for getting the transaction current status from braintree.
    */
    public static B2B_BrainTreeTransactionResponse braintreeTransactionSearch(String transactionID, String accessToken){
        B2B_BrainTreeTransactionResponse objBrainTreeTransactionResponse = new B2B_BrainTreeTransactionResponse();
        try{
            String reqBody = '{"transactionID": "'+transactionID+'", "accessToken": "'+accessToken+'"}';
            HttpRequest request = B2B_IntegrationCallout.createBraintreeRequest('POST',reqBody,'search');
            Http http = new Http();
            HTTPResponse response = http.send(request);
            objBrainTreeTransactionResponse.requestBody = request.getBody();
            objBrainTreeTransactionResponse.responseBody = response.getBody();
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){    
                String responseBody = response.getBody();
                Map<String,Object> mapVoidResponse = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                Integer status = Integer.valueOf(mapVoidResponse.get('status'));
                if(status == 200){
                    Map<String,Object> mapTransaction = (Map<String,Object>) mapVoidResponse.get('transaction');
                    objBrainTreeTransactionResponse = B2B_BrainTreeTransactionResponse.parseTransactionData(objBrainTreeTransactionResponse, responseBody, mapTransaction);                                                  
                }else{
                    objBrainTreeTransactionResponse.errorMessage = JSON.serialize(mapVoidResponse.get('errorMessage'));
                    objBrainTreeTransactionResponse.status = status;
                } 
            }else {
                objBrainTreeTransactionResponse.status = response.getStatusCode();
                objBrainTreeTransactionResponse.errorMessage = response.getStatus();               
            } 
        }catch(Exception ex){
            objBrainTreeTransactionResponse.errorMessage = ex.getMessage();
            objBrainTreeTransactionResponse.status = 400;           
        }
        return objBrainTreeTransactionResponse;     
    }  

    /*
    Created By : Suresh Bandi
    Date : 19-09-2024
    Description : This method is used for making a callout at braintree server for cancelling the order.
    */   
    public static String braintreeTransactionVoid(String customerID, String merchantID, String transactionID, String accessToken){
        B2B_BrainTreeTransactionResponse objBrainTreeTransactionResponse = new B2B_BrainTreeTransactionResponse();
        Order__x objOrder = [SELECT id, AccountId__c , ExternalId FROM Order__x where BT_Transaction_Id_c__c =:transactionID];
        Long beforeAPI = B2B_Util.fetchCurrentTime();
        try{            
            String reqBody = '{"customerID": "'+customerID+'", "merchantID": "'+merchantID+'", "transactionID": "'+'iuytfb'+'", "accessToken": "'+accessToken+'"}';
            HttpRequest request = B2B_IntegrationCallout.createBraintreeRequest('POST',reqBody,'void');
            Http http = new Http();
            HTTPResponse response = http.send(request);
            objBrainTreeTransactionResponse.requestBody = request.getBody();
            objBrainTreeTransactionResponse.responseBody = response.getBody();
            if(response.getStatusCode() == 200){
                String responseBody = response.getBody();
                Map<String,Object> mapVoidResponse = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                Integer status = Integer.valueOf(mapVoidResponse.get('status'));
                if(status == 200){
                    Map<String,Object> mapTransaction = (Map<String,Object>) mapVoidResponse.get('transaction');
                    objBrainTreeTransactionResponse = B2B_BrainTreeTransactionResponse.parseTransactionData(objBrainTreeTransactionResponse, responseBody, mapTransaction);                                                  
                }else{
                    objBrainTreeTransactionResponse.errorMessage = JSON.serialize(mapVoidResponse.get('errorMessage'));
                    objBrainTreeTransactionResponse.status = status;
                }  
            }else {
                objBrainTreeTransactionResponse.status = 400;
                objBrainTreeTransactionResponse.errorMessage = response.getStatus(); 
                Long afterAPI = B2B_Util.fetchCurrentTime();
                Long durationTime = B2B_Util.calInMilliSeconds(beforeAPI,afterAPI);
                String errorMsg = 'Order Modification Error due to Braintree API: Error : Issue with Payment Void Transaction';
                 B2B_Util.createErrorRecord('BrainTree API Error','',objOrder.AccountId__c,'','','B2B_HDMBraintreeIntegration',errorMsg,Label.B2B_Error_Type,'','braintreeTransactionVoid',true,objOrder.ExternalId,'','',durationTime,Label.B2B_Severity,'Request:'+request.getBody(),'Response:'+response.getBody());              
            } 
        }catch(Exception ex){
            objBrainTreeTransactionResponse.errorMessage = ex.getMessage();
            objBrainTreeTransactionResponse.status = 400;           
        }
        return JSON.serialize(objBrainTreeTransactionResponse);
    }   


     /*
    Created By : Suresh Bandi
    Date : 19-09-2024
    Description : This method is used for creating bt transaction records.
    */ 
    public static void createBTTransaction(B2B_BrainTreeTransactionResponse objBrainTreeTransactionResponse,Order__x objOrder){
        //query old Bt transaction for reference
        BT_Transaction_Details_c__x btDetail = [SELECT Id, ExternalId,Type_c__c, Customer_c__c,BT_TransactionId_c__c, Cardholder_Name_c__c FROM BT_Transaction_Details_c__x 
                                                                                                            WHERE Order_c__c =: objOrder.ExternalId Order by CreatedDate__c DESC LIMIT 1];
        
        //creating the new transaction for refund for can event    
        BT_Transaction_Details_c__x objBTTransactionDetails = new BT_Transaction_Details_c__x();   
        objBTTransactionDetails.Name__c ='Void Transaction';
        objBTTransactionDetails.BT_TransactionId_c__c = btDetail.BT_TransactionId_c__c;                               
        objBTTransactionDetails.Type_c__c = btDetail.Type_c__c;  
        objBTTransactionDetails.Transaction_Status_c__c = 'Failed';
        objBTTransactionDetails.Order_c__c = objOrder.ExternalId;
        objBTTransactionDetails.Billing_Street_c__c = objOrder.BillingStreet__c;
        objBTTransactionDetails.Billing_City_c__c = objOrder.BillingCity__c;
        objBTTransactionDetails.Billing_State_c__c = objOrder.BillingState__c;
        objBTTransactionDetails.Billing_PostalCode_c__c = objOrder.BillingPostalCode__c;
        objBTTransactionDetails.Credit_Card_Number_c__c = objOrder.CC_Last4_c__c;
        objBTTransactionDetails.Payment_Gateway_c__c = objOrder.Payment_Gateway_c__c;
        objBTTransactionDetails.Payment_Method_Type_c__c = objOrder.Payment_Type_c__c;
        objBTTransactionDetails.Payment_Method_Token_c__c = objOrder.Payment_Method_Token_c__c;
        objBTTransactionDetails.Cardholder_Name_c__c = btDetail.Cardholder_Name_c__c;    
        objBTTransactionDetails.Customer_c__c = btDetail.Customer_c__c;
        //objBTTransactionDetails.Order_Transaction_c__c = orderTransactionId;
        objBTTransactionDetails.Transaction_Date_c__c = System.now();
        if(!Test.isRunningTest()){
            Database.insertImmediate(objBTTransactionDetails);
        }
        System.debug('BT Transaction Details-->'+objBTTransactionDetails);
    }
    
    
    public class ResponseWrapper {
        public Integer status;
        public string requestBody;
        public string responseBody;
        public string merchantId;
        public boolean isSuccess;
        public string dealerNumber;
        public string refreshToken; 
        public string accessToken;
        public string errorMessage;
        public string message;
        public string errorCode;
        public List<String> paymentMethods;        
    }
    
    public class DeviceCodeWrapper {
        public Integer status;
        public string requestBody;
        public string responseBody;
        public string deviceToken;
    }
    
    public class RequestWrapper {
        public B2B_AccessTokenResponseWrapper tokenResponse;
    }
    
}