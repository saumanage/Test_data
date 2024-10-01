global class HelmsLeadCrationNotificationSFMCAcura {

    //Fetching all Lead record ids which will Created from Aura.
    public static void leadCreationSFMCAura(List<Lead> acuraLead) {
        
      
        
      /*  List<Lead> ledlist=[SELECT Id,FirstName,Exterior_Color__c,Interior_Color__c,PreferredDealerContact_ID__r.email, ContactKey_TXT__c,
                            Email, Model_TXT__c, SubDiv_TXT__c,Division_CD__c,PreferredDealerAccount_ID__r.Phone,
                            PreferredDealerAccount_ID__r.name,PreferredDealerAccount_ID__r.ShippingStreet,
                            PreferredDealerAccount_ID__r.ShippingCity,PreferredDealerAccount_ID__r.ShippingState,
                            PreferredDealerAccount_ID__r.ShippingPostalCode,PreferredDealerAccount_ID__r.ShippingCountry,
                            BrandsiteShoppingTool_TXT__c,Send_confirmation_Email__c,Year_YR__c,PreferredDealerContact_ID__r.name  FROM Lead
                            where SubDiv_TXT__c='Acura'  AND BrandsiteShoppingTool_TXT__c =null  AND isConverted = true AND Send_confirmation_Email__c = true AND
                            LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c = true AND id IN: ids];*/
    
            
        AuraWprapperClass sr = new AuraWprapperClass ();
        for(Lead l : acuraLead) {
            AuraWprapperClass.subscriberAttributes subscribe = new AuraWprapperClass.subscriberAttributes ();
            AuraWprapperClass.contactAttributes conAttributes = new AuraWprapperClass.contactAttributes ();
            AuraWprapperClass.To to = new AuraWprapperClass.To ();
            
            string shippingstreet ='';
            string shippingcity='';
            string shippingState='';
            string shippingpostalcode='';
            string shippingcountry='';
            if(l.PreferredDealerAccount_ID__r.ShippingStreet!=null){
                shippingstreet = l.PreferredDealerAccount_ID__r.ShippingStreet;   
            }
            if(l.PreferredDealerAccount_ID__r.ShippingCity!=null){
                shippingcity = l.PreferredDealerAccount_ID__r.ShippingCity;  
            }
            if(l.PreferredDealerAccount_ID__r.shippingState!=null){
                shippingState= l.PreferredDealerAccount_ID__r.shippingState;
            }
            if(l.PreferredDealerAccount_ID__r.ShippingPostalCode!=null){
                shippingpostalcode = l.PreferredDealerAccount_ID__r.ShippingPostalCode;   
            }
            if(l.PreferredDealerAccount_ID__r.ShippingCountry!=null){
                shippingcountry = l.PreferredDealerAccount_ID__r.ShippingCountry;   
            }
            string dealerAddress1=shippingstreet +' '+ shippingcity +' '+shippingState ;
            string dealerAddress2=shippingpostalcode +' '+shippingcountry;
            
            subscribe.dATA10 = dealerAddress1;
            subscribe.dATA11 = dealerAddress2;
            subscribe.fName= l.FirstName;
            subscribe.dATA39 =l.Year_YR__c;
            subscribe.dATA41 =l.Exterior_Color__c;
            subscribe.dATA42 =l.Interior_Color__c;
            subscribe.sENDERFNAME = l.PreferredDealerAccount_ID__r.name;
            subscribe.dATA9 = l.PreferredDealerContact_ID__r.name;
            subscribe.dATA6 = l.PreferredDealerAccount_ID__r.Phone;
            subscribe.dATA2 = l.Model_TXT__c;
            subscribe.rEPLYTOEMAIL = l.PreferredDealerContact_ID__r.email; //emailMap.get(l.PreferredDealerContact_ID__c);
            conAttributes.subscriberAttributes = subscribe;
            to.address = l.Email;
            to.subscriberKey = l.ContactKey_TXT__c;
            to.contactAttributes = conAttributes;
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
            sf.grant_type = HELMSConstants.grant_type;
            sf.client_id = HELMSConstants.client_id;
            sf.client_secret = HELMSConstants.client_secret;
            sf.account_id = HELMSConstants.account_id;
            String jsonString = JSON.serialize(sf);
      //      system.debug('JsonString------>>>>'+JsonString);
            req.setBody(jsonString);
            Http http = new Http();
            HTTPResponse res = http.send(req);
      //      system.debug(res.getBody());
            oAuthClass autorize = (oAuthClass)JSON.deserialize(res.getBody(), oAuthClass.class);
            string accesstoken = autorize.access_token; 
            
            
                
            //Requested Json body send to SFMC based on Access Token.
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Accept', 'application/json');
            req1.setHeader('Content-Type','application/json;charset=UTF-8');
            //string accesstoken ='eyJhbGciOiJIUzI1NiIsImtpZCI6IjQiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiI3ekZ0Z0NWY3Y4dXpwSTlaQlJFRW9MRTkiLCJjbGllbnRfaWQiOiJxdm5mY2tqZHM1aW9jMm8yb2gzOG5yM2QiLCJlaWQiOjcyOTM2NDcsInN0YWNrX2tleSI6IlM3IiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciJ9._7XHNPD91a4JYbeHeBSZXJPqpzwnwyvzWAR2Y23MPuo.JVetWdbrqfFhoR7ARFI7crsn9jYm3D8S34Ycp2C3yjXSgfngTYEcmOyz-T1dABs8zfmGjpB2IEkXmnpQzwKRqtfo7cJYWiU5Cl1Jc-ICtd9r39lmMDylXGGwyLIHzMjpIU5ldRJY5HPT';
            req1.setHeader('Authorization','Bearer ' + accesstoken);
            req1.setMethod('POST');
            //req1.setEndpoint('https://mc219s2l565j37tg6q88270hftr1.rest.marketingcloudapis.com/messaging/v1/messageDefinitionSends/key:69023/send');
            req1.setEndpoint('callout:AcuraSecondCall');
            req1.setTimeout(120000);
            
            String jsonString1=JSON.serialize(sr);
            req1.setBody(jsonString1);
     //       system.debug('JsonString1'+JsonString1);
            Http http1 = new Http();
            HTTPResponse res1 = http1.send(req1);
    //        system.debug(res1.getBody());
                
        }
    }
    public class oAuthClass {
        public string access_token {get;set;} 
    }
    
    
}