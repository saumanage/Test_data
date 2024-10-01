/*

SSO Error Message


1)Dealer's access not enabled in HELMS
Error Message - “Lead Management tool enrollment opportunities will be made available to all dealers soon. Please contact your DSM if you have any questions.”

2)Dealer gets SSO error because email is not passed from iN(because user wasn't set up with email)
Error Message - Please work with your Administrator to set up a email address for your account. Once email is set-up, please try signing in again.
3)Dealer gets other SSO errors
Error Message - We are having difficulties logging you in. Please contact iN Support for assistance.


*/

global class HELMSSSOCustomJITHandlerPartner{

     global static string errorMsg{ get; set;} 
     global static string error_log{ get; set;}   
    /* global static Boolean AccNoAccess{ get; set;}
     global static Boolean otherError{ get; set;}
     global static Boolean EmailError{ get; set;}
     */
     //global static Boolean otherError{ get; set{ otherError= false;}}
     global HELMSSSOCustomJITHandlerPartner(){
     
         String s=  ApexPages.currentPage().getParameters().get('ErrorDetails');        
         errorMsg  = s;
         if(errorMsg!=null){
             if(errorMsg.contains('HELMSSSOCustomJITHandlerInternal')){
                 errorMsg =  errorMsg.remove('HELMSSSOCustomJITHandlerInternal');
             }
             if(errorMsg.contains('Apex:.JitException:')){
                errorMsg =  errorMsg.remove('Apex:.JitException:');
             }
    error_log =errorMsg;
            if(errorMsg.contains('EmailIsRequired')){
                //errorMsg = 'Please work with your Administrator to set up a email address for your account. Once email is set-up, please try signing in again.';
                errorMsg =System.Label.HondaSingleSignOnErrorEmailRequired;               
            }else if(errorMsg.contains('HDMNoAccess')){
                //errorMsg ='Dreamshop User do not have access to this application.';
                errorMsg = System.Label.HDMSingleSignOnErrorNoAccess;               
            }else if(errorMsg.contains('HELMSNoAccess')){
                errorMsg =System.Label.HondaSingleSignOnErrorFullaccess;               
            }else{
                errorMsg =System.Label.HondaSingleSignOnErrorOtherError;
            }
             /*if(errorMsg.contains('No Access Level for Dealer Account')){        
                AccNoAccess = true;
             }else if(errorMsg.contains('Email')){       
                EmailError = true;
             }else{      
                otherError = true;
            }*/
        
        }
        //HttpSample.executeMe();
     }
     
     public string jiterrolog{get;set;}
     public void createLog() {
             string myString    = jiterrolog;
             Logs__c lg= new Logs__c();                     
             lg.Name='Unsuccessful log-in attempts from SSO';  
             lg.Trigger_or_Class_Name__c='HELMSSSOCustomJITHandlerInternal';
             lg.type__c='Unsuccessful log-in attempts from SSO';
             lg.Error_Message__c=myString;
             insert lg;
        
     }
     
   


}