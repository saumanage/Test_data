/*This class is used to send the email notifications once Honda lead got created.*/
global with sharing class HELMSeShoppingSendNotification {
    global static void eshoppingAPi(List<Lead> hondaLead){
           try{
   //     System.debug('eShopping 1 ** ');
     /*   List<Lead> listLead = [Select Id, FirstName,Odometer_TXT__c, BodyStyle_TXT__c,  MSRP_AMT__c, ModelDestinationCharge_AM__c, 
                               ModelDealerAccessoryPrice_AM__c, Interior_Color__c, Exterior_Color__c, Transmission_TXT__c, Address_Street__c, Model_ID__c, 
                               State, Marketing_Campaign_Name__c, Make_TXT__c, Year_YR__c, ConvertedOpportunityId, LastName, Source_Name__c, Division_CD__c, 
                               Address, street,City, PostalCode, Email, PreferredDealerAccount_ID__c, PreferredDealerNumber_NUM__c, 
                               LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c From Lead where SubDiv_TXT__c='Honda' 
                               AND isConverted = true AND Send_confirmation_Email__c = true AND
                               LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c= true AND Id IN : leadIds]; */
        //System.debug('listLead : '+listLead);
        List<opportunity> oppList= new List<opportunity>();
		 List<Logs__c > logList= new List<Logs__c >();
      
            for(Lead l : hondaLead){
            
                List<Offers__c> offers = [SELECT Id, Opportunity__c, Offer_ID__c FROM Offers__c WHERE Opportunity__c = :l.ConvertedOpportunityId LIMIT 1];
                String offerId = 'AT5366';

         //       System.debug('offerId : '+offerId);
                String leadLastName = l.LastName;  
                String leadFirstName = l.FirstName;  
                String leadAddressLine1 = l.Address_Street__c;
                String leadCity = l.City;
                String leadState = l.State;
                //String LeadEmail = 'syam.mohan@wipro.com'; //l.Email;
                String leadEmail = l.Email;
                String leadPostalCode = l.PostalCode;
                String leadPreferredDealerNum = l.PreferredDealerNumber_NUM__c;
                //String LeadPreferredDealerNum = '206500';
                //String LeadModelYear = l.Year_YR__c;
                String leadModelYear = '2013';
                String leadModelMake = l.Make_TXT__c;
                String leadMarketingName = l.Marketing_Campaign_Name__c;
                String leadModelId = l.Model_ID__c;
                // Vin Number missing
                //String LeadTransmission = l.Transmission_TXT__c;
                String leadTransmission = 'Manual';
                //ModelEngine
                //String LeadOdometer = l.Odometer_TXT__c;
                String leadOdometer = '25000';
                String leadExterior = l.Exterior_Color__c;
                String leadInterior = l.Interior_Color__c;
                //ModelDealerStockNumber
                //ModelVehicleTypeCD
                //ModelConfiguredDSRP
                String leadModelDealerAccessory = '123'; //String.valueof(l.ModelDealerAccessoryPrice_AM__c);
                String leadModelDestinationCharge = '456'; //string.valueOf(l.ModelDestinationCharge_AM__c);
                String leadMSRP = '789'; //string.valueOf(l.MSRP_AMT__c);
                //ModelMFGColor
                String leadBodyStyle = l.BodyStyle_TXT__c;
                String requestBody = '';
                requestBody = '<HIT><ClientInfo appid="sample2.eshopping.services.honda.com" serverip="10.177.9.32" sessionid="0" userid="eshopping"/><MITs><MIT id="1"><ClientInfo appid="sample2.eshopping.services.honda.com" sessionid="0" serverip="10.177.9.32" userid="eshopping" echoinput="false"/><Input><Required><SourceCD>eshopping</SourceCD><ProductDivisionCD>A</ProductDivisionCD>';
                requestBody += '<FirstName>'+LeadFirstName+'</FirstName><LastName>'+LeadLastName+'</LastName><AddressLine1>'+LeadAddressLine1+'</AddressLine1>';
                requestBody += '<City>'+LeadCity+'</City><State>'+LeadState+'</State><ZipCode>'+LeadPostalCode+'</ZipCode><Email>'+LeadEmail+'</Email>';
                requestBody += '<HelmsLeadID>1234567890</HelmsLeadID>';
                requestBody += '<Dealers><Dealer id="1"><DealerID>'+LeadPreferredDealerNum+'</DealerID></Dealer></Dealers></Required>';
                requestBody += '<Optional><ContactKey/><EmailConfig><OfferId>'+offerId+'</OfferId><MaxOffersInEmail>2</MaxOffersInEmail><Data1/><Data2/><Data3/><Data4/><Data5/><Data6/><Data7/><Data8/><Data9/><Data10/><Data11/><Data12/><Data13/><Data14/><Data15/><Data16/><Data17/><Data18/><Data19/><Data20/></EmailConfig>';
                requestBody += '<Models><Model id="1"><ModelYear>'+LeadModelYear+'</ModelYear><ModelMake>Honda</ModelMake><ModelMarketingName>'+LeadMarketingName+'</ModelMarketingName><ModelID>'+LeadModelId+'</ModelID><ModelVIN>19UUA66205A007060</ModelVIN><ModelTransmission>'+LeadTransmission+'</ModelTransmission><ModelEngineSize>5.4L</ModelEngineSize><ModelOdometer>'+LeadOdometer+'</ModelOdometer><ModelExteriorColors><ModelExteriorColor id="1">'+LeadExterior+'</ModelExteriorColor></ModelExteriorColors><ModelInteriorColors><ModelInteriorColor id="1">'+LeadInterior+'</ModelInteriorColor></ModelInteriorColors><ModelDealerStockNumber>A007060</ModelDealerStockNumber><ModelVehicleTypeCD>N</ModelVehicleTypeCD><ModelConfiguredDSRP>23995.00</ModelConfiguredDSRP><ModelDealerAccessoryPrice>'+LeadModelDealerAccessory+'</ModelDealerAccessoryPrice><ModelDestinationCharge>'+LeadModelDestinationCharge+'</ModelDestinationCharge><ModelMSRP>'+LeadMSRP+'</ModelMSRP><ModelMfgColorCD>1287CH</ModelMfgColorCD><ModelBodyStyle>'+LeadBodyStyle+'</ModelBodyStyle></Model></Models>';
                requestBody += '</Optional></Input><Private key="b0_t_rNRs7a6JWTC5zPkiJjx09Tf4yh2XBXiQr2n17g"><TemplateInfo filename="Quote Request/SubmitRAQEmailMIT.xml" xsd="Quote Request/SubmitRAQEmailMIT.xsd" class="B2C.eShopping.BLL.QuoteRequest" method="SubmitRAQEmail"/></Private></MIT></MITs><Private/></HIT>';
                
                // System.debug('requestBody : '+requestBody);    
                //String username = 'service_HELMS_B2CeShopping_Dev';
                //String password = 'Shade$44';
                
                //Blob headerValue = Blob.valueOf(username + ':' + password);
                //String authorizationHeader = 'Basic ' +
                //EncodingUtil.base64Encode(headerValue);
        
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                //request.setEndpoint('https://ws-dev2.hondaweb.com/REST/B2C/RAQEmailHandlerService/1.0');
                request.setEndpoint('callout:eShopping_Credentials');
               
                request.setHeader('Content-Type','text/xml');
                
                request.setHeader('hondaHeaderType.messageId', '925ea6a8-5943-48ae-b673-dd485f9bd821');
                request.setHeader('B2CHeader.AppID', 'sample2.eshopping.services.honda.com');
                request.setHeader('Authorization', 'Basic c2VydmljZV9IRUxNU19CMkNlU2hvcHBpbmdfRGV2OlNoYWRlJDQ0');
                
                request.setMethod('POST');
               // request.setTimeout(120000);
                request.setBody(requestBody);
           
                HttpResponse response = http.send(request);
         
               // system.debug('::::response::::::'+response.getBody());
              //  system.debug('::::getStatusCode::::::'+response.getStatusCode());
                if(response.getStatusCode()==200){
                    Opportunity opp= new Opportunity();
                    opp.id = l.ConvertedOpportunityId;
                    opp.Status_Message__c = string.valueof(response.getStatusCode());
                    oppList.add(opp);
                system.debug('::::response::::::'+response.getBody());
                system.debug('::::getStatusCode::::::'+response.getStatusCode());
                }else{
					
		     Logs__c  l2 =new Logs__c (name='Integration callout failure',Trigger_or_Class_Name__c='HELMSeShoppingSendNotification', Error_Message__c =response.getBody(), Error_Line_Number__c =response.getStatusCode() );
			 logList.add(l2);
			 
            
				}
                system.debug('::::response::::::'+response.getBody());
                system.debug('::::getStatusCode::::::'+response.getStatusCode());
                
            }
            if(oppList.size()>0)
                update oppList;
			if(logList.size()>0)
                insert logList;
        
         }
        Catch(Exception ex){
        	//System.debug('Exception at line : '+ ex.getLineNumber());
            //System.debug('Exception Message : '+ ex.getMessage());
            Logs__c  l =new Logs__c (name='HELMSeShoppingSendNotification',Trigger_or_Class_Name__c='HELMSeShoppingSendNotification', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
    }
}