/*-------------------------------------------------------------------------------------------
Story Number :LMS-5361
Class Name : HelmsLeadCrationNotificationSFMC 
Test Class Name : HelmsLeadCrationNotificationSFMCTest
Last Modified Version Owner : Ghouse
Comments : Send Email From SFMC when Lead is created From Marien or PE Brand Sites.
--------------------------------------------------------------------------------------------*/

global with sharing class HelmsLeadCrationNotificationSFMC {
    

    //Fetching all Lead record ids which will Created from Marien or PE sites.
    global static void leadCreationSFMC(List<Lead> pEMarineLead) {
        try{
             //  system.debug(':ids::::3333333333:::::::'+ids);
               
               /*  List<Lead> lead_List=[SELECT Id, ContactKey_TXT__c, Email, Model_TXT__c, SubDiv_TXT__c,Division_CD__c,ConvertedOpportunityId,
                        PreferredDealerAccount_ID__r.Phone,PreferredDealerAccount_ID__r.name,
                        PreferredDealerAccount_ID__r.ShippingStreet,PreferredDealerAccount_ID__r.ShippingCity,
                        PreferredDealerAccount_ID__r.ShippingPostalCode,PreferredDealerAccount_ID__r.ShippingCountry,
                        BrandsiteShoppingTool_TXT__c,Send_confirmation_Email__c  FROM Lead 
                        where (SubDiv_TXT__c='Marine' OR SubDiv_TXT__c='PowerEquipment')   AND isConverted = true AND Send_confirmation_Email__c = true AND
                        LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c = true AND BrandsiteShoppingTool_TXT__c =null AND id IN: ids];
    
    */
    
            //Iterating all Lead Records and mapping the requested parameters from SFMC.
            
            SFMCRequest sr = new SFMCRequest ();
            list<Opportunity> updateOppList = new list<Opportunity>();
            for(Lead l : pEMarineLead) {
                
           //     system.debug(':::ContactKey_TXT__c::::'+l.ContactKey_TXT__c);
                
                SFMCRequest.SubscriberAttributes subscribe = new SFMCRequest.SubscriberAttributes ();
                SFMCRequest.ContactAttributes conAttributes = new SFMCRequest.ContactAttributes ();
                SFMCRequest.To to = new SFMCRequest.To ();
                    
                string shippingstreet ='';
                string shippingcity='';
                string shippingpostalcode='';
                string shippingcountry='';
                if(l.PreferredDealerAccount_ID__r.ShippingStreet!=null){
                    shippingstreet = l.PreferredDealerAccount_ID__r.ShippingStreet;   
                }
                if(l.PreferredDealerAccount_ID__r.ShippingCity!=null){
                    shippingcity = l.PreferredDealerAccount_ID__r.ShippingCity;  
                }
                if(l.PreferredDealerAccount_ID__r.ShippingPostalCode!=null){
                    shippingpostalcode = l.PreferredDealerAccount_ID__r.ShippingPostalCode;   
                }
                if(l.PreferredDealerAccount_ID__r.ShippingCountry!=null){
                    shippingcountry = l.PreferredDealerAccount_ID__r.ShippingCountry;   
                }
                string dealerAddress=shippingstreet +' '+ shippingcity +' '+shippingpostalcode +' '+shippingcountry;
                
                subscribe.Dealer_Address = dealerAddress;
                subscribe.Dealer_Name = l.PreferredDealerAccount_ID__r.name;
                subscribe.Dealer_Phone = l.PreferredDealerAccount_ID__r.Phone;
                subscribe.Model_Name = l.Model_TXT__c;
                subscribe.Sub_Division =l.SubDiv_TXT__c; //PowerEquipment //Marine
                conAttributes.SubscriberAttributes = subscribe;
                to.Address = l.Email;
                //string ckey = 'H352338222';
                to.SubscriberKey = l.ContactKey_TXT__c;
                to.ContactAttributes = conAttributes;
                sr.To = to;
                
                
                // Authorization Request to get access token.
                HttpRequest req = new HttpRequest();           
                req.setHeader('Accept', 'application/json');
                req.setHeader('Content-Type','application/json;charset=UTF-8');
                req.setMethod('POST');
                req.setEndpoint('callout:mSFMC_Credentails');
                //req.setEndpoint('https://mc219s2l565j37tg6q88270hftr1.auth.marketingcloudapis.com/v2/token'); 
                req.setTimeout(120000);
                
               SFMCAuthentication sf=  new SFMCAuthentication();
                //sr.SFMCAuth(HELMSConstants.grant_type,HELMSConstants.client_id,HELMSConstants.client_secret,HELMSConstants.account_id);
                sf.grant_type = HELMSConstants.grant_type;
                sf.client_id = HELMSConstants.client_id;
                sf.client_secret = HELMSConstants.client_secret;
                sf.account_id = HELMSConstants.account_id;
                String jsonString = JSON.serialize(sf);
             //   system.debug('JsonString------>>>>'+jsonString);
                req.setBody(jsonString);
                Http http = new Http();
                HTTPResponse res = http.send(req);
             //   system.debug(res.getBody());
                oAuthClass autorize = (oAuthClass)JSON.deserialize(res.getBody(), oAuthClass.class);
                string accesstoken = autorize.access_token; 
                
                //Requested Json body send to SFMC based on Access Token.
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Accept', 'application/json');
                req1.setHeader('Content-Type','application/json;charset=UTF-8');
                //string accesstoken ='eyJhbGciOiJIUzI1NiIsImtpZCI6IjQiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiI3ekZ0Z0NWY3Y4dXpwSTlaQlJFRW9MRTkiLCJjbGllbnRfaWQiOiJxdm5mY2tqZHM1aW9jMm8yb2gzOG5yM2QiLCJlaWQiOjcyOTM2NDcsInN0YWNrX2tleSI6IlM3IiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciJ9._7XHNPD91a4JYbeHeBSZXJPqpzwnwyvzWAR2Y23MPuo.JVetWdbrqfFhoR7ARFI7crsn9jYm3D8S34Ycp2C3yjXSgfngTYEcmOyz-T1dABs8zfmGjpB2IEkXmnpQzwKRqtfo7cJYWiU5Cl1Jc-ICtd9r39lmMDylXGGwyLIHzMjpIU5ldRJY5HPT';
                req1.setHeader('Authorization','Bearer ' + accesstoken);
                req1.setMethod('POST');
                //req1.setEndpoint('https://mc219s2l565j37tg6q88270hftr1.rest.marketingcloudapis.com/messaging/v1/messageDefinitionSends/key:68881/send');
                req1.setEndpoint('callout:mSFMC_SecondCall');
                req1.setTimeout(120000);
                
                String jsonString1=JSON.serialize(sr);
                req1.setBody(jsonString1);
            //    system.debug('JsonString1'+jsonString1);
                Http http1 = new Http();
                HTTPResponse res1 = http1.send(req1);
            //    system.debug(res1.getBody());
                Opportunity opp = [select id,Customer_Acknowledgement__c from Opportunity where id=: l.ConvertedOpportunityId limit 1];
                if(opp != null) {
                    Opp.Customer_Acknowledgement__c = false;
                }
                SFMCResponse message = (SFMCResponse)JSON.deserialize(res1.getBody(), SFMCResponse.class);
                if(message!=null && message.responses!=null && message.responses[0] != null){
                    if(message.responses[0].messages[0] != null && message.responses[0].messages[0] == 'Queued' && l.ConvertedOpportunityId != null){
                        if(Opp.Customer_Acknowledgement__c == false) {
                            Opp.Customer_Acknowledgement__c = true;
                        }
                    }
                }
                //update opp; 
                updateOppList.add(opp);
            }
            
            
      
            if(updateOppList.size() > 0) {
                update updateOppList;
            }
        } catch(Exception ex) {
            Logs__c  l =new Logs__c (name='HelmsLeadCrationNotificationSFMC',Trigger_or_Class_Name__c='HelmsLeadCrationNotificationSFMC', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
            
        }
        
    }
   
    
    global class oAuthClass {
        global string access_token {get;set;} 
    }
    

}