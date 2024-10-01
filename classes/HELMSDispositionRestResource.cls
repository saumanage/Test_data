// This class hosts the disposition API for HELMS which is being used by the integration team to post dispositions requests to HELMS
@RestResource(urlMapping='/disposition_api/*')
global with sharing class HELMSDispositionRestResource {

        @HttpPost //HttpPost annotation exposes the method as a REST resource and called when an HTTP POST request is sent
        global static void disCreationLogic() {
            
                    RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
                    RestResponse res = RestContext.response;
                    RestResponse resp= RestContext.response;
                    resp.addHeader('Content-Type', 'application/xml');
                    string errormessage='';
                    string OppSF_Ids='';
                    List<Routing_Dealer_CRM_Disposition__c> rtDispList=  new List<Routing_Dealer_CRM_Disposition__c>();
                    String jsonBody='';    
                        
                        try{       
                                        if(req.requestBody!=null)
                                            jsonBody = req.requestBody.toString(); //the body of the request        
                                        if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
                                             responseWrapper Wrpobj =(responseWrapper ) System.JSON.deserialize(jsonBody, responseWrapper.class);
                                             
                                             for(integer i=0; i<Wrpobj.status.lead.size(); i++){
                                                 Routing_Dealer_CRM_Disposition__c rtDisp=  new Routing_Dealer_CRM_Disposition__c();
                                                 rtDisp.HELMS_Opportunity_External_Key__c = +Wrpobj.status.lead[i].id;
                                                 rtDisp.Arrival_Time_DT_c__c = Wrpobj.status.lead[i].arrivaltime;
                                                 rtDisp.Auto_Response__c = Wrpobj.status.lead[i].autoresponse;
                                                 rtDisp.Response_Time__c = Wrpobj.status.lead[i].responsetime;
                                                 rtDisp.The_Last_Event__c = Wrpobj.status.lead[i].lastevent;
                                                 rtDisp.Current_Status__c = Wrpobj.status.lead[i].currentstatus;
                                                 rtDispList.add(rtDisp);
                                              }
                                        
                                        }
                                        List<Database.SaveResult> insertNewDisp = Database.insert(rtDispList,false); //insert the new Task
                                        for(Integer i=0;i<insertNewDisp.size();i++){
                                            if (!insertNewDisp[i].isSuccess()) { //if the insert DML was NOT successful
                                                for(Database.Error err : insertNewDisp[i].getErrors()) {
                                                    errormessage += err.getMessage(); //set the message to the first error in the array
                                                    if(String.isBlank(OppSF_Ids))
                                                        OppSF_Ids =rtDispList[i].HELMS_Opportunity_External_Key__c;
                                                    else
                                                        OppSF_Ids =OppSF_Ids+';'+ rtDispList[i].HELMS_Opportunity_External_Key__c;
                                                }
                                            }
                                        }
                                        if(insertNewDisp.size()>0 && !String.isBlank(errormessage)){
                                            Logs__c logRecord = new Logs__c(Name='Disposition Error',Trigger_or_Class_Name__c='HELMSDispositionRestResource',Error_Message__c = errormessage);
                                            insert logRecord;
                                            Routing_Disposition_Failure__c routd= new Routing_Disposition_Failure__c();
                                            routd.Payload__c = req.requestBody.toString();
                                            routd.log__c= logRecord.id;
                                            routd.Opportunity_SF_Ids__c = OppSF_Ids;
                                            insert routd;
                                            resp.responseBody = Blob.valueOf('<error>'+errormessage+'</error>');
                                            resp.statusCode = 500;
                                        }
                        }catch(Exception ex){
                            Logs__c logRecord = new Logs__c(Name='Disposition Error',Trigger_or_Class_Name__c='HELMSDispositionRestResource',Error_Message__c = ex.getMessage(),Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
                            insert logRecord;
                            Routing_Disposition_Failure__c routd= new Routing_Disposition_Failure__c();
                            routd.Payload__c = req.requestBody.toString();
                            routd.log__c= logRecord.id;
                            insert routd;
                            errormessage = ex.getMessage();
                            resp.responseBody = Blob.valueOf('<error>'+errormessage+'</error>');
                            resp.statusCode = 500;
                        }
                        if(String.isBlank(errormessage) && !String.isBlank(jsonBody)){
                            resp.responseBody = Blob.valueOf('<result>Success</result>');
                            resp.statusCode = 200;
                        }
                                
                                
        }
                           
        //ResponseWrapper class for API response
        public class responseWrapper{
            public status status{get;set;}
        }

        public class status{
            public list<lead> lead{get;set;}
        }
        public class lead{
            public String lastevent{get;set;}
            public datetime responsetime{get;set;}
            public String autoresponse{get;set;}
            public String currentstatus{get;set;}
            public datetime arrivaltime{get;set;}
            public String id{get;set;}
        }
                        
                        
   
}