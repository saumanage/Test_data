/**** Opp Trigger Handler Name;HELMSLeadDealerAssignmentADFHandler
User story Number : LMS-3636
SFDC will publish to a platform event
****/
public class HELMSLeadDealerAssignmentADFHandler{
    public static boolean isHappenedRouting = false;
    public static boolean isRoutingBatchProcess = false;
    List<Lead_Dealer_Assignment_ADF__e> publishEvents = new List<Lead_Dealer_Assignment_ADF__e>();
    /* Getting Max count of Payload Sequence Number - LMS - 6575 */
    public Static Integer getMaxSequenceNumber(Id oppId){
        List<AggregateResult> oppRec = new List<AggregateResult>();
        oppRec = [SELECT max(Recipient_Response_Sequence__c), Opportunity__c FROM XML_Payload__c WHERE Opportunity__c = : oppId Group By Opportunity__c];
        Integer maxCount = 0;
        if(oppRec.size() > 0){
            Double maxCountDouble = oppRec[0].get('expr0')==null?0:(Double)oppRec[0].get('expr0');
            maxCount = maxCountDouble.intValue(); 
        }
        return maxCount;
    }
    /* Getting Max count of Payload Sequence Number - LMS - 6575 */
    
    
    public void updateOpportunityOnDealerAcknowledgement(List<Lead_Dealer_Acknowledgement_ADF__e> leadAcknowldgement){
        try{
            /* New Code */
            Map < String, Routing_Status__mdt > routingMessages = new Map < String, Routing_Status__mdt>();
            for(Routing_Status__mdt fw: Routing_Status__mdt.getAll().values()){
                routingMessages.put(fw.Status_Code__c, fw);
                // system.debug(mapFilterWords);
            }
           // System.debug('routingMessages : '+routingMessages);
            Map < String, DSP_Routing_Status__mdt > dsproutingMessages = new Map < String, DSP_Routing_Status__mdt>();
            for(DSP_Routing_Status__mdt fw: DSP_Routing_Status__mdt.getAll().values()){
                dsproutingMessages.put(fw.Status_Code__c, fw);
            } 
           
            /* New Code */
             
            Map < String, Urban_Science_Routing_Status__mdt > ubroutingMessages = new Map < String, Urban_Science_Routing_Status__mdt>();
            for(Urban_Science_Routing_Status__mdt urb: Urban_Science_Routing_Status__mdt.getAll().values()){
                ubroutingMessages.put(urb.Status_Code__c, urb);
                // system.debug(mapFilterWords);
            }
            Map<String, Lead_Dealer_Acknowledgement_ADF__e> acknwoledgementMap = new Map<String, Lead_Dealer_Acknowledgement_ADF__e>();
            Set<String> acknwoledgementSet = new Set<String>();
            for(Lead_Dealer_Acknowledgement_ADF__e acknowledgeRes : leadAcknowldgement){
                if(acknowledgeRes.Oppotunity_SF_ID__c != null){
                    acknwoledgementMap.put(acknowledgeRes.Oppotunity_SF_ID__c, acknowledgeRes);
                    acknwoledgementSet.add(acknowledgeRes.Oppotunity_SF_ID__c);
                                system.debug('acknowledgeRes----------->'+acknowledgeRes);
            system.debug('acknwoledgementMap------->'+acknwoledgementMap);
                }
            }

            List<Opportunity> opportunityToUpdate = new List<Opportunity>();
            List<XML_Payload__c> xmlpayloadToUpdate = new List<XML_Payload__c>();
            List<XML_Payload__c> crmXMLPayloadToUpdate = new List<XML_Payload__c>();  // CRM and Urban Science - LMS - 6575
            if(acknwoledgementSet.size() > 0){
                //, CRM_Payload__c //Response_Urban_Science_c__c, 
                for(Opportunity opp :[SELECT Id, Provider_Type__c, LeadProvider_ID__r.Name,Send_to_DSP__c, Is_This_Lead_Update__c, LeadProvider_ID__r.Send_to_Urban_Science_Flag__c, SendOnlyToUrbanScience__c, Name,Routing_Status_Message__c, Urban_Science_Routing_Response_Message__c, Response_Urban_Science__c, Sent_to_Urban_Science_Status__c, Opportunity_SF_ID__c, Error_Details_Urban_Science__c, Routing_Status__c, Routing_Failure_Date_Time__c, Routing_Success_Date_Time__c FROM Opportunity WHERE Routing_Status__c != 'Success' AND Opportunity_SF_ID__c IN : acknwoledgementSet FOR UPDATE]){
                    
                    /* XML Payload for CRM and Urban Science. LMS - 6575 */
                    XML_Payload__c crmXMLPayload = new XML_Payload__c(); //XML Payload for CRM
                    XML_Payload__c urbscnceXMLPayload = new XML_Payload__c();  //XML Payload for Urban Science
                    XML_Payload__c dspXMLPayload = new XML_Payload__c();//XML Payload for DSP 
                    Integer payloadSequenceNumber = HELMSLeadDealerAssignmentADFHandler.getMaxSequenceNumber(opp.Id);
                 //   System.debug('Seq Number is : '+payloadSequenceNumber);
                    crmXMLPayload.Recipient_Response_Sequence__c = payloadSequenceNumber+1;
                    urbscnceXMLPayload.Recipient_Response_Sequence__c = payloadSequenceNumber+1;
                    crmXMLPayload.Recipient_Type__c = 'CRM';
                    urbscnceXMLPayload.Recipient_Type__c = 'Urban Science';
                    dspXMLPayload.Recipient_Type__c = 'DSP';
                    dspXMLPayload.Recipient_Response_Sequence__c = payloadSequenceNumber+1;
                    /* XML Payload for CRM and Urban Science. LMS - 6575  */

                    if(opp.SendOnlyToUrbanScience__c && !acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Initial_Walkin_Lead__c && acknwoledgementMap.containskey(opp.Opportunity_SF_ID__c) && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != '' && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != null ){
                        String routing_error_temp = '';
                        String routing_error_for_db = '';
                        /* For Xml Payload Name Length issue */
                        String opportunity_name_temp = '';
                        /* For Xml Payload Name Length issue */
                        if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c == '0'){
                            opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
                            /* New Code */
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.Routing_Status_Message__c = '';
                            }
                            /* New Code */
                            if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != '' && ubroutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c)){
                                opp.Urban_Science_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                                urbscnceXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                            }
                            
                            /* Urban Science Response */
                            opp.Response_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_Urban_Science__c;
                            /* Urban Science Response */
                            
                            opp.Sent_to_Urban_Science_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
                            /* Adding the CRM Payload to the custom object */
                            XML_Payload__c payload = new XML_Payload__c ();
                            //payload.XML_Payload__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c;
                            payload.Opportunity__c = opp.Id;
                            urbscnceXMLPayload.Opportunity__c = opp.Id;
                            /* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                	payload.Name = opportunity_name_temp.substring(0,75);    
                                    urbscnceXMLPayload.Name = opportunity_name_temp.substring(0,75); 
                                }else{
                                	payload.Name = opportunity_name_temp;    
                                    urbscnceXMLPayload.Name = opportunity_name_temp; 
                                }
                            }                            
                            /* For reducing the Length of Payload Name, we are checking the length */
                            /* Adding the whole response from CRM XML Payload */
                            payload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            urbscnceXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            /* Adding the whole response from CRM XML Payload */
                            
                            xmlpayloadToUpdate.add(payload);
                            System.debug('Error Details : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c + ' : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c);
                            opp.Error_Details_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c;  
                            urbscnceXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c; //LMS - 6575
                            crmXMLPayloadToUpdate.add(urbscnceXMLPayload);
                            opp.Routing_Status__c = 'Success';
                            opp.Routing_Success_Date_Time__c = System.now();
                            opp.Routing_Error__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            routing_error_temp = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            if(routing_error_temp!=null){
                                if(routing_error_temp.length() > 255){
                                    routing_error_for_db = routing_error_temp.substring(0,255);    
                                }else{
                                    routing_error_for_db = routing_error_temp;
                                }
                            }
                            opp.Routing_Error_for_Dashboard__c = routing_error_for_db;
                            opportunityToUpdate.add(opp);
                        }else{
                        //    System.debug('Error Details : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c + ' : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c);
                            opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c;
                            /* New Code */
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.Routing_Status_Message__c = '';
                            }
                            /* New Code */
                            if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != '' && ubroutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c)){
                                opp.Urban_Science_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                            	urbscnceXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                            }
                            /* Urban Science Response */
                            opp.Response_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_Urban_Science__c;
                            /* Urban Science Response */
                            /* Adding the CRM Payload to the custom object */
                            XML_Payload__c payload1 = new XML_Payload__c ();
                            //payload1.XML_Payload__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c;
                            payload1.Opportunity__c = opp.Id;
                            //payload1.Name = opp.Name; 
                            /* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                	payload1.Name = opportunity_name_temp.substring(0,75);    
                                }else{
                                	payload1.Name = opportunity_name_temp;    
                                }
                            }                            
                            /* For reducing the Length of Payload Name, we are checking the length */
                            /* Adding the whole response from CRM XML Payload */
                            payload1.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            /* Adding the whole response from CRM XML Payload */
                            xmlpayloadToUpdate.add(payload1);
                            opp.Sent_to_Urban_Science_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
                            opp.Error_Details_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c;
                            opp.Routing_Status__c = 'Failure';   
                            opp.Routing_Failure_Date_Time__c = System.now();
                            opp.Routing_Error__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            routing_error_temp = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            if(routing_error_temp!=null){
                                if(routing_error_temp.length() > 255){
                                    routing_error_for_db = routing_error_temp.substring(0,255);    
                                }else{
                                    routing_error_for_db = routing_error_temp;
                                }
                            }
                            opp.Routing_Error_for_Dashboard__c = routing_error_for_db;
                            opportunityToUpdate.add(opp);
                        }
                    }
                                   
                    if(!opp.SendOnlyToUrbanScience__c && !acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Initial_Walkin_Lead__c && acknwoledgementMap.containskey(opp.Opportunity_SF_ID__c) && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c != '' && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c != null){
                        String routing_error_temp = '';
                        String routing_error_for_db = '';
                        /* For Xml Payload Name Length issue */
                        String opportunity_name_temp = '';
                        /* For Xml Payload Name Length issue */
                        if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c == '0'){
                            opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c;
                            /* New Code */
                            
                            if(opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){ 
                            if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != '' && ubroutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c)){
                                opp.Urban_Science_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                                urbscnceXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                            }
                            }
                            
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.Routing_Status_Message__c = opp.Lead_Dealer_Acknowledgement_Status_Code__c+' - '+routingMessages.get(opp.Lead_Dealer_Acknowledgement_Status_Code__c).Routing_Message__c;
                                crmXMLPayload.Recipient_Status__c = opp.Lead_Dealer_Acknowledgement_Status_Code__c+' - '+routingMessages.get(opp.Lead_Dealer_Acknowledgement_Status_Code__c).Routing_Message__c;
                            }
                            /* New Code */
                            String opportunity_Response_DSP = '';
                            
								opportunity_Response_DSP =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                            
                              if(opportunity_Response_DSP != null ){
                                if(opportunity_Response_DSP.length() > 255){
                               opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);
                                } else{
                                   opp.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                                }
                              }
                                         
                          if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c != '' && dsproutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c)){
                                opp.DSP_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c).Routing_Message__c;
                                dspXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).	Sent_to_DSP_Status__c).Routing_Message__c;
                                opp.DSP_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c;
                            }
                            //opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);
                            System.debug('testsendtodsp1----'+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Send_to_DSP__c);
                            opp.Send_to_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Send_to_DSP__c; 
      
                            /* Urban Science Response */
                              if(opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){                           
                            opp.Response_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_Urban_Science__c;
                            /* Urban Science Response */
                            
                            opp.Sent_to_Urban_Science_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
                              }
                            /* Adding the CRM Payload to the custom object */
                                  
                            XML_Payload__c payload = new XML_Payload__c ();
                            //payload.XML_Payload__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c;
                            payload.Opportunity__c = opp.Id;
                            //payload.Name = opp.Name;
                            
                            /* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                	payload.Name = opportunity_name_temp.substring(0,75);    
                                    crmXMLPayload.Name = opportunity_name_temp.substring(0,75); //LMS - 6575
                                    urbscnceXMLPayload.Name = opportunity_name_temp.substring(0,75); //LMS - 6575
                                  dspXMLPayload.Name = opportunity_name_temp.substring(0,75);
                                }else{
                                	payload.Name = opportunity_name_temp;    
                                    crmXMLPayload.Name = opportunity_name_temp; //LMS - 6575
                                    urbscnceXMLPayload.Name = opportunity_name_temp; //LMS - 6575
                                    dspXMLPayload.Name = opportunity_name_temp; 
                                }
                            }                            
                            /* For reducing the Length of Payload Name, we are checking the length */
                            /* Adding the whole response from CRM XML Payload */
                            payload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            /* Adding the whole response from CRM XML Payload */
                            
                           
                            crmXMLPayload.Opportunity__c = opp.Id; //LMS - 6575
                            urbscnceXMLPayload.Opportunity__c = opp.Id; //LMS - 6575
                            dspXMLPayload.Opportunity__c = opp.Id;
                            
                            crmXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c; //LMS - 6575
                            urbscnceXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c; //LMS - 6575
                            dspXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            
                            crmXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c; //LMS - 6575
                            urbscnceXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c; //LMS - 6575
                            
                          dspXMLPayload.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c; 
                            dspXMLPayload.DSP_Payload__c=acknwoledgementMap.get(opp.Opportunity_SF_ID__c).DSP_Payload__c;
                       
                            crmXMLPayloadToUpdate.add(crmXMLPayload);
                            
                            if(opp.LeadProvider_ID__r.Send_to_Urban_Science_Flag__c  && opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){
                                crmXMLPayloadToUpdate.add(urbscnceXMLPayload);
                            }
                            if(opp.Send_to_DSP__c){
                                     crmXMLPayloadToUpdate.add(dspXMLPayload);
                            }
                                     // system.debug('dspXMLPayload------->'+dspXMLPayload);
                            xmlpayloadToUpdate.add(payload);
                           // System.debug('Error Details : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c + ' : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c);
                            opp.Error_Details_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c; 
                          //opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);  
                            opp.Routing_Status__c = 'Success';
                            opp.Routing_Success_Date_Time__c = System.now();
                            opp.Routing_Error__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            routing_error_temp = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            if(routing_error_temp!=null){
                                if(routing_error_temp.length() > 255){
                                    routing_error_for_db = routing_error_temp.substring(0,255);    
                                }else{
                                    routing_error_for_db = routing_error_temp;
                                }
                            }
                            opp.Routing_Error_for_Dashboard__c = routing_error_for_db;
                            opportunityToUpdate.add(opp);
                        }else{
                            //System.debug('Error Details : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c + ' : '+acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c);
                            opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c;
                            /* New Code */
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.Routing_Status_Message__c = opp.Lead_Dealer_Acknowledgement_Status_Code__c+' - '+routingMessages.get(opp.Lead_Dealer_Acknowledgement_Status_Code__c).Routing_Message__c;
                                crmXMLPayload.Recipient_Status__c = opp.Lead_Dealer_Acknowledgement_Status_Code__c+' - '+routingMessages.get(opp.Lead_Dealer_Acknowledgement_Status_Code__c).Routing_Message__c;
                            }
                            /* New Code */
                            if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c != '' && ubroutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c)){
                                opp.Urban_Science_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                                urbscnceXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c).Routing_Message__c;
                            }
                            /* Urban Science Response */
                            if(opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){
                            opp.Response_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_Urban_Science__c;
                            }
                            /* Urban Science Response */
                           if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c != '' && ubroutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c)){
                                opp.DSP_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c).Routing_Message__c;
                                dspXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c).Routing_Message__c;
                            }
                            
                             String opportunity_Response_DSP = '';
                            
								opportunity_Response_DSP =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                            
                              if(opportunity_Response_DSP != null ){
                                if(opportunity_Response_DSP.length() > 255){
                               opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);
                                } else{
                                   opp.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                                }
                              }
                            /* Adding the CRM Payload to the custom object */
                            XML_Payload__c payload1 = new XML_Payload__c ();
                            //payload1.XML_Payload__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c;
                            payload1.Opportunity__c = opp.Id;
                            //payload1.Name = opp.Name; 
                            /* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                	payload1.Name = opportunity_name_temp.substring(0,75);    
                                    crmXMLPayload.Name = opportunity_name_temp.substring(0,75); //LMS - 6575
                                    urbscnceXMLPayload.Name = opportunity_name_temp.substring(0,75); //LMS - 6575
                                    dspXMLPayload.Name = opportunity_name_temp.substring(0,75);
                                }else{
                                	payload1.Name = opportunity_name_temp;    
                                    crmXMLPayload.Name = opportunity_name_temp; //LMS - 6575
                                    urbscnceXMLPayload.Name = opportunity_name_temp; //LMS - 6575
                                    dspXMLPayload.Name = opportunity_name_temp;
                                }
                            }                            
                            /* For reducing the Length of Payload Name, we are checking the length */
                            /* Adding the whole response from CRM XML Payload */
                            payload1.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            /* Adding the whole response from CRM XML Payload */
                            xmlpayloadToUpdate.add(payload1);
                            
                            crmXMLPayload.Opportunity__c = opp.Id; //LMS - 6575
                            urbscnceXMLPayload.Opportunity__c = opp.Id; //LMS - 6575
                            dspXMLPayload.Opportunity__c = opp.Id;
                            
                            crmXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c; //LMS - 6575
                            urbscnceXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c; //LMS - 6575
                            
                            crmXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c; //LMS - 6575
                            urbscnceXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c; //LMS - 6575
                            dspXMLPayload.CRM_XML_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_XML_Response__c;
                            
                            
                            crmXMLPayload.Opportunity_Routing_Response__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).CRM_Payload__c;
                            dspXMLPayload.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c; 
                            dspXMLPayload.DSP_Payload__c=acknwoledgementMap.get(opp.Opportunity_SF_ID__c).DSP_Payload__c;
              
                            crmXMLPayloadToUpdate.add(crmXMLPayload);
                            
                            if(opp.LeadProvider_ID__r.Send_to_Urban_Science_Flag__c  && opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){
                                crmXMLPayloadToUpdate.add(urbscnceXMLPayload);
                            }
                              if(opp.Send_to_DSP__c){
                               crmXMLPayloadToUpdate.add(dspXMLPayload);
                              }
                            
                            if(opp.Provider_Type__c != HELMSConstants.DealerOriginatedLead ){
                            opp.Sent_to_Urban_Science_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
                            opp.Error_Details_Urban_Science__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Error_Details_Urban_Science__c;
                            }
                          	opp.DSP_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c;
                            system.debug('LAvanya DSP_Status__c--------------->'+ acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c);
                           // opp.Response_DSP__c =opportunity_Response_DSP.substring(0,255);
                            opp.Routing_Status__c = 'Failure';   
                            opp.Routing_Failure_Date_Time__c = System.now();
                            opp.Routing_Error__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            routing_error_temp = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Routing_Error__c;
                            if(routing_error_temp!=null){
                                if(routing_error_temp.length() > 255){
                                    routing_error_for_db = routing_error_temp.substring(0,255);    
                                }else{
                                    routing_error_for_db = routing_error_temp;
                                }
                            }
                            opp.Routing_Error_for_Dashboard__c = routing_error_for_db;
                            opportunityToUpdate.add(opp);
                        }
                        
                    }
      
                    if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Initial_Walkin_Lead__c && acknwoledgementMap.containskey(opp.Opportunity_SF_ID__c) && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c != '' && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c != null ){

                        /* For Xml Payload Name Length issue */
                        String opportunity_name_temp = '';
                        /* For Xml Payload Name Length issue */
                        if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c == '0'){
                            opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c;
                            /* New Code */
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.DSP_Routing_Status_Message__c = '';
                            }

                          if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c != '' && dsproutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c)){
                                opp.DSP_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c).Routing_Message__c;
                                dspXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).	Sent_to_DSP_Status__c).Routing_Message__c;
                                opp.DSP_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c;
                            }
                           // system.debug('Sent_to_DSP_Status__c------->'+);
                            
                             String opportunity_Response_DSP = '';
                            
						 	opportunity_Response_DSP =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                            
                              if(opportunity_Response_DSP != null ){
                                if(opportunity_Response_DSP.length() > 255){
                               opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);
                                } else{
                                   opp.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                                }
                              }

                            opp.Send_to_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Send_to_DSP__c; 

                             XML_Payload__c payload = new XML_Payload__c ();

                            payload.Opportunity__c = opp.Id;
                            dspXMLPayload.Opportunity__c = opp.Id;

							/* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                    dspXMLPayload.Name = opportunity_name_temp.substring(0,75); 
                                }else{
                                    dspXMLPayload.Name = opportunity_name_temp; 
                                }
                            } 
                            
                            dspXMLPayload.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c; 
                            dspXMLPayload.DSP_Payload__c=acknwoledgementMap.get(opp.Opportunity_SF_ID__c).DSP_Payload__c;
                            crmXMLPayloadToUpdate.add(dspXMLPayload);
                          
                             if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c == '0'){
                            opp.Routing_Status__c = 'Success';
                            opp.Routing_Success_Date_Time__c = System.now();
                            } else if (acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c != '0'){
								opp.Routing_Status__c = 'Failure';
                            opp.Routing_Failure_Date_Time__c = System.now();
							}
                            
                            opportunityToUpdate.add(opp);
                        }else{
							opp.Lead_Dealer_Acknowledgement_Status_Code__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Status_Code__c;
                            if(routingMessages.containskey(opp.Lead_Dealer_Acknowledgement_Status_Code__c)){
                                opp.DSP_Routing_Status_Message__c = '';
                            }


                          if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c !=null && acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c != '' && dsproutingMessages.containskey(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c)){
                                opp.DSP_Routing_Response_Message__c =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c).Routing_Message__c;
                                dspXMLPayload.Recipient_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c+' - '+dsproutingMessages.get(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).	Sent_to_DSP_Status__c).Routing_Message__c;
                                opp.DSP_Status__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c;
                            }
                            
                            String opportunity_Response_DSP = '';
                            
								opportunity_Response_DSP =  acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                            
                              if(opportunity_Response_DSP != null ){
                                if(opportunity_Response_DSP.length() > 255){
                               opp.Response_DSP__c = opportunity_Response_DSP.substring(0,255);
                                } else{
                                   opp.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c;
                                }
                              }
                            
                            opp.Send_to_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Send_to_DSP__c; 

                             XML_Payload__c payload = new XML_Payload__c ();

                            dspXMLPayload.Opportunity__c = opp.Id;

                            /* For reducing the Length of Payload Name, we are checking the length */
                            opportunity_name_temp = opp.Name;
                            if(opportunity_name_temp != null ){
                                if(opportunity_name_temp.length() > 75){
                                    dspXMLPayload.Name = opportunity_name_temp.substring(0,75); 
                                }else{
                                    dspXMLPayload.Name = opportunity_name_temp; 
                                }
                            } 

                           dspXMLPayload.Response_DSP__c = acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Response_DSP__c; 
                           dspXMLPayload.DSP_Payload__c=acknwoledgementMap.get(opp.Opportunity_SF_ID__c).DSP_Payload__c;
                            
                            
                            crmXMLPayloadToUpdate.add(dspXMLPayload);
                            
                            if(acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c == '0'){
                            	opp.Routing_Status__c = 'Success';
                            	opp.Routing_Success_Date_Time__c = System.now();
                            } else if (acknwoledgementMap.get(opp.Opportunity_SF_ID__c).Sent_to_DSP_Status__c != '0'){
								opp.Routing_Status__c = 'Failure';
                            	opp.Routing_Failure_Date_Time__c = System.now();
							}
                            opportunityToUpdate.add(opp);
                        }
                
                }
                }
            }
            List<Lead_Dealer_Acknowledgement_ADF__e> errorOpportunities = new List<Lead_Dealer_Acknowledgement_ADF__e>();
            if(opportunityToUpdate.size() > 0){
              //  System.debug('Processing** : '+leadAcknowldgement);
                //update opportunityToUpdate;
                Database.SaveResult[] updateOppResults = Database.update(opportunityToUpdate,false);
                for (Integer i = 0; i < opportunityToUpdate.size(); i++) {
                    Database.SaveResult s = updateOppResults[i];
                    Lead_Dealer_Acknowledgement_ADF__e origRecord = leadAcknowldgement[0];
                   // System.debug('ORG** : '+origRecord);
                    if (!s.isSuccess()) {
                    //	System.debug('Not Submitted : '+origRecord);
                        errorOpportunities.add(origRecord);
                    }else{
                      //  System.debug('Submitted : '+origRecord);
            }
                }
            }
            //if(xmlpayloadToUpdate.size() > 0){
            if(crmXMLPayloadToUpdate.size() > 0){    

                Database.SaveResult[] insertXMLResults = Database.insert(crmXMLPayloadToUpdate,false);
                for (Integer i = 0; i < crmXMLPayloadToUpdate.size(); i++) {
                    Database.SaveResult s = insertXMLResults[i];
                    if (!s.isSuccess()) {
                        if(insertXMLResults.size()>0 ){
                        List<Database.Error> errors = insertXMLResults[i].getErrors(); //grab the error array from the SaveResult object
                            Logs__c  l =new Logs__c (name='XML payload insert Failure',Trigger_or_Class_Name__c='HELMSLeadDealerAssignmentADFHandler');
                            if(errors.size()>0){
                                l.Error_Message__c = errors[0].getMessage()+'XML Payload:'+insertXMLResults[i]; 
                            }else{
                                l.Error_Message__c = 'XML Payload:'+insertXMLResults[i];
                            }
            insert l;
                        }
                    }
                }
            }
            /* Opportunities whose Routing Status is not updated due to exception */
            if(errorOpportunities.size() > 0){
                HELMSLeadDealerAssignmentADFHandler.updateOpportunityRoutingCustomObject(errorOpportunities);
            }
            /* Opportunities whose Routing Status is not updated due to exception */
        }catch(Exception ex){
           
            Logs__c  l =new Logs__c (name='Lead routing failure',type__c='Lead routing failure',Trigger_or_Class_Name__c='HELMSLeadDealerAssignmentADFHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
             insert l;
        }
    }
    
    public static void updateOpportunityRoutingCustomObject(List<Lead_Dealer_Acknowledgement_ADF__e> opprts){
        try{
            List<Routing_Acknowledgement_No_Response__c> recList = new List<Routing_Acknowledgement_No_Response__c>();
            Routing_Acknowledgement_No_Response__c newRec = new Routing_Acknowledgement_No_Response__c();
            for(Lead_Dealer_Acknowledgement_ADF__e opp : opprts){
             	newRec.Status_Code__c = opp.Status_Code__c;
            	newRec.Sent_to_Urban_Science_Status__c = opp.Sent_to_Urban_Science_Status__c;
                newRec.Routing_Error__c = opp.Routing_Error__c;
                newRec.Response_Urban_Science__c = opp.Response_Urban_Science__c;
                newRec.Opportunity_SF_ID__c = opp.Oppotunity_SF_ID__c;
                newRec.Error_Details_Urban_Science__c = opp.Error_Details_Urban_Science__c;
                newRec.CRM_XML_Response__c = opp.CRM_XML_Response__c;
                newRec.CRM_Payload__c = opp.CRM_Payload__c;
                newRec.DSP_Status__c = opp.Sent_to_DSP_Status__c;
                newRec.Response_DSP__c = opp.Response_DSP__c;
                newRec.Initial_Walkin_Lead__c = opp.Initial_Walkin_Lead__c;
                newRec.Send_to_DSP__c = opp.Send_to_DSP__c;
                newRec.DSP_Payload__c = opp.DSP_Payload__c;
                recList.add(newRec);
            }
           // System.debug('recList 66 : '+recList);
            if(recList.size() > 0){
            	insert recList;    
            }
        }catch(Exception ex){
           Logs__c  l =new Logs__c (name='Update Opportunity Routing CustomObject',Trigger_or_Class_Name__c='HELMSLeadDealerAssignmentADFHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l; 
        }
    }
    
    public void updateOpportunityBlankResponse(List<Routing_Acknowledgement_No_Response__c> newOppotunityBlankResponse){
        /* New Code */
            Map < String, Routing_Status__mdt > routingMessages = new Map < String, Routing_Status__mdt>();
            for(Routing_Status__mdt fw: Routing_Status__mdt.getAll().values()){
                routingMessages.put(fw.Status_Code__c, fw);
                // system.debug(mapFilterWords);
            }
           // System.debug('routingMessages : '+routingMessages);
            /* New Code */
            
            Map < String, Urban_Science_Routing_Status__mdt > ubroutingMessages = new Map < String, Urban_Science_Routing_Status__mdt>();
            for(Urban_Science_Routing_Status__mdt urb: Urban_Science_Routing_Status__mdt.getAll().values()){
                ubroutingMessages.put(urb.Status_Code__c, urb);
                // system.debug(mapFilterWords);
            }
           // System.debug('ubroutingMessages : '+ubroutingMessages);
           // 
          Map < String, DSP_Routing_Status__mdt > dsproutingMessages = new Map < String, DSP_Routing_Status__mdt>();
            for(DSP_Routing_Status__mdt fw: DSP_Routing_Status__mdt.getAll().values()){
                dsproutingMessages.put(fw.Status_Code__c, fw);
            } 
        
    	Set<String> oppSFID = new Set<String>();
        Map<String,Routing_Acknowledgement_No_Response__c> mapRec = new Map<String,Routing_Acknowledgement_No_Response__c>();
        for(Routing_Acknowledgement_No_Response__c rec : newOppotunityBlankResponse){
        	oppSFID.add(rec.Opportunity_SF_ID__c);
            mapRec.put(rec.Opportunity_SF_ID__c,rec);
        }
       // System.debug('oppSFID : '+oppSFID);
      //  System.debug('mapRec : '+mapRec);
        List<Opportunity> oppRecToUpdate = new List<Opportunity>();
        List<XML_Payload__c> xmlpayloadToUpdate = new List<XML_Payload__c>();
        List<Opportunity> oppRecBlankResponse = [SELECT Id, Name,Provider_Type__c, Opportunity_SF_ID__c, Error_Details_Urban_Science__c,Initial_Walkin_Lead__c, Response_Urban_Science__c, Routing_Error__c, Sent_to_Urban_Science_Status__c, Lead_Dealer_Acknowledgement_Status_Code__c, DSP_Status__c, Response_DSP__c FROM Opportunity WHERE Opportunity_SF_ID__c IN : oppSFID FOR UPDATE];
       // System.debug(oppRecToUpdate);
        For(Opportunity opportunityRec : oppRecBlankResponse){
        	opportunityRec.Lead_Dealer_Acknowledgement_Status_Code__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Status_Code__c;
            opportunityRec.Sent_to_Urban_Science_Status__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Sent_to_Urban_Science_Status__c;
            /* New Code */
            if(routingMessages.containskey(opportunityRec.Lead_Dealer_Acknowledgement_Status_Code__c)){
            	opportunityRec.Routing_Status_Message__c = opportunityRec.Lead_Dealer_Acknowledgement_Status_Code__c+' - '+routingMessages.get(opportunityRec.Lead_Dealer_Acknowledgement_Status_Code__c).Routing_Message__c;
            }
            if(ubroutingMessages.containskey(opportunityRec.Sent_to_Urban_Science_Status__c)){
            	opportunityRec.Urban_Science_Routing_Response_Message__c =  opportunityRec.Sent_to_Urban_Science_Status__c+' - '+ubroutingMessages.get(opportunityRec.Sent_to_Urban_Science_Status__c).Routing_Message__c;
            }
            /* New Code */
            
              if(dsproutingMessages.containskey(opportunityRec.DSP_Status__c)){
               opportunityRec.DSP_Routing_Response_Message__c =  opportunityRec.DSP_Status__c+' - '+dsproutingMessages.get(opportunityRec.DSP_Status__c).Routing_Message__c;
              }
            
           	//opportunityRec.Response_DSP__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_DSP__c; CAPS - 2506
            
            /**CAPS 2506*/
               if(mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_DSP__c != null){
                if(mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_DSP__c.length() > 255){
                    opportunityRec.Response_DSP__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_DSP__c.substring(0,255);
                }else{
                    opportunityRec.Response_DSP__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_DSP__c;
                }                
                } 
            /**CAPS 2506*/     
       
            opportunityRec.Error_Details_Urban_Science__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Error_Details_Urban_Science__c;
            opportunityRec.Response_Urban_Science__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Response_Urban_Science__c;
            opportunityRec.Routing_Error__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Routing_Error__c;
            opportunityRec.Opportunity_SF_ID__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).Opportunity_SF_ID__c;
            if(mapRec.get(opportunityRec.Opportunity_SF_ID__c).Status_Code__c == '0'){
                opportunityRec.Routing_Status__c = 'Success';
                opportunityRec.Routing_Success_Date_Time__c = System.now();
            }else{
                opportunityRec.Routing_Status__c = 'Failure';
                opportunityRec.Routing_Failure_Date_Time__c = System.now();
            }
            XML_Payload__c payload1 = new XML_Payload__c ();
            //payload1.XML_Payload__c = mapRec.get(opportunityRec.Opportunity_SF_ID__c).CRM_Payload__c;
            payload1.Opportunity__c = opportunityRec.Id;
            /* For reducing the Length of Payload Name, we are checking the length */
            String opportunity_name_temp = '';
            opportunity_name_temp = opportunityRec.Name;
            if(opportunity_name_temp != null ){
            	if(opportunity_name_temp.length() > 75){
                	payload1.Name = opportunity_name_temp.substring(0,75);    
                }else{
                	payload1.Name = opportunity_name_temp;    
                }
            }                            
            /* For reducing the Length of Payload Name, we are checking the length */
            xmlpayloadToUpdate.add(payload1);
            oppRecToUpdate.add(opportunityRec);
         }
       //  System.debug('oppRecToUpdate : '+oppRecToUpdate);
         //if(oppRecToUpdate.size() > 0){
            //update(oppRecToUpdate);
         //}
         List<Logs__c> insertLogs = new List<Logs__c>();
         Set<String> customObjOppSFID = new Set<String>();
        	if(oppRecToUpdate.size()>0){
                upsert xmlpayloadToUpdate;
                Database.SaveResult[] results = Database.update(oppRecToUpdate,false);
              //  System.debug(' Updated updateOpportunity  $$$ :: '+oppRecToUpdate);
                for (Integer i = 0; i < oppRecToUpdate.size(); i++) {
                    Database.SaveResult s = results[i];
                    Opportunity origRecord = oppRecToUpdate[i]; 
                    if (!s.isSuccess()) {
                        for(Database.Error error : results[i].getErrors()) {
                           Logs__c  l =new Logs__c (SF_Rec_Id__c = oppRecToUpdate[i].Opportunity_SF_ID__c,name='ADF Handler',Trigger_or_Class_Name__c='HELMS Lead Dealer Assignment ADF Handler', Error_Message__c =error.getMessage()
                           //, Error_Fields__c =string.valueof(error.getFields() )  
                           );
                           insertLogs.add(l); 
                        } 
                    }else{
                        customObjOppSFID.add(origRecord.Opportunity_SF_ID__c);
                    }
                }
            }
        if(insertLogs.size() > 0){
        	insert insertLogs;
        }
        if(customObjOppSFID.size() > 0){
            updateRoutingNoAckResponse(customObjOppSFID);
        }
        
            
    }
    
    public void updateRoutingNoAckResponse(Set<String> str){
        List<Routing_Acknowledgement_No_Response__c> listToUpdate = new List<Routing_Acknowledgement_No_Response__c>();
        for (Routing_Acknowledgement_No_Response__c oppRec : [SELECT Id, Opportunity_SF_ID__c, IsProcessed__c FROM Routing_Acknowledgement_No_Response__c WHERE Opportunity_SF_ID__c IN : str FOR UPDATE]){
            oppRec.IsProcessed__c = true;
            listToUpdate.add(oppRec);
        }
        if(listToUpdate.size() > 0){
            update listToUpdate;
        }
    }
    
    public void newLeadDispositionADFs(List<Opportunity> opty){
       //System.debug('Inside Lead Disposition');
        try{
            List<Opportunity> updateOppList =  new List<Opportunity>();
            Map<String,Lead_Disposition_Last_Event_Status__c> custom = new Map<string,Lead_Disposition_Last_Event_Status__c>();
            Map<string , Dealer_Participation__c> dealerpatiLeist = new Map<string , Dealer_Participation__c>();
            Map<String , List<Opportunity_Additional_Attribute__c>> opptytoAttributesMap = new Map<String , List<Opportunity_Additional_Attribute__c>>();
            Map<String , String> IsAttriActvMap= new Map<String , String>();            
            
            Set<String> dealerSet=new Set<String>();
            Set<id> prdvrids=new Set<id>();
            Set<String> SubDivSet=new Set<String>();
            Set<String> opptyIds = new Set<String>();
            Set<String> dupoppidset = new Set<String>();
            for(Opportunity opp : opty){
                
                dealerSet.add(opp.PreferredDealerAccount_TXT__c);
                SubDivSet.add(opp.SubDiv_TXT__c);
                opptyIds.add(opp.Id);
                if(opp.LeadProvider_ID__c!=null)
                prdvrids.add(opp.LeadProvider_ID__c);
                if(opp.Duplicate_Similar__c==true || opp.Is_Third_Party_Duplicate__c==true){
                    dupoppidset.add(opp.Id);   
                }
                
            }
            Map<String , String> parentoppids = new Map<string, string>();
            for(Opportunity_Relations__c opprel: [Select id,New_Opportunity__c,Previous_Opportunity__r.Opportunity_SF_ID__c from Opportunity_Relations__c Where New_Opportunity__c IN: dupoppidset ]){
                parentoppids.put(opprel.New_Opportunity__c,opprel.Previous_Opportunity__r.Opportunity_SF_ID__c);
            }
            
            List<Lead_Additional_Attribute_Definition__c> ledAttriLst=[SELECT Id,Name, Shared_With_Dealer__c from Lead_Additional_Attribute_Definition__c ];
            for(Lead_Additional_Attribute_Definition__c ledAtrr: ledAttriLst){
                IsAttriActvMap.put(ledAtrr.Name,ledAtrr.Shared_With_Dealer__c);
            }           
            
            List<Opportunity_Additional_Attribute__c> oppAddAttributesList = [SELECT Id,Opportunity_Id__c,Definition_Name__r.Name,Attribute_Value__c FROM Opportunity_Additional_Attribute__c WHERE Opportunity_Id__c IN: opptyIds AND Definition_Name__r.Shared_With_Dealer__c = 'TRUE'];
            Map<id,account> accmap= new Map<Id, Account>([select id,name,Send_to_Urban_Science_Flag__c,Provider_Service_Name__c from account where id in :prdvrids ]);
            if(oppAddAttributesList.size() > 0){
                for(Opportunity_Additional_Attribute__c oppAttr : oppAddAttributesList){
                    if(!opptytoAttributesMap.containsKey(oppAttr.Opportunity_Id__c))
                        opptytoAttributesMap.put(oppAttr.Opportunity_Id__c,new List<Opportunity_Additional_Attribute__c>());
                    opptytoAttributesMap.get(oppAttr.Opportunity_Id__c).add(oppAttr);
                }                   
            }
            /** CAPS-895
            for(Dealer_Participation__c endpointdetails : [SELECT Id, CRM_System__c, Is_Active__c, Dealer_Subdivision__c,
                                                               Dealer_Subdivision__r.SubDiv_TXT__c, 
                                                               DealerAccount_ID__c, CRM_System__r.Name, 
                                                               CRM_System__r.CRM_AUTH_TYPE__c, 
                                                               CRM_System__r.CRM_BASIC_AUTH__c, 
                                                               CRM_System__r.CRM_FORMAT__c, 
                                                               CRM_System__r.CRM_HEADER_API_KEY__c,
                                                               CRM_System__r.CRM_PROTOCOL__c,
                                                               CRM_System__r.Endpoint_URL__c,
                                                           	   CRM_System__r.Receive_Lead_Updates__c,
                                                           	   DealerAccount_ID__r.Receive_Dealer_Updates__c
                                                               FROM Dealer_Participation__c 
                                                               WHERE Is_Active__c = true AND DealerAccount_ID__c IN : dealerSet 
                                                               AND Dealer_Subdivision__r.SubDiv_TXT__c IN : SubDivSet FOR UPDATE]){
                                                               
                dealerpatiLeist.put(endpointdetails.DealerAccount_ID__c +''+endpointdetails.Dealer_Subdivision__r.SubDiv_TXT__c , endpointdetails);                                              
            }
            */
            for(Dealer_Participation__c endpointdetails : [SELECT Id, CRM_System__c, Is_Active__c, Dealer_Subdivision__c,
                                                               Dealer_Subdivision__r.SubDiv_TXT__c, 
                                                               DealerAccount_ID__c, CRM_System__r.Name, 
                                                               CRM_System__r.CRM_AUTH_TYPE__c, 
                                                               CRM_System__r.CRM_BASIC_AUTH__c, 
                                                               CRM_System__r.CRM_FORMAT__c, 
                                                               CRM_System__r.CRM_HEADER_API_KEY__c,
                                                               CRM_System__r.CRM_PROTOCOL__c,
                                                               CRM_System__r.Endpoint_URL__c,
                                                           	   CRM_System__r.Receive_Lead_Updates__c,
                                                           	   DealerAccount_ID__r.Receive_Dealer_Updates__c
                                                               FROM Dealer_Participation__c 
                                                               WHERE Is_Active__c = true AND DealerAccount_ID__c IN : dealerSet]){
                                                               
                dealerpatiLeist.put(endpointdetails.DealerAccount_ID__c, endpointdetails);                                              
            }
            Map<id, Account> preferredobj = new map<id, Account>();
            for(Account a: [SELECT Id, Name, Phone FROM Account WHERE Id IN : dealerSet FOR UPDATE]){
                preferredobj.put(a.id, a);
            }
            
            for(Opportunity opp : opty){
                    Lead_Dealer_Assignment_ADF__e eve = new Lead_Dealer_Assignment_ADF__e();
                    // LMS- 5543 saikiran
                
                if(opp.LeadProvider_ID__c!=null ){
                    if(accmap.get(opp.LeadProvider_ID__c)!=null){
                        eve.Provider_Service__c = accmap.get(opp.LeadProvider_ID__c).Provider_Service_Name__c;
                        eve.Send_to_Urban_Science__c = accmap.get(opp.LeadProvider_ID__c).Send_to_Urban_Science_Flag__c;
                    }
                }   
                if(opp.LeadProvider_ID__c!=null ){
                    eve.Lead_Provider_Name__c = accmap.get(opp.LeadProvider_ID__c).name;
                    /*if(opp.Provider_Tool_Name__c != '' && opp.Provider_Tool_Name__c != null){
                        eve.Lead_Provider_Name__c += '-'+opp.Provider_Tool_Name__c;
                    }*/
                }else{
                    eve.Lead_Provider_Name__c = '';
                }
                if(opp.Provider_Tool_Name__c!=null && opp.Provider_Tool_Name__c != ''){
                    eve.Provider_Tool__c = opp.Provider_Tool_Name__c;
                  //  system.debug('opp.Provider_Tool_Name__c :'+opp.Provider_Tool_Name__c);
                }else{
                    eve.Provider_Tool__c = '';
                }
                if(opp.Provider_Type__c != null && opp.Provider_Type__c != ''){
                    eve.Provider_Type__c = opp.Provider_Type__c ;
                } else{
                    eve.Provider_Type__c = '';
                }
                if(opp.External_Lead_Reference_Number__c!=null && opp.External_Lead_Reference_Number__c != ''){
                    eve.External_Lead_Reference_Number__c = opp.External_Lead_Reference_Number__c;
                 //   system.debug('opp.External_Lead_Reference_Number__c :'+opp.External_Lead_Reference_Number__c);
                }else{
                    eve.External_Lead_Reference_Number__c = '';
                }
                    if(opp.Street_TXT__c!=null && opp.Street_TXT__c != ''){
                        eve.AddressLine1_TXT__c = opp.Street_TXT__c;
                    }else{
                        eve.AddressLine1_TXT__c = '';
                    }
                    if(opp.AddressType_TXT__c!=null && opp.AddressType_TXT__c != ''){
                        eve.AddressType_TXT__c = opp.AddressType_TXT__c;
                    }else{
                        eve.AddressType_TXT__c = '';
                    }
                    if(opp.AppartmentNumber_TXT__c!=null && opp.AppartmentNumber_TXT__c != ''){
                        eve.ApartmentNumber_NUM__c = opp.AppartmentNumber_TXT__c;
                    }else{
                        eve.ApartmentNumber_NUM__c = '';
                    }
                //dinesh
                if(opp.Chat_Transcript__c !=null && opp.Chat_Transcript__c != ''){
                    eve.Chat_Transcript__c = opp.Chat_Transcript__c;
                }
                //System.debug(' eve 2: '+eve);
                //dinesh
                    if(opp.BodyStyle_TXT__c!=null && opp.BodyStyle_TXT__c != ''){
                        eve.Body_Style_TXT__c = opp.BodyStyle_TXT__c;    
                    }else{
                        eve.Body_Style_TXT__c = '';
                    }
                    if(opp.City_TXT__c!=null && opp.City_TXT__c != ''){
                        eve.City_TXT__c = opp.City_TXT__c;   
                    }else{
                        eve.City_TXT__c = '';
                    }
                    if(opp.Color_XML__c!=null && opp.Color_XML__c != ''){
                    eve.Color_TXT__c = (opp.Color_XML__c).replace('"' , '\\"').replace('&','&amp;');
                    }else{
                        eve.Color_TXT__c = '';
                    }
                    if(opp.Condition_TXT__c!=null && opp.Condition_TXT__c != ''){
                        eve.Condition_TXT__c = opp.Condition_TXT__c; 
                    }else{
                        eve.Condition_TXT__c = '';
                    }
                	if(opp.PhoneType_NM__c!=null && opp.PhoneType_NM__c != ''){
                        if(opp.PhoneType_NM__c == 'home' || opp.PhoneType_NM__c == 'phone' || opp.PhoneType_NM__c == 'voice' || opp.PhoneType_NM__c == 'unknown'){
                        	eve.PhoneType_NM__c = 'voice';    
                        }else if(opp.PhoneType_NM__c == 'cellphone' || opp.PhoneType_NM__c == 'cell' || opp.PhoneType_NM__c == 'text'){
                            eve.PhoneType_NM__c = 'cellphone';
                        }else{
                            eve.PhoneType_NM__c = '';
                        }
                    }else{
                        eve.PhoneType_NM__c = '';
                    }
                    if(opp.ContactTime_TXT__c!=null && opp.ContactTime_TXT__c != ''){
                        eve.Contact_Time_TM__c = (opp.ContactTime_TXT__c).toLowerCase();
                    }else{
                        eve.Contact_Time_TM__c = '';
                    }
                    if(opp.ContactType_TXT__c!=null && opp.ContactType_TXT__c != ''){
                        eve.Contact_type_TXT__c = opp.ContactType_TXT__c;
                    }else{
                        eve.Contact_type_TXT__c = '';
                    }
                    if(opp.ContactMethod_TXT__c!=null && opp.ContactMethod_TXT__c != ''){
                        eve.ContactMethod_TXT__c = opp.ContactMethod_TXT__c;
                    }else{
                        eve.ContactMethod_TXT__c = '';
                    }
                     if(opp.Country_TXT__c!=null && opp.Country_TXT__c != ''){
                        eve.Country_TXT__c = opp.Country_TXT__c;
                    }else{
                        eve.Country_TXT__c = '';
                    }
                    if(opp.Customer_Ids_ID__c!=null && opp.Customer_Ids_ID__c != ''){
                        eve.Customer_IDs__c = opp.Customer_Ids_ID__c;
                    }else{
                        eve.Customer_IDs__c = '' ;
                    }
                
                	/* Modified the below as per suggested by Eshwar. We are replacing the Dealer_IDs__c value to whatever Preferred Dealer Number
                	 * received through Lead Enrichment process. - Syam Mohan */
                    /*if(opp.Dealer_Ids_ID__c!=null && opp.Dealer_Ids_ID__c!=''){
                        eve.Dealer_IDs__c = (opp.Dealer_Ids_ID__c).replace('"' , '\\"'); 
                    }else{
                        eve.Dealer_IDs__c = '<id>'+opp.PreferredDealerNumber_NUM__c+'</id>';
                    }*/
                	eve.Dealer_IDs__c = '<id>'+opp.PreferredDealerNumber_NUM__c+'</id>';
                	/* Modified the below as per suggested by Eshwar. We are replacing the Dealer_IDs__c value to whatever Preferred Dealer Number
                	 * received through Lead Enrichment process. - Syam Mohan */
                
                    
                    if(preferredobj.containskey(opp.PreferredDealerAccount_TXT__c)){
                        String prefDelName = '';
                        if((preferredobj.get(opp.PreferredDealerAccount_TXT__c)).Name != '' && (preferredobj.get(opp.PreferredDealerAccount_TXT__c)).Name != null){
                            prefDelName = (preferredobj.get(opp.PreferredDealerAccount_TXT__c)).Name.replaceAll('\'','') ;
                            //prefDelName = (preferredobj.get(opp.PreferredDealerAccount_TXT__c)).Name.replace('\'','\\\'');
                            
                        }
                        eve.DealerAccountfromADF_TXT__c = prefDelName;
                        eve.DealerContactfromADF_TXT__c = (preferredobj.get(opp.PreferredDealerAccount_TXT__c)).Phone;
                        /* Send Vendor Contact Details along with the Routing Request. 
                         * For now, we are adding dummy values. - Added by Syam Mohan */
                    
      if(opp.Vendor_Contact_Email__c != null && opp.Vendor_Contact_Email__c != ''){
                             eve.Vendor_Contact_Email__c = opp.Vendor_Contact_Email__c;
                            
                        } else{
                                 eve.Vendor_Contact_Email__c = 'none@email.com';
                        }
                        
                        if(opp.Vendor_Contact_Name__c != null && opp.Vendor_Contact_Name__c != ''){
                           eve.Vendor_Contact_Name__c = opp.Vendor_Contact_Name__c;
                        } else {
                        eve.Vendor_Contact_Name__c = 'NA';
                        } 
                        /* Send Vendor Contact Details along with the Routing Request. 
                         * For now, we are adding dummy values. - Added by Syam Mohan */
                    }else{
                        eve.DealerAccountfromADF_TXT__c = '';
                        eve.DealerContactfromADF_TXT__c = '';
                        eve.Vendor_Contact_Name__c = '';
                        eve.Vendor_Contact_Email__c = '';
                    }
                //System.debug(' eve 3: '+eve);
                /* Enrichment Section */
                String descr;
                descr = '';
                /*if(opp.Division_CD__c == 'M' && opp.SubDiv_TXT__c == 'Motorcycle'){ 
                    if(opp.PSPOwnershipStatus_TXT__c != null && opp.PSPOwnershipStatus_TXT__c != ''){
                        descr = descr + 'PSP Ownership Status : '+opp.PSPOwnershipStatus_TXT__c+'; ';  
                    }
                    if(opp.PSPCurrentProductsOwned_TXT__c != null && opp.PSPCurrentProductsOwned_TXT__c != ''){
                        descr = descr + 'PSP Current Products Owned : '+opp.PSPCurrentProductsOwned_TXT__c+'; ';
                    }
                    if(opp.PSPCurrentProductsOwned2_TXT__c != null && opp.PSPCurrentProductsOwned2_TXT__c != ''){
                        descr = descr + 'PSP Current Products Owned2 : '+opp.PSPCurrentProductsOwned2_TXT__c+'; '; 
                    }
                    
                    if(opp.PSPOwnershipStatusHousehold_TXT__c != null && opp.PSPOwnershipStatusHousehold_TXT__c != ''){
                        descr = descr + 'PSP Ownership Status Household : '+opp.PSPOwnershipStatusHousehold_TXT__c;
                    }
                }*/
                
                /* Powerequipment Division 
                if(opp.Division_CD__c == 'P' && opp.SubDiv_TXT__c == 'PowerEquipment'){  
                    if(opp.PEOwnershipStatus_TXT__c != null && opp.PEOwnershipStatus_TXT__c != ''){
                        descr = descr + 'PE Ownership Status : '+opp.PEOwnershipStatus_TXT__c+'; ';
                    }
                    if(opp.PECurrentProductsOwned_TXT__c != null && opp.PECurrentProductsOwned_TXT__c != ''){
                        descr = descr + 'PE Current Products Owned : '+opp.PECurrentProductsOwned_TXT__c+'; ';
                    }
                    if(opp.PEOwnershipStatusHousehold_TXT__c != null && opp.PEOwnershipStatusHousehold_TXT__c != ''){
                        descr = descr + 'PE Ownership Status Household : '+opp.PEOwnershipStatusHousehold_TXT__c;
                    }
                }
                 Powerequipment Division */
                
                /* Honda Division
                if(opp.Division_CD__c == 'A' && opp.SubDiv_TXT__c == 'Honda'){                  
                    if(opp.HondaOwnershipStatus_TXT__c != null && opp.HondaOwnershipStatus_TXT__c != ''){
                        descr = descr + 'Honda Ownership Status : '+opp.HondaOwnershipStatus_TXT__c+'; ';  
                    }
                    if(opp.HondaCurrentProductsOwned_TXT__c != null && opp.HondaCurrentProductsOwned_TXT__c != ''){
                        descr = descr +'Honda Current Products Owned : '+opp.HondaCurrentProductsOwned_TXT__c+'; ';  
                    }
                    if(opp.HondaCurrentProductsOwned2_TXT__c != null && opp.HondaCurrentProductsOwned2_TXT__c != ''){
                        descr = descr +'Honda Current Products Owned2 : '+opp.HondaCurrentProductsOwned2_TXT__c+'; ';  
                    }
                    if(String.Valueof(opp.HondaHighValueTrimlinePropensity_NUM__c) != null ){
                        descr = descr +'Honda Highvalue Timeline Propensity : '+opp.HondaHighValueTrimlinePropensity_NUM__c+'; ';  
                    }
                    if(opp.HondaOwnershipStatusHousehold_TXT__c != null && opp.HondaOwnershipStatusHousehold_TXT__c != ''){
                        descr = descr +'Honda Ownership Status Household : '+opp.HondaOwnershipStatusHousehold_TXT__c;  
                    } 
                }    
                Honda Division */
                
                /* Acura Division
                if(opp.Division_CD__c == 'B' && opp.SubDiv_TXT__c == 'Acura'){  
                    if(opp.AcuraOwnershipStatus_TXT__c != null && opp.AcuraOwnershipStatus_TXT__c != ''){
                        descr = descr + 'Acura Ownership Status : '+opp.AcuraOwnershipStatus_TXT__c+'; ';  
                    } 
                    if(opp.AcuraCurrentProductsOwned_TXT__c != null && opp.AcuraCurrentProductsOwned_TXT__c != ''){
                        descr = descr +'Acura Current Products Owned : '+opp.AcuraCurrentProductsOwned_TXT__c+'; ';  
                    } 
                    if(opp.AcuraCurrentProductsOwned2_TXT__c != null && opp.AcuraCurrentProductsOwned2_TXT__c != ''){
                        descr = descr +'Acura Current Products Owned2 : '+opp.AcuraCurrentProductsOwned2_TXT__c+'; ';  
                    } 
                    if(String.valueof(opp.AcuraHighValueTrimlinePropensity_NUM__c) != null ){
                        descr = descr +'Acura HighValue TrimlinePropensity : '+opp.AcuraHighValueTrimlinePropensity_NUM__c+'; ';  
                    } 
                    if(opp.AcuraOwnershipStatusHousehold_TXT__c != null && opp.AcuraOwnershipStatusHousehold_TXT__c != ''){
                        descr = descr +'Acura Ownership StatusHousehold : '+opp.AcuraOwnershipStatusHousehold_TXT__c;  
                    }
                }
                 Acura Division */
                /*if(String.valueof(opp.YourDealershipServicesLast60Mths_NUM__c) != null){
                    descr = descr + 'Dealership Services Last 60 Months : '+opp.YourDealershipServicesLast60Mths_NUM__c;  
                }
                if(String.valueof(opp.YourDealershipSvsSpentLast60Mth_NUM__c) != null ){
                    descr =descr + 'Dealership Svs Spent Last 60 Months : '+opp.YourDealershipSvsSpentLast60Mth_NUM__c;  
                }
                if(String.valueof(opp.DateofLastService_DT__c) != null ){
                    descr = descr + '; Date of Last Service : '+opp.DateofLastService_DT__c;  
                }
                if(opp.SalesRelatedDealerNumber__c != null && opp.SalesRelatedDealerNumber__c != ''){
                    descr = descr + '; Sales Related DealerNumber : '+opp.SalesRelatedDealerNumber__c;  
                }
                if(opp.ServiceRelatedDealerNumber__c != null && opp.ServiceRelatedDealerNumber__c != ''){
                    descr = descr + '; Service Related DealerNumber : '+opp.ServiceRelatedDealerNumber__c;  
                } */
                if(opp.ENR_CI_Ownership__c  != null && opp.ENR_CI_Ownership__c != ''){
                    descr = descr + ' Ownership: ' + opp.ENR_CI_Ownership__c; 
                }
                if(opp.ENR_CI_Ownership_Details__c  != null && opp.ENR_CI_Ownership_Details__c != ''){
                    descr = descr + ' Ownership Details: ' + opp.ENR_CI_Ownership_Details__c; 
                }
                if(opp.ENR_CI_Service_History__c    != null && opp.ENR_CI_Service_History__c != ''){
                    descr = descr + ' Service History: ' + opp.ENR_CI_Service_History__c; 
                }
                if(opp.ENR_CI_Children_in_Household__c  != null && opp.ENR_CI_Children_in_Household__c != ''){
                    descr = descr + ' Children in Household: ' + opp.ENR_CI_Children_in_Household__c; 
                }
                if(opp.ENR_CI_Event_Attendance__c   != null && opp.ENR_CI_Event_Attendance__c != ''){
                    descr = descr + ' Event Attendance: ' + opp.ENR_CI_Event_Attendance__c; 
                }
                if(opp.ENR_CI_Extended_Warranty__c  != null && opp.ENR_CI_Extended_Warranty__c != ''){
                    descr = descr + ' Extended Warranty: ' + opp.ENR_CI_Extended_Warranty__c; 
                }
                if(opp.ENR_CI_Likely_to_Buy_Acura__c    != null && opp.ENR_CI_Likely_to_Buy_Acura__c != ''){
                    descr = descr + ' Likely to Buy Acura: ' + opp.ENR_CI_Likely_to_Buy_Acura__c; 
                }
                if(opp.ENR_CI_Likely_to_Buy_Honda__c    != null && opp.ENR_CI_Likely_to_Buy_Honda__c != ''){
                    descr = descr + ' Likely to Buy Honda: ' + opp.ENR_CI_Likely_to_Buy_Honda__c; 
                }
                if(opp.ENR_CI_Likely_to_Buy_PSP__c  != null && opp.ENR_CI_Likely_to_Buy_PSP__c != ''){
                    descr = descr + ' Likely to Buy PSP: ' + opp.ENR_CI_Likely_to_Buy_PSP__c;
                } 
                //System.debug(' eve 40: '+eve);
                /* Enrichment Section */
                String attributeInfo = '';
                if(opptytoAttributesMap.get(opp.Id) != null && opptytoAttributesMap.get(opp.Id).size() > 0){
                    for(Opportunity_Additional_Attribute__c oppAttr : opptytoAttributesMap.get(opp.Id)){
                        if(!String.isBlank(oppAttr.Attribute_Value__c)){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains(oppAttr.Definition_Name__r.Name))
                                if(IsAttriActvMap.get(oppAttr.Definition_Name__r.Name)=='TRUE')
                            descr += +'; '+oppAttr.Definition_Name__r.Name + ' : '+oppAttr.Attribute_Value__c+'';
                            
                            attributeInfo += +'; '+oppAttr.Definition_Name__r.Name + ' : '+oppAttr.Attribute_Value__c+'';
                        }   
                    }
                }else{
                    if(opp.LeadAdditionalInfos__c != null && opp.LeadAdditionalInfos__c != ''){
                       
                    }
                }
                descr=descr.replaceall('<!\\[CDATA\\[','').replaceall('\\]\\]>','');
               // System.debug('opp.Description : '+opp.Description);
                    if(opp.Description!=null && opp.Description!=''){
                        
                         String oppDesc = opp.Description;
                        if(!string.isblank(oppDesc) && oppDesc.contains('<![CDATA[') ){
                         oppDesc = oppDesc.substringBetween('<![CDATA[',']]>');
                         oppDesc=oppDesc.replaceall('<!\\[CDATA\\[','').replaceall('\\]\\]>','');
                        }
                      //   system.debug('descriptioncdata'+oppDesc);
                         
                       if(descr!=null && descr!=''){
                            Blob blobData=Blob.valueOf((oppDesc+descr+';  ')); // added manually by Bijay
                            String encodedString = EncodingUtil.base64Encode(blobData);
                             //eve.Description_DESC__c = encodedString;
                            eve.ADF_Description_DESC__c = encodedString;
                         }else{
                             Blob blobData=Blob.valueOf(oppDesc);
                             String encodedString = EncodingUtil.base64Encode(blobData);
                                //eve.Description_DESC__c = encodedString;
                             eve.ADF_Description_DESC__c = encodedString;
                         }
                    }else{
                          if(descr!=null && descr!=''){
                             Blob blobData=Blob.valueOf(descr);
                             String encodedString = EncodingUtil.base64Encode(blobData);
                                 //eve.Description_DESC__c = encodedString;
                             eve.ADF_Description_DESC__c = encodedString;
                         }else{
                                //eve.Description_DESC__c = encodedString;
                             eve.ADF_Description_DESC__c = '';
                         }
                    } 
                
                Opportunity oppty = new Opportunity(Id= opp.Id);
                	if(!isRoutingBatchProcess){
                    	String DescriptionTemp = String.isNotBlank(opp.Description) ? opp.Description +' '+ attributeInfo  : attributeInfo;
                        oppty.Description = DescriptionTemp; 
                        oppty.Routing_Status__c = '';
                        oppty.RoutedDateTime__c = System.now();
                        /** CAPS-895
                         * if(dealerpatiLeist.size() > 0 && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c)){
                            oppty.Dealer_CRM_Vendor__c=dealerpatiLeist.Get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.Name;
                        }
                         */
                        if(dealerpatiLeist.size() > 0 && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c)){
                            oppty.Dealer_CRM_Vendor__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.Name;
                        }
                    }
                	if(isRoutingBatchProcess){
                        oppty.Routing_Status__c = 'Submitted for Re-Routing';
                        oppty.RoutedDateTime__c = System.now();

                        /** CAPS-895
                         * if(dealerpatiLeist.size() > 0 && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c)){
                            oppty.Dealer_CRM_Vendor__c=dealerpatiLeist.Get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.Name;
                        }
                         */
                        if(dealerpatiLeist.size() > 0 && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c)){
                            oppty.Dealer_CRM_Vendor__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.Name;
                        }
                    }
                updateOppList.add(oppty);
                if(opp.Division_CD__c!=null && opp.Division_CD__c!=''){
                    eve.Division_CD__c = opp.Division_CD__c;
                    }else{
                        eve.Division_CD__c = '';
                    }                    
                    if(opp.Doors_TXT__c!=null && opp.Doors_TXT__c!=''){
                        eve.Doors_TXT__c = opp.Doors_TXT__c;
                    }else{
                        eve.Doors_TXT__c = '';
                    } 
                    if(opp.Email__c!=null && opp.Email__c!=''){
                        eve.Email_TXT__c = opp.Email__c;
                    }else{
                        eve.Email_TXT__c = '';
                    } 
                    //eve.EventUuid = 
                    if(opp.Fax__c!=null && opp.Fax__c!=''){
                        eve.Fax_TXT__c = opp.Fax__c;
                    }else{
                        eve.Fax_TXT__c = '';
                    } 
                    if(opp.FinancialDetails_TXT__c !=null && opp.FinancialDetails_TXT__c !=''){
                        eve.Financial_Details_TXT__c = (opp.FinancialDetails_TXT__c).replace('"' , '\\"');
                    }else{
                        eve.Financial_Details_TXT__c = '';
                    }
                    if(opp.First_Name_TXT__c!=null && opp.First_Name_TXT__c!=''){
                        eve.FirstName_NM__c = opp.First_Name_TXT__c.replace('\\','').replace('+','').replace('"','');
                    }else{
                        eve.FirstName_NM__c = '';
                    } 
                    if(opp.Last_Name_TXT__c!=null && opp.Last_Name_TXT__c!=''){
                        eve.LastName_NM__c = opp.Last_Name_TXT__c.replace('\\','').replace('+','').replace('"','');
                    }else{
                        eve.LastName_NM__c = '';
                    } 
                    if(opp.Make_TXT__c!=null && opp.Make_TXT__c!=''){
                        eve.Make_TXT__c = opp.Make_TXT__c;
                    }else{
                        eve.Make_TXT__c = '';
                    } 
                    if(opp.Middle_Name_TXT__c!=null && opp.Middle_Name_TXT__c!=''){
                        eve.MiddleName_NM__c = opp.Middle_Name_TXT__c.replace('\\','').replace('+','').replace('"','');
                    }else{
                        eve.MiddleName_NM__c = '';
                    } 
                    if(opp.MiddlewareUUID__c!=null && opp.MiddlewareUUID__c!=''){
                        eve.MiddlewareUUID__c = opp.MiddlewareUUID__c;
                    }else{
                        eve.MiddlewareUUID__c = '';
                    } 
                    if(opp.MobilePhone__c!=null && opp.MobilePhone__c!=''){
                        eve.Mobile_TXT__c = opp.MobilePhone__c;
                    }else{
                        eve.Mobile_TXT__c = '';
                    } 
                    if(opp.Trim_TXT__c!=null && opp.Trim_TXT__c!=''){
                        Blob blobTrimTXT=Blob.valueOf(opp.Trim_TXT__c);
                        String trimTXTString = EncodingUtil.base64Encode(blobTrimTXT);
                        eve.Model_Trim_TXT__c = trimTXTString;
                    }else{
                        eve.Model_Trim_TXT__c = '';
                    } 
                    if(opp.Model_TXT__c!=null && opp.Model_TXT__c!=''){
                        Blob blobModelTXT=Blob.valueOf(opp.Model_TXT__c);
                        String modelTXTString = EncodingUtil.base64Encode(blobModelTXT);
                        eve.Model_TXT__c = modelTXTString;
                    }else{
                        eve.Model_TXT__c = '';
                    } 
                    if(String.valueof(opp.MSRP_AMT__c)!=null && String.valueof(opp.MSRP_AMT__c) != ''){
                        eve.MSRP_AMT__c = String.valueof(opp.MSRP_AMT__c);
                    }else{
                        eve.MSRP_AMT__c = '';
                    } 
                    if(opp.Name!=null && opp.Name!=''){
                        eve.Name_NM__c = '';
                        if(opp.First_Name_TXT__c!=null && opp.First_Name_TXT__c!=''){
                            eve.Name_NM__c =   opp.First_Name_TXT__c.replace('\\','').replace('+','').replace('"','')+' ';  
                        }
                        if(opp.Middle_Name_TXT__c!=null && opp.Middle_Name_TXT__c!=''){
                            eve.Name_NM__c +=   opp.Middle_Name_TXT__c.replace('\\','').replace('+','').replace('"','')+' ';  
                        }
                        if(opp.Last_Name_TXT__c!=null && opp.Last_Name_TXT__c!=''){
                            eve.Name_NM__c +=   opp.Last_Name_TXT__c.replace('\\','').replace('+','').replace('"','');  
                        }
                        
                    }else{
                        eve.Name_NM__c ='';
                    } 
                    if(opp.OdometerStatus_TXT__c!=null && opp.OdometerStatus_TXT__c!=''){
                        eve.Odometer_Status_TXT__c = opp.OdometerStatus_TXT__c;
                    }else{
                        eve.Odometer_Status_TXT__c = '';
                    } 
                    if(opp.Odometer_TXT__c!=null && opp.Odometer_TXT__c!=''){
                        eve.Odometer_TXT__c = opp.Odometer_TXT__c;
                    }else{
                        eve.Odometer_TXT__c = '';
                    } 
                    if(opp.OdometerUnits_TXT__c!=null && opp.OdometerUnits_TXT__c!=''){
                        eve.Odometer_Units_TXT__c = opp.OdometerUnits_TXT__c;
                    }else{
                        eve.Odometer_Units_TXT__c = '';
                    } 
                    if(opp.Opportunity_SF_ID__c!=null && opp.Opportunity_SF_ID__c!=''){
                        eve.Oppotunity_SF_ID__c = opp.Opportunity_SF_ID__c;
                    }else{
                        eve.Oppotunity_SF_ID__c = '';
                    } 
                    if(opp.Options_TXT__c!= null && opp.Options_TXT__c!= ''){
                        eve.Options_TXT__c = '<![CDATA['+(opp.Options_TXT__c).replace('"' , '\\"')+']]>';
                    }else{
                        eve.Options_TXT__c = '';
                    }
                    if(opp.OtherContacts_TXT__c!= null && opp.OtherContacts_TXT__c!= ''){
                        eve.OtherContacts_TXT__c = (opp.OtherContacts_TXT__c).replace('"' , '\\"');
                    }else{
                        eve.OtherContacts_TXT__c = '';
                    }
                    if(opp.OtherLeadProvider_TXT__c!= null && opp.OtherLeadProvider_TXT__c!= ''){                        
                        eve.OtherLeadProvider_TXT__c = (opp.OtherLeadProvider_TXT__c).replace('"' , '\\"').replace('&','&amp;').replace('<','&lt;').replace('>','&gt;');
                    }else{
                        eve.OtherLeadProvider_TXT__c = '';
                    }
                    if(opp.Pager_TXT__c!= null && opp.Pager_TXT__c!= ''){                        
                        eve.Pager_TXT__c = opp.Pager_TXT__c;
                    }else{
                        eve.Pager_TXT__c = '';
                    }
                    if(opp.Phone__c!= null && opp.Phone__c!= ''){                        
                        eve.Phone_TXT__c = opp.Phone__c;
                    }else{
                        eve.Phone_TXT__c = '';
                    }
                //LMS - 4898 - Syam Mohan
                if(opp.External_Lead_Reference_Number__c!=null && opp.External_Lead_Reference_Number__c!=''){
                    eve.External_Lead_Reference_Number__c = opp.External_Lead_Reference_Number__c;
                }else{
                    eve.External_Lead_Reference_Number__c='';
                }
                    
                //LMS - 4898 - Syam Mohan
                    if(opp.Prospect_Ids_ID__c!=null && opp.Prospect_Ids_ID__c!=''){
                        eve.Prospect_IDs__c = (opp.Prospect_Ids_ID__c).replace('"' , '\\"');
                    }else{
                        String prospectIdStr = '<id source="HELMS">'+opp.Opportunity_SF_ID__c+'</id>';
                        eve.Prospect_IDs__c = prospectIdStr.replace('"' , '\\"');
                    }
                    
                    if(opp.Provider_Ids_ID__c!=null && opp.Provider_Ids_ID__c!=''){
                        eve.Provider_IDs__c = (opp.Provider_Ids_ID__c).replace('"' , '\\"');
                    }else{
                        eve.Provider_IDs__c ='';
                    }
                    if(opp.ProviderContactDetail_TXT__c!=null && opp.ProviderContactDetail_TXT__c!=''){
                        //eve.ProviderContactDetails_TXT__c = opp.ProviderContactDetail_TXT__c;
                        eve.ProviderContactDetails_TXT__c = (opp.ProviderContactDetail_TXT__c).replace('"' , '\\"');
                    }else{
                        eve.ProviderContactDetails_TXT__c = '';
                    }
                    //LMS - 5448 Lead Provider and Lead Provider Tool to be concatenated when sending opportunities to Dealers
                    //saikiran
                    if(opp.ProviderDetail_TXT__c!=null && opp.ProviderDetail_TXT__c!=''){
                        eve.ProviderDetails_TXT__c = opp.ProviderDetail_TXT__c.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;');
                    }else{
                        eve.ProviderDetails_TXT__c = '';
                    }
                    //system.debug('LeadProvider_ID__c::::::::::::'+accmap.get(opp.LeadProvider_ID__c));                
                if(accmap.get(opp.LeadProvider_ID__c)!=null && eve.ProviderDetails_TXT__c!=null){
                    eve.ProviderDetails_TXT__c = (opp.ProviderDetail_TXT__c + ' ' +accmap.get(opp.LeadProvider_ID__c).name).replace('&','&amp;').replace('<','&lt;').replace('>','&gt;');
                 //system.debug('LeadProvider_ID__c::::::::::::'+opp.ProviderDetail_TXT__c + ' '+accmap.get(opp.LeadProvider_ID__c).name);  
                }else if(accmap.get(opp.LeadProvider_ID__c)!=null && eve.ProviderDetails_TXT__c==null){
                    eve.ProviderDetails_TXT__c = accmap.get(opp.LeadProvider_ID__c).name.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;');
                }
                
                if(opp.Provider_Tool_Name__c!=null && eve.ProviderDetails_TXT__c!=null){
                    eve.ProviderDetails_TXT__c = (opp.ProviderDetail_TXT__c + ' ' +opp.Provider_Tool_Name__c);
                    //system.debug('LeadProvider_ID__c::::::::::::'+opp.ProviderDetail_TXT__c + ' '+opp.Provider_Tool_Name__c); 
                }else if(opp.Provider_Tool_Name__c!=null && eve.ProviderDetails_TXT__c==null){
                    eve.ProviderDetails_TXT__c = opp.Provider_Tool_Name__c;
                }
                
                //system.debug('eve.ProviderDetails_TXT__c:::::::::::'+eve.ProviderDetails_TXT__c);
                
                  if(opp.Provider_Type__c !=null && eve.ProviderDetails_TXT__c!=null){
                    eve.ProviderDetails_TXT__c = (opp.ProviderDetail_TXT__c + ' ' +opp.Provider_Type__c);
                    //system.debug('LeadProvider_ID__c::::::::::::'+opp.ProviderDetail_TXT__c + ' '+opp.Provider_Tool_Name__c); 
                }else if(opp.Provider_Type__c!=null && eve.ProviderDetails_TXT__c==null){
                    eve.ProviderDetails_TXT__c = opp.Provider_Type__c;
                }
                
                    if(opp.PurchaseEarliestDate_DT__c!=null && opp.PurchaseEarliestDate_DT__c!=''){
                        eve.PurchaseEarliestDate_DT__c = opp.PurchaseEarliestDate_DT__c;
                    }else{
                        eve.PurchaseEarliestDate_DT__c = '';
                    }
                    if(opp.PurchaseHorizon_TXT__c!=null && opp.PurchaseHorizon_TXT__c!=''){
                        eve.PurchaseHorizon_TXT__c = opp.PurchaseHorizon_TXT__c;
                    }else{
                        eve.PurchaseHorizon_TXT__c = '';
                    }
                    if(opp.PurchaseLatestDate_DT__c!=null && opp.PurchaseLatestDate_DT__c!=''){
                        eve.PurchaseLatestDate_DT__c = opp.PurchaseLatestDate_DT__c;
                    }else{
                        eve.PurchaseLatestDate_DT__c = '';
                    }
                    if(String.valueof(opp.Quote_AMT__c) !=null && String.valueof(opp.Quote_AMT__c) !=''){
                        eve.Quote_AMT__c = String.valueof(opp.Quote_AMT__c);
                    }else{
                        eve.Quote_AMT__c = '';
                    }
                    if(opp.Source_Name__c!=null && opp.Source_Name__c!=''){
                        eve.SourceName_TXT__c = opp.Source_Name__c;
                    }else{
                        eve.SourceName_TXT__c = '';
                    }
                    if(opp.SourceUser_TXT__c!=null && opp.SourceUser_TXT__c!=''){
                        eve.SourceUser_TXT__c = opp.SourceUser_TXT__c;
                    }else{
                        eve.SourceUser_TXT__c = '';
                    }
                    if(opp.State_TXT__c!=null && opp.State_TXT__c!=''){
                        eve.State_TXT__c = opp.State_TXT__c;
                    }else{
                        eve.State_TXT__c = '';
                    }
                    if(opp.SubDiv_TXT__c!=null && opp.SubDiv_TXT__c!=''){
                        eve.SubDiv_TXT__c = opp.SubDiv_TXT__c;
                    }else{
                        eve.SubDiv_TXT__c = '';
                    }
                    if(opp.Suffix_TXT__c!=null && opp.Suffix_TXT__c!=''){
                        eve.Suffix_INIT__c = opp.Suffix_TXT__c;
                    }else{
                       eve.Suffix_INIT__c = '';
                    }
                	/* Sending the Stock Number while sending to Routing - Added by Syam */
                    if(opp.InventoryNumber_TXT__c != null && opp.InventoryNumber_TXT__c != ''){
                        eve.Stock_Number_NUM__c = opp.InventoryNumber_TXT__c;
                    }else{
                        eve.Stock_Number_NUM__c = '';
                    }
                	/* Sending the Stock Number while sending to Routing - Added by Syam */
                    //eve.Stock_Number_NUM__c
                    
                    if(opp.TradeBalanceOwed_TXT__c!=null && opp.TradeBalanceOwed_TXT__c!=''){
                        eve.TradeBalanceOwed_TXT__c = opp.TradeBalanceOwed_TXT__c;
                    }else{
                       eve.TradeBalanceOwed_TXT__c = '';
                    }
                    if(opp.TradeMake_TXT__c!=null && opp.TradeMake_TXT__c!=''){
                        eve.TradeMake_TXT__c = opp.TradeMake_TXT__c;
                    }else{
                       eve.TradeMake_TXT__c = '';
                    }
                    if(opp.TradeMileage_TXT__c!=null && opp.TradeMileage_TXT__c!=''){
                        eve.TradeMileage_TXT__c = opp.TradeMileage_TXT__c;
                    }else{
                       eve.TradeMileage_TXT__c = '';
                    }
                    if(opp.TradeModel_TXT__c!=null && opp.TradeModel_TXT__c!=''){
                        eve.TradeModel_TXT__c = opp.TradeModel_TXT__c;
                    }else{
                       eve.TradeModel_TXT__c = '';
                    }
                    if(opp.TradeStatus_TXT__c!=null && opp.TradeStatus_TXT__c!=''){
                        eve.TradeStatus_TXT__c = opp.TradeStatus_TXT__c;
                    }else{
                       eve.TradeStatus_TXT__c = '';
                    }
                    if(opp.TradeValue_TXT__c!=null && opp.TradeValue_TXT__c!=''){
                        eve.TradeValue_TXT__c = opp.TradeValue_TXT__c;
                    }else{
                       eve.TradeValue_TXT__c = '';
                    }
                    if(opp.TradeYear_YR__c!=null && opp.TradeYear_YR__c!='0' && opp.TradeYear_YR__c!=''){
                        eve.TradeYear_YR__c = opp.TradeYear_YR__c;
                    }else{
                       //eve.TradeYear_YR__c ='0';
                       eve.TradeYear_YR__c = '';
                    }
                   // if(opp.TransactionCode_CD__c!=null && opp.TransactionCode_CD__c!=''){
                   //     eve.TransactionCode_CD__c = opp.TransactionCode_CD__c;
                   // }else{
                   //    eve.TransactionCode_CD__c = '';
                   // } 
                    if(opp.Transmission_TXT__c!=null && opp.Transmission_TXT__c!=''){
                        eve.Transmission_TXT__c = opp.Transmission_TXT__c;
                    }else{
                       eve.Transmission_TXT__c = '';
                    }
                    if(opp.TriggerTypeCode__c!=null && opp.TriggerTypeCode__c!=''){
                        eve.Trigger_type_Code__c = opp.TriggerTypeCode__c;
                    }else{
                       eve.Trigger_type_Code__c = '';
                    }
                    if(String.valueof(opp.TriggerSendbyDate_DT__c)!=null && String.valueof(opp.TriggerSendbyDate_DT__c)!=''){
                        eve.TriggerSendbyDate_DT__c = String.valueof(opp.TriggerSendbyDate_DT__c);
                    }else{
                       eve.Trigger_type_Code__c = '';
                    }
                    if(opp.Vehicle_Ids_ID__c!=null && opp.Vehicle_Ids_ID__c!=''){
                        eve.Vehicle_IDs__c = (opp.Vehicle_Ids_ID__c).replace('"' , '\\"');
                    }else{
                        eve.Vehicle_IDs__c = '';
                    }
                    if(opp.VehicleInterest_TXT__c!=null && opp.VehicleInterest_TXT__c!=''){
                        eve.Vehicle_Interest_TXT__c = opp.VehicleInterest_TXT__c;
                    }else{
                        eve.Vehicle_Interest_TXT__c = '';
                    }
                    if(opp.VehicleStatus_TXT__c!=null && opp.VehicleStatus_TXT__c!=''){
                        eve.Vehicle_Status_TX__c = opp.VehicleStatus_TXT__c;
                    }else{
                        eve.Vehicle_Status_TX__c = '';
                    }
                    if(opp.Number_NM__c!=null && opp.Number_NM__c!=''){
                        eve.Vin_Number_NUM__c = opp.Number_NM__c;
                    }else{
                        eve.Vin_Number_NUM__c = '';
                    }
                    if(opp.Year_YR__c!=null && opp.Year_YR__c!=''){
                        eve.Year_YR__c = integer.valueof(opp.Year_YR__c);
                    }else{
                        eve.Year_YR__c = 0;
                    }
                    if(opp.ZipCode_TXT__c!=null && opp.ZipCode_TXT__c!=''){
                        eve.ZipCode_TXT__c = opp.ZipCode_TXT__c;
                    }else{
                        eve.ZipCode_TXT__c  ='';
                    }
                
                    /* Send only to Urban Science. Added by Syam Mohan */
                    if(opp.SendOnlyToUrbanScience__c){
                        eve.SendOnlyToUrbanScience__c = opp.SendOnlyToUrbanScience__c;
                    }else{
                        eve.SendOnlyToUrbanScience__c = false;
                    }
                    /* Send only to Urban Science. Added by Syam Mohan */
                    //System.debug('Beofe LOO **');
                    /* Adding EndPoint URL, Protocol, Header API Key etc. tp PE. */
                    if(opp.SendOnlyToUrbanScience__c){
                         eve.CRM_AUTH_TYPE__c = '';
                        eve.CRM_BASIC_AUTH__c = '';
                        eve.CRM_FORMAT__c = '';
                        eve.CRM_HEADER_API_KEY__c = '';
                        eve.CRM_PROTOCOL__c = '';
                        eve.CRM_ENDPOINT__c = '';
                    }
                    /** CAPS-895 Lee
                     * if(!opp.SendOnlyToUrbanScience__c  && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c) && dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__c != null ){
                        eve.CRM_AUTH_TYPE__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.CRM_AUTH_TYPE__c;
                        eve.CRM_BASIC_AUTH__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.CRM_BASIC_AUTH__c;
                        eve.CRM_FORMAT__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.CRM_FORMAT__c;
                        eve.CRM_HEADER_API_KEY__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.CRM_HEADER_API_KEY__c;
                        eve.CRM_PROTOCOL__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.CRM_PROTOCOL__c;
                        eve.CRM_ENDPOINT__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.Endpoint_URL__c;
                    }
                     */                  
                    if(!opp.SendOnlyToUrbanScience__c  && dealerpatiLeist.containskey(opp.PreferredDealerAccount_TXT__c) && dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__c != null ){
                        
                        eve.CRM_AUTH_TYPE__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.CRM_AUTH_TYPE__c;
                        eve.CRM_BASIC_AUTH__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.CRM_BASIC_AUTH__c;
                        eve.CRM_FORMAT__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.CRM_FORMAT__c;
                        eve.CRM_HEADER_API_KEY__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.CRM_HEADER_API_KEY__c;
                        eve.CRM_PROTOCOL__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.CRM_PROTOCOL__c;
                        eve.CRM_ENDPOINT__c = dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.Endpoint_URL__c;
                    }
                //LMS-5602 Vamshi
                String commentsVal = '';
                if(opp.LeadAdditionalInfos__c != null && opp.LeadAdditionalInfos__c != ''){
                        String addInfo = opp.LeadAdditionalInfos__c;
                    String comments = '';
                        //System.debug('addInfo 55 : '+addInfo);
                        
                        if(addInfo.contains('<LeadAdditionalInfo key="VehicleComment">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('VehicleComment'))
                                if(IsAttriActvMap.get('VehicleComment')=='TRUE') {  
                            comments = comments +  'VehicleComment: '+ addInfo.substringBetween('<LeadAdditionalInfo key="VehicleComment">','</LeadAdditionalInfo>');
                                    
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="CustomerComment">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('CustomerComment'))
                                if(IsAttriActvMap.get('CustomerComment')=='TRUE'){
                            comments = comments +  'CustomerComment: '+ addInfo.substringBetween('<LeadAdditionalInfo key="CustomerComment">','</LeadAdditionalInfo>');
                             
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Models Selected">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('Models Selected'))
                                if(IsAttriActvMap.get('Models Selected')=='TRUE'){
                            comments = comments +  'Models Selected: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Models Selected">','</LeadAdditionalInfo>');
                                     
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="AdditionalInfo">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('AdditionalInfo'))
                                if(IsAttriActvMap.get('AdditionalInfo')=='TRUE'){
                            comments = comments +  'AdditionalInfo: '+ addInfo.substringBetween('<LeadAdditionalInfo key="AdditionalInfo">','</LeadAdditionalInfo>');
                                       
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="visitNotes">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('visitNotes'))
                                if(IsAttriActvMap.get('visitNotes')=='TRUE'){
                            comments = comments +  'visitNotes: '+ addInfo.substringBetween('<LeadAdditionalInfo key="visitNotes">','</LeadAdditionalInfo>');
                                      
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="originationUrl">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('originationUrl'))
                                if(IsAttriActvMap.get('originationUrl')=='TRUE'){
                            comments = comments +  'originationUrl: '+ addInfo.substringBetween('<LeadAdditionalInfo key="originationUrl">','</LeadAdditionalInfo>');
                                      
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="transcript">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('transcript'))
                                if(IsAttriActvMap.get('transcript')=='TRUE'){
                            comments = comments +  'transcript: '+ addInfo.substringBetween('<LeadAdditionalInfo key="transcript">','</LeadAdditionalInfo>');
                                       
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="DepositConfirmationNumber">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('DepositConfirmationNumber'))
                                if(IsAttriActvMap.get('DepositConfirmationNumber')=='TRUE'){
                            comments = comments +  'DepositConfirmationNumber: '+ addInfo.substringBetween('<LeadAdditionalInfo key="DepositConfirmationNumber">','</LeadAdditionalInfo>');
                                     
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="PriceComment">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('PriceComment'))
                                if(IsAttriActvMap.get('PriceComment')=='TRUE'){
                            comments = comments +  'PriceComment: '+ addInfo.substringBetween('<LeadAdditionalInfo key="PriceComment">','</LeadAdditionalInfo>');
                                      
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="Comment">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('Comment'))
                                if(IsAttriActvMap.get('Comment')=='TRUE'){
                            comments = comments +  'Comment: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Comment">','</LeadAdditionalInfo>');
                                       
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Customer Preferred Contact Method">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('Customer Preferred Contact Method'))
                                if(IsAttriActvMap.get('Customer Preferred Contact Method')=='TRUE'){
                            comments = comments +  'Customer Preferred Contact Method: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Customer Preferred Contact Method">','</LeadAdditionalInfo>');
                                       
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="UserComments">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('UserComments'))
                                if(IsAttriActvMap.get('UserComments')=='TRUE'){
                            comments = comments +  'UserComments: '+ addInfo.substringBetween('<LeadAdditionalInfo key="UserComments">','</LeadAdditionalInfo>');
                                       
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="special_description">')){
                            comments = comments +  'special_description: '+ addInfo.substringBetween('<LeadAdditionalInfo key="special_description">','</LeadAdditionalInfo>');
                              
                                
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="special_short_description">')){
                            comments = comments +  'special_short_description: '+ addInfo.substringBetween('<LeadAdditionalInfo key="special_short_description">','</LeadAdditionalInfo>');
                               
                                
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Id">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('Offer Id'))
                                if(IsAttriActvMap.get('Offer Id')=='TRUE'){
                            comments = comments +  'Offer Id: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Offer Id">','</LeadAdditionalInfo>');
                                      
                                }
                            } 
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Name">')){
                            if(IsAttriActvMap!=null && IsAttriActvMap.keyset().contains('Offer Name'))
                                if(IsAttriActvMap.get('Offer Name')=='TRUE'){
                            comments = comments +  'Offer Name: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Offer Name">','</LeadAdditionalInfo>');
                                       
                                }
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Type">')){
                            comments = comments +  'Offer Type: '+ addInfo.substringBetween('<LeadAdditionalInfo key="Offer Type">','</LeadAdditionalInfo>');
                              
                                
                            }
                        if(addInfo.contains('<LeadAdditionalInfo key="OfferName">')){
                            comments = comments +  'OfferName: '+ addInfo.substringBetween('<LeadAdditionalInfo key="OfferName">','</LeadAdditionalInfo>');
                              
                                
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="end_date">')){
                            comments = comments +  'end_date: '+ addInfo.substringBetween('<LeadAdditionalInfo key="end_date">','</LeadAdditionalInfo>');
                               
                                
                    }
                     //manually added semicolon- Bijay 
                    commentsVal = comments+';  ';
                }
                String depositString = '';
                    if(opp.Deposit_Confirmation_Number__c!=null && opp.Deposit_Confirmation_Number__c != ''){
                     depositString = depositString+ 'Deposit Confirmation Number:'+ opp.Deposit_Confirmation_Number__c +';';
                    }
                    if(opp.Deposit_Sales_Order_Number__c!=null && opp.Deposit_Sales_Order_Number__c != ''){
                	depositString = depositString+ 'Deposit Sales Order Number:'+ opp.Deposit_Sales_Order_Number__c+';';
                    }
                    if( opp.DEPOSIT_AMOUNT__c != null ){
                	depositString = depositString+ 'Deposit Amount: '+ opp.DEPOSIT_AMOUNT__c+';';
                }
                //5408
                  if( opp.Einstein_Predicted_Priority__c != null ){
                    depositString = depositString+ 'Einstein Predicted Priority: '+ opp.Einstein_Predicted_Priority__c+';';
                }
                if(depositString != ''){
                   commentsVal = commentsVal + depositString+';';
                }
                
                if(opp.Is_Third_Party_Duplicate__c==TRUE){
                    if(parentoppids.containsKey(opp.Id)){
                        parentoppids.get(opp.Id);
                        commentsVal = commentsVal +'This lead is a potential duplicate of a brand site lead: '+parentoppids.get(opp.Id)+';';
                      //  system.debug('potential duplicate:'+parentoppids.get(opp.Id));
                    }
                    
                }
                if(opp.Duplicate_Similar__c==TRUE){
                    if(parentoppids.containsKey(opp.Id)){
                        parentoppids.get(opp.Id);
                        commentsVal = commentsVal +'This lead is a potential duplicate of lead : '+parentoppids.get(opp.Id)+';';
                     //   system.debug('potential duplicate:'+parentoppids.get(opp.Id));
                    }
                    
                } 
                /*
                commentsVal = commentsVal +'Third Party Duplicate Lead: '+opp.Is_Third_Party_Duplicate__c+';';
                commentsVal = commentsVal +'Duplicate Similar Lead: '+opp.Duplicate_Similar__c;

                */
                if(opp.Source_Unique_ID__c != null){
                    commentsVal = commentsVal + 'Source Unique Id/AlternateDocumentID: '+opp.Source_Unique_ID__c+';';
                    if(opp.Appointment_Date_and_Time__c != null)
                    commentsVal = commentsVal + 'Appointment Date and Time : '+ opp.Appointment_Date_and_Time__c+';';
                    if(opp.Appointment_Id__c != null)
                    commentsVal = commentsVal + 'Appointment ID : ' + opp.Appointment_Id__c+';';
                    if(opp.Appointment_Location__c != null)
                    commentsVal = commentsVal + 'Appointment Location : ' + opp.Appointment_Location__c+ '; ';
                    if(opp.Appointment_Notes__c != null)
                    commentsVal = commentsVal + 'Appointment Notes : ' + opp.Appointment_Notes__c + '; ';
                    if(opp.Appointment_type__c != null)
                    commentsVal = commentsVal + 'Appointment Type : '+ opp.Appointment_type__c + '; ';
                    if(opp.Deal_ID__c != null)
                    commentsVal = commentsVal + 'Deal ID : '+ opp.Deal_ID__c + '; ';
                    if(opp.Deal_Link__c != null)
                    commentsVal = commentsVal + 'Deal Link : '+ opp.Deal_Link__c + '; ';
                    if(opp.Contact_person__c != null)
                    commentsVal = commentsVal + ' Contact Person : '+ opp.Contact_person__c + ';';
                }
                
                /* --- changes are updated by GLavanya - DSP - DS-3227 - start ---------*/  
                
				if(opp.ENR_CI_Ownership__c != null)
                    commentsVal = commentsVal + ' Customer Insight Ownership : '+ opp.ENR_CI_Ownership__c + ';';
				
				if(opp.ENR_CI_Ownership_Details__c != null)
                    commentsVal = commentsVal + ' Customer Insight Ownership Details : '+ opp.ENR_CI_Ownership_Details__c + ';';
				
				if(opp.ENR_CI_Service_History__c != null)
                    commentsVal = commentsVal + ' Customer Insight Service History : '+ opp.ENR_CI_Service_History__c + ';';
				
				if(opp.ENR_CI_Extended_Warranty__c != null)
                    commentsVal = commentsVal + ' Customer Insight Extended Warranty : '+ opp.ENR_CI_Extended_Warranty__c + ';';
				
				if(opp.ENR_CI_Event_Attendance__c != null)
                    commentsVal = commentsVal + ' Customer Insight Event Attendance : '+ opp.ENR_CI_Event_Attendance__c + ';';
				
				if(opp.ENR_CI_Likely_to_Buy_Acura__c != null)
                    commentsVal = commentsVal + ' Customer Insight Likely to Buy Acura : '+ opp.ENR_CI_Likely_to_Buy_Acura__c + ';';
				
				if(opp.ENR_CI_Likely_to_Buy_Honda__c != null)
                    commentsVal = commentsVal + ' Customer Insight Likely to Buy Honda : '+ opp.ENR_CI_Likely_to_Buy_Honda__c + ';';
				
				if(opp.ENR_CI_Likely_to_Buy_PSP__c != null)
                    commentsVal = commentsVal + ' Customer Insight Likely to Buy PSP : '+ opp.ENR_CI_Likely_to_Buy_PSP__c + ';';
				
				if(opp.ENR_CI_Children_in_Household__c != null)
                    commentsVal = commentsVal + ' Customer Insight Children in Household : '+ opp.ENR_CI_Children_in_Household__c + ';';
				
                /* --- changes are updated by GLavanya - DSP - DS-3227 - End ---------*/ 
                  
                  
    			commentsVal = commentsVal.replaceall('<!\\[CDATA\\[','').replaceall('\\]\\]>','');
                                
                Blob blobCmtData=Blob.valueOf(commentsVal);
                String encodedString = EncodingUtil.base64Encode(blobCmtData);
                if(commentsVal != ''){
                //   eve.Comment__c =  encodedString;
                eve.ADF_Comment__c = encodedString;
                }
                /*Start - Star Implementation*/
                if(opp.ENR_CI_Service_History__c!=null && opp.ENR_CI_Service_History__c!=''){
                        eve.Customer_Insight_Service_History__c = opp.ENR_CI_Service_History__c;
                    }else{
                        eve.Customer_Insight_Service_History__c = '';
                    }
                
                if(opp.DMGR_Environmental_Issues__c==true ){
                        eve.Environmental_Issues__c = true;
                    }else{
                        eve.Environmental_Issues__c = false;
                    }
                
                if(opp.DMGR_Green_Living__c==true ){
                        eve.Green_Living__c = true;
                    }else{
                        eve.Green_Living__c = false;
                    }
                
                if(opp.DMGR_Baseball__c==true ){
                        eve.Baseball__c = true;
                    }else{
                        eve.Baseball__c = false;
                    }
                
                if(opp.DMGR_Basketball__c==true ){
                        eve.Basketball__c = true;
                    }else{
                        eve.Basketball__c = false;
                    }
                
                if(opp.DMGR_Football__c==true ){
                        eve.Football__c = true;
                    }else{
                        eve.Football__c = false;
                    }
                
                if(opp.DMGR_US_Travel__c==true ){
                        eve.US_Travel__c = true;
                    }else{
                        eve.US_Travel__c = false;
                    }
                
                if(opp.DMGR_Hockey__c==true ){
                        eve.Hockey__c = true;
                    }else{
                        eve.Hockey__c = false;
                    }
                
                if(opp.DMGR_Skiing__c==true ){
                        eve.Skiing__c = true;
                    }else{
                        eve.Skiing__c = false;
                    }
                
                if(opp.DMGR_Golf__c==true ){
                        eve.Golf__c = true;
                    }else{
                        eve.Golf__c = false;
                    }
                
                if(opp.DMGR_Vehicle_Known_Owned__c==true ){
                        eve.Vehicle_Known_Owned__c = true;
                    }else{
                        eve.Vehicle_Known_Owned__c = false;
                    }
                
                if(opp.DMGR_Age__c!=null ){
                        eve.Age__c = opp.DMGR_Age__c;
                    }else{
                        eve.Age__c = null;
                    }
                
                if(opp.DMGR_Income__c!=null && opp.DMGR_Income__c!=''){
                        eve.Income__c = opp.DMGR_Income__c;
                    }else{
                        eve.Income__c = '';
                    }
                
                if(opp.DMGR_Children__c!=null && opp.DMGR_Children__c!=''){
                        eve.Children__c = opp.DMGR_Children__c;
                    }else{
                        eve.Children__c = '';
                    }
                
                if(opp.DMGR_Income_Estate_HHLD_Higher_Ranges__c!=null && opp.DMGR_Income_Estate_HHLD_Higher_Ranges__c!=''){
                        eve.Income_Estate_HHLD_Higher_Ranges__c = opp.DMGR_Income_Estate_HHLD_Higher_Ranges__c;
                    }else{
                        eve.Income_Estate_HHLD_Higher_Ranges__c = '';
                    }
                
                if(opp.DMGR_Marital_Status__c!=null && opp.DMGR_Marital_Status__c!=''){
                        eve.Marital_Status__c = opp.DMGR_Marital_Status__c;
                    }else{
                        eve.Marital_Status__c = '';
                    }
                
                if(opp.DMGR_Occupation__c!=null && opp.DMGR_Occupation__c!=''){
                        eve.Occupation__c = opp.DMGR_Occupation__c;
                    }else{
                        eve.Occupation__c = '';
                    }
                
                if(opp.DMGR_Home_Owner_or_Renter__c!=null && opp.DMGR_Home_Owner_or_Renter__c!=''){
                        eve.Home_Owner_or_Renter__c = opp.DMGR_Home_Owner_or_Renter__c;
                    }else{
                        eve.Home_Owner_or_Renter__c = '';
                    }
                
                if(opp.DMGR_Occupation_Detailed__c!=null && opp.DMGR_Occupation_Detailed__c!=''){
                        eve.Occupation_Detailed__c = opp.DMGR_Occupation_Detailed__c;
                    }else{
                        eve.Occupation_Detailed__c = '';
                    }
                
                if(opp.DMGR_Household_Size__c!=null){
                        eve.Household_Size__c = opp.DMGR_Household_Size__c;
                    }else{
                        eve.Household_Size__c = null;
                    }
                
                if(opp.DMGR_Education_Level__c!=null && opp.DMGR_Education_Level__c!=''){
                        eve.Education_Level__c = opp.DMGR_Education_Level__c;
                    }else{
                        eve.Education_Level__c = '';
                    }
                
                if(opp.ENR_CI_Ownership__c!=null && opp.ENR_CI_Ownership__c!=''){
                        eve.Customer_Insight_Ownership__c = opp.ENR_CI_Ownership__c;
                    }else{
                        eve.Customer_Insight_Ownership__c = '';
                    }
                
                if(opp.ENR_CI_Event_Attendance__c!=null && opp.ENR_CI_Event_Attendance__c!=''){
                        eve.Customer_Insight_Event_Attendance__c = opp.ENR_CI_Event_Attendance__c;
                    }else{
                        eve.Customer_Insight_Event_Attendance__c = '';
                    }
                
                if(opp.ENR_CI_Ownership_Details__c!=null && opp.ENR_CI_Ownership_Details__c!=''){
                        eve.Customer_Insight_Ownership_Details__c = opp.ENR_CI_Ownership_Details__c;
                    }else{
                        eve.Customer_Insight_Ownership_Details__c = '';
                    }
                
                if(opp.ENR_CI_Likely_to_Buy_Acura__c!=null && opp.ENR_CI_Likely_to_Buy_Acura__c!=''){
                        eve.Customer_Insight_Likely_to_Buy_Acura__c = opp.ENR_CI_Likely_to_Buy_Acura__c;
                    }else{
                        eve.Customer_Insight_Likely_to_Buy_Acura__c = '';
                    }
                
                if(opp.ENR_CI_Service_History__c!=null && opp.ENR_CI_Service_History__c!=''){
                        eve.Customer_Insight_Service_History__c = opp.ENR_CI_Service_History__c;
                    }else{
                        eve.Customer_Insight_Service_History__c = '';
                    }
                
               if(opp.ENR_CI_Likely_to_Buy_Honda__c!=null && opp.ENR_CI_Likely_to_Buy_Honda__c!=''){
                        eve.Customer_Insight_Likely_to_Buy_Honda__c = opp.ENR_CI_Likely_to_Buy_Honda__c;
                    }else{
                        eve.Customer_Insight_Likely_to_Buy_Honda__c = '';
                    }
                
               if(opp.ENR_CI_Extended_Warranty__c!=null && opp.ENR_CI_Extended_Warranty__c!=''){
                        eve.Customer_Insight_Extended_Warranty__c = opp.ENR_CI_Extended_Warranty__c;
                    }else{
                        eve.Customer_Insight_Extended_Warranty__c = '';
                    }
                
               if(opp.ENR_CI_Likely_to_Buy_PSP__c!=null && opp.ENR_CI_Likely_to_Buy_PSP__c!=''){
                        eve.Customer_Insight_Likely_to_Buy_PSP__c = opp.ENR_CI_Likely_to_Buy_PSP__c;
                    }else{
                        eve.Customer_Insight_Likely_to_Buy_PSP__c = '';
                    }
                
               if(opp.ENR_CI_Children_in_Household__c!=null && opp.ENR_CI_Children_in_Household__c!=''){
                        eve.Customer_Insight_Children_in_Household__c = opp.ENR_CI_Children_in_Household__c;
                    }else{
                        eve.Customer_Insight_Children_in_Household__c = '';
                    }
                
                if(opp.ENR_Acura_Vehicles_Owned__c!=null){
                        eve.Acura_Vehicles_Owned__c = opp.ENR_Acura_Vehicles_Owned__c;
                    }else{
                        eve.Acura_Vehicles_Owned__c = null;
                    }
                
                if(opp.ENR_Honda_Vehicles_Owned__c!=null){
                        eve.Honda_Vehicles_Owned__c = opp.ENR_Honda_Vehicles_Owned__c;
                    }else{
                        eve.Honda_Vehicles_Owned__c = null;
                    }
                
                if(opp.ENR_Power_Sports_Vehicles_Owned__c!=null ){
                        eve.Power_Sports_Vehicles_Owned__c = opp.ENR_Power_Sports_Vehicles_Owned__c;
                    }else{
                        eve.Power_Sports_Vehicles_Owned__c = null;
                    }
                
                if(opp.ENR_Power_Equipment_Vehicles_Owned__c!=null ){
                        eve.Power_Equipment_Vehicles_Owned__c = opp.ENR_Power_Equipment_Vehicles_Owned__c;
                    }else{
                        eve.Power_Equipment_Vehicles_Owned__c = null;
                    }
                
                if(opp.ENR_Extended_Warranty_Contract__c==true ){
                        eve.Extended_Warranty_Contract__c = true;
                    }else{
                        eve.Extended_Warranty_Contract__c = false;
                    }
                
                if(opp.ENR_Likeliness_to_Buy_Acura__c!=null && opp.ENR_Likeliness_to_Buy_Acura__c!='' ){
                        eve.Customer_Likeliness_to_Buy_Acura__c = opp.ENR_Likeliness_to_Buy_Acura__c;
                    }else{
                        eve.Customer_Likeliness_to_Buy_Acura__c = '';
                    }
                
                if(opp.ENR_Likeliness_to_Buy_Honda__c!=null && opp.ENR_Likeliness_to_Buy_Honda__c!='' ){
                        eve.Customer_Likeliness_to_Buy_Honda__c = opp.ENR_Likeliness_to_Buy_Honda__c;
                    }else{
                        eve.Customer_Likeliness_to_Buy_Honda__c = '';
                    }
                
                if(opp.ENR_Likeliness_to_Buy_PSP__c!=null && opp.ENR_Likeliness_to_Buy_PSP__c!='' ){
                        eve.Customer_Likeliness_to_Buy_PSP__c = opp.ENR_Likeliness_to_Buy_PSP__c;
                    }else{
                        eve.Customer_Likeliness_to_Buy_PSP__c = '';
                    }
                if(opp.ENR_Ownership_Type__c!=null && opp.ENR_Ownership_Type__c!='' ){
                        eve.Ownership_Type__c = opp.ENR_Ownership_Type__c;
                    }else{
                        eve.Ownership_Type__c = '';
                    }
                if(String.valueof(opp.ENR_Total_Spent_on_Service_by_Customer__c)!=null && String.valueof(opp.ENR_Total_Spent_on_Service_by_Customer__c)!='' ){
                        eve.Total_Spent_on_Service_by_Customer__c = String.valueof(opp.ENR_Total_Spent_on_Service_by_Customer__c);
                    }else{
                        eve.Total_Spent_on_Service_by_Customer__c = '';
                    }
                if(String.valueof(opp.ENR_Total_Spent_on_Service_by_Warranty__c)!=null && String.valueof(opp.ENR_Total_Spent_on_Service_by_Warranty__c)!='' ){
                        eve.Total_Spent_on_Service_by_Warranty__c = String.valueof(opp.ENR_Total_Spent_on_Service_by_Warranty__c);
                    }else{
                        eve.Total_Spent_on_Service_by_Warranty__c = '';
                    }
                if(opp.Einstein_Predicted_Priority__c!=null && opp.Einstein_Predicted_Priority__c!='' ){
                        eve.Einstein_Predicted_Priority__c = opp.Einstein_Predicted_Priority__c;
                    }else{
                        eve.Einstein_Predicted_Priority__c = '';
                    }
                /* Added by Bijay- on 25th Jan*/
                if(opp.DEPOSIT_AMOUNT__c!=null ){
                        eve.Deposit_Amount__c = opp.DEPOSIT_AMOUNT__c;
                    }else{
                        eve.Deposit_Amount__c = null;
                    }
                
                if(opp.Deposit_Confirmation_Number__c!=null && opp.Deposit_Confirmation_Number__c!='' ){
                        eve.Deposit_Confirmation_Number__c = opp.Deposit_Confirmation_Number__c;
                    }else{
                        eve.Deposit_Confirmation_Number__c = '';
                    }
                
                if(opp.Deposit_Sales_Order_Number__c!=null && opp.Deposit_Sales_Order_Number__c!='' ){
                        eve.Deposit_Sales_Order_Number__c = opp.Deposit_Sales_Order_Number__c;
                    }else{
                        eve.Deposit_Sales_Order_Number__c = '';
                    }
                /*DSP -1183 - start*/
                
			/**CAPS-895
                 * if(Opp.Source_Unique_ID__c != null &&
               ((dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.Receive_Lead_Updates__c)||
                   (dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).DealerAccount_ID__r.Receive_Dealer_Updates__c ))){
                      eve.Send_to_DSP__c = true;  
                    }
                 * 
                 */			                    
                if(Opp.Source_Unique_ID__c != null &&
                ((dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).CRM_System__r.Receive_Lead_Updates__c)||
                    (dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c).DealerAccount_ID__r.Receive_Dealer_Updates__c ))){
                       eve.Send_to_DSP__c = true;  
                     }    

                eve.Initial_Walkin_Lead__c = opp.Initial_Walkin_Lead__c;
     
      			eve.Is_This_Lead_Update__c = opp.Is_This_Lead_Update__c;
                
                 if(opp.Appointment_Date_and_Time__c!=null && opp.Appointment_Date_and_Time__c!='' ){
                        eve.Appointment_Date_and_Time__c = opp.Appointment_Date_and_Time__c;
                    }else{
                        eve.Appointment_Date_and_Time__c = '';
                    }
                 if(opp.Appointment_Location__c!=null && opp.Appointment_Location__c!='' ){
                        eve.Appointment_Location__c = opp.Appointment_Location__c;
                    }else{
                        eve.Appointment_Location__c = '';
                    }
                 if(opp.Appointment_Notes__c!=null && opp.Appointment_Notes__c!='' ){
                        eve.Appointment_Notes__c = opp.Appointment_Notes__c;
                    }else{
                        eve.Appointment_Notes__c = '';
                    }
                 if(opp.Appointment_type__c!=null && opp.Appointment_type__c!='' ){
                        eve.Appointment_type__c = opp.Appointment_type__c;
                    }else{
                        eve.Appointment_type__c = '';
                    }
                 if(opp.Contact_person__c!=null && opp.Contact_person__c!='' ){
                        eve.Contact_person__c = opp.Contact_person__c;
                    }else{
                        eve.Contact_person__c = '';
                    }
                 if(opp.Deal_ID__c!=null && opp.Deal_ID__c!='' ){
                        eve.Deal_ID__c = opp.Deal_ID__c;
                    }else{
                        eve.Deal_ID__c = '';
                    }
                 if(opp.Deal_Link__c!=null && opp.Deal_Link__c!='' ){
                        eve.Deal_Link__c = opp.Deal_Link__c;
                    }else{
                        eve.Deal_Link__c = '';
                    }
                if(opp.Source_Unique_ID__c!=null && opp.Source_Unique_ID__c!='' ){
                        eve.Source_Unique_ID__c = opp.Source_Unique_ID__c;
                    }else{
                        eve.Source_Unique_ID__c = '';
                    }
                if(opp.Appointment_Id__c!=null && opp.Appointment_Id__c!='' ){
                        eve.Appointment_Id__c = opp.Appointment_Id__c;
                    }else{
                        eve.Appointment_Id__c = '';
                    }
                 if(opp.Deposit_IP_Addres_URL__c != null && opp.Deposit_IP_Addres_URL__c != ''){
                    eve.IP_Addres_URL__c = opp.Deposit_IP_Addres_URL__c;
                }else{
                    eve.IP_Addres_URL__c = '';
                }
                /*DSP-1183-End*/
               /* Added by Bijay- on 25th Jan*/
             /*End - Star Implementation*/
             //   System.debug('Description : '+eve.Description_DESC__c);
              //  System.debug('Comments : '+eve.Comment__c);
                 system.debug('PE EVE: '+eve);
                    publishEvents.add(eve);   
            }    
           
            if(publishEvents.size()>0){
                List<Database.SaveResult> results = EventBus.publish(publishEvents);
                for (Database.SaveResult sr : results) {
                    if (sr.isSuccess()) {
                     //   System.debug('Successfully published event.');
                        
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            Logs__c  l =new Logs__c (name='Lead routing failure'+sr.getId(),type__c='Lead routing failure',Trigger_or_Class_Name__c='HELMSLeadDealerAssignmentADFHandler', Error_Message__c ='Get fields:'+err.getFields()+'Get Message:'+err.getMessage() );
                            insert l;
                        }
                    }       
                }
                if(updateOppList.size() > 0)
                    UPDATE updateOppList;

            }
        
        }Catch(Exception ex){
                       
            Logs__c  l =new Logs__c (name='Lead routing failure',type__c='Lead routing failure',Trigger_or_Class_Name__c='HELMSLeadDealerAssignmentADFHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }   
    }
    
   
}