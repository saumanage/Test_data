/****************************************************************************************************************
Name: 			B2B_Util
Purpose: 		This class is to provide Tax from Vertex API.
Date: 			28/01/2021
Created By: 	Soumya Sahoo
******************************************************************************************************************
MODIFICATIONS – 	Date 		|	Dev Name		|	Method		|	User Story
******************************************************************************************************************
22/05/2022	|	Soumya Sahoo	|				    |	Error handling changes- JIRA- 8617
******************************************************************************************************************/
public class B2B_Util{
   
    // This method will generate unique UI which is required in request header.
    public static String createGui() {
        String kHexChars = '0123456789abcdef';
        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0; i<16; i++) {

            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';

            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if (i==6) {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }

            if (i==8) {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }

        return returnValue;
    }

    // This method is internally called from createGui()
    public static String getCharAtIndex(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str; 
        if (index == str.length()) return null;  
        return str.substring(index, index+1);
    }

    public static Boolean isSalesforceID(String value){
        try{ //Added by shalini for issue HDMP-6372
            if(Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(value).matches()){
                return true;
            } else{
                return false;
            }
           
        }catch(Exception ex){
            return false;
        }
    }
    public static Long fetchCurrentTime(){
        Long beforeAPI = DateTime.now().getTime();
        return beforeAPI;
    }
    
    public static Long calInMilliSeconds(Long beforeApi, Long afterAPI){
        Long timeDuration =(afterAPI-beforeApi);
        return timeDuration;
    }
    // Below method utilize to create record over error object
    public static void createErrorRecord(String errorName,String orderreturnId,String accountId,String personAccountId, String cartId,String className, String errorMessage, String errorType, String lineNumber,String methodName,Boolean notifySupport,String OrderId,String recordid,String stackTrace,Long duration,String severity,String requestPayload,String responsePayload){
        try{
            Error_c__x errorRecord  =  new Error_c__x();
            List<Error_c__x> errorRecToInsertList  =  new List<Error_c__x>();
            errorRecord.Name__c  =  errorName;
            if(String.isNotBlank(orderreturnId))
                errorRecord.Order_Transaction_c__c = orderreturnId;
            if(String.isNotBlank(accountId))
                errorRecord.Account_c__c  =  accountId;
            if(String.isNotBlank(personAccountId))
                errorRecord.Person_Account_c__c = personAccountId;
            if(String.isNotBlank(cartId))
                errorRecord.Cart_c__c	 = cartId;
            errorRecord.ClassName_c__c  = className;
           	if(String.isNotBlank(OrderId))
                errorRecord.Order_c__c=OrderId;
            errorRecord.Duration_c__c  = duration;
            errorRecord.Error_Message_c__c = errorMessage;
            errorRecord.Error_Type_c__c = errorType;
            if(String.isNotBlank(lineNumber))
                errorRecord.Line_Number_c__c = Integer.valueOf(lineNumber);
            errorRecord.MethodName_c__c = methodName;
            errorRecord.Notify_Support_c__c = notifySupport;
            errorRecord.Support_Notification_Date_c__c = system.now();
            if(String.isNotBlank(orderId))
                errorRecord.Order_c__c = orderId;
            errorRecord.RecordId_c__c = recordid;
            errorRecord.Severity_c__c = Severity;
            errorRecord.StackTrace_c__c = stackTrace;
            errorRecord.Request_Payload_c__c = requestPayload;
            errorRecord.Response_Payload_c__c = responsePayload;
            errorRecToInsertList.add(errorRecord);
            if(!errorRecToInsertList.isEmpty()){
                if(!Test.isRunningTest()){
                    Database.insertImmediate(errorRecToInsertList);
                }                
            }
                
        }catch(Exception e) {
            System.debug(e.getMessage());
        }
       
    }
    
}