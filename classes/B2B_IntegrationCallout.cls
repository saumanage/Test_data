/**********************************************************************
Name: B2B_IntegrationCallout
Purpose: This class is a helper class for Integration classes
Created Date :  10/01/2024
Created By : Rajrishi Kaushik
*************************************************************/
public class B2B_IntegrationCallout {
    
    //method to create request for BrainTree System
    public static HttpRequest createBraintreeRequest(String methodType,String reqBody,String methodName){
        String guId = B2B_Util.createGui();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('hondaHeaderType.messageId', guId);
        request.setHeader('accept', 'application/json');
        request.setTimeout(120000);
        if(methodType == 'GET'){
            request.setMethod('GET');
        }else if(methodType == 'POST'){
            request.setMethod('POST');        
            request.setBody(reqBody);
            String finalUrl = 'callout:Braintree_Named_Credential';
            if(methodName == 'refund'){
                finalUrl += B2B_IntegrationConstants.BT_REFUND;  
            }else if(methodName == 'search'){
                finalUrl += B2B_IntegrationConstants.BT_TRAN_SEARCH; 
            }else if(methodName == 'void'){//added by suresh for payment settlement
                finalUrl += B2B_IntegrationConstants.BT_VOID;                  
            }
           
            request.setEndpoint(finalUrl);
            
        }
        return request;
    }
    
    //method to create request for HDM Salesforce System
    public static HttpRequest createHDMRequest(String methodName, String reqBody){
        String guId = B2B_Util.createGui();
        HttpRequest request = new HttpRequest();       
        
        request.setHeader('hondaHeaderType.messageId', guId);
        request.setHeader('accept', 'application/json');
        request.setMethod('POST');

        request.setBody(reqBody);
        String finalUrl = '';
        if(methodName == 'getDeviceCode'){
            request.setHeader('Authorization', Label.B2B_HDM_Authorization);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            finalUrl = 'callout:B2B_HDM_Credential';
        }else if(methodName == 'getDealerAccessToken'){          
            request.setHeader('Content-Type', 'application/json');
            finalUrl = 'callout:B2B_HDM_Dealer_Credential';
        }
        request.setEndpoint(finalUrl);
        return request;
    }

}