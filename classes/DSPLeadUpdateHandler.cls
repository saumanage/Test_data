/****  Trigger Name: DSPLeadUpdate 
Handler Name:DSPLeadUpdateHandler
Test Class Name : DSPLeadUpdateTest
Method Name :updateLeads - we are updating the values in Lead record
Method Name :updateOpportunity - we are updating the values in Opportunity record
User story Number :DS-1185/1187
SFDC will subscribe to a platform event queue to get update Lead data. 
****/
//===========================
public class DSPLeadUpdateHandler {
    // Updating the values in Lead record
    public static void updateLeads(List<DSP_Lead_Update__e> newDSPLeadUpdates){
        try{
            System.debug('newDSPLeadUpdate------'+newDSPLeadUpdates);
            Map<string, id> Providermap = new Map<string, id>();
            List<String> pnamelist = new List<String>();
            List<Lead> updateLeadList = new List<Lead>();
            Map<string,DSP_Lead_Update__e> mapLeadUpdation = new Map<string,DSP_Lead_Update__e>();
            Set<string> sourceUniqueIds = new Set<string>();
            for(DSP_Lead_Update__e leadupdation : newDSPLeadUpdates){
                sourceUniqueIds.add(leadupdation.Source_Unique_ID__c);
                mapLeadUpdation.put(leadupdation.Source_Unique_ID__c,leadupdation);
                if(leadupdation.ProviderDetails_TXT__c!=null){ 
                    string providename =  leadupdation.ProviderDetails_TXT__c;
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null){
                            pnamelist.add(pdn1[0]);
                        }
                    }else{
                        pnamelist.add(leadupdation.ProviderDetails_TXT__c);
                    }
                }
                if(leadupdation.Lead_Provider_Name__c!=null && leadupdation.Lead_Provider_Name__c!='')
                    pnamelist.add(leadupdation.Lead_Provider_Name__c);
            }
            Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            for(Account a:[select id,name from account where name IN: pnamelist and RecordTypeId=:providerAccRecTypeId]){  
                Providermap.put((a.name).toLowerCase(),a.id);
            }  
            User InteUser = [select id from user where name=:System.Label.PlatformEventUSerProfileName and isactive = true and Profile.name=:System.Label.PEProfile limit 1 ];
            List<Lead> updateLeads = [Select Id,Appointment_type__c,DSP_Update_Count__c, Appointment_Id__c, Appointment_Date_and_Time__c, CreatedById,ownerid,Vehicle_Ids_ID__c,Model_ID__c,Dealer_Ids_ID__c,PreferredDealerNumber_NUM__c,Dealer_Assignment_Type__c,Provider_Ids_ID__c,Division_CD__c,SubDiv_TXT__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Make_TXT__c,Model_TXT__c,Trim_TXT__c,Model_Name_NM__c,MSRP_AMT__c,Year_YR__c,Number_NM__c,BodyStyle_TXT__c,Odometer_TXT__c,OdometerStatus_TXT__c,OdometerUnits_TXT__c,Transmission_TXT__c,InventoryNumber_TXT__c,Color_TXT__c,FirstName,LastName,MiddleName,AddressType_TXT__c,Street,AppartmentNumber_TXT__c,City,state,Country,PostalCode,Email,Phone,MobilePhone,ContactMethod_TXT__c,Description,LeadProvider_ID__c,ProviderContactDetail_TXT__c,OtherLeadProvider_TXT__c,Provider_Tool_Name__c,Source_Unique_ID__c,Appointment_Location__c,Appointment_Notes__c,Contact_person__c,DEPOSIT_AMOUNT__c From Lead Where Source_Unique_ID__c IN : sourceUniqueIds order by CreatedDate desc limit 5000];
            if(updateLeads.size() > 0){
                for(Lead updatelead: updateLeads){
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_IDs__c !=null){
                        updatelead.Vehicle_Ids_ID__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_IDs__c).unescapeXml();
                        String M=(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_IDs__c).unescapeXml();
                        if(M.contains('>')){
                            String[] Mi = M.split('>');
                            if(mi[1].contains('<')){
                                String[] modelid = (mi[1]).split('<');
                                updatelead.Model_ID__c = (modelid[0]);
                            }
                        }else{
                            updatelead.Model_ID__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_IDs__c;
                        }
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Dealer_IDs__c !=null){
                        updatelead.Dealer_Ids_ID__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Dealer_IDs__c).unescapeXml();
                        String pdids=(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Dealer_IDs__c).unescapeXml();
                        if(pdids.contains('>')){
                            String[] pdn = pdids.split('>');
                            if(pdn[1].contains('<')){
                                String[] pdno = (pdn[1]).split('<');
                                updatelead.PreferredDealerNumber_NUM__c = (pdno[0]);
                            }
                        }else{
                            updatelead.PreferredDealerNumber_NUM__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Dealer_IDs__c;
                        }
                        String preferred = updatelead.PreferredDealerNumber_NUM__c;
                        if(preferred != null && preferred != ''){
                            if(preferred.substring(0, 1) == '0'){
                                preferred= preferred.replace('0', '');
                            }
                        }
                        if(preferred != '' && preferred != null){
                            updatelead.Dealer_Assignment_Type__c = 'Customer Selected';    
                        }
                        updatelead.PreferredDealerNumber_NUM__c = preferred;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Provider_IDs__c!=null){
                        updatelead.Provider_Ids_ID__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Provider_IDs__c).unescapeXml();
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_Interest_TXT__c!=null){
                        updatelead.VehicleInterest_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_Interest_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_Status_TX__c!=null){
                        updatelead.VehicleStatus_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vehicle_Status_TX__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Make_TXT__c!=null){
                        updatelead.Make_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Make_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_TXT__c!=null){
                        updatelead.Model_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_TXT__c;
                    }
                    if(updatelead.Model_TXT__c==null ){
                        if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Name_NM__c!=null){
                            updatelead.Model_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Name_NM__c;
                        }
                    } 
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Trim_TXT__c!=null){         
                        updatelead.Trim_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Trim_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Name_NM__c!=null){         
                        updatelead.Model_Name_NM__c= mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Model_Name_NM__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).MSRP_AMT__c!=null){ 
                        String s=mapLeadUpdation.get(updatelead.Source_Unique_ID__c).MSRP_AMT__c;
                        if(s.contains(',')){
                            String s1=s.remove(',');
                            Decimal msrp = Decimal.valueOf(s1);
                            updatelead.MSRP_AMT__c = msrp;
                        }else{
                            Decimal msrp = Decimal.valueOf(s);
                            updatelead.MSRP_AMT__c = msrp;
                        }
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Year_YR__c!=null){      
                        updatelead.Year_YR__c = String.valueOf(Integer.valueOf(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Year_YR__c));
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vin_Number_NUM__c!=null){      
                        updatelead.Number_NM__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Vin_Number_NUM__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Body_Style_TXT__c!=null){      
                        updatelead.BodyStyle_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Body_Style_TXT__c;
                    }  
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_TXT__c!=null){   
                        updatelead.Odometer_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_Status_TXT__c!=null){   
                        updatelead.OdometerStatus_TXT__c = String.valueOf(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_Status_TXT__c);
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_Units_TXT__c!=null){
                        updatelead.OdometerUnits_TXT__c = String.valueOf(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Odometer_Units_TXT__c);
                    }  
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Transmission_TXT__c!=null){                 
                        updatelead.Transmission_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Transmission_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Stock_Number_NUM__c!=null && mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Stock_Number_NUM__c!='0'){  
                        updatelead.InventoryNumber_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Stock_Number_NUM__c;
                    }    
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Color_TXT__c!=null){ 
                        updatelead.Color_TXT__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Color_TXT__c).unescapeXml();
                    }
             		if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).FirstName_NM__c !=null && mapLeadUpdation.get(updatelead.Source_Unique_ID__c).FirstName_NM__c.length()>40){    
                        updatelead.FirstName = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).FirstName_NM__c.substring(0,40);
                    } 
                    else if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).FirstName_NM__c == null){
                         updatelead.FirstName = updatelead.FirstName;
                    }
					else{
                        updatelead.FirstName = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).FirstName_NM__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).LastName_NM__c!=null && mapLeadUpdation.get(updatelead.Source_Unique_ID__c).LastName_NM__c.length()>80){
                        updatelead.LastName = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).LastName_NM__c.substring(0,80);
                    } 
                    else if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).LastName_NM__c == null){
                         updatelead.LastName = updatelead.LastName;
                    }
                    else{
                        updatelead.LastName = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).LastName_NM__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).MiddleName_NM__c!=null){ 
                        updatelead.MiddleName = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).MiddleName_NM__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressType_TXT__c!=null){ 
                        updatelead.AddressType_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressType_TXT__c;
                    }
                    string addStreet;
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine1_TXT__c!=null){
                        addStreet = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine1_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine2_TXT__c!=null){
                        addStreet =addStreet+', '+mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine2_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine3_TXT__c!=null){
                        addStreet = addStreet+', '+mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine3_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine4_TXT__c!=null){
                        addStreet = addStreet+', '+mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine4_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine5_TXT__c!=null){
                        addStreet = addStreet+', '+mapLeadUpdation.get(updatelead.Source_Unique_ID__c).AddressLine5_TXT__c;
                    }                
                    if(addStreet!=null){
                        updatelead.Street=addStreet;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ApartmentNumber_NUM__c!=null){   
                        updatelead.AppartmentNumber_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ApartmentNumber_NUM__c;
                    } 
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).City_TXT__c!=null){
                        updatelead.City = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).City_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).State_TXT__c!=null){
                        updatelead.state = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).State_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Country_TXT__c!=null){
                        updatelead.Country = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Country_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ZipCode_TXT__c!=null){
                        updatelead.PostalCode = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ZipCode_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Email_TXT__c!=null){
                        String strEmail = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Email_TXT__c;
                        Boolean bValidateEmail = Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', strEmail.trim());
                        if(bValidateEmail){
                            updatelead.Email = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Email_TXT__c;
                        }
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_type__c!=null){
                        updatelead.Appointment_type__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_type__c;
                    } 
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Phone_TXT__c!=null){
                        updatelead.Phone = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Phone_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Mobile_TXT__c!=null){
                        updatelead.MobilePhone = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Mobile_TXT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ContactMethod_TXT__c!=null){ 
                        updatelead.ContactMethod_TXT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ContactMethod_TXT__c; 
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Description_DESC__c!=null){ 
                        updatelead.Description = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Description_DESC__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderDetails_TXT__c!=null){ 
                        updatelead.ProviderDetail_TXT__c= mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderDetails_TXT__c;
                        string providename =  mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderDetails_TXT__c;
                        if(providename.contains(':')){
                            String[] pdn1 = providename.split(':');
                            if(pdn1[0]!=null && Providermap.containsKey((pdn1[0]).toLowerCase())){
                                updatelead.LeadProvider_ID__c = Providermap.get((pdn1[0]).toLowerCase());
                            }
                            if(pdn1[1]!=null){
                                updatelead.LeadsourceOther_TXT__c = pdn1[1];
                            }
                        }
                        else if(Providermap.containsKey((mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderDetails_TXT__c).toLowerCase())){
                            updatelead.LeadProvider_ID__c = Providermap.get((mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderDetails_TXT__c).toLowerCase());
                        }                    
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderContactDetails_TXT__c!=null){ 
                        updatelead.ProviderContactDetail_TXT__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).ProviderContactDetails_TXT__c).unescapeXml();
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).OtherLeadProvider_TXT__c!=null){ 
                        updatelead.OtherLeadProvider_TXT__c = (mapLeadUpdation.get(updatelead.Source_Unique_ID__c).OtherLeadProvider_TXT__c).unescapeXml();
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Lead_Provider_Name__c!=null && mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Lead_Provider_Name__c!=''){
                        if(Providermap.get((mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Lead_Provider_Name__c).toLowerCase())!=null)
                        updatelead.LeadProvider_ID__c = Providermap.get((mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Lead_Provider_Name__c).toLowerCase());
                        system.debug(':::updatelead.LeadProvider_ID__c:::::::'+updatelead.LeadProvider_ID__c);
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Provider_Tool__c!=null){
                        updatelead.Provider_Tool_Name__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Provider_Tool__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Location__c!=null){
                        updatelead.Appointment_Location__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Location__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Notes__c!=null){
                        updatelead.Appointment_Notes__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Notes__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Contact_person__c!=null){
                        updatelead.Contact_person__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Contact_person__c;
                    } 
                   /* if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Salesforce_Order_Number__c!=null){
                        updatelead.Deposit_Sales_Order_Number__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Salesforce_Order_Number__c;
                    } */
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).DEPOSIT_AMOUNT__c!=null){
                        updatelead.DEPOSIT_AMOUNT__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).DEPOSIT_AMOUNT__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Deal_ID__c!=null){
                        updatelead.Deal_ID__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Deal_ID__c;
                    }
                     if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Deal_Link__c!=null){
                        updatelead.Deal_Link__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Deal_Link__c;
                    }
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Date_and_Time__c!=null){
                        updatelead.Appointment_Date_and_Time__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Date_and_Time__c;
                    } 
                    if(mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Id__c!=null){
                        updatelead.Appointment_Id__c = mapLeadUpdation.get(updatelead.Source_Unique_ID__c).Appointment_Id__c;
                    } 
                    
				updatelead.DSP_Update_Count__c = updatelead.DSP_Update_Count__c + 1;           
                    
				updateLeadList.add(updatelead);
                }
            }
            if(updateLeadList.size() > 0){
                Database.SaveResult[] results = Database.update(updateLeadList, false);
                List<Logs__c> loglist = new List<Logs__c>();
                for (Integer i = 0; i < updateLeadList.size(); i++) {
                    Database.SaveResult s = results[i];
                    if (!s.isSuccess()) {
                        for(Database.Error error : results[i].getErrors()){
                                Logs__c l =new Logs__c (SF_Rec_Id__c=updateLeadList[i].id, name='DSP Lead Update Handler Class' ,Trigger_or_Class_Name__c='DSPLeadUpdateHandler', Error_Message__c =error.getMessage());
                                loglist.add(l);
                        }
                    }
                }
                if(loglist.size()>0){
                    insert loglist;
                }
            }
        }
        Catch(Exception ex){
            Logs__c  l =new Logs__c (PE_Reply_Id__c=newDSPLeadUpdates[0].ReplayId, name='Update insertion failures',Type__c='Lead update failures',Trigger_or_Class_Name__c='DSPLeadUpdateHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }    
    }

    // Updating the values in opportunity record
    public static void updateOpportunity(List<DSP_Lead_Update__e> newDSPOpportunityUpdates){
        try{
            System.debug('newDSPOpportunityUpdates : '+newDSPOpportunityUpdates);
            Map<string, id> Providermap = new Map<string, id>();
            List<String> pnamelist = new List<String>();
            List<Opportunity> updateoppsList = new List<Opportunity>();
             List<Opportunity> sendupdatestodealer = new List<Opportunity>();
            Map<string,DSP_Lead_Update__e> mapOppUpdation = new Map<string,DSP_Lead_Update__e>();
            Set<string> sourceUniqueIds = new Set<string>();
            
            Set<String> dealerSet=new Set<String>();  
            Set<String> SubDivSet=new Set<String>();
  			 Map<string , Dealer_Participation__c> dealerpatiLeist = new Map<string , Dealer_Participation__c>();
            for(DSP_Lead_Update__e oppupdation : newDSPOpportunityUpdates){
                sourceUniqueIds.add(oppupdation.Source_Unique_ID__c);
                mapOppUpdation.put(oppupdation.Source_Unique_ID__c,oppupdation);
                if(oppupdation.ProviderDetails_TXT__c!=null){ 
                    string providename =  oppupdation.ProviderDetails_TXT__c;
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null){
                            pnamelist.add(pdn1[0]);
                        }
                    }else{
                        pnamelist.add(oppupdation.ProviderDetails_TXT__c);
                    }
                }
                if(oppupdation.Lead_Provider_Name__c!=null && oppupdation.Lead_Provider_Name__c!='')
                    pnamelist.add(oppupdation.Lead_Provider_Name__c);
            }
            Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            for(Account a:[select id,name from account where name IN: pnamelist and RecordTypeId=:providerAccRecTypeId]){  
                Providermap.put((a.name).toLowerCase(),a.id);
            }  
            User InteUser = [select id from user where name=:System.Label.PlatformEventUSerProfileName and isactive = true and Profile.name=:System.Label.PEProfile limit 1 ];
          List<Opportunity> updateOpportunity = [SELECT Id,Deposit_IP_Addres_URL__c, Send_to_DSP__c,Provider_Type__c,Is_This_Lead_Update__c, Vendor_Contact_Email__c, Vendor_Contact_Name__c, Initial_Walkin_Lead__c,DSP_Update_Count__c, Appointment_Location__c,Source_Unique_ID__c,Appointment_Notes__c, Contact_person__c, Deal_ID__c, Deal_Link__c, Appointment_Date_and_Time__c, Appointment_Id__c, Appointment_type__c, Name,Is_Third_Party_Duplicate__c,Duplicate_Similar__c,Einstein_Predicted_Priority__c,Routable_FLG__c,Opportunity_SF_ID__c,Deposit_Confirmation_Number__c,Deposit_Sales_Order_Number__c,DEPOSIT_AMOUNT__c,PreferredDealerAccount_TXT__c, SubDiv_TXT__c,SendOnlyToUrbanScience__c,Provider_Tool_Name__c, External_Lead_Reference_Number__c,LeadProvider_ID__c,Vehicle_Ids_ID__c,VehicleInterest_TXT__c,VehicleStatus_TXT__c,Number_NM__c,Year_YR__c,ZipCode_TXT__c,TradeValue_TXT__c,TradeYear_YR__c,Transmission_TXT__c,TriggerTypeCode__c,TriggerSendbyDate_DT__c,TradeBalanceOwed_TXT__c,TradeMake_TXT__c,TradeMileage_TXT__c,TradeModel_TXT__c,TradeStatus_TXT__c,Quote_AMT__c,Source_Name__c,SourceUser_TXT__c,State_TXT__c,Suffix_TXT__c,InventoryNumber_TXT__c,ProviderDetail_TXT__c,PurchaseEarliestDate_DT__c,PurchaseHorizon_TXT__c,PurchaseLatestDate_DT__c,Pager_TXT__c,Phone__c,Prospect_Ids_ID__c,Provider_Ids_ID__c,Routing_Status__c,ProviderContactDetail_TXT__c,Odometer_TXT__c,OdometerUnits_TXT__c,Options_TXT__c,OtherContacts_TXT__c,OtherLeadProvider_TXT__c,MiddlewareUUID__c,MobilePhone__c,Trim_TXT__c,Model_TXT__c,MSRP_AMT__c,OdometerStatus_TXT__c,FinancialDetails_TXT__c,First_Name_TXT__c,Last_Name_TXT__c,Make_TXT__c,Middle_Name_TXT__c,PhoneType_NM__c,ServiceRelatedDealerNumber__c,LeadAdditionalInfos__c,Description,Doors_TXT__c,Email__c,Fax__c,YourDealershipSvsSpentLast60Mth_NUM__c,DateofLastService_DT__c,SalesRelatedDealerNumber__c,AcuraOwnershipStatusHousehold_TXT__c,YourDealershipServicesLast60Mths_NUM__c,Chat_Transcript__c,AcuraCurrentProductsOwned_TXT__c,AcuraCurrentProductsOwned2_TXT__c,AcuraHighValueTrimlinePropensity_NUM__c,HondaHighValueTrimlinePropensity_NUM__c,HondaOwnershipStatusHousehold_TXT__c,AcuraOwnershipStatus_TXT__c,HondaOwnershipStatus_TXT__c,HondaCurrentProductsOwned_TXT__c,HondaCurrentProductsOwned2_TXT__c,PEOwnershipStatus_TXT__c,PECurrentProductsOwned_TXT__c,PEOwnershipStatusHousehold_TXT__c,PSPCurrentProductsOwned_TXT__c,PSPCurrentProductsOwned2_TXT__c,PSPOwnershipStatusHousehold_TXT__c,Customer_Ids_ID__c,PreferredDealerNumber_NUM__c,Division_CD__c,PSPOwnershipStatus_TXT__c,Color_XML__c,Condition_TXT__c,ContactTime_TXT__c,ContactType_TXT__c,ContactMethod_TXT__c,Country_TXT__c,Lead_Dealer_Acknowledgement_Status_Code__c,Street_TXT__c,AddressType_TXT__c,AppartmentNumber_TXT__c,BodyStyle_TXT__c,City_TXT__c,ENR_CI_Service_History__c,ENR_CI_Ownership_Details__c,ENR_CI_Ownership__c,ENR_CI_Likely_to_Buy_PSP__c,ENR_CI_Likely_to_Buy_Honda__c,ENR_CI_Likely_to_Buy_Acura__c,ENR_CI_Extended_Warranty__c,ENR_CI_Event_Attendance__c,ENR_CI_Children_in_Household__c,DMGR_Environmental_Issues__c,DMGR_Green_Living__c,DMGR_Baseball__c,DMGR_Basketball__c,DMGR_Football__c,DMGR_US_Travel__c,DMGR_Hockey__c,DMGR_Skiing__c,DMGR_Golf__c,DMGR_Vehicle_Known_Owned__c,DMGR_Age__c,DMGR_Income__c,DMGR_Children__c,DMGR_Income_Estate_HHLD_Higher_Ranges__c,DMGR_Marital_Status__c,DMGR_Occupation__c,DMGR_Home_Owner_or_Renter__c,DMGR_Occupation_Detailed__c,DMGR_Household_Size__c,DMGR_Education_Level__c,ENR_Acura_Vehicles_Owned__c,ENR_Honda_Vehicles_Owned__c,ENR_Power_Sports_Vehicles_Owned__c,ENR_Power_Equipment_Vehicles_Owned__c,ENR_Extended_Warranty_Contract__c,ENR_Likeliness_to_Buy_Acura__c,ENR_Likeliness_to_Buy_Honda__c,ENR_Likeliness_to_Buy_PSP__c,ENR_Ownership_Type__c,ENR_Total_Spent_on_Service_by_Customer__c,ENR_Total_Spent_on_Service_by_Warranty__c From Opportunity  Where Source_Unique_ID__c IN : sourceUniqueIds order by CreatedDate desc limit 5000]; 
           
             if(updateOpportunity.size() > 0){
                for(Opportunity updateopp: updateOpportunity){
                    
                dealerSet.add(updateopp.PreferredDealerAccount_TXT__c);
                SubDivSet.add(updateopp.SubDiv_TXT__c);
                    
                    if(updateopp.Initial_Walkin_Lead__c){
                        updateopp.Initial_Walkin_Lead__c = false;
                    }

                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_IDs__c !=null){
                        updateopp.Vehicle_Ids_ID__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_IDs__c).unescapeXml();
                        String M=(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_IDs__c).unescapeXml();
                        if(M.contains('>')){
                            String[] Mi = M.split('>');
                            if(mi[1].contains('<')){
                                String[] modelid = (mi[1]).split('<');
                                updateopp.Model_ID__c = (modelid[0]);
                            }
                        }else{
                            updateopp.Model_ID__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_IDs__c;
                        }
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Dealer_IDs__c !=null){
                        updateopp.Dealer_Ids_ID__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).Dealer_IDs__c).unescapeXml();
                        String pdids=(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Dealer_IDs__c).unescapeXml();
                        if(pdids.contains('>')){
                            String[] pdn = pdids.split('>');
                            if(pdn[1].contains('<')){
                                String[] pdno = (pdn[1]).split('<');
                                updateopp.PreferredDealerNumber_NUM__c = (pdno[0]);
                            }
                        }else{
                            updateopp.PreferredDealerNumber_NUM__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Dealer_IDs__c;
                        }
                        String preferred = updateopp.PreferredDealerNumber_NUM__c;
                        if(preferred != null && preferred != ''){
                            if(preferred.substring(0, 1) == '0'){
                                preferred= preferred.replace('0', '');
                            }
                        }
                        if(preferred != '' && preferred != null){
                            updateopp.Dealer_Assignment_Type__c = 'Customer Selected';    
                        }
                        updateopp.PreferredDealerNumber_NUM__c = preferred;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Provider_IDs__c!=null){
                        updateopp.Provider_Ids_ID__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).Provider_IDs__c).unescapeXml();
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_Interest_TXT__c!=null){
                        updateopp.VehicleInterest_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_Interest_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_Status_TX__c!=null){
                        updateopp.VehicleStatus_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vehicle_Status_TX__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Make_TXT__c!=null){
                        updateopp.Make_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Make_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_TXT__c!=null){
                        updateopp.Model_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_TXT__c;
                    }
                    if(updateopp.Model_TXT__c==null ){
                        if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Name_NM__c!=null){
                            updateopp.Model_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Name_NM__c;
                        }
                    } 
                   if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_type__c!=null){
                        updateopp.Appointment_type__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_type__c;
                    } 
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Trim_TXT__c!=null){         
                        updateopp.Trim_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Trim_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Name_NM__c!=null){         
                        updateopp.Model_Name_NM__c= mapOppUpdation.get(updateopp.Source_Unique_ID__c).Model_Name_NM__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).MSRP_AMT__c!=null){ 
                        String s=mapOppUpdation.get(updateopp.Source_Unique_ID__c).MSRP_AMT__c;
                        if(s.contains(',')){
                            String s1=s.remove(',');
                            Decimal msrp = Decimal.valueOf(s1);
                            updateopp.MSRP_AMT__c = msrp;
                        }else{
                            Decimal msrp = Decimal.valueOf(s);
                            updateopp.MSRP_AMT__c = msrp;
                        }
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Year_YR__c!=null){      
                        updateopp.Year_YR__c = String.valueOf(Integer.valueOf(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Year_YR__c));
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vin_Number_NUM__c!=null){      
                        updateopp.Number_NM__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Vin_Number_NUM__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Body_Style_TXT__c!=null){      
                        updateopp.BodyStyle_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Body_Style_TXT__c;
                    }  
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_TXT__c!=null){   
                        updateopp.Odometer_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_Status_TXT__c!=null){   
                        updateopp.OdometerStatus_TXT__c = String.valueOf(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_Status_TXT__c);
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_Units_TXT__c!=null){
                        updateopp.OdometerUnits_TXT__c = String.valueOf(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Odometer_Units_TXT__c);
                    }  
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Transmission_TXT__c!=null){                 
                        updateopp.Transmission_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Transmission_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Stock_Number_NUM__c!=null && mapOppUpdation.get(updateopp.Source_Unique_ID__c).Stock_Number_NUM__c!='0'){  
                        updateopp.InventoryNumber_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Stock_Number_NUM__c;
                    }    
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Color_TXT__c!=null){ 
                        updateopp.Color_TXT__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).Color_TXT__c).unescapeXml();
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).FirstName_NM__c!=null && mapOppUpdation.get(updateopp.Source_Unique_ID__c).FirstName_NM__c.length()>40){    
                        updateopp.First_Name_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).FirstName_NM__c.substring(0,40);
                    } 
                    else if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).FirstName_NM__c == null){
                         updateopp.First_Name_TXT__c = updateopp.First_Name_TXT__c;
                    }else{
                        updateopp.First_Name_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).FirstName_NM__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).LastName_NM__c!=null && mapOppUpdation.get(updateopp.Source_Unique_ID__c).LastName_NM__c.length()>80){
                        updateopp.Last_Name_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).LastName_NM__c.substring(0,80);
                    } 
                    else if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).LastName_NM__c == null){
                         updateopp.Last_Name_TXT__c = updateopp.Last_Name_TXT__c;
                    }else{
                        updateopp.Last_Name_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).LastName_NM__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).MiddleName_NM__c!=null){ 
                        updateopp.Middle_Name_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).MiddleName_NM__c;
                    }
                    else if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).MiddleName_NM__c == null){
                         updateopp.Middle_Name_TXT__c = updateopp.Middle_Name_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressType_TXT__c!=null){ 
                        updateopp.AddressType_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressType_TXT__c;
                    }
                    string addStreet;
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine1_TXT__c!=null){
                        addStreet = mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine1_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine2_TXT__c!=null){
                        addStreet =addStreet+', '+mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine2_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine3_TXT__c!=null){
                        addStreet = addStreet+', '+mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine3_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine4_TXT__c!=null){
                        addStreet = addStreet+', '+mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine4_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine5_TXT__c!=null){
                        addStreet = addStreet+', '+mapOppUpdation.get(updateopp.Source_Unique_ID__c).AddressLine5_TXT__c;
                    }                
                    if(addStreet!=null){
                        updateopp.Street_TXT__c=addStreet;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).ApartmentNumber_NUM__c!=null){   
                        updateopp.AppartmentNumber_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).ApartmentNumber_NUM__c;
                    } 
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).City_TXT__c!=null){
                        updateopp.City_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).City_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).State_TXT__c!=null){
                        updateopp.State_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).State_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Country_TXT__c!=null){
                        updateopp.Country_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Country_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).ZipCode_TXT__c!=null){
                        updateopp.ZipCode_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).ZipCode_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Email_TXT__c!=null){
                        String strEmail = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Email_TXT__c;
                        Boolean bValidateEmail = Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', strEmail.trim());
                        if(bValidateEmail){
                            updateopp.Email__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Email_TXT__c;
                        }
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Phone_TXT__c!=null){
                        updateopp.Phone__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Phone_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Mobile_TXT__c!=null){
                        updateopp.MobilePhone__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Mobile_TXT__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).ContactMethod_TXT__c!=null){ 
                        updateopp.ContactMethod_TXT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).ContactMethod_TXT__c; 
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Description_DESC__c!=null){ 
                        updateopp.Description = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Description_DESC__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderDetails_TXT__c!=null){ 
                        updateopp.ProviderDetail_TXT__c= mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderDetails_TXT__c;
                        string providename =  mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderDetails_TXT__c;
                        if(providename.contains(':')){
                            String[] pdn1 = providename.split(':');
                            if(pdn1[0]!=null && Providermap.containsKey((pdn1[0]).toLowerCase())){
                                updateopp.LeadProvider_ID__c = Providermap.get((pdn1[0]).toLowerCase());
                            }
                            if(pdn1[1]!=null){
                                updateopp.LeadsourceOther_TXT__c = pdn1[1];
                            }
                        }
                        else if(Providermap.containsKey((mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderDetails_TXT__c).toLowerCase())){
                            updateopp.LeadProvider_ID__c = Providermap.get((mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderDetails_TXT__c).toLowerCase());
                        }                    
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderContactDetails_TXT__c!=null){ 
                        updateopp.ProviderContactDetail_TXT__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).ProviderContactDetails_TXT__c).unescapeXml();
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).OtherLeadProvider_TXT__c!=null){ 
                        updateopp.OtherLeadProvider_TXT__c = (mapOppUpdation.get(updateopp.Source_Unique_ID__c).OtherLeadProvider_TXT__c).unescapeXml();
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Lead_Provider_Name__c!=null && mapOppUpdation.get(updateopp.Source_Unique_ID__c).Lead_Provider_Name__c!=''){
                        if(Providermap.get((mapOppUpdation.get(updateopp.Source_Unique_ID__c).Lead_Provider_Name__c).toLowerCase())!=null)
                        updateopp.LeadProvider_ID__c = Providermap.get((mapOppUpdation.get(updateopp.Source_Unique_ID__c).Lead_Provider_Name__c).toLowerCase());
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Provider_Tool__c!=null){
                        updateopp.Provider_Tool_Name__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Provider_Tool__c;
                    }
                   if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Location__c!=null){
                        updateopp.Appointment_Location__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Location__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Notes__c!=null){
                        updateopp.Appointment_Notes__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Notes__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Contact_person__c!=null){
                        updateopp.Contact_person__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Contact_person__c;
                    } 
                   /* if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Salesforce_Order_Number__c!=null){
                        updateopp.Deposit_Sales_Order_Number__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Salesforce_Order_Number__c;
                    }*/
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).DEPOSIT_AMOUNT__c!=null){
                        updateopp.DEPOSIT_AMOUNT__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).DEPOSIT_AMOUNT__c;
                    }
                   if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Deal_ID__c!=null){
                        updateopp.Deal_ID__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Deal_ID__c;
                    }
                    if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Deal_Link__c!=null){
                        updateopp.Deal_Link__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Deal_Link__c;
                    }
                     if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Date_and_Time__c!=null){
                        updateopp.Appointment_Date_and_Time__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Date_and_Time__c;
                    }
					if(mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Id__c!=null){
                        updateopp.Appointment_Id__c = mapOppUpdation.get(updateopp.Source_Unique_ID__c).Appointment_Id__c;
                    }
                    
                    updateopp.DSP_Update_Count__c = updateopp.DSP_Update_Count__c + 1;
                    
                    if(updateopp.DSP_Update_Count__c != 0 ){
                        updateopp.Is_This_Lead_Update__c = true;
                    }
                    
                    updateoppsList.add(updateopp);               
                }
            }
            if(updateoppsList.size() > 0){
                Database.SaveResult[] results = Database.update(updateoppsList, false);
                List<Logs__c> loglist = new List<Logs__c>();
                for (Integer i = 0; i < updateoppsList.size(); i++) {
                    Database.SaveResult s = results[i];
                    if (!s.isSuccess()) {
                        for(Database.Error error : results[i].getErrors()){
                                Logs__c l =new Logs__c (SF_Rec_Id__c=updateoppsList[i].id, name='DSP Lead Update Handler Class' ,Trigger_or_Class_Name__c='DSPLeadUpdateHandler', Error_Message__c =error.getMessage());
                                loglist.add(l);
                        }
                    }
                }
                if(loglist.size()>0){
                    insert loglist;
                }
            }
            
            
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
                                                               AND Dealer_Subdivision__r.SubDiv_TXT__c IN : SubDivSet]){
                                                               
                dealerpatiLeist.put(endpointdetails.DealerAccount_ID__c +''+endpointdetails.Dealer_Subdivision__r.SubDiv_TXT__c , endpointdetails);                                              
            }
            for(Opportunity opp : updateOpportunity){
                
                 if(Opp.Source_Unique_ID__c != null &&(dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__c != null && dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).CRM_System__r.Receive_Lead_Updates__c)||
                    (dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).DealerAccount_ID__c != null && dealerpatiLeist.get(opp.PreferredDealerAccount_TXT__c +''+opp.SubDiv_TXT__c).DealerAccount_ID__r.Receive_Dealer_Updates__c )){    
                        sendupdatestodealer.add(opp);
                     }  
                
            }
            if(sendupdatestodealer.size()>0){   
            HELMSLeadDealerAssignmentADFHandler routing = new HELMSLeadDealerAssignmentADFHandler();
            routing.newLeadDispositionADFs(sendupdatestodealer);
            }
        }
        Catch(Exception ex){
            Logs__c  l =new Logs__c (PE_Reply_Id__c=newDSPOpportunityUpdates[0].ReplayId, name='Opportuntiy routing update failures',Type__c='Opportunity update failures',Trigger_or_Class_Name__c='DSPLeadUpdateHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            system.debug('error report :::::'+l);
            insert l;
        }    
    }
}