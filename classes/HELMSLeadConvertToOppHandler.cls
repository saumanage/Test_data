/*******************************************************************************************
* @Name         HELMSLeadConvertToOppHandler 
* @Author       Mamatha Gonuguntla  
This class will convert lead to opportunity
*******************************************************************************************/
public with sharing class HELMSLeadConvertToOppHandler {
    Public static boolean flag = true;
    
    public static void handleLeadToOppInsert(List<Lead> leadListRecord)
    {
                   
        try
        {
                        
            Map<Id,Lead> leadMap = new Map<Id,Lead>();
            Map<Id,List<String>> leadDealerIdMap = new Map<Id,List<String>>();
            Map<String,Account> accountDealerMap = new Map<String,Account>();
            Set<String> dealerIdSet = new Set<String>();
            Set<String> dealerAccIdSet = new Set<String>();
            for(Lead ldRec : leadListRecord)
            {
         //      System.debug('=====123=============='+ldRec.isConverted); 
                if(!ldRec.isConverted && ldRec.SubDiv_TXT__c!=null){
                    
                    leadMap.put(ldRec.Id, ldRec);
                    
        //            String dealerIdString = ldRec.Dealer_Ids_ID__c;
                 
                    if(ldRec.PreferredDealerNumber_NUM__c!=null){
                        dealerIdSet.add(ldRec.PreferredDealerNumber_NUM__c);
                        List<String> dealerIdSingle = new List<String>();
                        dealerIdSingle.add(ldRec.PreferredDealerNumber_NUM__c);
                        leadDealerIdMap.put(ldRec.Id, dealerIdSingle);
                    }
                    
                    if(ldRec.PreferredDealerAccount_ID__c!=null){
                        dealerAccIdSet.add(ldRec.PreferredDealerAccount_ID__c);
                        
                        List<String> dealerIdSingle = new List<String>();
                        dealerIdSingle.add(ldRec.PreferredDealerAccount_ID__c);
                        leadDealerIdMap.put(ldRec.Id, dealerIdSingle);
                    }
                }
            }
            //system.debug('---dealerIdSet------'+dealerIdSet);
            for(Account acc : [select Id,Name,DealerCode_CD__c,OwnerId from Account where DealerCode_CD__c in :dealerIdSet OR id IN :dealerAccIdSet])
            {
                accountDealerMap.put(acc.DealerCode_CD__c,acc);
            }
            
            //system.debug('---accountDealerMap------'+accountDealerMap);
            
            List<Opportunity> oppNewCreatedList = new List<Opportunity>();
     //     List<Lead> updatedLeadRecordList = new List<Lead>();
            
            Map<String,String> oppRecordtype = new Map<String,String>();
            for(Lead_Division_Mapping_From_Subdivision__mdt m :[select id,Subdivision__c,Opp_Recortype_API_name__c, Division_CD__c from Lead_Division_Mapping_From_Subdivision__mdt])
            {
                oppRecordtype.put(m.Subdivision__c , m.Opp_Recortype_API_name__c);
            }
            
            //Lead_Expiration__c leadCustomVal = Lead_Expiration__c.getInstance();
            Lead_Expiration__c leadCustomVal = Lead_Expiration__c.getOrgDefaults();
            
            //system.debug('oppRecordtype----'+oppRecordtype);
            list<string> ledIds = new list<string>();
            for(Id ldId : leadDealerIdMap.keySet())
            {
                ledIds.add(ldId);
               /* List<String> dealerIdsAssociatedList = leadDealerIdMap.get(ldId);
                  system.debug('---dealerIdsAssociatedList------'+dealerIdsAssociatedList);
                for(String str : dealerIdsAssociatedList)
                { */
                
                    Opportunity opp = new Opportunity();
                    //opp.Name = leadMap.get(ldId).Name;
                    String oppName;
                    //system.debug('---leadMap.get(ldId).FirstName------'+leadMap.get(ldId).FirstName);
                    if(leadMap.get(ldId).FirstName !=null && leadMap.get(ldId).FirstName !=''){
                    
                        oppName = leadMap.get(ldId).FirstName;
                        opp.First_Name_TXT__c = leadMap.get(ldId).FirstName;
                //        System.debug('++++++' + leadMap.get(ldId).FirstName);
                    }
                
                //dinesh
                if(leadMap.get(ldId) != null && leadMap.get(ldId).Chat_Transcript__c !=null && leadMap.get(ldId).Chat_Transcript__c !=''){
                        opp.Chat_Transcript__c = leadMap.get(ldId).Chat_Transcript__c;
                    }

                //dinesh
                    if(leadMap.get(ldId).MiddleName !=null && leadMap.get(ldId).MiddleName !=''){
                    
                        if(oppName!=null){
                            oppName= oppName+' '+leadMap.get(ldId).MiddleName;
                        }else{
                             oppName= leadMap.get(ldId).MiddleName;
                        }
                        
                        opp.Middle_Name_TXT__c = leadMap.get(ldId).MiddleName;
                    }
                    if(leadMap.get(ldId).LastName !=null){
                        if(oppName!=null){
                            oppName= oppName+' '+leadMap.get(ldId).LastName;
                        }else{
                             oppName= leadMap.get(ldId).LastName;
                        }
                        
                        opp.Last_Name_TXT__c = leadMap.get(ldId).LastName;
                    }
                    if(leadMap.get(ldId).Year_YR__c !=null){
                        if(oppName!=null){
                        oppName= oppName+ ' '+leadMap.get(ldId).Year_YR__c;
                        }else{
                            oppName= leadMap.get(ldId).Year_YR__c;
                        }
                    }
                    if(leadMap.get(ldId).Model_TXT__c !=null){
                    
                        oppName= oppName+' '+leadMap.get(ldId).Model_TXT__c;
                    }
                    if(leadMap.get(ldId).Model_ID__c !=null){
                    
                        oppName= oppName+ ' '+leadMap.get(ldId).Model_ID__c;
                    }
                    if(leadMap.get(ldId).Trim_TXT__c !=null){
                    
                        oppName= oppName+ ' '+leadMap.get(ldId).Trim_TXT__c;
                    }
                    
                    if(leadMap.get(ldId).Suffix !=null){
                    
                       opp.Suffix_TXT__c = leadMap.get(ldId).Suffix;
                    }
                    
                    if(!string.isblank(oppName) && oppName.length()>120){
                        oppName = oppName.substring(0,120);
                    }
                    
                    opp.Name = oppName;
                    opp.AccountId = leadMap.get(ldId).CustomerAccount_ID__c;
                    opp.Lead_ID__c = ldId;
                   /* if(accountDealerMap.containsKey(str)){
                        opp.PreferredDealerAccount_TXT__c = accountDealerMap.get(str).Id;                       
                        opp.OwnerId = accountDealerMap.get(str).OwnerId;
                    }
                    
                    */
                    
                    if(accountDealerMap.containsKey(leadMap.get(ldId).PreferredDealerNumber_NUM__c)){
                        //opp.PreferredDealerAccount_TXT__c = accountDealerMap.get(leadMap.get(ldId).PreferredDealerNumber_NUM__c).Id;                       
                        opp.OwnerId = accountDealerMap.get(leadMap.get(ldId).PreferredDealerNumber_NUM__c).OwnerId;
                    }
                    
                    opp.StageName = 'Assigned to Dealer';
                                                           
                    
                     //Mamatha
                    opp.ContactKey_TXT__c = leadMap.get(ldId).ContactKey_TXT__c;
                    opp.Division_CD__c = leadMap.get(ldId).Division_CD__c;
                     //System.debug('ContactKey11111'+leadMap.get(ldId).ContactKey_TXT__c);
                    String leadDivision;
                    if(leadMap.get(ldId).Division_CD__c!=null){
                        leadDivision = (leadMap.get(ldId).Division_CD__c)+'__C';
                    }
                    //system.debug('leadDivision======'+leadDivision);
                    if(leadDivision!=null){
                        //system.debug(leadCustomVal.get('A__C'));
                        //system.debug('Integer.valueOf(leadCustomVal.get(leadDivision))--------'+Integer.valueOf(leadCustomVal.get(leadDivision)));
                        Integer getCustomDivisionVal = Integer.valueOf(leadCustomVal.get(leadDivision));
                                                
                        opp.CloseDate = System.today()+getCustomDivisionVal;
                    }else{
                        opp.CloseDate = System.today()+Integer.valueOf(leadCustomVal.get('A__C'));
                       //system.debug('Integer.valueOf(leadCustomVal.get(leadDivision))--------'+Integer.valueOf(leadCustomVal.get('A__C')));

                    }
                    opp.SubDiv_TXT__c=leadMap.get(ldId).SubDiv_TXT__c;
                    //System.debug('SubDiv'+leadMap.get(ldId).SubDiv_TXT__c);
                    //System.debug('Division'+leadMap.get(ldId).Division_CD__c);                   
                    if(leadMap.get(ldId).Division_CD__c !=null && leadMap.get(ldId).SubDiv_TXT__c!=null){
                        string recTypeName = oppRecordtype.get(leadMap.get(ldId).SubDiv_TXT__c);
                        //system.debug('recTypeName-------'+recTypeName);
                        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recTypeName).getRecordTypeId();
                    }                                                          
                    /* Updating Lead Status Reason to Opportunity */
                    //opp.StatusReason_TXT__c = leadMap.get(ldId).StatusReason_TXT__c;
                  /*
                  if(leadMap.get(ldId).StatusReason_TXT__c == 'Duplicate Similar'){
                      opp.Duplicate_Similar__c = true;
                  }
                  */
                  opp.Duplicate_Similar__c = leadMap.get(ldId).Is_Duplicate_Similar_Lead__c ;
                    /* Updating Lead Status Reason to Opportunity */
                
                    //LMS - 4898 - Syam
                    opp.External_Lead_Reference_Number__c = leadMap.get(ldId).External_Lead_Reference_Number__c;
                    //LMS - 4898 - Syam
                    
                  
                    //NSX Prasanna
                if(leadMap.get(ldId).SubDiv_TXT__c  == 'NSX'){
                    if(leadMap.get(ldId).Sales_Status__c =='Cancelled'){
                         opp.StageName = HELMSConstants.Closed_Lost;
                        opp.OpportunityStatus_TXT__c = HELMSConstants.closedLostStatus; 
                    }
                    if(leadMap.get(ldId).Sales_Status__c =='Accepted'){
                         opp.StageName = HELMSConstants.SalesOrder;
                         opp.OpportunityStatus_TXT__c = HELMSConstants.SalesOrderStatus; 
                    }
                    if(leadMap.get(ldId).Sales_Status__c =='Waitlist'){
                         opp.StageName = HELMSConstants.On_Hold;
                         opp.OpportunityStatus_TXT__c = HELMSConstants.OnHoldStatus; 
                    }
                }
                    
              
                    if(!String.isblank(leadMap.get(ldId).Street) && leadMap.get(ldId).Street.length()>80){
                            opp.Street_TXT__c= leadMap.get(ldId).Street.substring(0,80);
                    } else{
                            opp.Street_TXT__c= leadMap.get(ldId).Street;
                    }
                    /* Dealer Assignment Type - Syam Mohan */
                    //opp.Dealer_Assignment_Type__c=leadMap.get(ldId).Dealer_Assignment_Type__c;
                    /* Dealer Assignment Type - Syam Mohan */
                
                    opp.Provider_Tool_Name__c=leadMap.get(ldId).Provider_Tool_Name__c;
                
                    // opp.Street_TXT__c = leadMap.get(ldId).Street;
                    opp.City_TXT__c = leadMap.get(ldId).City;
                    opp.State_TXT__c = leadMap.get(ldId).state;
                    opp.Country_TXT__c = leadMap.get(ldId).Country;
                    opp.ZipCode_TXT__c = leadMap.get(ldId).PostalCode;
                     
                     //4929
                     opp.Deposit_Confirmation_Number__c = leadMap.get(ldId).Deposit_Confirmation_Number__c;
                     opp.DEPOSIT_AMOUNT__c = leadMap.get(ldId).DEPOSIT_AMOUNT__c;
                     opp.Deposit_IP_Addres_URL__c = leadMap.get(ldId).Deposit_IP_Addres_URL__c;
                     opp.Deposit_Sales_Order_Number__c = leadMap.get(ldId).Deposit_Sales_Order_Number__c;
                
                    opp.VehicleInterest_TXT__c = leadMap.get(ldId).VehicleInterest_TXT__c;
                    opp.VehicleStatus_TXT__c=leadMap.get(ldId).VehicleStatus_TXT__c;
                    opp.Make_TXT__c=leadMap.get(ldId).Make_TXT__c;
                    opp.Model_TXT__c=leadMap.get(ldId).Model_TXT__c;
                    opp.Model_Group_Name__c=leadMap.get(ldId).Model_Group_Name__c;
                    opp.Trim_TXT__c = leadMap.get(ldId).Trim_TXT__c;            
                    opp.Year_YR__c = leadMap.get(ldId).Year_YR__c;
                    opp.Condition_TXT__c = leadMap.get(ldId).Condition_TXT__c;
                    opp.Number_NM__c = leadMap.get(ldId).Number_NM__c;
                    opp.Doors_TXT__c = leadMap.get(ldId).Doors_TXT__c;
                    opp.BodyStyle_TXT__c = leadMap.get(ldId).BodyStyle_TXT__c;
                    opp.Odometer_TXT__c = leadMap.get(ldId).Odometer_TXT__c;
                    opp.OdometerStatus_TXT__c = leadMap.get(ldId).OdometerStatus_TXT__c;
                    opp.OdometerUnits_TXT__c = leadMap.get(ldId).OdometerUnits_TXT__c;
                    opp.Transmission_TXT__c = leadMap.get(ldId).Transmission_TXT__c;
                    opp.InventoryNumber_TXT__c = leadMap.get(ldId).InventoryNumber_TXT__c;
                    /*
                    if(String.isNotEmpty(leadMap.get(ldId).Color_TXT__c)){
                        opp.Color_TXT__c = getColorCombination(leadMap.get(ldId).Color_TXT__c);
                    }
                    */
                    //opp.Color_TXT__c = leadMap.get(ldId).Color_TXT__c;
                    opp.Color_XML__c = leadMap.get(ldId).Color_XML__c;
                    
                    opp.PriceSource_TXT__c  = leadMap.get(ldId).PriceSource_TXT__c ;
                    opp.FinanceMethod_TXT__c = leadMap.get(ldId).FinanceMethod_TXT__c;
                    opp.FinanceAmountType_TXT__c = leadMap.get(ldId).FinanceAmountType_TXT__c;
                    opp.BalanceAmount_NUM__C = leadMap.get(ldId).BalanceAmount_NUM__C;
                    opp.BalanceType_TXT__c = leadMap.get(ldId).BalanceType_TXT__c;
                    opp.TradeMake_TXT__c = leadMap.get(ldId).TradeMake_TXT__c;
                    opp.TradeModel_TXT__c = leadMap.get(ldId).TradeModel_TXT__c;
                   // opp.TradeYear_YR__c = leadMap.get(ldId).TradeYear_YR__c;
                    opp.TradeMileage_TXT__c = leadMap.get(ldId).TradeMileage_TXT__c;
                    opp.TradeValue_TXT__c = leadMap.get(ldId).TradeValue_TXT__c;
                    opp.TradeBalanceOwed_TXT__c = leadMap.get(ldId).TradeBalanceOwed_TXT__c;
                    opp.Price_TXT__c = leadMap.get(ldId).Price_TXT__c;
                    opp.ModelDealerAccessoryPrice_AM__c = leadMap.get(ldId).ModelDealerAccessoryPrice_AM__c;
                    opp.ModelDestinationCharge_AM__c = leadMap.get(ldId).ModelDestinationCharge_AM__c;
                    opp.PriceType_TXT__c = leadMap.get(ldId).PriceType_TXT__c;
                    opp.Currency_AM__c = leadMap.get(ldId).Currency_AM__c;
                    opp.Delta_TXT__c = leadMap.get(ldId).Delta_TXT__c;
                    opp.Relative_TXT__c = leadMap.get(ldId).Relative_TXT__c;
                    opp.AddressType_TXT__c = leadMap.get(ldId).AddressType_TXT__c;
                    opp.CleansedAddress_TXT__c = leadMap.get(ldId).CleansedAddress_TXT__c;
                    opp.AppartmentNumber_TXT__c = leadMap.get(ldId).AppartmentNumber_TXT__c;
                    opp.Email__c = leadMap.get(ldId).Email;
                    opp.Phone__c = leadMap.get(ldId).Phone;
                    opp.MobilePhone__c = leadMap.get(ldId).MobilePhone;
                    opp.PhoneType_NM__c = leadMap.get(ldId).PhoneType_NM__c;
                    opp.ContactMethod_TXT__c = leadMap.get(ldId).ContactMethod_TXT__c;
                    opp.ContactTime_TXT__C = leadMap.get(ldId).ContactTime_TXT__C;
                    opp.PurchaseHorizon_TXT__c = leadMap.get(ldId).PurchaseHorizon_TXT__c;
                    opp.PurchaseEarliestDate_DT__c = leadMap.get(ldId).PurchaseEarliestDate_DT__c;
                    opp.PurchaseLatestDate_DT__c = leadMap.get(ldId).PurchaseLatestDate_DT__c;
                    opp.Description = leadMap.get(ldId).Description;
                    opp.OtherContacts_TXT__c = leadMap.get(ldId).OtherContacts_TXT__c;                  
                    opp.PreferredDealerAccount_TXT__c = leadMap.get(ldId).PreferredDealerAccount_ID__c;
                    opp.PreferredDealerNumber_NUM__c = leadMap.get(ldId).PreferredDealerNumber_NUM__c;
                    opp.PreferredDealerContact_ID__c = leadMap.get(ldId).PreferredDealerContact_ID__c;
                    opp.LeadProvider_ID__c = leadMap.get(ldId).LeadProvider_ID__c;
                    
                    opp.ProviderDetail_TXT__c = leadMap.get(ldId).ProviderDetail_TXT__c;
                    opp.ProviderService_TXT__c = leadMap.get(ldId).ProviderService_TXT__c;
                    opp.ProviderContactDetail_TXT__c = leadMap.get(ldId).ProviderContactDetail_TXT__c;
                    opp.OtherLeadProvider_TXT__c = leadMap.get(ldId).OtherLeadProvider_TXT__c;
                    opp.External_ID__c = leadMap.get(ldId).External_ID__c;
                    opp.LeadSource = leadMap.get(ldId).LeadSource;
                    opp.LeadsourceOther_TXT__C = leadMap.get(ldId).LeadsourceOther_TXT__C;
                    opp.LeadCampaignName_TXT__c = leadMap.get(ldId).LeadCampaignName_TXT__c;
                    //AMSLM-1207
                    opp.Shopping_Tool_Name__c = leadMap.get(ldId).Shopping_Tool_Name__c;
                    opp.BrandsiteShoppingTool_TXT__c = leadMap.get(ldId).BrandsiteShoppingTool_TXT__c;
                    opp.ValidAddress_FLG__c = leadMap.get(ldId).ValidAddress_FLG__c;
                    opp.ValidPhoneNum_FLG__c = leadMap.get(ldId).ValidPhoneNum_FLG__c;
                    opp.ValidEmail_FLG__c = leadMap.get(ldId).ValidEmail_FLG__c;
                    opp.ValidMobile_FLG__c = leadMap.get(ldId).ValidMobile_FLG__c;
                    opp.ApplicantNumber_TXT__c = leadMap.get(ldId).ApplicantNumber_TXT__c; 
                    opp.ProductInterest_TXT__c = leadMap.get(ldId).ProductInterest_TXT__c;
                    opp.Category_TXT__c = leadMap.get(ldId).Category_TXT__c;
                    opp.Power_TXT__C = leadMap.get(ldId).Power_TXT__C;
                    opp.Model_ID__C = leadMap.get(ldId).Model_ID__C;
                    opp.ProviderSourceType_TXT__c = leadMap.get(ldId).ProviderSourceType_TXT__c;
                    opp.Dealer_Ids_ID__c = leadMap.get(ldId).Dealer_Ids_ID__c;
                    opp.Prospect_Ids_ID__c = leadMap.get(ldId).Prospect_Ids_ID__c;
                    opp.Provider_Ids_ID__c = leadMap.get(ldId).Provider_Ids_ID__c;
                    opp.Customer_Ids_ID__c = leadMap.get(ldId).Customer_Ids_ID__c;
                    opp.Vehicle_Ids_ID__c = leadMap.get(ldId).Vehicle_Ids_ID__c;
                    opp.TransactionCode_CD__c = leadMap.get(ldId).TransactionCode_CD__c;
                    opp.Image_URL__c = leadMap.get(ldId).Image_URL__c;
                    opp.FinanceAmount_TXT__c = leadMap.get(ldId).FinanceAmount_TXT__c;
                    opp.Options_TXT__c = leadMap.get(ldId).Options_TXT__c;
                //NSX Fileds Mapping
                    opp.NSX__c  = leadMap.get(ldId).NSX_Tech__c;
                    opp.LTWT__c  = leadMap.get(ldId).LTWT__c;
                    opp.Special_Requests__c = leadMap.get(ldId).Special_Requests__c;
                    opp.UIDs__c = leadMap.get(ldId).UIDs__c ;
                    opp.Production_Month__c = leadMap.get(ldId).Production_Month__c;
                    opp.DEPOSIT_AMOUNT__c  = leadMap.get(ldId).DEPOSIT_AMOUNT__c;
                    opp.Deposit_Taken_By__c = leadMap.get(ldId).Deposit_Taken_By__c;
                    opp.Lead_Submission_Date__c = leadMap.get(ldId).Lead_Submission_Date__c;
                    //Product Model - Jay
                    if(leadMap.get(ldId).Product_Model_Group_Id__c != null){
                        opp.Product_Model_Group_Id__c  = leadMap.get(ldId).Product_Model_Group_Id__c;
                    }
                    if(leadMap.get(ldId).Product_Model_Id__c != null){
                        opp.Product_Model_Id__c = leadMap.get(ldId).Product_Model_Id__c;
                    }
                    
                    //LMS-4950 - Jay
                    opp.DMGR_Baseball__c = leadMap.get(ldId).DMGR_Baseball__c;
                    opp.DMGR_Basketball__c = leadMap.get(ldId).DMGR_Basketball__c;
                    opp.DMGR_Football__c = leadMap.get(ldId).DMGR_Football__c;
                    opp.DMGR_Environmental_Issues__c = leadMap.get(ldId).DMGR_Environmental_Issues__c;
                    opp.DMGR_Golf__c = leadMap.get(ldId).DMGR_Golf__c;
                    opp.DMGR_Green_Living__c = leadMap.get(ldId).DMGR_Green_Living__c;
                    opp.DMGR_Hockey__c = leadMap.get(ldId).DMGR_Hockey__c;
                    opp.DMGR_Outdoors__c = leadMap.get(ldId).DMGR_Outdoors__c;
                    opp.DMGR_Photography__c = leadMap.get(ldId).DMGR_Photography__c;
                    opp.DMGR_Skiing__c = leadMap.get(ldId).DMGR_Skiing__c;
                    opp.DMGR_US_Travel__c = leadMap.get(ldId).DMGR_US_Travel__c;
                    opp.DMGR_Vehicle_Known_Owned__c = leadMap.get(ldId).DMGR_Vehicle_Known_Owned__c;
                    if(leadMap.get(ldId).DMGR_Age__c != null){
                        opp.DMGR_Age__c = leadMap.get(ldId).DMGR_Age__c;
					}
                    if(leadMap.get(ldId).DMGR_Children__c != null){
                        opp.DMGR_Children__c = leadMap.get(ldId).DMGR_Children__c;
						}
                    if(leadMap.get(ldId).DMGR_Education_Level__c != null){                
                        opp.DMGR_Education_Level__c = leadMap.get(ldId).DMGR_Education_Level__c;
						}
                    if(leadMap.get(ldId).DMGR_Marital_Status__c != null){
                        opp.DMGR_Marital_Status__c = leadMap.get(ldId).DMGR_Marital_Status__c;
						}
                    if(leadMap.get(ldId).DMGR_Income__c != null){
                        opp.DMGR_Income__c = leadMap.get(ldId).DMGR_Income__c;
						}
                    if(leadMap.get(ldId).DMGR_Home_Owner_or_Renter__c != null){
                        opp.DMGR_Home_Owner_or_Renter__c = leadMap.get(ldId).DMGR_Home_Owner_or_Renter__c;
						}
                    if(leadMap.get(ldId).DMGR_Income_Estate_HHLD_Higher_Ranges__c != null){
                        opp.DMGR_Income_Estate_HHLD_Higher_Ranges__c = leadMap.get(ldId).DMGR_Income_Estate_HHLD_Higher_Ranges__c;
						}
                    if(leadMap.get(ldId).DMGR_Household_Size__c != null){
                        opp.DMGR_Household_Size__c = leadMap.get(ldId).DMGR_Household_Size__c;
						}
                    if(leadMap.get(ldId).DMGR_Occupation_Detailed__c != null){
                        opp.DMGR_Occupation_Detailed__c = leadMap.get(ldId).DMGR_Occupation_Detailed__c;
						}
                    if(leadMap.get(ldId).DMGR_Occupation__c != null){
                        opp.DMGR_Occupation__c = leadMap.get(ldId).DMGR_Occupation__c;
						}
                    if(leadMap.get(ldId).DMGR_Vehicle_Known_Owned__c != null){
                        opp.DMGR_Vehicle_Known_Owned__c = leadMap.get(ldId).DMGR_Vehicle_Known_Owned__c;
						}
                    opp.ENR_Acura_Vehicles_Owned__c = leadMap.get(ldId).ENR_Acura_Vehicles_Owned__c;
                    opp.ENR_Honda_Vehicles_Owned__c = leadMap.get(ldId).ENR_Honda_Vehicles_Owned__c;
                    opp.ENR_CI_Ownership_Details__c = leadMap.get(ldId).ENR_CI_Ownership_Details__c;
                    opp.ENR_CI_Likely_to_Buy_Acura__c = leadMap.get(ldId).ENR_CI_Likely_to_Buy_Acura__c;
                    opp.ENR_CI_Likely_to_Buy_Honda__c = leadMap.get(ldId).ENR_CI_Likely_to_Buy_Honda__c;
                    opp.ENR_CI_Likely_to_Buy_PSP__c = leadMap.get(ldId).ENR_CI_Likely_to_Buy_PSP__c;
                    opp.ENR_Likeliness_to_Buy_Acura__c = leadMap.get(ldId).ENR_Likeliness_to_Buy_Acura__c;
                    opp.ENR_Likeliness_to_Buy_Honda__c = leadMap.get(ldId).ENR_Likeliness_to_Buy_Honda__c;
                    opp.ENR_Likeliness_to_Buy_PSP__c = leadMap.get(ldId).ENR_Likeliness_to_Buy_PSP__c;
                    opp.ENR_Ownership_Type__c = leadMap.get(ldId).ENR_Ownership_Type__c;
                    if(leadMap.get(ldId).ENR_CI_Event_Attendance__c != null)
                        opp.ENR_CI_Event_Attendance__c = leadMap.get(ldId).ENR_CI_Event_Attendance__c;
                    opp.ENR_CI_Extended_Warranty__c = leadMap.get(ldId).ENR_CI_Extended_Warranty__c;
                    opp.ENR_CI_Ownership__c = leadMap.get(ldId).ENR_CI_Ownership__c;
                    opp.ENR_CI_Service_History__c = leadMap.get(ldId).ENR_CI_Service_History__c;
                    if(leadMap.get(ldId).ENR_CI_Children_in_Household__c != null)
                        opp.ENR_CI_Children_in_Household__c = leadMap.get(ldId).ENR_CI_Children_in_Household__c;
                    opp.ENR_Total_Spent_on_Service_by_Customer__c = leadMap.get(ldId).ENR_Total_Spent_on_Service_by_Customer__c;
                    opp.ENR_Total_Spent_on_Service_by_Warranty__c = leadMap.get(ldId).ENR_Total_Spent_on_Service_by_Warranty__c;
                    opp.ENR_Extended_Warranty_Contract__c = leadMap.get(ldId).ENR_Extended_Warranty_Contract__c;
                    opp.Enrichment_XML_Payload__c = leadMap.get(ldId).Enrichment_XML_Payload__c;
                
                    
                    //LMS-1950 - Vamshi
                    opp.LeadAdditionalInfos__c = leadMap.get(ldId).LeadAdditionalInfos__c;
                
                    //LMS-5373 - Ghouse
                    
                   opp.Send_confirmation_Email__c = leadMap.get(ldId).Send_confirmation_Email__c;
                    
                    //LMS-3050
                    opp.MSRP_AMT__c = leadMap.get(ldId).MSRP_AMT__c;
                    opp.Quote_AMT__c = leadMap.get(ldId).Quote_AMT__c;
                                
                    //LMS-3659
                    opp.TradeBalanceOwed_TXT__c = leadMap.get(ldId).TradeBalanceOwed_TXT__c;
                    opp.TradeMake_TXT__c = leadMap.get(ldId).TradeMake_TXT__c;
                    opp.TradeMileage_TXT__c = leadMap.get(ldId).TradeMileage_TXT__c;
                    opp.TradeModel_TXT__c = leadMap.get(ldId).TradeModel_TXT__c;
                    opp.TradeValue_TXT__c = leadMap.get(ldId).TradeValue_TXT__c;
                    opp.TradeYear_YR__c = leadMap.get(ldId).TradeYear_YR__c;
                    opp.TradeStatus_TXT__c = leadMap.get(ldId).TradeStatus_TXT__c;
                    
                    
                    //Added as a part of LMS-1635
                    if(leadMap.get(ldId).Multiple_Lead_Providers__c!=null){
                        opp.Multiple_Lead_Providers__c = leadMap.get(ldId).Multiple_Lead_Providers__c;
                    } 
                    //Ended as a part of LMS-1635
                    
                    //Added as a part of LMS-2630
                    opp.Lead_Group_ID__c = leadMap.get(ldId).Lead_Group_ID__c;
                    //Ended as a part of LMS-2630
                    
                    //Added as a part of LMS-1453
                    opp.Source_Name__c = leadMap.get(ldId).Source_Name__c;
                    opp.MiddlewareUUID__c = leadMap.get(ldId).MiddlewareUUID__c;
                    opp.SourceUser_TXT__c = leadMap.get(ldId).SourceUser_TXT__c;
                    //Ended as a part of LMS-1453
                    
                    // added as a part of LMS-4627
                    opp.Marketable_FLG__c = leadMap.get(ldId).Marketable_FLG__c;
                     //Ended as a part of LMS-1453
                    opp.FinancialDetails_TXT__c = leadMap.get(ldId).Financial_Details_TXT__c;
                    //Added as part of 2125
                    opp.AcuraCurrentProductsOwned_TXT__c = leadMap.get(ldId).AcuraCurrentProductsOwned_TXT__c;
                    opp.AcuraCurrentProductsOwned2_TXT__c = leadMap.get(ldId).AcuraCurrentProductsOwned2_TXT__c;
                    opp.AcuraHighValueTrimlinePropensity_NUM__c = leadMap.get(ldId).AcuraHighValueTrimlinePropensity_NUM__c;
                    opp.AcuraOwnershipStatus_TXT__c = leadMap.get(ldId).AcuraOwnershipStatus_TXT__c;
                    opp.AcuraOwnershipStatusHousehold_TXT__c = leadMap.get(ldId).AcuraOwnershipStatusHousehold_TXT__c;
                    opp.Address_Error_CD__c = leadMap.get(ldId).Address_Error_CD__c;
                    opp.Address_Error_Description_TXT__c = leadMap.get(ldId).Address_Error_Description_TXT__c;
                    opp.Address_Status_TXT__c = leadMap.get(ldId).Address_Status_TXT__c;
                    opp.CleansedAddress_TXT__c = leadMap.get(ldId).CleansedAddress_TXT__c;
                    opp.DateofLastService_DT__c = leadMap.get(ldId).DateofLastService_DT__c;
                    opp.Email_CheckedDate_TXT__c = leadMap.get(ldId).Email_CheckedDate_TXT__c;
                    opp.Email_Error_CD__c = leadMap.get(ldId).Email_Error_CD__c;
                    opp.Email_Error_Description_TXT__c = leadMap.get(ldId).Email_Error_Description_TXT__c;
                    opp.Home_Phone_Error_CD__c = leadMap.get(ldId).Home_Phone_Error_CD__c;
                    opp.Home_Phone_Error_Description_TXT__c = leadMap.get(ldId).Home_Phone_Error_Description_TXT__c;
                    opp.HondaCurrentProductsOwned_TXT__c = leadMap.get(ldId).HondaCurrentProductsOwned_TXT__c;
                    opp.HondaCurrentProductsOwned2_TXT__c = leadMap.get(ldId).HondaCurrentProductsOwned2_TXT__c;
                    opp.HondaHighValueTrimlinePropensity_NUM__c = leadMap.get(ldId).HondaHighValueTrimlinePropensity_NUM__c;
                    opp.HondaOwnershipStatus_TXT__c = leadMap.get(ldId).HondaOwnershipStatus_TXT__c;
                    opp.HondaOwnershipStatusHousehold_TXT__c = leadMap.get(ldId).HondaOwnershipStatusHousehold_TXT__c;
                    opp.Location_Description_TXT__c = leadMap.get(ldId).Location_Description_TXT__c;
                    opp.Location_Error_CD__c = leadMap.get(ldId).Location_Error_CD__c;
                    opp.Location_Error_Description_TXT__c = leadMap.get(ldId).Location_Error_Description_TXT__c;
                    opp.Location_Status_TXT__c = leadMap.get(ldId).Location_Status_TXT__c;
                    opp.Model_Error_CD__c = leadMap.get(ldId).Model_Error_CD__c;
                    opp.Model_Error_Description_TXT__c = leadMap.get(ldId).Model_Error_Description_TXT__c;
                    opp.Model_IMG__c = leadMap.get(ldId).Model_IMG__c;
                    opp.Model_Name_NM__c = leadMap.get(ldId).Model_Name_NM__c;
                    opp.PECurrentProductsOwned_TXT__c = leadMap.get(ldId).PECurrentProductsOwned_TXT__c;
                    opp.PEOwnershipStatus_TXT__c = leadMap.get(ldId).PEOwnershipStatus_TXT__c;
                    opp.PEOwnershipStatusHousehold_TXT__c = leadMap.get(ldId).PEOwnershipStatusHousehold_TXT__c;
                    opp.PreferredDealerNumber_NUM__c = leadMap.get(ldId).PreferredDealerNumber_NUM__c;
                    opp.PSPOwnershipStatus_TXT__c = leadMap.get(ldId).PSPOwnershipStatus_TXT__c;
                    opp.PSPOwnershipStatusHousehold_TXT__c = leadMap.get(ldId).PSPOwnershipStatusHousehold_TXT__c;
                    opp.SalesRelatedDealerNumber__c    = leadMap.get(ldId).SalesRelatedDealerNumber__c;
                    opp.ServiceRelatedDealerNumber__c  = leadMap.get(ldId).ServiceRelatedDealerNumber__c;
             //     opp.SFMC_description_TXT__c  = leadMap.get(ldId).SFMC_description_TXT__c;
             //     opp.SFMC_errorcode_TXT__c    = leadMap.get(ldId).SFMC_errorcode_TXT__c;
             //     opp.SFMC_errordescription_TXT__c     = leadMap.get(ldId).SFMC_errordescription_TXT__c;
             //     opp.SFMC_status_TXT__c   = leadMap.get(ldId).SFMC_status_TXT__c;
                    opp.SFMC_Sales_status__c = leadMap.get(ldId).SFMC_Sales_status__c;
                    opp.SFMC_Sales_description__c = leadMap.get(ldId).SFMC_Sales_description__c;
                    opp.SFMC_Sales_errorcode__c = leadMap.get(ldId).SFMC_Sales_errorcode__c;
                    opp.SFMC_Sales_errordescription__c  = leadMap.get(ldId).SFMC_Sales_errordescription__c;
                    opp.SFMC_Service_status__c  = leadMap.get(ldId).SFMC_Service_status__c;
                    opp.SFMC_Service_description__c = leadMap.get(ldId).SFMC_Service_description__c;
                    opp.SFMC_Service_errorcode__c = leadMap.get(ldId).SFMC_Service_errorcode__c;
                    opp.SFMC_Service_errordescription__c = leadMap.get(ldId).SFMC_Service_errordescription__c;
                    opp.Valid_Model_ID_FLG__c    = leadMap.get(ldId).Valid_Model_ID_FLG__c;
                    opp.PSPCurrentProductsOwned_TXT__c = leadMap.get(ldId).PSPCurrentProductsOwned_TXT__c;
                    opp.PSPCurrentProductsOwned2_TXT__c = leadMap.get(ldId).PSPCurrentProductsOwned2_TXT__c;
                    opp.PSPOwnershipStatus_TXT__c = leadMap.get(ldId).PSPOwnershipStatus_TXT__c;
                    opp.PSPOwnershipStatusHousehold_TXT__c = leadMap.get(ldId).PSPOwnershipStatusHousehold_TXT__c;
                    opp.YourDealershipServicesLast60Mths_NUM__c = leadMap.get(ldId).YourDealershipServicesAmountSpentLast60M__c;
                    opp.YourDealershipSvsSpentLast60Mth_NUM__c = leadMap.get(ldId).YourDealershipServicesLast60Months_NUM__c;
                    opp.DateofLastService_DT__c = leadMap.get(ldId).DateofLastService_DT__c;
                //Lavanya -LMS-5176-start
                    opp.Interior_Color__c = leadMap.get(ldId).Interior_Color__c;
                    opp.Exterior_Color__c = leadMap.get(ldId).Exterior_Color__c;
                //End-LMS-5176
                 //Vinay LMS-5871 
                    opp.ProductLine__c = leadMap.get(ldId).ProductLine__c;
                 //Vinay LMS-6098
                    opp.Marketing_Campaign_Name__c= leadMap.get(ldId).Marketing_Campaign_Name__c;
                   //End LMS-6098 
                   opp.TriggerTypeCode__c= leadMap.get(ldId).TriggerTypeCode__c;
                   //LMS-6694
                    opp.Is_Third_Party_Duplicate__c = leadMap.get(ldId).Is_Third_Party_Duplicate_Lead__c;
                
				 /*DSP Code - start - GLavanya- DS-1182*/ 
               	opp.ProviderService_TXT__c=leadMap.get(ldId).ProviderService_TXT__c;
                opp.Source_Unique_ID__c= leadMap.get(ldId).Source_Unique_ID__c;
                opp.Appointment_Date_and_Time__c= leadMap.get(ldId).Appointment_Date_and_Time__c;
                opp.Appointment_Location__c = leadMap.get(ldId).Appointment_Location__c;
                opp.Appointment_Notes__c = leadMap.get(ldId).Appointment_Notes__c;
                opp.Contact_person__c = leadMap.get(ldId).Contact_person__c;
                opp.Lead_Coming_From_CRM__c = leadMap.get(ldId).Lead_Coming_From_CRM__c;
                opp.Deal_ID__c = leadMap.get(ldId).Deal_ID__c;
                opp.Deal_Link__c = leadMap.get(ldId).Deal_Link__c;
                opp.Appointment_type__c = leadMap.get(ldId).Appointment_type__c;
                opp.Vendor_Contact_Name__c = leadMap.get(ldId).Vendor_Contact_Name__c;
                opp.Vendor_Contact_Email__c = leadMap.get(ldId).Vendor_Contact_Email__c;
                opp.Appointment_Id__c  = leadMap.get(ldId).Appointment_Id__c;
                opp.Provider_Type__c = leadMap.get(ldId).Provider_Type__c;
             /*DSP Code - End - GLavanya- DS-1182*/
                

                   
                 //System.debug('oppNewCreatedList'+oppNewCreatedList);   
                    oppNewCreatedList.add(opp); 
                                      
                    
               // }
           /*     
                Lead leadRecord = new Lead();
                leadRecord.Id=ldId;
                leadRecord.Status='Closed - Converted';
                
                updatedLeadRecordList.add(leadRecord);
               */
            }
           List<Opportunity> olist = new List<Opportunity>();
            set<id> oppids = new set<id>();
            if(oppNewCreatedList.size()>0)
            {
                Database.SaveResult[] results = Database.insert(oppNewCreatedList, false);
                //List<Opportunity> olist = new List<Opportunity>();
                
                // Iterate SaveResult array
                for (Database.SaveResult result : results) {
                    if (result.isSuccess()) {
                        //Successfully inserted
                        //Handle insertion
                        //System.debug('opp inserted' + result.getId());
                        Opportunity autoOpp = new Opportunity(id=result.getId());
                        olist.add(autoOpp);
                        //System.debug('result------'+result);
                        oppids.add(result.getId());
                    }
                    else {
                        //Error ecountered              
                        for(Database.Error error : result.getErrors()) {
                            //Handle error
                             System.debug(error.getStatusCode() + ': ' + error.getMessage() + 
                                          ' Fields that affected the error: ' + error.getFields());
                            Logs__c logRecord = new Logs__c(Name='Batch or Lead Trigger Lead to Opp ** ',Trigger_or_Class_Name__c='HELMSLeadConvertToOppHandler **',Error_Message__c = error.getMessage() + '' +error.getFields(),Error_Line_Number__c = 0);
                            insert logRecord;

                        }
                    }
                }
                System.debug('==olist==='+olist);
               /* if(olist.size() > 0){
                    List<Opportunity_Additional_Attribute__c> oppAddInfoList = new List<Opportunity_Additional_Attribute__c>();
                    Map<String,String> leadToOppMap = new Map<String,String>();
                    List<Opportunity> oppList = [SELECT Id,Lead_ID__c FROM Opportunity WHERE ID IN: olist];
                    for(Opportunity opp : oppList){
                        leadToOppMap.put(opp.Lead_ID__c,opp.Id);
                    }
                    if(leadToOppMap.size() > 0){
                        List<Lead_Additional_Attribute__c> addInfoList = [SELECT id,Lead_Id__c,Name,Definition_Name__c,Sequence_Number__c,Attribute_Value__c FROM Lead_Additional_Attribute__c WHERE Lead_Id__c IN: leadToOppMap.keyset()];
                        for(Lead_Additional_Attribute__c leadAddInfo : addInfoList){
                            if(leadToOppMap.containsKey(leadAddInfo.Lead_Id__c)){
                                Opportunity_Additional_Attribute__c oppAttribute = new Opportunity_Additional_Attribute__c();
                                oppAttribute.Name = leadAddInfo.Name;
                                oppAttribute.Definition_Name__c = leadAddInfo.Definition_Name__c;
                                oppAttribute.Sequence_Number__c = leadAddInfo.Sequence_Number__c;
                                oppAttribute.Attribute_Value__c = leadAddInfo.Attribute_Value__c;
                                oppAttribute.Opportunity_Id__c = leadToOppMap.get(leadAddInfo.Lead_Id__c); 
                                oppAddInfoList.add(oppAttribute);
                            }
                        }
                    }
                     System.debug('==olist==oppAddInfoList='+oppAddInfoList);
                    if(oppAddInfoList.size() > 0)
                        INSERT oppAddInfoList;
                }*/
                //HELMSLeadConvertToOppHandler.AutoleadConvert(oppNewCreatedList);
                
                HELMSLeadConvertToOppHandler.AutoleadConvert(olist);
            
            }
       
        }catch(Exception ex){
            Logs__c logRecord = new Logs__c(Name='Batch or Lead Trigger Lead to Opp',Trigger_or_Class_Name__c='HELMSLeadConvertToOppHandler',Error_Message__c = ex.getMessage(),Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
            insert logRecord;
            
        }
            
    } 

    public static void AutoleadConvert(List<Opportunity> oppNewCreatedList){
    
        try{
            set<Id> oppIds = new set<Id>();
            for(Opportunity opp:oppNewCreatedList) {
                system.debug('AccountId-----'+opp.AccountId);
                system.debug('Lead_ID__c-----'+opp.Lead_ID__c);
                oppIds.add(opp.Id);
            }
            system.debug('oppIds-----'+oppIds);
            set<id> oset = new set<id>();
           //List<LeadStatus> lead= new List<LeadStatus>();
            //LeadStatus convertStatus = [SELECT Id,ApiName, IsConverted,MasterLabel from LeadStatus where IsConverted=true and (ApiName =:System.Label.Ready_to_Convert OR ApiName =:System.Label.New OR ApiName =:System.Label.On_Hold)];
            List<LeadStatus> convertStatus = [SELECT Id,ApiName, IsConverted,MasterLabel from LeadStatus where IsConverted=true and ApiName !=: System.Label.Closed_Not_Converted and ApiName !=: System.Label.Closed_Converted];
             //system.debug(convertStatus);
             List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            

             for (Opportunity opp: [select id,Lead_ID__c,AccountId from Opportunity where id IN : oppIds and AccountId!=null and Lead_ID__c!=null ]) {
                if (opp.id!=null && !(oset.Contains(opp.Lead_ID__c))) {
                    
                    oset.add(opp.Lead_ID__c);
                     Database.LeadConvert lc = new Database.LeadConvert();
                      
                      lc.setLeadId(opp.Lead_ID__c);
                      lc.setOpportunityId(opp.id);
                    if(convertStatus.size() >0)
                    lc.setConvertedStatus(convertStatus[0].ApiName);
                    //lc.setConvertedStatus(convertStatus.ApiName);
                      // lc.setConvertedStatus(convertStatus.MasterLabel);
                      //lc.setContactId(lead.CustomerAccount_ID__r.PersonContactId);
                      //lc.setAccountId(Opp.Lead_ID__r.CustomerAccount_ID__c);
                      lc.setAccountId(opp.AccountId);
                      leadConverts.add(lc);
                }
             }

             if (!leadConverts.isEmpty()) {
                  System.debug('Email =>=> 1');
                  //List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
                  //AMSLM-1053
                  List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts, false);
                    
                   Set<id> leadids = new Set<id>();
                   Set<id> opp_ids = new Set<id>();
                   for(Database.LeadConvertResult lctemp: lcr){
                       if(lctemp.isSuccess()){
                            opp_ids.add(lctemp.getOpportunityId());
                            leadids.add(lctemp.getLeadId());
                        }
                    }
                   if(HelmsCheckRecursive.run_Once()){
                       System.debug('Email =>=> 2');
                      if(leadids.size()>0  && Limits.getQueueableJobs() == 0)                     
                           System.enqueueJob(new HelmsSFMCQueueable(leadids,opp_ids));
                   }
                      
                  
           
             }
            
        }catch(Exception ex){
            Logs__c logRecord = new Logs__c(Name='HELMSAutoLeadConvertBatch Batch Error', Trigger_or_Class_Name__c='HELMSAutoLeadConvertBatch',  Error_Message__c = ex.getMessage(),
                                            Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
            insert logRecord;
            
        }  
    
    }
}