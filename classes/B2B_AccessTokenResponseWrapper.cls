/**********************************************************************
Name: B2B_AccessTokenResponseWrapper
Purpose: Apex class is used as a wrapper for BT Refresh Token APIs
Created Date :  03/05/2024
Created By : Rajrishi Kaushik
*************************************************************/
public class B2B_AccessTokenResponseWrapper {
    public Integer status;  
    public String merchantId; 
    public String errorMessage;
    public cls_credentials credentials;
    public String requestBody;
    public String responseBody;
    
    public class cls_credentials {
        public String accessToken;  
        public String refreshToken;
        public String tokenType; 
        public String expiresAt; 
        public String scope;  
    }
}