/**** Trigger Handler Name:HELMSLeadCreationPEHandler
User story Number : LMS-1553
SFDC will subscribe to a platform event queue to get new Lead data. 
****/
public with sharing class HELMSLeadCreationPEHandler {
    public static void createLeads(List<Lead_Creation_ADF__e> newLeadCreationADFs){
        try{
     //       System.debug('newLeadCreationADFs : '+newLeadCreationADFs);
            Map<string, id> providermap = new Map<string, id>();
            List<String> pnamelist = new List<String>();
            List<String> dealerNumber = New List<String>();
            Map<String,Dealer_Division__c> dealDivMap = New Map<String,Dealer_Division__c>();
            /* Blocking insertion of Leads having same Lead Reference Number */
            Set<String> leadExternalLeadReferenceNumber = new Set<String>();
            for(Lead_Creation_ADF__e leadCretionExternal : newLeadCreationADFs){
                if(leadCretionExternal.External_Lead_Reference_Number__c != null && leadCretionExternal.External_Lead_Reference_Number__c != ''){ 
                    leadExternalLeadReferenceNumber.add(leadCretionExternal.External_Lead_Reference_Number__c);
                }
                //modified as part of CAPS-4336
                if(leadCretionExternal.Dealer_IDs__c!=null){
                    string delearNumber = '';
                    String pdids=(leadCretionExternal.Dealer_IDs__c).unescapeXml();
                    if(pdids.contains('>')){
                        String[] pdn = pdids.split('>');
                        if(pdn[1].contains('<')){
                            String[] pdno = (pdn[1]).split('<');                   
                            delearNumber = (pdno[0]);
                        }
                    }else{
                        delearNumber = leadCretionExternal.Dealer_IDs__c;
                    }
                    dealerNumber.add(delearNumber);
                } 
            }
            //modified as part of CAPS-4336
            if(!dealerNumber.isEmpty()){
                for(Dealer_Division__c dealDiv:[select id,Division_CD__c, SubDiv_TXT__c,Dealer_ID__r.DealerCode_CD__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c in: dealerNumber WITH SECURITY_ENFORCED]){
                    dealDivMap.put(dealDiv.Dealer_ID__r.DealerCode_CD__c,dealDiv);
                }
            }

            List<AggregateResult> existingExternalLeadReferenceNumber = new List<AggregateResult>([select External_Lead_Reference_Number__c, Count(Id) from Lead where External_Lead_Reference_Number__c in :leadExternalLeadReferenceNumber GROUP BY External_Lead_Reference_Number__c]);
            Map<String, Integer> externamLeadRefMap = new Map<String, Integer>();
            for (AggregateResult ar : existingExternalLeadReferenceNumber) { 
                externamLeadRefMap.put( String.valueof( ar.get('External_Lead_Reference_Number__c')),Integer.valueof(ar.get('expr0')) );
            }
            /* Blocking insertion of Leads having same Lead Reference Number */
            
            for(Lead_Creation_ADF__e leadCretion : newLeadCreationADFs){
                if(leadCretion.ProviderDetails_TXT__c!=null){ 
                    string providename =  leadCretion.ProviderDetails_TXT__c;
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null){
                            pnamelist.add(pdn1[0]);
                        }
                    }else{
                        pnamelist.add(leadCretion.ProviderDetails_TXT__c);
                    }
                }
                if(leadCretion.Lead_Provider_Name__c!=null && leadCretion.Lead_Provider_Name__c!=''){
                    pnamelist.add(leadCretion.Lead_Provider_Name__c);
            }
            }
            
            Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            for(Account a:[select id,name from account where name IN: pnamelist and RecordTypeId=:providerAccRecTypeId]){  
                providermap.put((a.name).toLowerCase(),a.id);
            }  
            
            
            User inteUser = [select id from user where name=:System.Label.PlatformEventUSerProfileName and isactive = true and Profile.name=:System.Label.PEProfile limit 1 ];
            list<Lead> newLeadList = new List<Lead>();
            for(Lead_Creation_ADF__e leadCretion : newLeadCreationADFs){
            
                //System.debug('platform event record --------'+leadCretion);
                Boolean isTrue = true;
                
                Lead newLead = new Lead();
               Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('HELMS_Leads').getRecordTypeId();
                //system.debug('------'+LeadRecordTypeId);
               newLead.recordtypeid=leadRecordTypeId;
               
               if(leadCretion.CreatedById!=null){
                    newLead.CreatedById  = leadCretion.CreatedById; 
               }
               
               newLead.ownerid  = inteUser.id;
               
       //         system.debug(':::Prospect_IDs__c:::::::'+leadCretion.Prospect_IDs__c);
               
                if(leadCretion.Prospect_IDs__c!=null){
                    newLead.Prospect_Ids_ID__c = (leadCretion.Prospect_IDs__c).unescapeXml();
                    
                    String myDate=(leadCretion.Prospect_IDs__c).unescapeXml();
                    
                    //system.debug('------'+myDate.contains('>'));
                    if(myDate.contains('>')){
                        String[] myDateOnly = myDate.split('>');
                        //system.debug('-myDateOnly-----'+myDateOnly);
                        
                        //system.debug('--myDateOnly[01]----'+myDateOnly[1]);
                        if(myDateOnly[1].contains('<')){
                            String[] myDateOnly2 = (myDateOnly[1]).split('<');
                            //system.debug('------'+(myDateOnly2[0]));
                            newLead.External_ID__c = (myDateOnly2[0]);
                        }
                    }
                    
                }
                
                if(leadCretion.Vehicle_IDs__c!=null){
                    newLead.Vehicle_Ids_ID__c = (leadCretion.Vehicle_IDs__c).unescapeXml();
                    
                    String M=(leadCretion.Vehicle_IDs__c).unescapeXml();
                    if(M.contains('>')){
                        String[] Mi = M.split('>');
                        if(mi[1].contains('<')){
                            String[] modelid = (mi[1]).split('<');
                            newLead.Model_ID__c = (modelid[0]);
                        }
                    }else{
                        newLead.Model_ID__c = leadCretion.Vehicle_IDs__c;
                    }
                                                   
                    
                    
                }
                
                //newLead.Vehicle_Ids_ID__c = leadCretion.Model_ID__c;
                
                 
                if(leadCretion.Dealer_IDs__c!=null){
                    newLead.Dealer_Ids_ID__c = (leadCretion.Dealer_IDs__c).unescapeXml();
                    
                    String pdids=(leadCretion.Dealer_IDs__c).unescapeXml();
                    if(pdids.contains('>')){
                        String[] pdn = pdids.split('>');
                        if(pdn[1].contains('<')){
                        String[] pdno = (pdn[1]).split('<');                   
                        
                        newLead.PreferredDealerNumber_NUM__c = (pdno[0]);
                        }
                    }else{
                        newLead.PreferredDealerNumber_NUM__c = leadCretion.Dealer_IDs__c;
                    }
                    newLead.Dealer_Assignment_Type__c = 'Customer Selected';
                } 
                newLead.Provider_Ids_ID__c = (leadCretion.Provider_IDs__c)?.unescapeXml();
                //modified as part of CAPS-4336 - START
                if(dealDivMap.containsKey(newLead.PreferredDealerNumber_NUM__c)){
                    newLead.Division_CD__c = dealDivMap.get(newLead.PreferredDealerNumber_NUM__c).Division_CD__c;
                    newLead.SubDiv_TXT__c = dealDivMap.get(newLead.PreferredDealerNumber_NUM__c).SubDiv_TXT__c;
                }
                if(newLead.Division_CD__c==null && leadCretion.Business_Unit_Code_CD__c!=null){
                    newLead.Division_CD__c = String.valueOf(leadCretion.Business_Unit_Code_CD__c);
                }
                
                if(newLead.SubDiv_TXT__c==null && leadCretion.BusinessUnitSubDivision_CD__c!=null){
                    newLead.SubDiv_TXT__c = String.valueOf(leadCretion.BusinessUnitSubDivision_CD__c);
                }
                /*if(leadCretion.Business_Unit_Code_CD__c!=null){
                   newLead.Division_CD__c = String.valueOf(leadCretion.Business_Unit_Code_CD__c);
                //newLead.Division_CD__c = 'A';
               }
                
               if(leadCretion.BusinessUnitSubDivision_CD__c!=null){
                  newLead.SubDiv_TXT__c = String.valueOf(leadCretion.BusinessUnitSubDivision_CD__c);
                  // newLead.SubDiv_TXT__c = 'Honda';
               }*/
               //modified as part of CAPS-4336 - END
               if(leadCretion.Vehicle_Interest_TXT__c!=null){
                    newLead.VehicleInterest_TXT__c = leadCretion.Vehicle_Interest_TXT__c;
               }
               
               if(leadCretion.Vehicle_Status_TX__c!=null){
                   newLead.VehicleStatus_TXT__c = leadCretion.Vehicle_Status_TX__c;
               }
               
               if(leadCretion.Make_TXT__c!=null){
                    newLead.Make_TXT__c = leadCretion.Make_TXT__c;
               }
               /* For Model Group Name - LMS - 5177 - Added by Syam */ 
                
                
              
              
             if(leadCretion.Model_TXT__c!=null){
                   newLead.Model_TXT__c = leadCretion.Model_TXT__c;
             }
             if(newLead.Model_TXT__c==null ){
                 if(leadCretion.Model_Name_NM__c!=null){
                     newLead.Model_TXT__c = leadCretion.Model_Name_NM__c;
                 }
             }
               if(leadCretion.Provider_Service__c !=null){
                    newLead.ProviderService_TXT__c = leadCretion.Provider_Service__c;
                }
                
                 if(leadCretion.Provider_Type__c == null){
                    newLead.Provider_Type__c = HELMSConstants.CustomerOriginatedLead;
                }  else  if(leadCretion.Provider_Type__c !=null){
                    newLead.Provider_Type__c = leadCretion.Provider_Type__c;
                }
                system.debug('LavanyaPRovider----->'+leadcretion.Provider_Type__c);
                system.debug('LavanyaProvider1------->'+newLead.Provider_Type__c);
                
               /*DSP Code - start - GLavanya- DS-1182*/
               
                if(leadCretion.Source_Unique_ID__c!=null){
                   newLead.Source_Unique_ID__c= leadCretion.Source_Unique_ID__c;
             }
                 if(leadCretion.Appointment_Date_and_Time__c!=null){
                   newLead.Appointment_Date_and_Time__c= leadCretion.Appointment_Date_and_Time__c;
             }
                 if(leadCretion.Appointment_Location__c !=null){
                   newLead.Appointment_Location__c = leadCretion.Appointment_Location__c;
             }
                 if(leadCretion.Appointment_type__c !=null){
                   newLead.Appointment_type__c = leadCretion.Appointment_type__c;
             }
                 if(leadCretion.Appointment_Notes__c !=null){
                   newLead.Appointment_Notes__c = leadCretion.Appointment_Notes__c;
             }
                 if(leadCretion.Contact_person__c !=null){
                   newLead.Contact_person__c = leadCretion.Contact_person__c;
             }
             /*        if(leadCretion.Customer_Chat__c !=null){
                   newLead.Customer_Chat__c = leadCretion.Customer_Chat__c;
             } */
                 if(leadCretion.Deal_ID__c !=null){
                   newLead.Deal_ID__c = leadCretion.Deal_ID__c;
             }
                 if(leadCretion.Deal_Link__c !=null){
                   newLead.Deal_Link__c = leadCretion.Deal_Link__c;
             }
                
                 if(leadCretion.Vendor_Contact_Name__c !=null){
                   newLead.Vendor_Contact_Name__c = leadCretion.Vendor_Contact_Name__c;
             }
                
                 if(leadCretion.Vendor_Contact_Email__c !=null){
                   newLead.Vendor_Contact_Email__c = leadCretion.Vendor_Contact_Email__c;
             }
                 if(leadCretion.Appointment_Id__c !=null){
                   newLead.Appointment_Id__c = leadCretion.Appointment_Id__c;
             }
             
                 /*DSP Code - end-GLavanya- DS-1182*/
             //pramod  
             if(leadCretion.Chat_Transcript__c!=null){
                   newLead.Chat_Transcript__c = leadCretion.Chat_Transcript__c;
             }
                 
             
                
              if(leadCretion.Model_Trim_TXT__c!=null){         
                newLead.Trim_TXT__c = leadCretion.Model_Trim_TXT__c;
                }
                
                //updated below code as part of AMSLM-457-start
                
                  if(leadCretion.Model_Name_NM__c!=null){         
                newLead.Model_Name_NM__c= leadCretion.Model_Name_NM__c;
                }
                   //updated below code as part of AMSLM-457-End
                
              if(leadCretion.Year_YR__c!=null){      
                newLead.Year_YR__c = String.valueOf(Integer.valueOf(leadCretion.Year_YR__c));
                
                }
                
              if(leadCretion.Condition_TXT__c!=null){      
                
                newLead.Condition_TXT__c = leadCretion.Condition_TXT__c;
                }
                
              if(leadCretion.Vin_Number_NUM__c!=null){      
                newLead.Number_NM__c = leadCretion.Vin_Number_NUM__c;
                }
                
              if(leadCretion.Doors_TXT__c!=null){      
                newLead.Doors_TXT__c = leadCretion.Doors_TXT__c;
                }
                
              if(leadCretion.Body_Style_TXT__c!=null){      
                newLead.BodyStyle_TXT__c = leadCretion.Body_Style_TXT__c;
              }  
              
              if(leadCretion.Odometer_TXT__c!=null){   
                
                newLead.Odometer_TXT__c = leadCretion.Odometer_TXT__c;
            }
            if(leadCretion.Odometer_Status_TXT__c!=null){   
                newLead.OdometerStatus_TXT__c = String.valueOf(leadCretion.Odometer_Status_TXT__c);
            }
            
            if(leadCretion.Odometer_Units_TXT__c!=null){
                newLead.OdometerUnits_TXT__c = String.valueOf(leadCretion.Odometer_Units_TXT__c);
             }  
            if(leadCretion.Transmission_TXT__c!=null){                 
                newLead.Transmission_TXT__c = leadCretion.Transmission_TXT__c;
            }
            
            if(leadCretion.Stock_Number_NUM__c!=null && leadCretion.Stock_Number_NUM__c!='0'){  
                newLead.InventoryNumber_TXT__c = leadCretion.Stock_Number_NUM__c;
            }    
            
            if(leadCretion.Options_TXT__c!=null){ 
            newLead.Options_TXT__c = (leadCretion.Options_TXT__c).unescapeXml();
            
            }
            
            //LMS-1950 - Vamshi
            if(leadCretion.LeadAdditionalInfos__c!=null){ 
            newLead.LeadAdditionalInfos__c= (leadCretion.LeadAdditionalInfos__c).unescapeXml();
            
            }
             //LMS-5373 - Ghouse
                if(leadCretion.Send_confirmation_Email__c!=null){ 
            newLead.Send_confirmation_Email__c= leadCretion.Send_confirmation_Email__c;
            
            }

            
            if(leadCretion.Color_TXT__c!=null){ 
                newLead.Color_TXT__c = (leadCretion.Color_TXT__c).unescapeXml();
            }
            if(leadCretion.Financial_Details_TXT__c!=null){ 
                newLead.Financial_Details_TXT__c = (leadCretion.Financial_Details_TXT__c).unescapeXml();
            }
             //validateonly code was updated as a part of AMSLM-832-GLavanya      
            if(leadCretion.Validateonly__c!=null){
                newLead.Validateonly__c = leadCretion.Validateonly__c;
            }
                //firstname code was updated as a part of AMSLM-859-GLavanya   
            if(leadCretion.FirstName_NM__c!=null && leadCretion.FirstName_NM__c.length()>40){    
                newLead.FirstName = leadCretion.FirstName_NM__c.substring(0,40);
            } else{
                newLead.FirstName = leadCretion.FirstName_NM__c;
            }
                 //Lastname code was updated as a part of AMSLM-934-GLavanya   
            if(leadCretion.LastName_NM__c!=null && leadCretion.LastName_NM__c.length()>80){
                newLead.LastName = leadCretion.LastName_NM__c.substring(0,80);
            } else{
                newLead.LastName = leadCretion.LastName_NM__c;
            }
            if(leadCretion.MiddleName_NM__c!=null){ 
                newLead.MiddleName = leadCretion.MiddleName_NM__c;
            }
            if(leadCretion.Suffix_INIT__c!=null){   
                newLead.Suffix = leadCretion.Suffix_INIT__c;
            }
            
               // newLead.Name = leadCretion.Name_NM__c; // Field is not writeable Lead.name
                
            if(leadCretion.Contact_type_TXT__c!=null){ 
                newLead.ContactType_TXT__c = leadCretion.Contact_type_TXT__c;
            }
            if(leadCretion.AddressType_TXT__c!=null){ 
                newLead.AddressType_TXT__c = leadCretion.AddressType_TXT__c;
            }
            
            string addStreet;
            if(leadCretion.AddressLine1_TXT__c!=null){
                addStreet = leadCretion.AddressLine1_TXT__c;
            }
            
            if(leadCretion.AddressLine2_TXT__c!=null){
                addStreet =addStreet+', '+leadCretion.AddressLine2_TXT__c;
            }
            
            if(leadCretion.AddressLine3_TXT__c!=null){
                addStreet = addStreet+', '+leadCretion.AddressLine3_TXT__c;
            }
            
            if(leadCretion.AddressLine4_TXT__c!=null){
                addStreet = addStreet+', '+leadCretion.AddressLine4_TXT__c;
            }
            
            if(leadCretion.AddressLine5_TXT__c!=null){
                addStreet = addStreet+', '+leadCretion.AddressLine5_TXT__c;
            }                
            
            if(addStreet!=null){
                newLead.Street=addStreet;
            }
            if(leadCretion.ApartmentNumber_NUM__c!=null){   
                newLead.AppartmentNumber_TXT__c = leadCretion.ApartmentNumber_NUM__c;
            } 
            if(leadCretion.City_TXT__c!=null){
                newLead.City = leadCretion.City_TXT__c;
            }
            if(leadCretion.State_TXT__c!=null){
                newLead.state = leadCretion.State_TXT__c;
            }
            if(leadCretion.Country_TXT__c!=null){
                newLead.Country = leadCretion.Country_TXT__c;
            }
            if(leadCretion.ZipCode_TXT__c!=null){
                newLead.PostalCode = leadCretion.ZipCode_TXT__c;
            }
            if(leadCretion.Email_TXT__c!=null){
                //Bug HPS-32 and HPS-487
                String strEmail = leadCretion.Email_TXT__c;
           
                //Boolean bValidateEmail = Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', strEmail.trim());
                //Boolean bValidateEmail = Pattern.matches('[+a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', strEmail.trim());
                Boolean bValidateEmail = Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', strEmail.trim());
                //System.debug('bValidateEmail ===> '+bValidateEmail);
                if(bValidateEmail){
                    newLead.Email = leadCretion.Email_TXT__c;
                }
                /*else{
                    newLead.Email = 'helms@honda.com.invalid';
                }
                */
                //end Bug HPS-32
                
            }
            if(leadCretion.Phone_TXT__c!=null){
                newLead.Phone = leadCretion.Phone_TXT__c;
            }
            if(leadCretion.Mobile_TXT__c!=null){
                newLead.MobilePhone = leadCretion.Mobile_TXT__c;
            }
            if(leadCretion.Fax_TXT__c!=null){
                newLead.Fax = leadCretion.Fax_TXT__c;
            }    
                if(leadCretion.Pager_TXT__c!=null){ 
                    newLead.Pager__c = leadCretion.Pager_TXT__c; 
                }
                
                if(leadCretion.ContactMethod_TXT__c!=null){ 
                    newLead.ContactMethod_TXT__c = leadCretion.ContactMethod_TXT__c; 
                }
                
                if(leadCretion.Contact_Time_TM__c!=null){ 
                  if(leadCretion.Contact_Time_TM__c==System.Label.Contact_time_anytime){
                     newLead.ContactTime_TXT__c= 'nopreference';
                     }
                     else{
                    newLead.ContactTime_TXT__c= leadCretion.Contact_Time_TM__c;
                }
                }
                
                /* LMS - 5171 - Added By Syam */
                if(leadCretion.PhoneType_NM__c!=null){ 
                    newLead.PhoneType_NM__c= leadCretion.PhoneType_NM__c;
                }
                /* LMS - 5171 - Added By Syam */
                
                if(leadCretion.PurchaseHorizon_TXT__c!=null){ 
                                 
                newLead.PurchaseHorizon_TXT__c =leadCretion.PurchaseHorizon_TXT__c ;
                }
       
                if(leadCretion.PurchaseEarliestDate_DT__c!=null){ 
                
                   
                    newLead.PurchaseEarliestDate_DT__c = leadCretion.PurchaseEarliestDate_DT__c;
                }
                if(leadCretion.PurchaseLatestDate_DT__c!=null){ 
                
                 
                newLead.PurchaseLatestDate_DT__c =  leadCretion.PurchaseLatestDate_DT__c;
               }

                if(leadCretion.Description_DESC__c!=null){ 
               newLead.Description = leadCretion.Description_DESC__c;
               }
            
               if(leadCretion.OtherContacts_TXT__c!=null){ 
                newLead.OtherContacts_TXT__c = (leadCretion.OtherContacts_TXT__c).unescapeXml();
                }
                
                if(leadCretion.DealerAccountfromADF_TXT__c!=null){ 
                newLead.DealerAccountfromADF_TXT__c = leadCretion.DealerAccountfromADF_TXT__c;
                }
                if(leadCretion.DealerContactfromADF_TXT__c!=null){ 
                newLead.DealerContactfromADF_TXT__c = (leadCretion.DealerContactfromADF_TXT__c).unescapeXml();
                }
              
                if(leadCretion.ProviderDetails_TXT__c!=null){ 
                    newLead.ProviderDetail_TXT__c= leadCretion.ProviderDetails_TXT__c;
                    string providename =  leadCretion.ProviderDetails_TXT__c;
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null && providermap.containsKey((pdn1[0]).toLowerCase())){
                            newLead.LeadProvider_ID__c = providermap.get((pdn1[0]).toLowerCase());
                            
                        }
                        
                        if(pdn1[1]!=null){
                            newLead.LeadsourceOther_TXT__c = pdn1[1];
                        }
                        
                    }
                  else if(providermap.containsKey((leadCretion.ProviderDetails_TXT__c).toLowerCase())){
                        newLead.LeadProvider_ID__c = providermap.get((leadCretion.ProviderDetails_TXT__c).toLowerCase());
                                                    
                    }
                                     
                
                }
                if(leadCretion.ProviderContactDetails_TXT__c!=null){ 
                newLead.ProviderContactDetail_TXT__c = (leadCretion.ProviderContactDetails_TXT__c).unescapeXml();
                }
                if(leadCretion.OtherLeadProvider_TXT__c!=null){ 
                newLead.OtherLeadProvider_TXT__c = (leadCretion.OtherLeadProvider_TXT__c).unescapeXml();
                }
                
               
                //LMS-3050
                if(leadCretion.MSRP_AMT__c!=null){ 
                    String s=leadCretion.MSRP_AMT__c;
                    if(s.contains(',')){
                        String s1=s.remove(',');
                        Decimal msrp = Decimal.valueOf(s1);
                        //system.debug('msrp ----'+msrp );
                        newLead.MSRP_AMT__c = msrp;
                    }else{
                        Decimal msrp = Decimal.valueOf(s);
                        //system.debug('msrp ----'+msrp );
                        newLead.MSRP_AMT__c = msrp;
                    }
                }
                if(leadCretion.Quote_AMT__c!=null){ 
                    String s=leadCretion.Quote_AMT__c;
                    if(s.contains(',')){
                        String s1=s.remove(',');
                        Decimal Quote= Decimal.valueOf(s1);
                        //system.debug('Quote----'+Quote);
                        newLead.Quote_AMT__c= Quote;
                    }else{
                        Decimal Quote= Decimal.valueOf(s);
                        //system.debug('Quote----'+Quote);
                        newLead.Quote_AMT__c= Quote;
                    }
                   // newLead.Quote_AMT__c = leadCretion.Quote_AMT__c;
                }
                
                //LMS-6075
               // newLead.LeadSource = System.Label.LeadSource;
                  
                //LMS-3659
                if(leadCretion.TradeBalanceOwed_TXT__c!=null){ 
                    newLead.TradeBalanceOwed_TXT__c = leadCretion.TradeBalanceOwed_TXT__c;
                }
                if(leadCretion.TradeMake_TXT__c!=null){ 
                    newLead.TradeMake_TXT__c = leadCretion.TradeMake_TXT__c;
                }
                if(leadCretion.TradeMileage_TXT__c!=null){ 
                    newLead.TradeMileage_TXT__c = leadCretion.TradeMileage_TXT__c;
                }
                if(leadCretion.TradeModel_TXT__c!=null){ 
                    newLead.TradeModel_TXT__c = leadCretion.TradeModel_TXT__c;
                }
                if(leadCretion.TradeValue_TXT__c!=null){ 
                    newLead.TradeValue_TXT__c = leadCretion.TradeValue_TXT__c;
                }
                if(leadCretion.TradeYear_YR__c!=null){ 
                    newLead.TradeYear_YR__c = leadCretion.TradeYear_YR__c;
                } 
               if(leadCretion.TradeStatus_TXT__c!=null){ 
                    newLead.TradeStatus_TXT__c = leadCretion.TradeStatus_TXT__c;
                }
                
                /* New Fields in Lead Creation Process (IsPhoneVerified, IsEmailVerified, Is AddressVerified) - Syam Mohan */
                //System.debug('leadCretion.isEmailValidated__c : '+leadCretion.isEmailValidated__c);
                //System.debug('leadCretion.isPhoneValidated__c : '+leadCretion.isPhoneValidated__c);
                /*if(leadCretion.isAddressValidated__c!=null){ 
                    newLead.ValidAddress_FLG__c = leadCretion.isAddressValidated__c;
                }*/
                if(leadCretion.isEmailValidated__c!=null){ 
                    newLead.ValidEmail_FLG__c = leadCretion.isEmailValidated__c;
                }
                if(leadCretion.isPhoneValidated__c!=null){ 
                    newLead.ValidPhoneNum_FLG__c = leadCretion.isPhoneValidated__c;
                }
                if(leadCretion.isDealerized__c!=null){ 
                    newLead.IsDealerized__c = leadCretion.isDealerized__c;
                }
                /* New Fields in Lead Creation Process (IsPhoneVerified, IsEmailVerified, Is AddressVerified) - Syam Mohan */
                
                //LMS - 4898 - Syam
                if(leadCretion.External_Lead_Reference_Number__c!=null){
                    newLead.External_Lead_Reference_Number__c = leadCretion.External_Lead_Reference_Number__c;
                }
                //LMS - 4898 - Syam
                
           //     system.debug(':::leadCretion:::::::'+leadCretion.Lead_Provider_Name__c);
                //LMS-5543 -saikiran
                if(leadCretion.Lead_Provider_Name__c!=null && leadCretion.Lead_Provider_Name__c!=''){
                    if(providermap.get((leadCretion.Lead_Provider_Name__c).toLowerCase())!=null)
                        newLead.LeadProvider_ID__c = providermap.get((leadCretion.Lead_Provider_Name__c).toLowerCase());
           //          system.debug(':::newLead.LeadProvider_ID__c:::::::'+newLead.LeadProvider_ID__c);
                    
                }
                  if(leadCretion.Provider_Tool__c!=null){
                    newLead.Provider_Tool_Name__c = leadCretion.Provider_Tool__c;
                }
                 if(leadCretion.Provider_URL__c!=null){
                    newLead.Provider_URL__c = leadCretion.Provider_URL__c;
                }
                 if(leadCretion.Additional_Source_Info__c!=null){
                    newLead.Provider_Additional_Source_Information__c = leadCretion.Additional_Source_Info__c;
                }
                if(leadCretion.External_Lead_User_Identifier__c!=null){
                    newLead.External_Lead_User_Identifier__c = leadCretion.External_Lead_User_Identifier__c;
                }
                if(leadCretion.Marketing_Campaign_Name__c!=null){
                    newLead.Marketing_Campaign_Name__c = leadCretion.Marketing_Campaign_Name__c;
                }
                if(leadCretion.Shopping_Tool__c!=null){
                    newLead.Shopping_Tool_Name__c = leadCretion.Shopping_Tool__c;
                }
                //LMS-5543
                //AMSLM-665 - Vinay
                if(leadCretion.Lead_Payload__c!=null){
                    newLead.Lead_Payload__c = leadCretion.Lead_Payload__c;
                }
                    //LMS-4929
                 if(leadCretion.Deposit_Confirmation_Number__c!=null){
                    newLead.Deposit_Confirmation_Number__c = leadCretion.Deposit_Confirmation_Number__c;
                }
                 if(leadCretion.Salesforce_Order_Number__c!=null){
                    newLead.Deposit_Sales_Order_Number__c = leadCretion.Salesforce_Order_Number__c;
                }
                 if(leadCretion.Deposit_Amount__c!=null){
                    newLead.DEPOSIT_AMOUNT__c = leadCretion.Deposit_Amount__c;
                }
                 if(leadCretion.IP_Addres_URL__c!=null){
                    newLead.Deposit_IP_Addres_URL__c = leadCretion.IP_Addres_URL__c;
                }
                
                //LMS-1453-Lavanya
               if(leadCretion.Source_Name__c!=null){
                   newLead.Source_Name__c = String.valueOf(leadCretion.Source_Name__c);
                //newLead.Source_Name__c = 'Facebook';
               }
               if(leadCretion.Source_User__c!=null){
                    newLead.SourceUser_TXT__c = leadCretion.Source_User__c;
                } 
                if(leadCretion.MiddlewareUUID__c!=null){ 
                    List<Lead> existingmiddlewareuid = new List<Lead>([select id from lead where MiddlewareUUID__c=: leadCretion.MiddlewareUUID__c]);
                    if(existingmiddlewareuid.size()>0){
                        newlead.Duplicate_MiddlewareUID__c=leadCretion.MiddlewareUUID__c;
                        newLead.MiddlewareUUID__c=null;
                    }else{
                    newLead.MiddlewareUUID__c = leadCretion.MiddlewareUUID__c;
                }
                }
                if(leadCretion.Transaction_Code__c!=null){ 
                    if(leadCretion.Transaction_Code__c=='VL'){
                    newLead.TransactionCode_CD__c='VL Vehicle Lead only';
                    }
                    else if(leadCretion.Transaction_Code__c=='PL'){
                    newLead.TransactionCode_CD__c='PL Preview (GetOnTheList) Lead';
                    }
                    else{
                    newLead.TransactionCode_CD__c = leadCretion.Transaction_Code__c;
                    }
                }
                if(leadCretion.Trigger_type_Code__c!=null){ 
                    newLead.Triggertypecode__c = leadCretion.Trigger_type_Code__c;
                }
                if(leadCretion.Tigger_Send_By_Date__c!=null){ 
                    system.debug('Tigger_Send_By_Date__c---------'+ leadCretion.Tigger_Send_By_Date__c);
                    /* string myDate=String.valueOf(leadCretion.Tigger_Send_By_Date__c);
                    String[] myDateOnly = myDate.split('T');
                    newLead.TriggerSendbyDate_DT__c = date.valueOf(myDateOnly[0]);
                    */
                    if(leadCretion.Tigger_Send_By_Date__c == '9999-01-01 00:00:00.000'){
                
                    }else{
                    string myDate=String.valueOf(leadCretion.Tigger_Send_By_Date__c);
                        String[] myDateOnly = myDate.split('T');
                        newLead.TriggerSendbyDate_DT__c = datetime.valueOf(myDate);
                    }
                    
                }
                //end LMS-1453-Lavanya
                /* Blocking insertion of Leads having same Lead Reference Number */
                Boolean isExistsExtLeadRefNum = false;
                if(externamLeadRefMap.size() > 0 && leadCretion.External_Lead_Reference_Number__c != null && leadCretion.External_Lead_Reference_Number__c != '' && externamLeadRefMap.containskey(leadCretion.External_Lead_Reference_Number__c) && externamLeadRefMap.get(leadCretion.External_Lead_Reference_Number__c) > 0 ){
                    isExistsExtLeadRefNum = true;
                }
                if(!isExistsExtLeadRefNum){
                newLeadList.add(newLead);
                }
                /* Blocking insertion of Leads having same Lead Reference Number */
            }
            insert newLeadList;

        }Catch(Exception ex){
            
            Logs__c  l =new Logs__c (PE_Reply_Id__c=newLeadCreationADFs[0].ReplayId, name='Lead insertion failures',Type__c='Lead insertion failures',Trigger_or_Class_Name__c='HELMSLeadCreationPEHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }    
    }
}