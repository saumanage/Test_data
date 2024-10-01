/*-------------------------------------------------------------------------------------------
Class Name : LeadTriggerHandler 
Test Class Name : LeadTriggerHandlerTest
Last Modified Version Owner : Surabhi Rastogi/Mamatha Gonuguntla
Comments : Code to update the Valid Name field on the basis of the Filter Words(LMS-1801,5349)
Code to update the Status Reason on the basis of Valid Name
---------------------------------------------------------------------------------------------
Modification Log: 
May 11th, 2021 Bandi Sujatha (Appirio) Created Method for handling De-Duplication Logic for Leads(LMS-1568)
----------------------------------------------------------------------------------------------
*/

public with sharing class LeadTriggerHandler {
    
    public static boolean isRunValidName = true;
    public static boolean isUpdatedMultiLeadProvider = false;
    // public static Boolean isMarketableflag = false; 
    
    // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
    public void insertLeadSFID (List < Lead > lstnewLead){
        for (lead ld: lstnewLead) {
           // System.debug('Lead SF ID is : '+ld.Lead_SF_ID__c);
            if(ld.Lead_SF_ID__c == null || ld.Lead_SF_ID__c == ''){
               ld.Lead_SF_ID__c = LeadTriggerHandler.generateUniqueLeadSFId(5);
            }
        }
    }
    // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
    
    // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
    public static String generateUniqueLeadSFId(Integer len) {
        Datetime dt = system.now();
        String s = string.valueof(dt);
        String s2 = s.replaceAll('\\D','');
        //String sKey = userinfo.getOrganizationId() +s2;
        String sKey = s2;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        String finalEncodedString = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        finalEncodedString = sKey+randStr;
        List<Lead> perLeadList = [select id,Lead_SF_ID__c from Lead where createddate = LAST_N_DAYS:1 AND Lead_SF_ID__c = : finalEncodedString];
        if(perLeadList.size()>0){
            LeadTriggerHandler.generateUniqueLeadSFId(5);
        }
        return finalEncodedString; 
    }
    // HPS - 468 - Generating Lead SF ID immediately after creatingLead.
    
    public void updateValidNameonLead(List < Lead > lstnewLead) {
        try {
            // Map < String, Filter_Words_MDT__c > mapFilterWords = Filter_Words_MDT__c.getAll();
            Map < String, Filter_Words_MDT__c > mapFilterWords = new Map < String, Filter_Words_MDT__c >();
            for(Filter_Words_MDT__c fw: Filter_Words_MDT__c.getAll().values()){
                mapFilterWords.put((fw.name).toUpperCase(), fw);
                // system.debug(mapFilterWords);
            }
            
            List < Lead > updateLeadList = new List < Lead > ();
            
            set< id > prdrids = new set<id> ();
            Map< id,Account > prdrmap = new Map<id, Account>();
           /* HPT-430 -Start */
            set< id > dlrids = new set<id> ();
            Map< id,Account > dlrmap = new Map<id, Account>();
              /* HPT-430 -End */
            for (Lead ld: lstnewLead) { 
                prdrids.add(ld.LeadProvider_ID__c);
                
            }
            prdrmap = new Map<id, Account>([Select id, Routing_Date_Termination__c,Division__c, SubDivision_TXT__c , Lead_Source__c, RoutingDate_DT__c, Is_Concierge_Process_Needed__c, Send_Product_Missing_Notification__c, Send_Invalid_Information_notification__c , Send_confirmation_interest_notification__c, Send_Customer_Acknowledgement_Email_Flag__c, Enrichment__c, Deduplication__c   from Account where id IN: prdrids limit 50000]); 
              /* HPT-430 -Start */
              for (Lead ld: lstnewLead) { 
                dlrids.add(ld.PreferredDealerAccount_ID__c);
                
            }
             dlrmap = new Map<id, Account>([Select id,DealerCode_CD__c  from Account where id IN: dlrids limit 50000]); 
              /* HPT-430 -end */
            
            for (Lead ld: lstnewLead) {
                //String leadFirstName = ld.FirstName;
                // String leadLastName = ld.LastName;
                // String leadConcatName = ld.FirstName + ' ' + ld.LastName;
                if(ld.LeadProvider_ID__c!=null && prdrmap.containskey(ld.LeadProvider_ID__c) && prdrmap.get(ld.LeadProvider_ID__c).Lead_Source__c != null){
                    ld.LeadSource = prdrmap.get(ld.LeadProvider_ID__c).Lead_Source__c;
                }
                String leadFirstName = '';
                if(ld.FirstName != null && ld.FirstName!=''){
                    leadFirstName = ((ld.FirstName).toUpperCase()).trim();
                }
                
                /*DSP-1182-start*/
                 if((ld.Lead_Coming_From_CRM__c == '' || ld.Lead_Coming_From_CRM__c == null) && ld.Dealer_CRM_Vendor__c != null && ld.Source_Unique_ID__c != null && ld.Provider_Type__c != HELMSConstants.CustomerOriginatedLead){
                      ld.Lead_Coming_From_CRM__c = ld.Dealer_CRM_Vendor__c ;
                }
                /*DSP-1182-End*/
                
             /* HPT-430 -Start */
                
               IF(ld.FirstName != null && ld.LastName != null && ld.PreferredDealerAccount_ID__c != null){
                    ld.IsFirstName_FLG__c = true;
                }
                if((prdrmap.get(ld.LeadProvider_ID__c)) != null &&  (prdrmap.get(ld.LeadProvider_ID__c).Lead_Source__c == 'Third Party')) {
                    ld.TransactionCode_CD__c = 'VL Vehicle Lead only';
                }
              
                if((dlrmap.get(ld.PreferredDealerAccount_ID__c)) != null && ((dlrmap.get(ld.PreferredDealerAccount_ID__c)).DealerCode_CD__c != null)){
                    ld.PreferredDealerNumber_NUM__c = dlrmap.get(ld.PreferredDealerAccount_ID__c).DealerCode_CD__c ;
                }
                    /* HPT-430 -End */
                //HPS-526-depends on lead provider send confirmation email field will update
                if( prdrmap.get(ld.LeadProvider_ID__c) != null && prdrmap.get(ld.LeadProvider_ID__c).Send_Customer_Acknowledgement_Email_Flag__c != null){
                ld.Send_confirmation_Email__c = prdrmap.get(ld.LeadProvider_ID__c).Send_Customer_Acknowledgement_Email_Flag__c;
                }
                
                if((ld.Division_CD__c == '' || ld.Division_CD__c == null)&& prdrmap.get(ld.LeadProvider_ID__c) != null && prdrmap.get(ld.LeadProvider_ID__c).SubDivision_TXT__c != null){
                     ld.Division_CD__c = prdrmap.get(ld.LeadProvider_ID__c).Division__c;
                     ld.SubDiv_TXT__c = prdrmap.get(ld.LeadProvider_ID__c).SubDivision_TXT__c;
                }
                
                String leadLastName = (ld.LastName).toUpperCase();
                String leadConcatName = (leadFirstName + ' ' + leadLastName).trim();
               // system.debug('leadConcatName:'+leadConcatName);
                //LMS-5349-Lavanya  
                // String leadStreet = ld.Street;
                // String leadEmail = ld.Email;
                String leadStreet = '';
                if(ld.Street != null && ld.Street!=''){
                    leadStreet = ((ld.Street).toUpperCase()).trim();
                    //      system.debug('leadStreet:'+leadStreet);
                } 
                String leadEmail = '';
                if(ld.Email != null && ld.Email!=''){
                    leadEmail = ((ld.Email).toUpperCase()).trim();
                    // system.debug('leadEmail:'+leadEmail);
                }
                // end -5349
                
                if(ld.Email != null && ld.Provider_Type__c ==  HELMSConstants.DealerOriginatedLead ){
                    ld.ValidEmail_FLG__c = true;
                } else if(ld.Phone != null  && ld.Provider_Type__c ==  HELMSConstants.DealerOriginatedLead ){
                    ld.ValidPhoneNum_FLG__c = true;
                } else if(ld.MobilePhone != null && ld.Provider_Type__c ==  HELMSConstants.DealerOriginatedLead ){
                    ld.ValidMobile_FLG__c = true;
                }
                
                //System.debug('mapFilterWords : '+mapFilterWords);
                for (string str: mapFilterWords.keyset()) {
                    str = str.toUpperCase();
                    //   System.debug('Str : '+str);
                    if(mapFilterWords.containskey(str))
                        // system.debug('1:'+mapFilterWords.containskey(str));
                        //  System.debug('======>>>>>>'+mapFilterWords.get(str).Handling_txt__c);
                        if(ld.ValidName_TXT__c != HELMSConstants.Genuine  && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead)
                    {
                        if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Contains && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Name || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmails )) {
                            
                            if (mapFilterWords.containskey(str) && leadFirstName != null && leadFirstName.contains(str)) {  
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            } else if (mapFilterWords.containskey(str) && leadLastName != null && leadLastName.contains(str)) {
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            } else if (mapFilterWords.containskey(str) && leadConcatName != null && leadConcatName.contains(str)) {
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            }
                        } else if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Equals && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Name || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmails )) {
                            
                            if (mapFilterWords.containskey(str) && leadFirstName != null && leadFirstName.equals(str)) {
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            } else if (mapFilterWords.containskey(str) && leadLastName != null && leadLastName.equals(str)) {
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            } else if (mapFilterWords.containskey(str) && leadConcatName != null && leadConcatName.equals(str)) {
                                
                                ld.ValidName_TXT__c = mapFilterWords.get(str).Handling_txt__c;
                            }
                        }
                    }
                    //   system.debug('mapFilterWords.get(str).Category_txt__c :'+mapFilterWords.get(str).Category_txt__c);
                    // system.debug('HELMSConstants.Contains :'+HELMSConstants.Contains);
                    // modified as part of CAPS-4294
                    if(ld.ValidEmail_FLG__c == true){
                        ld.Email_Cache_Status__c = HELMSConstants.Genuine;
                    }
                    if(ld.ValidEmail_FLG__c == false && ld.Email_Cache_Status__c != HELMSConstants.Genuine  && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead)
                    {
                        if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Contains && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Email || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmails ) && leadEmail != null && leadEmail.contains(str))  {
                            //       System.debug('Contains *');
                            ld.Email_Cache_Status__c = mapFilterWords.get(str).Handling_txt__c;
                        }else if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Equals && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Email || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmails ) && leadEmail != null && leadEmail.equals(str)) {
                            // System.debug('Reject *');            
                            ld.Email_Cache_Status__c = mapFilterWords.get(str).Handling_txt__c;
                        } 
                    }
                    // modified as part of CAPS-4294
                    if(ld.ValidAddress_FLG__c == true){
                        ld.Address_Cache_Status__c = HELMSConstants.Genuine;
                    }
                    if(ld.ValidAddress_FLG__c == false && ld.Address_Cache_Status__c != HELMSConstants.Genuine  && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead)
                    {
                        if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Contains && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Address || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail||mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmails ) && leadStreet != null && leadStreet.contains(str))  {
                            ld.Address_Cache_Status__c = mapFilterWords.get(str).Handling_txt__c;
                        }else if (mapFilterWords.containskey(str) && mapFilterWords.get(str).Category_txt__c == HELMSConstants.Equals && (mapFilterWords.get(str).Check_Against__c == HELMSConstants.Address || mapFilterWords.get(str).Check_Against__c == HELMSConstants.NameAddressEmail ) && leadStreet != null && leadStreet.equals(str)) {
                            
                            ld.Address_Cache_Status__c = mapFilterWords.get(str).Handling_txt__c;
                        } 
                    }
                    
                }
                
                 /*HPT-448 - start */
                  Boolean hasaddressvalidationcache = ((ld.ValidName_TXT__c ==  HELMSConstants.Genuine || ld.ValidName_TXT__c == null) && (ld.Email_Cache_Status__c == HELMSConstants.Genuine || ld.Email_Cache_Status__c == null) && ld.Address_Cache_Status__c != HELMSConstants.Genuine);
                 /*HPT-448 - end*/ 
               
                   
                if ((isRunValidName || ld.IsConverted == true ) && ld.Status !=  HELMSConstants.CNC && ld.Status != HELMSConstants.closedcon) {
                    isRunValidName = false;
                    //  LMS-6124-R4 - start - Lavanya
                     Boolean isMarketableflag = false;
                     Boolean leadGrade = false;
                    Boolean isDeal = false;

                    Boolean hasAtLeastOneValidContactMethod = (ld.ValidEmail_FLG__c || ld.ValidPhoneNum_FLG__c || ld.ValidMobile_FLG__c);//CAPS-1078
                    
                    if((ld.ValidEmail_FLG__c == True && ld.Email != null && ld.Division_CD__c != null) && 
                       (prdrmap.get(ld.LeadProvider_ID__c) != null && (prdrmap.get(ld.LeadProvider_ID__c).Send_confirmation_interest_notification__c == true || prdrmap.get(ld.LeadProvider_ID__c).Send_Product_Missing_Notification__c == true || prdrmap.get(ld.LeadProvider_ID__c).Send_Invalid_Information_notification__c == true)) &&
                       (ld.Model_TXT__c == null || (ld.ValidAddress_FLG__c == false && ld.PreferredDealerAccount_ID__c == null) || (ld.ValidPhoneNum_FLG__c == false && ld.ContactType_TXT__c == 'Home Phone')))
                    {
                       isMarketableflag = true; 
                    }
                    
                     if(ld.Source_Unique_ID__c != null && ld.Deal_ID__c == null && ld.Deal_Link__c == null){
                            
                        isDeal = true; 
                            
                        }
                    
                    if(ld.StatusReason_TXT__c != HELMSConstants.Conciergecmpld ){
                  
                      if(isMarketableflag == true && ld.Reconfirm_Interest__c == HELMSConstants.noresponse && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead )
                        {
                            ld.StatusReason_TXT__c = HELMSConstants.journeyincomplete;
                            ld.Status = HELMSConstants.CNC;
                                    
                        } else if(isMarketableflag == true && ld.Reconfirm_Interest__c == 'No' && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            
                            ld.StatusReason_TXT__c = HELMSConstants.CustIntrstPrdct;
                            ld.Status = HELMSConstants.CNC;
                            
                        } else if(isMarketableflag == true && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            ld.StatusReason_TXT__c = HELMSConstants.Nurturingjourney;
                            ld.Status = HELMSConstants.Nurturing;
                        
                        }  else if (ld.IsConverted == true && ld.ConvertedOpportunityId != null && (ld.Status == HELMSConstants.closedcon || ld.Status == HELMSConstants.Convert) && (ld.StatusReason_TXT__c == HELMSConstants.LECE || ld.StatusReason_TXT__c == HELMSConstants.Pending || ld.StatusReason_TXT__c == HELMSConstants.invalidemailphone || ld.StatusReason_TXT__c == HELMSConstants.UAD || ld.StatusReason_TXT__c == HELMSConstants.journeycmpld || ld.StatusReason_TXT__c == HELMSConstants.Conciergecmpld ||ld.StatusReason_TXT__c == null )){
                          
                            ld.Status = HELMSConstants.closedcon;
                            ld.StatusReason_TXT__c = HELMSConstants.newoppty; 
                            
                        } else if (ld.IsConverted == true && ld.ConvertedOpportunityId != null && ld.Status == HELMSConstants.Convert && (ld.StatusReason_TXT__c == HELMSConstants.tpd || ld.StatusReason_TXT__c == HELMSConstants.Dupsim)){
                          
                            ld.Status = HELMSConstants.closedcon;
                            
                        } else if (isMarketableflag == false && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead  && (ld.ValidName_TXT__c == HELMSConstants.Reject || ld.Email_Cache_Status__c == HELMSConstants.Reject || ld.Address_Cache_Status__c == HELMSConstants.Reject)) {
                        
                            ld.StatusReason_TXT__c = HELMSConstants.NameAddEmailError;
                            ld.Status =  HELMSConstants.CNC;
                        
                        } else if(isMarketableflag == false && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead  && (ld.ValidName_TXT__c == HELMSConstants.Cache || ld.Email_Cache_Status__c == HELMSConstants.Cache || (ld.Address_Cache_Status__c == HELMSConstants.Cache &&  !hasaddressvalidationcache)) ) {
                       
                            ld.StatusReason_TXT__c =  HELMSConstants.NameAddrEmailCache;
                            ld.Status = HELMSConstants.MVal;
                        } else if(isMarketableflag == false && prdrmap.get(ld.LeadProvider_ID__c) == null){
                        
                            ld.StatusReason_TXT__c = HELMSConstants.LPE;
                            ld.Status = HELMSConstants.MVal;
                        
                        }  else if(isMarketableflag == false && ld.PreferredDealerAccount_ID__c == null ){
                        
                            if(ld.StatusReason_TXT__c != HELMSConstants.UAD){
                                ld.StatusReason_TXT__c = HELMSConstants.UAD;    
                            }
                            ld.Status = HELMSConstants.MVal;
                        /**CAPS-1078  -start */    
                        } else if ((isMarketableflag == false   && ld.PreferredDealerAccount_ID__c != null && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead && !hasAtLeastOneValidContactMethod && (ld.Status == 'New' || ld.StatusReason_TXT__c == HELMSConstants.UAD ))||
                                 (isMarketableflag == false && ld.Is_Enrichment_Update__c == true  &&!hasAtLeastOneValidContactMethod) && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                           
                            ld.StatusReason_TXT__c = HELMSConstants.invalidemailphone;
                            ld.Status = HELMSConstants.onhold;
                            // system.debug('status------->'+ld.status);
                        /**CAPS-1078 -end */    
  
                        } else if(prdrmap.get(ld.LeadProvider_ID__c).Enrichment__c == false &&  ld.StatusReason_TXT__c != HELMSConstants.Dupmerge && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead  &&  ld.StatusReason_TXT__c != HELMSConstants.tpd && (ld.ContactKey_TXT__c == null || ld.Is_Enrichment_Update__c == false) && ld.StatusReason_TXT__c != HELMSConstants.Dupsim &&  ld.Status != HELMSConstants.closedcon &&  ld.StatusReason_TXT__c != HELMSConstants.Pending){
                            ld.StatusReason_TXT__c = HELMSConstants.LECE ;
                            ld.Status = HELMSConstants.onhold; 
                        
                        } else if(isMarketableflag == false && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead  && ld.SFMC_Sales_errorcode__c != null && ld.SFMC_Service_errorcode__c != null && ld.Location_Error_CD__c!=null && ld.PreferredDealerAccount_ID__c == null){
                            ld.StatusReason_TXT__c = HELMSConstants.DACF;
                            ld.Status = HELMSConstants.onhold;    
                        }else if(prdrmap.get(ld.LeadProvider_ID__c) != null && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead  && prdrmap.get(ld.LeadProvider_ID__c).Is_Concierge_Process_Needed__c){
                            ld.Status = HELMSConstants.Nurturing;
                            ld.StatusReason_TXT__c = HELMSConstants.Concierge;
                        }else if(ld.Is_Duplicate_Similar_Lead__c == true && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            ld.StatusReason_TXT__c = HELMSConstants.Dupsim;
                        }else if(ld.Is_Third_Party_Duplicate_Lead__c == true && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            ld.StatusReason_TXT__c = HELMSConstants.TPD;
                        } else if(isDeal == true && ld.Status != HELMSConstants.Convert && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            
                            ld.StatusReason_TXT__c = HELMSConstants.WaitforDeal;
                            ld.Status = HELMSConstants.onhold;   
                            
                        } else if(isDeal == false && ld.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            ld.StatusReason_TXT__c = HELMSConstants.Pending;
                            ld.Status = 'New';
                        }
                    
                    }
                         //  system.debug('status------->'+ld.status);
                         //  system.debug('status Reason ------------>'+ld.StatusReason_TXT__c);  
                         //  system.debug('isconverted----->'+ld.IsConverted);
                    
                    
                     
                
                    //LMS-6124-R4- End
                      system.debug('ld.LeadGrade_FLG__c---->'+ld.LeadGrade_FLG__c);
                    //LMS-3647-Lavanya
                    if ( ld.Is_Enrichment_Update__c && ld.IsFirstName_FLG__c  && (ld.StatusReason_TXT__c==null || ld.StatusReason_TXT__c == HELMSConstants.Pending || ld.StatusReason_TXT__c == HELMSConstants.Dupsim || ld.StatusReason_TXT__c == HELMSConstants.TPD || ld.StatusReason_TXT__c == HELMSConstants.LECE || ld.StatusReason_TXT__c == HELMSConstants.UAD) && ld.Division_CD__c!=null && ld.Status!= HELMSConstants.CNC && (ld.ValidEmail_FLG__c || ld.ValidPhoneNum_FLG__c || ld.ValidMobile_FLG__c ) && 
                        (ld.Email_Cache_Status__c == null ||ld.Email_Cache_Status__c== HELMSConstants.Genuine) && (ld.ValidName_TXT__c == null ||ld.ValidName_TXT__c== HELMSConstants.Genuine) && (ld.Address_Cache_Status__c == null || ld.Address_Cache_Status__c == HELMSConstants.Genuine ||  hasaddressvalidationcache)  && ld.PreferredDealerAccount_ID__c != null && prdrmap.get(ld.LeadProvider_ID__c) != null && prdrmap.get(ld.LeadProvider_ID__c).Enrichment__c == true && ld.CustomerAccount_ID__c != null && isMarketableflag == false && 
                        (ld.Triggertypecode__c == HELMSConstants.Instant || 
                        ((ld.Triggertypecode__c== HELMSConstants.Future || ld.Triggertypecode__c== HELMSConstants.FixedDate )&& 
                       prdrmap.get(ld.LeadProvider_ID__c) != null && prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c != null && ld.TriggerSendbyDate_DT__c==null && prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c<=system.now())||
                         ((ld.Triggertypecode__c== HELMSConstants.Future || ld.Triggertypecode__c== HELMSConstants.FixedDate) && 
                         prdrmap.get(ld.LeadProvider_ID__c) != null && ld.TriggerSendbyDate_DT__c!=null && ld.TriggerSendbyDate_DT__c <prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c &&  
                          (prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c == null || prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c > System.now()) && ld.TriggerSendbyDate_DT__c <= system.now())||
                         ((ld.Triggertypecode__c == HELMSConstants.Future || ld.Triggertypecode__c== HELMSConstants.FixedDate) && prdrmap.get(ld.LeadProvider_ID__c) != null &&
                          ld.TriggerSendbyDate_DT__c !=null && prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c <ld.TriggerSendbyDate_DT__c && 
                          (prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c == null || prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c > System.now()) &&  prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c <= system.now())||
                         ((ld.Triggertypecode__c==HELMSConstants.Future || ld.Triggertypecode__c== HELMSConstants.FixedDate) &&
                          prdrmap.get(ld.LeadProvider_ID__c) !=null && prdrmap.get(ld.LeadProvider_ID__c).RoutingDate_DT__c == null && ld.TriggerSendbyDate_DT__c !=null && 
                          (prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c == null || prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c > System.now()) &&  ld.TriggerSendbyDate_DT__c <= system.now())))
                        {
                            
                              //   system.debug('status ----->'+ld.status); 
                                leadGrade = true;
                                if(leadGrade = true && isMarketableflag == false  && (ld.StatusReason_TXT__c == null|| ld.StatusReason_TXT__c == HELMSConstants.Nurturingjourney || ld.StatusReason_TXT__c == HELMSConstants.UAD || ld.StatusReason_TXT__c == HELMSConstants.Pending|| ld.StatusReason_TXT__c == HELMSConstants.LECE || ld.StatusReason_TXT__c == HELMSConstants.DACF)&& prdrmap.get(ld.LeadProvider_ID__c).Is_Concierge_Process_Needed__c == false && ld.Status != HELMSConstants.closedcon ) 
                                {
                                   
                                    ld.Status = HELMSConstants.Convert;
                                    ld.StatusReason_TXT__c = HELMSConstants.journeycmpld;
                                   
                                }else if (leadGrade = true && isMarketableflag == false && (ld.Status != HELMSConstants.Convert && ld.Status != HELMSConstants.closedcon) && prdrmap.get(ld.LeadProvider_ID__c).Is_Concierge_Process_Needed__c == true ) {
                                   
                                    ld.Status = HELMSConstants.Nurturing;
                                    ld.StatusReason_TXT__c = HELMSConstants.Concierge;
                                   
                                }else if(leadGrade = true && isMarketableflag == false && ld.StatusReason_TXT__c == HELMSConstants.tpd && ld.Status != HELMSConstants.closedcon ){
                                  
                                    ld.Status = HELMSConstants.Convert;
                                    //ld.Status = HELMSConstants.closedcon;
                                }
                             
                               
                                              
                          }
                  
                    
                    
                    //LMS-6123 mamatha
                    if (prdrmap.get(ld.LeadProvider_ID__c)!= null && prdrmap.get(ld.LeadProvider_ID__c).Enrichment__c == true && ld.Is_Enrichment_Update__c && ld.IsFirstName_FLG__c && (ld.StatusReason_TXT__c==null || ld.StatusReason_TXT__c == HELMSConstants.Pending || ld.StatusReason_TXT__c == HELMSConstants.Dupsim || ld.StatusReason_TXT__c == HELMSConstants.TPD || ld.StatusReason_TXT__c == HELMSConstants.LECE || ld.StatusReason_TXT__c == HELMSConstants.Nurturingjourney) && ld.Division_CD__c!=null && ld.Status!= HELMSConstants.CNC  &&  ld.StatusReason_TXT__c != HELMSConstants.Dupsim &&
                        (ld.Email_Cache_Status__c == null ||ld.Email_Cache_Status__c== HELMSConstants.Genuine) && 
                        (ld.ValidName_TXT__c == null ||ld.ValidName_TXT__c== HELMSConstants.Genuine) && (ld.Address_Cache_Status__c == null || ld.Address_Cache_Status__c == HELMSConstants.Genuine ||  hasaddressvalidationcache)  && ld.PreferredDealerAccount_ID__c != null && ld.LeadProvider_ID__c != null  &&
                        (ld.ValidEmail_FLG__c || ld.ValidPhoneNum_FLG__c || ld.ValidMobile_FLG__c ) &&  ld.Status != HELMSConstants.Convert && isMarketableflag == false && ld.Triggertypecode__c != HELMSConstants.Instant ){
                           
                            if(prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c == null || prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c != null) 
                            {   
                                ld.Status = HELMSConstants.onhold;
                                if(prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c == null || prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c > System.now()){
                                
                                    ld.StatusReason_TXT__c = HELMSConstants.windowtostart;     
                                    
                                }else if(prdrmap.get(ld.LeadProvider_ID__c).Routing_Date_Termination__c < System.now()){                                
                                    
                                    ld.StatusReason_TXT__c = HELMSConstants.windowexpired;
                                
                                }
                            } 
                             
                            
                        } 
                    
                }
                
            }
                
            
        
    }   Catch(Exception ex) {
            Logs__c l = new Logs__c(name = 'Lead- Update Valid Name', Trigger_or_Class_Name__c = 'LeadTriggerHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
        }
   
    }
    
    /*public static boolean checkLeadWithSameProvider(Id LeadProvider){
String testId = (string)LeadProvider;
integer  count= database.countQuery('select count() FROM Lead WHERE LeadProvider_ID__c =: testId');
system.debug('the count is '+ count);
if(count > 0){
return true;
}
return false;
}*/
    
    
    //Method for handling De-Duplication Logic for Leads(LMS-1568)
    public void findDuplicateLeadRecord(List < Lead > newvalues) {
        
        try{
            Map < String, Lead > leadNameMap = new Map < String, Lead > ();
            Map < String, Deduplication_Parameters__mdt > customDivisionMap = new Map < string, Deduplication_Parameters__mdt > ();
            for (Deduplication_Parameters__mdt dup: [select id, Division__c, Minutes_Threshold__c, Days_Threshold__c, UBBottomDaysInMin__c, UBUpperDaysInMin__c from Deduplication_Parameters__mdt]) {
                customDivisionMap.put(dup.Division__c, dup);
            }
            
            set < String > divisionSet = new set < String > ();
            set < String > subDivisionSet = new set < String > ();
            set < String > prefDealerAccSet = new set < String > ();
            set < String > modelSet = new set < String > ();
            
            /* All Leads inserting throgh trigger */
            List<Lead> newInsertingLead = new List<Lead>();
            Map<String, Lead> leadMap = new Map<String, Lead>();
            
            /* To get all Leads that differs only LeadProvider Value */
            Map<String, List<Lead>> mapMatchingDuplicateConditions = new Map<String, List<Lead>>(); // All Leads that has duplicate conditions        
            /* To get all Leads that differs only LeadProvider Value */
            
            /* To hold all Lead Id that matches with condition */
            List<lead> matchingLeadRec = new List<lead>();
            /* To hold all Lead Id that matches with condition */
            
            /* All Parent Leads to be updated multipleleadprovider field */
            List<lead> leadsToUpdate = new List<lead>();
            Map<Id, String> leadsToUpdateMap = new Map<Id, String>();
            /* All Parent Leads to be updated multipleleadprovider field */
            
            /* All Converted Opportunity to be updated */
            List<Opportunity> oppToUpdate = new List<Opportunity>();
            /* All Converted Opportunity to be updated */
            
            /* Lead Provider Name Map */
            List<Id> leadProviderNamesIdList = new List<Id>();
            Map<Id,String> leadProviderNamesIdMap = new Map<Id,String>();
            //6623
            Map<Id, Account> accountMap = new Map<Id, Account>();
            
            /* Lead Provider Name Map */
            for (lead ld: newvalues) {
                newInsertingLead.add(ld);
                leadMap.put(ld.LastName,ld); // Adding all inserting Leads into the Map
                divisionSet.add(ld.Division_CD__c);
                subDivisionSet.add(ld.SubDiv_TXT__c);
                prefDealerAccSet.add(ld.PreferredDealerAccount_ID__c);
                leadProviderNamesIdList.add(ld.LeadProvider_ID__c);
                modelSet.add(ld.Model_TXT__c);
            }
            //System.debug('leadProviderNamesId : '+leadProviderNamesIdList);
            if(leadProviderNamesIdList.size() > 0){
                for(Account acc: [SELECT Id, Name,Bypass_Duplicate_Merge_Rule__c, Deduplication__c from Account WHERE Id IN: leadProviderNamesIdList]){
                    leadProviderNamesIdMap.put(acc.Id,acc.Name);
                    accountMap.put(acc.Id,acc);
                }   
                  //System.debug('accountMap : '+accountMap);             
            }
            //System.debug('leadProviderNamesIdMap : '+leadProviderNamesIdMap);
            
            Map < String, String > leadMulProvDupMap = new Map < String, String > ();
            String leadProviderNames = '';
            List<Id> parentLeadId = new List<Id>();
            Map<Id, String> parentLeadMap = new Map<Id, String>();
            
            
            /* LMS-2842 (For adding ParentLead_ID__c) */
            Map<String, Id> matchingParentLeadsMap = new Map<String, Id>();
            /* LMS-2842 (For adding ParentLead_ID__c) */
            
            
            /* 06 Jul 2021 */
            Map<String, Set<String>> newLeadProviderMap = new Map<String, Set<String>>();
            Map<String, Set<Id>> newLeadProviderMapDetails = new Map<String, Set<Id>>();
            
            Set<String> leadProviderStrSet = new Set<String>();
            Set<Id> leadProviderStrSetDetails = new Set<Id>();
            
            /* LMS - 1930 - Adding Multiple Lead Provider ** */
            
            
            /* LMS - 1930 - Adding Multiple Lead Provider ** */   
            
            
            
            
            for (Lead listofLead: [select id, LeadProvider_ID__c, LeadProvider_ID__r.Name, LeadProvider_ID__r.Compare_Third_Party_for_Duplicate_Flag__c, Year_YR__c, FirstName, External_Lead_Reference_Number__c, LastName, Email, Phone, PostalCode, PreferredDealerAccount_ID__c, Division_CD__c, SubDiv_TXT__c, Model_TXT__c, Trim_TXT__c,InventoryNumber_TXT__c, IsConverted, Status, CreatedDate, StatusReason_TXT__c, ConvertedOpportunityId from Lead where Model_TXT__c IN: modelSet AND Division_CD__c IN: divisionSet and SubDiv_TXT__c IN: subDivisionSet and PreferredDealerAccount_ID__c IN: prefDealerAccSet AND Createddate= LAST_N_DAYS:30 and Status !='Closed - Not Converted' and StatusReason_TXT__c !='Name/Address/Email Cache' ORDER BY CreatedDate DESC]) {
                
                /* To get all Leads that differs only LeadProvider Value. Adding Items */
                
                for(Lead ldtemp : newInsertingLead){
                    if(accountMap.get(ldtemp.LeadProvider_ID__c) != null && accountMap.get(ldtemp.LeadProvider_ID__c).Deduplication__c){
                    
                    /* LMS-2842 (For adding ParentLead_ID__c) */
                    /*
FInd the duplicate Leads with the following condition
Exact: Last Name,Email address,Phone Number,Postal Coder,Preferred Dealer Account,Division,Subdivision,Model and Year.
Add value to Parent Lead Field with the matching Lead Record
*/
                    //Checking the condition for the matching Scenario.
                    if( (ldtemp.LastName == listofLead.LastName) && 
                       (ldtemp.Email == listofLead.Email) && 
                       (ldtemp.Phone == listofLead.Phone) &&
                       (ldtemp.PostalCode == listofLead.PostalCode) &&
                       (ldtemp.PreferredDealerAccount_ID__c == listofLead.PreferredDealerAccount_ID__c) && 
                       (ldtemp.Division_CD__c == listofLead.Division_CD__c) && 
                       (ldtemp.SubDiv_TXT__c == listofLead.SubDiv_TXT__c) && 
                       (ldtemp.Model_TXT__c == listofLead.Model_TXT__c) && 
                       (ldtemp.Year_YR__c == listofLead.Year_YR__c) &&
                       (ldtemp.InventoryNumber_TXT__c == listofLead.InventoryNumber_TXT__c)
                      ){
                          //Adding Elements to map based on the Lead Duplication Condition 
                          if(!matchingParentLeadsMap.containskey(ldtemp.LastName+''+ldtemp.Email+''+ldtemp.Phone+''+ldtemp.PostalCode+''+ldtemp.PreferredDealerAccount_ID__c+''+ldtemp.Division_CD__c+''+ldtemp.SubDiv_TXT__c+''+ldtemp.Model_TXT__c+''+ldtemp.Year_YR__c+''+ldtemp.InventoryNumber_TXT__c)){
                              matchingParentLeadsMap.put(ldtemp.LastName+''+ldtemp.Email+''+ldtemp.Phone+''+ldtemp.PostalCode+''+ldtemp.PreferredDealerAccount_ID__c+''+ldtemp.Division_CD__c+''+ldtemp.SubDiv_TXT__c+''+ldtemp.Model_TXT__c+''+ldtemp.Year_YR__c+''+ldtemp.InventoryNumber_TXT__c,listofLead.Id);    
                          }else{
                              matchingParentLeadsMap.put(ldtemp.LastName+''+ldtemp.Email+''+ldtemp.Phone+''+ldtemp.PostalCode+''+ldtemp.PreferredDealerAccount_ID__c+''+ldtemp.Division_CD__c+''+ldtemp.SubDiv_TXT__c+''+ldtemp.Model_TXT__c+''+ldtemp.Year_YR__c+''+ldtemp.InventoryNumber_TXT__c,listofLead.Id);   
                          }
                      }
                    /* LMS-2842 (For adding ParentLead_ID__c) */
                }
                }
                /* To get all Leads that differs only LeadProvider Value. Adding Items */
                
                if(!leadNameMap.containsKey(listofLead.Lastname)){
                    leadNameMap.put(listofLead.Lastname, listofLead);
                }
            }
            
            //System.debug('Before Matching **'); 
            
            Map<string , String> oppMunlProviderUpdate = new Map<string , String>();
            for (lead l: newvalues) {
                if(accountMap.get(l.LeadProvider_ID__c) != null && accountMap.get(l.LeadProvider_ID__c).Deduplication__c){
                    
                
                /* Checking the Lead Provider is new in the entire system */
                Boolean existsLeadProviderInSystem = false;
                //existsLeadProviderInSystem = LeadTriggerHandler.checkLeadWithSameProvider(l.LeadProvider_ID__c);
                /* Checking the Lead Provider is new in the entire system */
                
                if (leadNameMap.containsKey(l.lastname)) {
                    if( (l.FirstName == leadNameMap.get(l.lastname).FirstName) && 
                       (l.Email == leadNameMap.get(l.lastname).Email) && 
                       (l.Phone == leadNameMap.get(l.lastname).Phone) && 
                       (l.PostalCode == leadNameMap.get(l.lastname).PostalCode) &&
                       (l.PreferredDealerAccount_ID__c == leadNameMap.get(l.lastname).PreferredDealerAccount_ID__c) && 
                       (l.Division_CD__c == leadNameMap.get(l.lastname).Division_CD__c) &&
                       (l.SubDiv_TXT__c == leadNameMap.get(l.lastname).SubDiv_TXT__c) &&
                       (l.Model_TXT__c == leadNameMap.get(l.lastname).Model_TXT__c) &&
                       (l.InventoryNumber_TXT__c == leadNameMap.get(l.lastname).InventoryNumber_TXT__c)) {
                           /* Urban Science Leads */
                          // System.debug('l.External_Lead_Reference_Number__c : '+l.External_Lead_Reference_Number__c);
                           if((l.External_Lead_Reference_Number__c != null && l.External_Lead_Reference_Number__c != '') && l.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                               System.debug('1 : '+ leadProviderNamesIdMap);
                               System.debug('2 : '+ leadProviderNamesIdMap.containskey(l.LeadProvider_ID__c) );
                               System.debug('3 : '+leadProviderNamesIdMap.get(l.LeadProvider_ID__c).containsIgnoreCase('thirdparty'));
                               System.debug('4 : '+leadNameMap.get(l.lastname).LeadProvider_ID__r.Compare_Third_Party_for_Duplicate_Flag__c);
                               if( (leadProviderNamesIdMap.size() > 0 && leadProviderNamesIdMap.containskey(l.LeadProvider_ID__c) && leadProviderNamesIdMap.get(l.LeadProvider_ID__c).containsIgnoreCase('thirdparty') && (leadNameMap.get(l.lastname).LeadProvider_ID__r.Compare_Third_Party_for_Duplicate_Flag__c) )   ||  (leadNameMap.get(l.lastname).LeadProvider_ID__r.Compare_Third_Party_for_Duplicate_Flag__c)){
                                //   System.debug(' Inside the Lead Provider THIRDPARTY');
                                   /* Finding Days between */
                                   Integer noOfDays = 0;
                                   Integer noOfDaysInMin = 0;
                                   Date startDate = Date.today();
                                   Date endDate = Date.valueOf(leadNameMap.get(l.lastname).CreatedDate);
                                   
                                 //  System.debug('DIFF ** '+ (DateTime.now().getTime() - leadNameMap.get(l.lastname).CreatedDate.getTime()) );
                                   Integer minDiff = Integer.valueOf( (DateTime.now().getTime() - leadNameMap.get(l.lastname).CreatedDate.getTime()) / (1000 * 60) );
                                 //  System.debug('minDiff : '+minDiff);
                                   //System.debug('endDate : '+endDate);
                                   noOfDays = endDate.daysBetween(startDate);
                                   //System.debug('Number of Days : '+noOfDays);
                                   /* Finding Days between */
                                   noOfDaysInMin = noOfDays*24*60;
                               //      System.debug('noOfDaysInMin : '+noOfDaysInMin);
                              //     System.debug('UBBottomDaysInMin__c : '+customDivisionMap.get(l.Division_CD__c).UBBottomDaysInMin__c);
                             //    System.debug('UBUpperDaysInMin__c : '+customDivisionMap.get(l.Division_CD__c).UBUpperDaysInMin__c);
                                   if(minDiff < customDivisionMap.get(l.Division_CD__c).UBBottomDaysInMin__c ){
                                        if(l.status == 'New' || l.status == HELMSConstants.onhold){
                                    //   System.debug('Inside Third Party Duplicate ');
                                       l.StatusReason_TXT__c = HELMSConstants.TPD;
                                       l.Is_Third_Party_Duplicate_Lead__c = true ;
                                   }
                                   }
                                   if(minDiff > customDivisionMap.get(l.Division_CD__c).UBBottomDaysInMin__c && minDiff < customDivisionMap.get(l.Division_CD__c).UBUpperDaysInMin__c){
                                    //   System.debug('Inside Duplicate Similar Inside Urban Science ');
                                       l.StatusReason_TXT__c = HELMSConstants.Dupsim;
                                       l.Is_Duplicate_Similar_Lead__c = true ;
                                   }
                               }
                           }
                           /* Urban Science Leads */
                           
                           /* Non-Urban Science Leads */
                           if((l.External_Lead_Reference_Number__c == '' || l.External_Lead_Reference_Number__c == null) && l.Provider_Type__c !=  HELMSConstants.DealerOriginatedLead ){
                            //   System.debug('Inside No External Lead Reference Number'+l.LeadProvider_ID__c +' : '+leadNameMap.get(l.lastname).LeadProvider_ID__c);
                               // && !existsLeadProviderInSystem
                               if(l.LeadProvider_ID__c != leadNameMap.get(l.lastname).LeadProvider_ID__c){
                                   System.debug('Inside Not Matching');
                                   // l.Status = 'Manual Validation'; - LMS-6124- Lavanya - R4
                                   l.Status = HELMSConstants.Convert;
                                   l.StatusReason_TXT__c = 'Duplicate Similar';
                                   l.Is_Duplicate_Similar_Lead__c = true ;
                               }
                               if(l.LeadProvider_ID__c == leadNameMap.get(l.lastname).LeadProvider_ID__c){
                               //    System.debug('Inside Matching');
                                   DateTime currebtDT = datetime.now();
                                   DateTime leadCreatedDT = leadNameMap.get(l.lastname).createddate;
                                   //6623
                                   Account oldAcc = accountmap.get(l.LeadProvider_ID__c );
                                   boolean sameDay = leadCreatedDT.isSameDay(currebtDT);
                                   Integer minute=0;
                                   boolean DuplicateSimilar = false;
                                   boolean DuplicateMerged = false;
                                   if(sameDay){
                                       if(currebtDT.hour() == leadCreatedDT.hour() ){
                                           minute = currebtDT.minute() - leadCreatedDT.minute() ;
                                           System.debug('minute : '+minute);
                                           //6623
                                           if(customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c != null && (minute <= customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c)&& (oldAcc.Bypass_Duplicate_Merge_Rule__c== false)){
                                               DuplicateMerged = true;    
                                           }
                                           //6623
                                           else if(customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c != null && (minute <= customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c)&& (oldAcc.Bypass_Duplicate_Merge_Rule__c== true)){
                                               DuplicateSimilar = true;    
                                           }
                                           
                                           else if(customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c != null && (minute > customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c)){
                                               DuplicateSimilar = true;    
                                           }else{
                                               DuplicateMerged = true;
                                           }
                                           
                                       }else{
                                           DuplicateSimilar=true;
                                       }
                                   }else{
                                       DuplicateSimilar=true;
                                   }
                               //    System.debug('minute : '+minute);
                              //    System.debug('Merge/ Similar : '+DuplicateMerged+', '+DuplicateSimilar);
                             //     System.debug('customDivisionMap : '+customDivisionMap);
                                   if (customDivisionMap.containsKey(l.Division_CD__c)) {
                                //       System.debug('Inside &&');
                                       if (DuplicateMerged && (l.Division_CD__c != null) && (customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c != null) && (minute <= customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c)) {
                                   //        System.debug('Inside && && ');
                                           l.Status = HELMSConstants.CNC;
                                           l.StatusReason_TXT__c = HELMSConstants.Dupmerge;
                                           //Parent Lead Id checking in the Map and adding the ParentLeadId value
                                           if(matchingParentLeadsMap.size() > 0 && matchingParentLeadsMap.containskey(l.LastName+''+l.Email+''+l.Phone+''+l.PostalCode+''+l.PreferredDealerAccount_ID__c+''+l.Division_CD__c+''+l.SubDiv_TXT__c+''+l.Model_TXT__c+''+l.Year_YR__c)){
                                               l.ParentLead_ID__c = matchingParentLeadsMap.get(l.LastName+''+l.Email+''+l.Phone+''+l.PostalCode+''+l.PreferredDealerAccount_ID__c+''+l.Division_CD__c+''+l.SubDiv_TXT__c+''+l.Model_TXT__c+''+l.Year_YR__c);
                                           }
                                       } else if (DuplicateSimilar && (l.Division_CD__c != null) && (customDivisionMap.get(l.Division_CD__c).Minutes_Threshold__c != null)) {
                                  //         System.debug('Inside && && &&');
                                         //  l.Status = HELMSConstants.MVal; -  LMS-6124- Lavanya - R4
                                           l.Status = HELMSConstants.Convert;
                                           l.StatusReason_TXT__c = HELMSConstants.Dupsim;
                                           l.Is_Duplicate_Similar_Lead__c = true ;
                                           //Parent Lead Id checking in the Map and adding the ParentLeadId value
                                           if(matchingParentLeadsMap.size() > 0 && matchingParentLeadsMap.containskey(l.LastName+''+l.Email+''+l.Phone+''+l.PostalCode+''+l.PreferredDealerAccount_ID__c+''+l.Division_CD__c+''+l.SubDiv_TXT__c+''+l.Model_TXT__c+''+l.Year_YR__c)){
                                               l.ParentLead_ID__c = matchingParentLeadsMap.get(l.LastName+''+l.Email+''+l.Phone+''+l.PostalCode+''+l.PreferredDealerAccount_ID__c+''+l.Division_CD__c+''+l.SubDiv_TXT__c+''+l.Model_TXT__c+''+l.Year_YR__c);
                                           } 
                                       }
                                   } 
                               }
                           }
                           /* Non-Urban Science Leads */
                           
                           
                       }
                }
                }
            
            
            }
            
            
        }
        
        Catch(Exception ex) {
            Logs__c l = new Logs__c(name = 'Lead-Find Duplicate', Trigger_or_Class_Name__c = 'LeadTriggerHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;
        }
        
    }
                    /*
                public void updateMultipleProvider(List < Lead > newLead){
                try{
                Map<String, Lead> leadMap = new Map<String, Lead>();
                set < String > divisionSet = new set < String > ();
                set < String > subDivisionSet = new set < String > ();
                set < String > prefDealerAccSet = new set < String > ();
                set < String > prefDealerAccNumSet = new set < String > ();
                Map<String, Set<String>> multiProviderValMap = new Map<String, Set<String>>();
                Map<Id, Set<String>> multiProviderValLeadId = new Map<Id, Set<String>>();
                List<Lead> newMulProList = new List<Lead>();
                for (lead ldRec: newLead) {
                leadMap.put(ldRec.LastName, ldRec);
                divisionSet.add(ldRec.Division_CD__c);
                subDivisionSet.add(ldRec.SubDiv_TXT__c);
                prefDealerAccSet.add(ldRec.PreferredDealerAccount_ID__c);
                prefDealerAccNumSet.add(ldRec.PreferredDealerNumber_NUM__c);
                }
                //Checking all existing records
                for (Lead allLeadRec: [select id, LeadProvider_ID__c, LeadProvider_ID__r.Name, Year_YR__c, LastName, Email, Phone, PostalCode, PreferredDealerAccount_ID__c, PreferredDealerNumber_NUM__c, Division_CD__c, SubDiv_TXT__c, Model_TXT__c, Trim_TXT__c, IsConverted, Status, CreatedDate, StatusReason_TXT__c, ConvertedOpportunityId from Lead where Division_CD__c IN: divisionSet and SubDiv_TXT__c IN: subDivisionSet and (PreferredDealerAccount_ID__c IN: prefDealerAccSet  or PreferredDealerNumber_NUM__c IN:prefDealerAccNumSet) and CreatedDate = LAST_N_DAYS: 30 ORDER BY CreatedDate DESC]) {
                if( leadMap.containskey(allLeadRec.LastName) && 
                (leadMap.get(allLeadRec.LastName).Email == allLeadRec.Email) && 
                (leadMap.get(allLeadRec.LastName).Phone == allLeadRec.Phone) && 
                (leadMap.get(allLeadRec.LastName).PostalCode == allLeadRec.PostalCode) && 
                ( (leadMap.get(allLeadRec.LastName).PreferredDealerAccount_ID__c == allLeadRec.PreferredDealerAccount_ID__c) || (leadMap.get(allLeadRec.LastName).PreferredDealerNumber_NUM__c == allLeadRec.PreferredDealerNumber_NUM__c)) && 
                (leadMap.get(allLeadRec.LastName).Division_CD__c == allLeadRec.Division_CD__c) && 
                (leadMap.get(allLeadRec.LastName).SubDiv_TXT__c == allLeadRec.SubDiv_TXT__c) && 
                (leadMap.get(allLeadRec.LastName).Year_YR__c == allLeadRec.Year_YR__c) && 
                (leadMap.get(allLeadRec.LastName).Model_TXT__c == allLeadRec.Model_TXT__c)
                ){
                //System.debug('allLeadRec ** : '+allLeadRec);
                newMulProList.add(allLeadRec);
                //Adding the Lead Provider values of all Leads to the Map
                if(!multiProviderValMap.containskey(leadMap.get(allLeadRec.LastName).LastName+''+leadMap.get(allLeadRec.LastName).Email+''+leadMap.get(allLeadRec.LastName).Phone+''+leadMap.get(allLeadRec.LastName).PostalCode+''+leadMap.get(allLeadRec.LastName).Division_CD__c+''+leadMap.get(allLeadRec.LastName).SubDiv_TXT__c+''+leadMap.get(allLeadRec.LastName).Model_TXT__c+''+leadMap.get(allLeadRec.LastName).Year_YR__c+''+leadMap.get(allLeadRec.LastName).PreferredDealerAccount_ID__c)){
                Set<String> multipleProviderSet = new Set<String>();
                multipleProviderSet.add(allLeadRec.LeadProvider_ID__r.Name);
                multiProviderValMap.put(leadMap.get(allLeadRec.LastName).LastName+''+leadMap.get(allLeadRec.LastName).Email+''+leadMap.get(allLeadRec.LastName).Phone+''+leadMap.get(allLeadRec.LastName).PostalCode+''+leadMap.get(allLeadRec.LastName).Division_CD__c+''+leadMap.get(allLeadRec.LastName).SubDiv_TXT__c+''+leadMap.get(allLeadRec.LastName).Model_TXT__c+''+leadMap.get(allLeadRec.LastName).Year_YR__c+''+leadMap.get(allLeadRec.LastName).PreferredDealerAccount_ID__c,multipleProviderSet);
                }else{
                Set<String> multipleProviderSet = new Set<String>(); 
                multipleProviderSet = multiProviderValMap.get(leadMap.get(allLeadRec.LastName).LastName+''+leadMap.get(allLeadRec.LastName).Email+''+leadMap.get(allLeadRec.LastName).Phone+''+leadMap.get(allLeadRec.LastName).PostalCode+''+leadMap.get(allLeadRec.LastName).Division_CD__c+''+leadMap.get(allLeadRec.LastName).SubDiv_TXT__c+''+leadMap.get(allLeadRec.LastName).Model_TXT__c+''+leadMap.get(allLeadRec.LastName).Year_YR__c+''+leadMap.get(allLeadRec.LastName).PreferredDealerAccount_ID__c);
                multipleProviderSet.add(allLeadRec.LeadProvider_ID__r.Name);
                multiProviderValMap.put(leadMap.get(allLeadRec.LastName).LastName+''+leadMap.get(allLeadRec.LastName).Email+''+leadMap.get(allLeadRec.LastName).Phone+''+leadMap.get(allLeadRec.LastName).PostalCode+''+leadMap.get(allLeadRec.LastName).Division_CD__c+''+leadMap.get(allLeadRec.LastName).SubDiv_TXT__c+''+leadMap.get(allLeadRec.LastName).Model_TXT__c+''+leadMap.get(allLeadRec.LastName).Year_YR__c+''+leadMap.get(allLeadRec.LastName).PreferredDealerAccount_ID__c,multipleProviderSet);
                }
                }
                }
                for (lead ldRec1: newMulProList) {
                if(multiProviderValMap.containskey(ldRec1.LastName+''+ldRec1.Email+''+ldRec1.Phone+''+ldRec1.PostalCode+''+ldRec1.Division_CD__c+''+ldRec1.SubDiv_TXT__c+''+ldRec1.Model_TXT__c+''+ldRec1.Year_YR__c+''+ldRec1.PreferredDealerAccount_ID__c)){
                multiProviderValLeadId.put(ldRec1.Id,multiProviderValMap.get(ldRec1.LastName+''+ldRec1.Email+''+ldRec1.Phone+''+ldRec1.PostalCode+''+ldRec1.Division_CD__c+''+ldRec1.SubDiv_TXT__c+''+ldRec1.Model_TXT__c+''+ldRec1.Year_YR__c+''+ldRec1.PreferredDealerAccount_ID__c));
                }
                }
                //System.debug('multiProviderValLeadId : '+multiProviderValLeadId);
                List<Lead> updateLeadsTemp1 = new List<Lead>();
                Set<Lead> updateLeadsTemp1Set = new Set<Lead>();
                List<Opportunity> updateOpportunityTemp1 = new List<Opportunity>();
                Map<Id, String> updateLeadMultipleProvider = new Map<Id, String>();
                Map<Id, String> updateOpportunityMultipleProvider = new Map<Id, String>();
                
                if(multiProviderValLeadId.size() > 0){
                for(Lead leadTemp : [SELECT Id, Multiple_Lead_Providers__c, IsConverted, ConvertedOpportunityId FROM Lead WHERE Id = : multiProviderValLeadId.keyset()]){
                // Lead leadTemp = [SELECT Id, Multiple_Lead_Providers__c, IsConverted, ConvertedOpportunityId FROM Lead WHERE Id = : leadId1];
                if(leadTemp.IsConverted){
                String multiProviderString = String.join(new List<String>(multiProviderValLeadId.get(leadTemp.id)), ',');
                updateOpportunityMultipleProvider.put(leadTemp.ConvertedOpportunityId, multiProviderString);
                }else{
                String multiProviderString = String.join(new List<String>(multiProviderValLeadId.get(leadTemp.id)), ',');
                leadTemp.Multiple_Lead_Providers__c = multiProviderString;
                //updateLeadsTemp1.add(leadTemp);
                updateLeadsTemp1Set.add(leadTemp);
                }
                } 
                }
                
                
                
                if(updateOpportunityMultipleProvider.size() > 0){
                for(Opportunity oppTemp : [SELECT Id, Multiple_Lead_Providers__c FROM Opportunity WHERE Id = :updateOpportunityMultipleProvider.keyset()]){
                // Opportunity oppTemp = [SELECT Id, Multiple_Lead_Providers__c FROM Opportunity WHERE Id = : oppId1];
                oppTemp.Multiple_Lead_Providers__c = updateOpportunityMultipleProvider.get(oppTemp.Id);
                updateOpportunityTemp1.add(oppTemp);
                }
                }
                
                if(updateLeadsTemp1Set.size() > 0){
                updateLeadsTemp1.addall(updateLeadsTemp1Set);
                }
                //Updating the Lead and Opportunity
                if(updateLeadsTemp1.size() > 0){
                System.debug('Current Time : '+updateLeadsTemp1);
                update updateLeadsTemp1;
                System.debug('Inside Update Lead : '+updateLeadsTemp1);
                
                }
                if(updateOpportunityTemp1.size() > 0){
                update updateOpportunityTemp1;
                }
                }catch(Exception ex){
                //System.debug('Exception at line : ' + ex.getLineNumber());
                //System.debug('Exception Message : ' + ex.getMessage());
                Logs__c l = new Logs__c(name = 'Lead-Find Duplicate', Trigger_or_Class_Name__c = 'LeadTriggerHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
                insert l; 
                }
                }
                */  
    
    public void updateLeadGroupIdValue(List < Lead > newLead){
        try{
            Map<String, Lead> leadMap = new Map<String, Lead>();
            //List<Id> duplLeadsId = new List<Id>();
            set < String > divisionSet = new set < String > ();
            set < String > subDivisionSet = new set < String > ();
            set < String > leadProviderSet = new set < String > ();
            
            //Adding all values to DivisionSet, SubDivisionSet, LeadProviderSet
            for (lead ldRec: newLead) {
                leadMap.put(ldRec.LastName, ldRec);
                divisionSet.add(ldRec.Division_CD__c);
                subDivisionSet.add(ldRec.SubDiv_TXT__c);
                leadProviderSet.add(ldRec.LeadProvider_ID__c);
            }
            
            Map<String, Lead > leadGrupidMap = new Map<String, Lead >();
            List<Lead> updateLeadList = new List<Lead>();
            //Fetching all existing Duplicate Lead Records created Today.
            List<Lead> matchingList = new List<Lead>();
            List<Lead> leadList = [SELECT Id, FirstName, LastName, Email, Phone, MobilePhone, Year_YR__c, Division_CD__c, SubDiv_TXT__c, Model_ID__c, Model_TXT__c, Trim_TXT__c, LeadProvider_ID__c, Lead_Group_ID__c, PostalCode, isConverted, ConvertedOpportunityId FROM Lead 
                                   WHERE Division_CD__c IN: divisionSet 
                                   AND SubDiv_TXT__c IN: subDivisionSet 
                                   AND LeadProvider_ID__c IN: leadProviderSet 
                                   AND createdDate =TODAY ORDER BY createdDate ASC];
            
            for(Lead allLeadRec : leadList ){                
                if( (leadMap.containsKey(allLeadRec.LastName)) && 
                   (allLeadRec.Email == leadMap.get(allLeadRec.LastName).Email) && 
                   (allLeadRec.Phone == leadMap.get(allLeadRec.LastName).Phone) && 
                   (allLeadRec.PostalCode == leadMap.get(allLeadRec.LastName).PostalCode) && 
                   (allLeadRec.Model_TXT__c == leadMap.get(allLeadRec.LastName).Model_TXT__c) && 
                   (allLeadRec.Year_YR__c == leadMap.get(allLeadRec.LastName).Year_YR__c)  ){
                       matchingList.add(allLeadRec);
                       if(!leadGrupidMap.containsKey( allLeadRec.LastName+''+allLeadRec.Division_CD__c+''+allLeadRec.SubDiv_TXT__c+''+allLeadRec.LeadProvider_ID__c)){
                           leadGrupidMap.put( allLeadRec.LastName+''+allLeadRec.Division_CD__c+''+allLeadRec.SubDiv_TXT__c+''+allLeadRec.LeadProvider_ID__c , allLeadRec  );
                           if(allLeadRec.Lead_Group_ID__c==null || allLeadRec.Lead_Group_ID__c==''){
                               allLeadRec.Lead_Group_ID__c= leadGrupidMap.get( allLeadRec.LastName+''+allLeadRec.Division_CD__c+''+allLeadRec.SubDiv_TXT__c+''+allLeadRec.LeadProvider_ID__c).id;
                               updateLeadList.add(allLeadRec);
                           }
                       }else if(allLeadRec.Lead_Group_ID__c==null || allLeadRec.Lead_Group_ID__c=='') {
                           allLeadRec.Lead_Group_ID__c= leadGrupidMap.get( allLeadRec.LastName+''+allLeadRec.Division_CD__c+''+allLeadRec.SubDiv_TXT__c+''+allLeadRec.LeadProvider_ID__c).id;
                           updateLeadList.add(allLeadRec);
                       }
                   }
            }
            Map<Id, Id> oppLeadGroupIdMapping = new Map<Id, Id>();
            Map<Id, Id> leadGroupIdMapping = new Map<Id, Id>();
            List<Opportunity> oppToUpdate = new List<opportunity>();
            List<Lead> updateLeads = new List<Lead>();
            if(updateLeadList.size() > 0 && matchingList.size() > 1){
                for(Lead list1 : updateLeadList){
                    if(list1.isConverted){
                        oppLeadGroupIdMapping.put(list1.ConvertedOpportunityId,list1.Lead_Group_ID__c);
                    }else{
                        leadGroupIdMapping.put(list1.Id,list1.Lead_Group_ID__c);
                    }
                } 
            }
            
            // Looping through the Leadmapping to update the Lead Group Id in Leads
            if(leadGroupIdMapping.size() > 0){
                /*for(Id leadId1 : leadGroupIdMapping.keyset()){
                    Lead leadTemp = [SELECT Id, Lead_Group_ID__c FROM Lead WHERE Id = : leadId1];
                    if(leadTemp.Lead_Group_ID__c == null || leadTemp.Lead_Group_ID__c == ''){
                    leadTemp.Lead_Group_ID__c = leadGroupIdMapping.get(leadId1);
                    updateLeads.add(leadTemp);
                    }
                    }*/
                for(Lead leadTemp : [SELECT Id, Lead_Group_ID__c FROM Lead WHERE Id IN : leadGroupIdMapping.keyset()]){
                    if(leadTemp.Lead_Group_ID__c == null || leadTemp.Lead_Group_ID__c == ''){
                        leadTemp.Lead_Group_ID__c = leadGroupIdMapping.get(leadTemp.Id);
                        updateLeads.add(leadTemp);
                    }
                }
            }
            //Updating the Leads
            if(updateLeads.size() > 0){
                update updateLeads;
            }
            // Looping through the Opportunitymapping to update the Lead Group Id in Opportunity
            if(oppLeadGroupIdMapping.size() > 0){
                /*for(Id oppId1 : oppLeadGroupIdMapping.keyset()){
Opportunity oppTemp = [SELECT Id, Lead_Group_ID__c FROM Opportunity WHERE Id = : oppId1];
if(oppTemp.Lead_Group_ID__c == null || oppTemp.Lead_Group_ID__c == ''){
oppTemp.Lead_Group_ID__c = oppLeadGroupIdMapping.get(oppId1);
oppToUpdate.add(oppTemp);
}
}*/
                for(Opportunity oppTemp : [SELECT Id, Lead_Group_ID__c FROM Opportunity WHERE Id IN : oppLeadGroupIdMapping.keyset()]){
                    if(oppTemp.Lead_Group_ID__c == null || oppTemp.Lead_Group_ID__c == ''){
                        oppTemp.Lead_Group_ID__c = oppLeadGroupIdMapping.get(oppTemp.Id);
                        oppToUpdate.add(oppTemp);
                    }
                }
            }
            //Updating the Opportunity
            if(oppToUpdate.size() > 0){
                update oppToUpdate;
            }
            
        }catch(Exception ex){
            //System.debug('Exception at line : ' + ex.getLineNumber());
            //System.debug('Exception Message : ' + ex.getMessage());
            
            Logs__c l = new Logs__c(name = 'Lead-Find Duplicate', Trigger_or_Class_Name__c = 'LeadTriggerHandler', Error_Message__c = ex.getMessage(), Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber())));
            insert l;            
        }
        
        
    }
    public void updateVehicleStatus(List<Lead> lstnewLeads){
        integer cY= system.now().Year();
        for(Lead l: lstnewLeads){
            if(l.Year_YR__c!=null && l.Year_YR__c.isNumeric()){
                if(l.Year_YR__c!='0' && (CY-integer.valueOf(l.Year_YR__c))>1 ){
                l.VehicleStatus_TXT__c='Used' ; 
            }
            }
        }
    }
   /* 
   public void updateModelGroupName(List<Lead>lstnewLead){
        for (Lead ld: lstnewLead) {
            String str = '';
            String modelGroupName = '';
            if(ld.Model_TXT__c !=null && ld.Model_TXT__c != ''){
                str = ld.Model_TXT__c;
                modelGroupName = str.split(' ')[0];
                //  ld.Model_Group_Name__c = modelGroupName;
            }
        }
    }  */
      //AMSLM-918
    public void updateModelGroupNameEmpty(List<Lead>lstnewLead){
        for (Lead ld: lstnewLead) {
            if(ld.Year_YR__c == '0' && ld.VehicleStatus_TXT__c == 'New'){
                 ld.Model_Group_Name__c  = '';
            }
        }
    }
    
    //Jay LMS-5766
    public void updateModelGroupNameOnLead(List<Lead> newLeads) {
      //  System.debug('pmgMapTrigger');
        try{
            Set<String> pmsOnNewLeads = new Set<String>();
            List<Lead> modelUpdatedLeads = new List<Lead>();
            Set<String> divisionSet = new Set<String>();
            Set<String> subDivisionSet = new Set<String>();
            for(Lead nw : newLeads){
                if(nw.Model_ID__c != null){
                    pmsOnNewLeads.add(nw.Model_ID__c);
                }
                divisionSet.add(nw.Division_CD__c);
                subDivisionSet.add(nw.SubDiv_TXT__c);
            }
            Map<String, Product_Model__c> currentPMsToRealtedMId = new Map<String, Product_Model__c>();
            Map<String, Product_Model__c> currentPMsToMarketingName = new Map<String, Product_Model__c>();
            Map<String, Product_Model_Group__c> currentPMGs = new Map<String, Product_Model_Group__c>();
            if(!pmsOnNewLeads.isEmpty()){
                for(Product_Model__c pm : [SELECT Id, Model_ID_Text__c, Product_Model_Group_Id__r.Id, 
                      Product_Model_Group_Id__r.Name from Product_Model__c WHERE Model_ID_Text__c in :pmsOnNewLeads ]){
                                          currentPMsToRealtedMId.put(pm.Model_ID_Text__c, pm);
                 }
            }
            for(Product_Model__c pm : [SELECT Id, Model_Marketing_Name__c , Product_Model_Group_Id__r.Id, 
                                       Product_Model_Group_Id__r.Name,Product_Model_Group_Id__r.Division__c from Product_Model__c where Product_Model_Group_Id__r.Division__c in :divisionSet and Product_Model_Group_Id__r.Subdivision__c in :subDivisionSet ]){
                                          currentPMsToMarketingName.put(pm.Model_Marketing_Name__c, pm); 
                                       }
            for(Product_Model_Group__c pmg : [SELECT Id, Name,Division__c FROM Product_Model_Group__c]){
                 currentPMGs.put(pmg.Name, pmg);
            }
            Set<String> MNames = new Set<String>();
            if(!currentPMsToMarketingName.isEmpty()){
                MNames = currentPMsToMarketingName.keySet();
            }
            for(Lead nl : newLeads){
                 Boolean matchFound = false;
                if(nl.Model_ID__c != null){
                //    System.debug('Model Id Scenario');
                    if(!currentPMsToRealtedMId.isEmpty()){
                        Product_Model__c holdPm = currentPMsToRealtedMId.get(nl.Model_ID__c);
                        if(holdPm != null){
                            if(holdPm.Product_Model_Group_Id__c != null){
                                nl.Product_Model_Group_Id__c = holdPm.Product_Model_Group_Id__r.Id;    
                                nl.Model_Group_Name__c = holdPm.Product_Model_Group_Id__r.Name;
                            }
                            nl.Product_Model_Id__c = holdPm.Id;
                            matchFound = true;
                        }
                    }
                }
               if(nl.Model_TXT__c != null && !matchFound){
               //     System.debug('Model Text Scenaro');
                    String model = nl.Model_TXT__c;
                    if(!currentPMsToMarketingName.isEmpty() && currentPMsToMarketingName.containsKey(model) && !matchFound){
                           // System.debug('Model Text Match to Marketing Name');
                            Product_Model__c holdPm  = currentPMsToMarketingName.get(model);
                            if(holdPm.Product_Model_Group_Id__c != null){
                                nl.Product_Model_Group_Id__c = holdPm.Product_Model_Group_Id__r.Id;    
                                nl.Model_Group_Name__c = holdPm.Product_Model_Group_Id__r.Name;
                            }
                            nl.Product_Model_Id__c = holdPm.Id; 
                        matchFound = true;
                    }
                    if(!currentPMGs.isEmpty() && !matchFound){
                    //    System.debug('Model Text fuzzy match to Product Model Name');
                        for(String modelName : currentPMGS.keySet()){
                            if((model.toLowerCase().contains(modelName.toLowerCase()) || modelName.toLowerCase().contains(model.toLowerCase())) && nl.Division_CD__c==currentPMGS.get(modelName).Division__c){
                            //    System.debug('Model Text fuzzy match to Product Model Name');
                                Product_Model_Group__c holdPmg = currentPMGs.get(modelName);
                                nl.Product_Model_Group_Id__c = holdPmg.Id;
                                nl.Model_Group_Name__c = holdPmg.Name;
                                matchFound = true;
                                break;
                            }else{
                                String firstWord = model.split(' ')[0].toLowerCase();
                                if(!firstWord.isNumeric()){
                                    if((firstWord.contains(modelName.toLowerCase()) || modelName.toLowerCase().contains(firstWord.toLowerCase())) && nl.Division_CD__c==currentPMGS.get(modelName).Division__c){
                             //           System.debug('Model Text fuzzy match to Product Model Name 2');
                                        Product_Model_Group__c holdPmg = currentPMGs.get(modelName);
                                        nl.Product_Model_Group_Id__c = holdPmg.Id;
                                        nl.Model_Group_Name__c = holdPmg.Name;
                                        matchFound = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }   
                }
            } 
        }catch(exception ex){
            Logs__c log = new Logs__c(
                name = 'Lead- Model Group Name On Lead',
                Trigger_or_Class_Name__c = 'LeadTriggerHandler',
                Error_Message__c = ex.getMessage(),
                Error_Line_Number__c = Integer.valueOf(string.valueof(ex.getLineNumber()))
            );
            insert log;
        }
    }     
}