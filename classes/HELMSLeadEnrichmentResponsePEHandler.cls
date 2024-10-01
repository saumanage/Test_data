/**** Trigger Handler Name:HELMSLeadEnrichmentResponsePEHandler
User story Number : LMS-1733
SFDC will subscribe to a platform event queue to update Lead data. 
****/
public class HELMSLeadEnrichmentResponsePEHandler {
    public static void UpdateLeads(List<Lead_Enrichment_Response__e> newLeadEnrichmentRes){
        
        try{
            System.debug('PE Response : '+newLeadEnrichmentRes);
            Set<String> leadIdsSet = new Set<String>();
            Map<String, Lead_Enrichment_Response__e> leadEnMap = new Map<String, Lead_Enrichment_Response__e>();
            List<Lead_Enrichment_Response_PE__c> updateCustomObject = new List<Lead_Enrichment_Response_PE__c>();
            List<Logs__c> lst2 = new List<Logs__c>();
            //Looping through the Subscribed values and adding to the Map with the Key as Encrypted Id Value
            for(Lead_Enrichment_Response__e leadEnriRes : newLeadEnrichmentRes){
                System.debug('Set :' + leadIdsSet);
                if(leadEnriRes.Lead_SF_ID__c != null){
                	leadIdsSet.add(leadEnriRes.Lead_SF_ID__c);
                	leadEnMap.put(leadEnriRes.Lead_SF_ID__c, leadEnriRes);
                }
                System.debug('Set : ' + leadIdsSet);
            }
            //System.debug('leadEnMap : '+leadEnMap);
            List<Lead> updateLeads = new List<Lead>();
            if(leadIdsSet.size()>0){
                //Searching existing Lead with the same Lead SF Id that received in the Platform Event and update the Leads
                String enrichmentSql = 'select id, IsConverted, Is_Enrichment_Update__c, City, state, SalesRelatedDealerNumber__c,ServiceRelatedDealerNumber__c,ValidMobile_FLG__c,AcuraCurrentProductsOwned_TXT__c,';
                enrichmentSql += 'AcuraCurrentProductsOwned2_TXT__c,AcuraHighValueTrimlinePropensity_NUM__c,AcuraOwnershipStatus_TXT__c, ';
                enrichmentSql += 'AcuraOwnershipStatusHousehold_TXT__c,Address_Error_CD__c,Address_Error_Description_TXT__c, ';
                enrichmentSql += 'Address_Status_TXT__c,CleansedAddress_TXT__c,DateofLastService_DT__c,Email_CheckedDate_TXT__c, ';
                enrichmentSql += 'Email_Error_CD__c,Home_Phone_Error_CD__c,Home_Phone_Error_Description_TXT__c,  ';
                enrichmentSql += 'HondaCurrentProductsOwned_TXT__c,HondaCurrentProductsOwned2_TXT__c,HondaHighValueTrimlinePropensity_NUM__c, ';
                enrichmentSql += 'HondaOwnershipStatus_TXT__c,HondaOwnershipStatusHousehold_TXT__c,Location_Description_TXT__c,'; 
                enrichmentSql += 'Location_Error_CD__c,Location_Error_Description_TXT__c,Location_Status_TXT__c, ';
                enrichmentSql += 'Model_Error_CD__c,Model_Error_Description_TXT__c,Model_IMG__c, Model_Name_NM__c, ';
                enrichmentSql += 'PECurrentProductsOwned_TXT__c,PEOwnershipStatus_TXT__c,PEOwnershipStatusHousehold_TXT__c, ';
                enrichmentSql += 'PreferredDealerNumber_NUM__c,PSPCurrentProductsOwned_TXT__c,PSPCurrentProductsOwned2_TXT__c, ';
                enrichmentSql += 'PSPOwnershipStatus_TXT__c,PSPOwnershipStatusHousehold_TXT__c,';
                enrichmentSql += 'SFMC_Sales_status__c,SFMC_Sales_description__c,SFMC_Sales_errorcode__c,SFMC_Sales_errordescription__c,SFMC_Service_status__c,SFMC_Service_description__c,SFMC_Service_errorcode__c,SFMC_Service_errordescription__c,'; 
                enrichmentSql += 'ValidAddress_FLG__c,ValidEmail_FLG__c,Valid_Model_ID_FLG__c,Cell_Phone_Error_Description_TXT__c, ';
                enrichmentSql += 'ValidPhoneNum_FLG__c,YourDealershipServicesAmountSpentLast60M__c,Cell_Phone_Error_CD__c,';
                enrichmentSql += 'Email_Error_Description_TXT__c,YourDealershipServicesLast60Months_NUM__c,Lead_SF_ID__c from lead where Lead_SF_ID__c IN:'+leadIdsSet+' AND IsConverted = false';
                //System.debug('SOQL IS : '+enrichmentSql);
                for(Lead led: [select id, IsConverted, Is_Enrichment_Update__c, City, state, SalesRelatedDealerNumber__c,ServiceRelatedDealerNumber__c,ValidMobile_FLG__c,AcuraCurrentProductsOwned_TXT__c,
                               AcuraCurrentProductsOwned2_TXT__c,AcuraHighValueTrimlinePropensity_NUM__c,AcuraOwnershipStatus_TXT__c, 
                               AcuraOwnershipStatusHousehold_TXT__c,Address_Error_CD__c,Address_Error_Description_TXT__c, 
                               Address_Status_TXT__c,CleansedAddress_TXT__c,DateofLastService_DT__c,Email_CheckedDate_TXT__c, 
                               Email_Error_CD__c,Home_Phone_Error_CD__c,Home_Phone_Error_Description_TXT__c, 
                               HondaCurrentProductsOwned_TXT__c,HondaCurrentProductsOwned2_TXT__c,HondaHighValueTrimlinePropensity_NUM__c, 
                               HondaOwnershipStatus_TXT__c,HondaOwnershipStatusHousehold_TXT__c,Location_Description_TXT__c, 
                               Location_Error_CD__c,Location_Error_Description_TXT__c,Location_Status_TXT__c, 
                               Model_Error_CD__c,Model_Error_Description_TXT__c,Model_IMG__c, Model_Name_NM__c, 
                               PECurrentProductsOwned_TXT__c,PEOwnershipStatus_TXT__c,PEOwnershipStatusHousehold_TXT__c, 
                               PreferredDealerNumber_NUM__c,PSPCurrentProductsOwned_TXT__c,PSPCurrentProductsOwned2_TXT__c, 
                               PSPOwnershipStatus_TXT__c,PSPOwnershipStatusHousehold_TXT__c,
                               SFMC_Sales_status__c,SFMC_Sales_description__c,SFMC_Sales_errorcode__c,SFMC_Sales_errordescription__c,SFMC_Service_status__c,SFMC_Service_description__c,SFMC_Service_errorcode__c,SFMC_Service_errordescription__c, 
                               ValidAddress_FLG__c,ValidEmail_FLG__c,Valid_Model_ID_FLG__c,Cell_Phone_Error_Description_TXT__c, 
                               ValidPhoneNum_FLG__c,YourDealershipServicesAmountSpentLast60M__c,Cell_Phone_Error_CD__c,
                               Email_Error_Description_TXT__c,YourDealershipServicesLast60Months_NUM__c,Lead_SF_ID__c from lead where Lead_SF_ID__c IN:leadIdsSet AND IsConverted = false ]){
                    //Assigning the Lead values from the Map
             /*     if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_status_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_status_TXT__c != ''){
                        led.SFMC_status_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_status_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_description_TXT__c != ''){
                        led.SFMC_description_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_description_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_errorcode_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_errorcode_TXT__c != ''){
                        led.SFMC_errorcode_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_errorcode_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_errordescription_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_errordescription_TXT__c != ''){
                        led.SFMC_errordescription_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_errordescription_TXT__c;
                    }  */
             //    Modified By  Vamshi                    
                    //System.debug('Lead SF ID : '+led.Lead_SF_ID__c);                   
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_status__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_status__c != ''){
                        led.SFMC_Sales_status__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_status__c;
                  }   
                   if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_description__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_description__c != ''){
                        led.SFMC_Sales_description__c   =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_description__c;
                    } 
                     if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errorcode__c  != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errorcode__c  != ''){
                        led.SFMC_Sales_errorcode__c    =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errorcode__c ;
                    }else{
                        led.SFMC_Sales_errorcode__c    = '' ;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errordescription__c  != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errordescription__c  != ''){
                        led.SFMC_Sales_errordescription__c    =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Sales_errordescription__c ;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_status__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_status__c != ''){
                        led.SFMC_Service_status__c =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_status__c;
                    } 
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_description__c != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_description__c != ''){
                        led.SFMC_Service_description__c =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_description__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errordescription__c  != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errordescription__c != ''){
                        led.SFMC_Service_errordescription__c  =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errordescription__c ;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errorcode__c  != null && leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errorcode__c != ''){
                        led.SFMC_Service_errorcode__c  =  leadEnMap.get(led.Lead_SF_ID__c).SFMC_Service_errorcode__c ;
                    }else{
                        led.SFMC_Service_errorcode__c  = '' ;
                    } 
            // Modified above code Vamshi.                       
                    /*if(leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatus_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatus_TXT__c != ''){
                        led.PSPOwnershipStatus_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatus_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned_TXT__c != ''){
                        led.PSPCurrentProductsOwned_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned2_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned2_TXT__c != ''){
                        led.PSPCurrentProductsOwned2_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PSPCurrentProductsOwned2_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatus_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatus_TXT__c != ''){
                        led.PEOwnershipStatus_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatus_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).PECurrentProductsOwned_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PECurrentProductsOwned_TXT__c != ''){
                        led.PECurrentProductsOwned_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).PECurrentProductsOwned_TXT__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatus_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatus_TXT__c != ''){
                        led.HondaOwnershipStatus_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatus_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned_TXT__c != ''){
                        led.HondaCurrentProductsOwned_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned_TXT__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned2_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned2_TXT__c != ''){
                        led.HondaCurrentProductsOwned2_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).HondaCurrentProductsOwned2_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatus_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatus_TXT__c != ''){
                        led.AcuraOwnershipStatus_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatus_TXT__c;
                    }
                    if(leadEnMap!=null && leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned_TXT__c != ''){
                        //led.AcuraCurrentProductsOwned_TXT__c =  '1';
                        led.AcuraCurrentProductsOwned_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned_TXT__c;
                    }               
                    if(leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned2_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned2_TXT__c != ''){
                      led.AcuraCurrentProductsOwned2_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).AcuraCurrentProductsOwned2_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).HondaHighValueTrimlinePropensity_NUM__c != null){
                        led.HondaHighValueTrimlinePropensity_NUM__c   =  leadEnMap.get(led.Lead_SF_ID__c).HondaHighValueTrimlinePropensity_NUM__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).AcuraHighValueTrimlinePropensity_NUM__c != null){
                      led.AcuraHighValueTrimlinePropensity_NUM__c =  leadEnMap.get(led.Lead_SF_ID__c).AcuraHighValueTrimlinePropensity_NUM__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatusHousehold_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatusHousehold_TXT__c != ''){
                        led.HondaOwnershipStatusHousehold_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).HondaOwnershipStatusHousehold_TXT__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatusHousehold_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatusHousehold_TXT__c != ''){
                        led.AcuraOwnershipStatusHousehold_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).AcuraOwnershipStatusHousehold_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatusHousehold_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatusHousehold_TXT__c != ''){
                        led.PSPOwnershipStatusHousehold_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PSPOwnershipStatusHousehold_TXT__c;
                    } 
                    if(leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatusHousehold_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatusHousehold_TXT__c != ''){
                        led.PEOwnershipStatusHousehold_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).PEOwnershipStatusHousehold_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).YourDealershipSvsSpentLast60Mth_NUM__c != null){
                        led.YourDealershipServicesLast60Months_NUM__c =  leadEnMap.get(led.Lead_SF_ID__c).YourDealershipSvsSpentLast60Mth_NUM__c;
                    }  
                    if(leadEnMap.get(led.Lead_SF_ID__c).YourDealershipServicesLast60Mths_NUM__c != null){
                        led.YourDealershipServicesAmountSpentLast60M__c   =  leadEnMap.get(led.Lead_SF_ID__c).YourDealershipServicesLast60Mths_NUM__c;
                    }*/
                    
                    if(leadEnMap.get(led.Lead_SF_ID__c).DateofLastService_DT__c != null){
                        string purchaseLastDateTemp=String.valueOf(leadEnMap.get(led.Lead_SF_ID__c).DateofLastService_DT__c);
                        String[] purchaseLastDateOnlyTemp = purchaseLastDateTemp.split('T');
                        Date DateofLastServiceVal = date.valueOf(purchaseLastDateOnlyTemp[0]);
                        if(DateofLastServiceVal != Date.valueOf('9999-12-31 00:00:00')){
                            led.DateofLastService_DT__c   =  DateofLastServiceVal;
                        }
                        
                    }   
                    
                    //Updating City and State 
                    //// && (led.City == '' || led.City == null)
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_City__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_City__c != ''){
                        led.City   =  leadEnMap.get(led.Lead_SF_ID__c).Location_City__c;
                    }
                    // && (led.state == '' || led.state == null)
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_State__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_State__c != ''){
                        led.state   =  leadEnMap.get(led.Lead_SF_ID__c).Location_State__c;
                    }
                    //Updating City and State
                        
                        
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_Status_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_Status_TXT__c != ''){
                        led.Location_Status_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).Location_Status_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_Description_TXT__c != ''){
                        led.Location_Description_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).Location_Description_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_Error_CD__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_Error_CD__c != ''){
                        led.Location_Error_CD__c =  leadEnMap.get(led.Lead_SF_ID__c).Location_Error_CD__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Location_Error_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Location_Error_Description_TXT__c != ''){
                        led.Location_Error_Description_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).Location_Error_Description_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Email_Error_CD__c != null && leadEnMap.get(led.Lead_SF_ID__c).Email_Error_CD__c != ''){
                        led.Email_Error_CD__c   =  leadEnMap.get(led.Lead_SF_ID__c).Email_Error_CD__c;
                        if(led.Email_Error_CD__c == '401'){               
            			Logs__c  l2 =new Logs__c (name='Melisa 401 Authentication Error for Email',type__c='Lead enrichment call failures',Trigger_or_Class_Name__c='HELMSLeadEnrichmentResponsePEHandler', Error_Message__c ='Email Authentication Error');
						lst2.add(l2);
                    }
                    }

                    if(leadEnMap.get(led.Lead_SF_ID__c).Email_Error_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Email_Error_Description_TXT__c != ''){
                      led.Email_Error_Description_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).Email_Error_Description_TXT__c;          
                    }
                    //Logs__c  l98 =new Logs__c (name='Enrichment Response :Valid Phone 3 '+leadEnMap.get(led.Lead_SF_ID__c).ValidPhoneNum_FLG__c,Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c ='', Error_Line_Number__c =0 );
                    //insert l98;
                    //Logs__c  l99 =new Logs__c (name='Enrichment Response :Valid Mobile 3 '+leadEnMap.get(led.Lead_SF_ID__c).ValidCellPhone_FLG__c,Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c ='', Error_Line_Number__c =0 );
                    //insert l99;    
                                   
                    if(leadEnMap.get(led.Lead_SF_ID__c).ValidPhoneNum_FLG__c){
                        led.ValidPhoneNum_FLG__c =  leadEnMap.get(led.Lead_SF_ID__c).ValidPhoneNum_FLG__c;
                        //Logs__c  l93 =new Logs__c (name='Enrichment Response :Valid Phone 18 ',Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c ='', Error_Line_Number__c =0 );
                        //insert l93;
                    }              
                    if(leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_CD__c != null && leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_CD__c != ''){
                        led.Home_Phone_Error_CD__c   =  leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_CD__c;                       
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_Description_TXT__c != ''){
                        led.Home_Phone_Error_Description_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).Home_Phone_Error_Description_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).ValidCellPhone_FLG__c){
                        led.ValidMobile_FLG__c   =  leadEnMap.get(led.Lead_SF_ID__c).ValidCellPhone_FLG__c;
                        //Logs__c  l94 =new Logs__c (name='Enrichment Response :Valid Mobile 28 ',Trigger_or_Class_Name__c='HELMSleadEnrichmentIntegrationupdate', Error_Message__c ='', Error_Line_Number__c =0 );
                        //insert l94;
                    } 
                                   
                    
                    if(leadEnMap.get(led.Lead_SF_ID__c).Cell_Phone_Error_CD__c != null){
                        led.Cell_Phone_Error_CD__c   =  leadEnMap.get(led.Lead_SF_ID__c).Cell_Phone_Error_CD__c;
						if(led.Cell_Phone_Error_CD__c == '401'){               
            			Logs__c  l1 =new Logs__c (name='Melisa 401 Authentication Error for Phone',type__c='Lead enrichment call failures',Trigger_or_Class_Name__c='HELMSLeadEnrichmentResponsePEHandler', Error_Message__c ='Home Phone Authentication Error');
						lst2.add(l1);
                    } 
                    }
                 
                    if(leadEnMap.get(led.Lead_SF_ID__c).Cell_Phone_Error_Description_TXT__c != null){
                        led.Cell_Phone_Error_Description_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).Cell_Phone_Error_Description_TXT__c;
                    } 
                    if(leadEnMap.get(led.Lead_SF_ID__c).Valid_Model_ID_FLG__c != null){
                        led.Valid_Model_ID_FLG__c   =  leadEnMap.get(led.Lead_SF_ID__c).Valid_Model_ID_FLG__c;
                    }  
                    if(leadEnMap.get(led.Lead_SF_ID__c).Model_Error_CD__c != null && leadEnMap.get(led.Lead_SF_ID__c).Model_Error_CD__c != ''){
                        led.Model_Error_CD__c =  leadEnMap.get(led.Lead_SF_ID__c).Model_Error_CD__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Model_Error_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Model_Error_Description_TXT__c != ''){
                        led.Model_Error_Description_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).Model_Error_Description_TXT__c;  
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Model_IMG__c != null && leadEnMap.get(led.Lead_SF_ID__c).Model_IMG__c != ''){
                        led.Model_IMG__c =  leadEnMap.get(led.Lead_SF_ID__c).Model_IMG__c;    
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Model_Name_NM__c != null && leadEnMap.get(led.Lead_SF_ID__c).Model_Name_NM__c != ''){
                        led.Model_Name_NM__c =  leadEnMap.get(led.Lead_SF_ID__c).Model_Name_NM__c;  
                    } 
                    if(leadEnMap.get(led.Lead_SF_ID__c).ValidAddress_FLG__c != null){
                        led.ValidAddress_FLG__c   =  leadEnMap.get(led.Lead_SF_ID__c).ValidAddress_FLG__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Address_Error_CD__c != null && leadEnMap.get(led.Lead_SF_ID__c).Address_Error_CD__c != ''){
                        led.Address_Error_CD__c =  leadEnMap.get(led.Lead_SF_ID__c).Address_Error_CD__c;
                        if(led.Address_Error_CD__c == '401'){               
            			Logs__c  l3 =new Logs__c (name='Melisa 401 Authentication Error for Address',type__c='Lead enrichment call failures',Trigger_or_Class_Name__c='HELMSLeadEnrichmentResponsePEHandler', Error_Message__c ='Address Authentication Error');
						lst2.add(l3);
						}
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Address_Error_Description_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Address_Error_Description_TXT__c != ''){
                    led.Address_Error_Description_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).Address_Error_Description_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).Address_Status_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Address_Status_TXT__c != ''){
                        led.Address_Status_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).Address_Status_TXT__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).CleansedAddress_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).CleansedAddress_TXT__c != ''){
                        led.CleansedAddress_TXT__c   =  leadEnMap.get(led.Lead_SF_ID__c).CleansedAddress_TXT__c;
                    }               
                    if(leadEnMap.get(led.Lead_SF_ID__c).Email_CheckedDate_TXT__c != null && leadEnMap.get(led.Lead_SF_ID__c).Email_CheckedDate_TXT__c != ''){
                        led.Email_CheckedDate_TXT__c =  leadEnMap.get(led.Lead_SF_ID__c).Email_CheckedDate_TXT__c;
                    }
                                   
                    /* For replacing 0000 from Preferred Dealer Number -Added by Syam Mohan */
                    String preferred_dealerstr_temp =led.PreferredDealerNumber_NUM__c;
                    if(led.PreferredDealerNumber_NUM__c != null && led.PreferredDealerNumber_NUM__c != ''){
                		preferred_dealerstr_temp= preferred_dealerstr_temp.replace('0', '');                       
                    }
                    /* For replacing 0000 from Preferred Dealer Number -Added by Syam Mohan */               
                    if(led.PreferredDealerNumber_NUM__c == null || preferred_dealerstr_temp == '' ||  preferred_dealerstr_temp == null ){
                        if(leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c != null && leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c != ''){
                            led.PreferredDealerNumber_NUM__c   =  leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c;
                            led.Dealer_Assignment_Type__c = 'Sales';
                        }
                        else if(leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c != null && leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c != ''){
                            led.PreferredDealerNumber_NUM__c   =  leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c;
                            led.Dealer_Assignment_Type__c = 'Service';
                        }else{
                            led.PreferredDealerNumber_NUM__c   =  leadEnMap.get(led.Lead_SF_ID__c).PreferredDealerNumber_NUM__c;
                            led.Dealer_Assignment_Type__c = 'Proximity';
                        }
                    } 
                    if(leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c != null && leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c != ''){
                        led.SalesRelatedDealerNumber__c   =  leadEnMap.get(led.Lead_SF_ID__c).SalesRelatedDealerNumber__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c != null && leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c != ''){
                        led.ServiceRelatedDealerNumber__c   =  leadEnMap.get(led.Lead_SF_ID__c).ServiceRelatedDealerNumber__c;
                    }
                    if(leadEnMap.get(led.Lead_SF_ID__c).ValidEmail_FLG__c != null){
                        led.ValidEmail_FLG__c   =  leadEnMap.get(led.Lead_SF_ID__c).ValidEmail_FLG__c;
                     }
                    led.Enrichment_Receive_Date_Time__c=system.now();               
                    led.Is_Enrichment_Update__c = true;
                    //Add those Leads to the List 
                    updateLeads.add(led);
                                   
                                   
                     
                                   
                    if(updateLeads.size()>0){
                        //update updateLeads;
                        Database.SaveResult[] results = Database.update(updateLeads,false);
                        //System.debug('results : '+results);
                        List<Lead> errorLeads = new List<Lead>();
                        List<Lead> enrichedLeadList = new List<Lead>();
                        for (Integer i = 0; i < updateLeads.size(); i++) {
                            Database.SaveResult s = results[i];
                            Lead origRecord = updateLeads[i];
                            if (!s.isSuccess()) {
                                errorLeads.add(origRecord);
                            }else{
                                // Adding for Multiple Lead Provider Value. When Lead is created without choosing the 
                                // Preferred Dealer Account, this value will be null. So, we are updating once LeadEnrichment
                                // is completed.
                               
                               enrichedLeadList.add(updateLeads[i]); 
                            }
                        }
                        if(enrichedLeadList.size() > 0){                            
                            //LeadTriggerHandler ldhandler = new LeadTriggerHandler();
                            //LeadTriggerHandler.isUpdatedMultiLeadProvider = true;
                            //ldhandler.updateMultipleProvider(enrichedLeadList);
                        }
                        if(errorLeads.size() > 0 ){
                            HELMSLeadEnrichmentResponsePEHandler.updateCustomObject(errorLeads);
                        }
                    }
                }
            }
         database.insert(lst2);
         }Catch(Exception ex){
                        
            Logs__c  l =new Logs__c (name='Lead Enrichment Response PE- Trigger Handler',Trigger_or_Class_Name__c='HELMSLeadEnrichmentResponsePEHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }   
           
    }
    
    public static void updateCustomObject(List<Lead> leads){
        try{
            Lead_Enrichment_Response_PE__c newRec = new Lead_Enrichment_Response_PE__c();
            for(Lead ld : leads){
                newRec.AcuraCurrentProductsOwned_TXT__c = ld.AcuraCurrentProductsOwned_TXT__c;
                newRec.AcuraCurrentProductsOwned2_TXT__c = ld.AcuraCurrentProductsOwned2_TXT__c;
                newRec.AcuraHighValueTrimlinePropensity_NUM__c = ld.AcuraHighValueTrimlinePropensity_NUM__c;
                newRec.AcuraOwnershipStatus_TXT__c = ld.AcuraOwnershipStatus_TXT__c;
                newRec.AcuraOwnershipStatusHousehold_TXT__c = ld.AcuraOwnershipStatusHousehold_TXT__c;
                newRec.Address_Error_CD__c = ld.Address_Error_CD__c;
                newRec.Address_Error_Description_TXT__c = ld.Address_Error_Description_TXT__c;
                newRec.Address_Status_TXT__c = ld.Address_Status_TXT__c;
                newRec.Cell_Phone_Error_CD__c = ld.Cell_Phone_Error_CD__c;
                newRec.Cell_Phone_Error_Description_TXT__c = ld.Cell_Phone_Error_Description_TXT__c;
                newRec.CleansedAddress_TXT__c = ld.CleansedAddress_TXT__c;
                newRec.Email_CheckedDate_TXT__c = ld.Email_CheckedDate_TXT__c;
                newRec.Email_Error_CD__c = ld.Email_Error_CD__c;
                newRec.Email_Error_Description_TXT__c = ld.Email_Error_Description_TXT__c;
                newRec.Home_Phone_Error_CD__c = ld.Home_Phone_Error_CD__c;
                newRec.Home_Phone_Error_Description_TXT__c = ld.Home_Phone_Error_Description_TXT__c;
                newRec.HondaCurrentProductsOwned_TXT__c = ld.HondaCurrentProductsOwned_TXT__c;
                newRec.HondaCurrentProductsOwned2_TXT__c = ld.HondaCurrentProductsOwned2_TXT__c;
                newRec.HondaHighValueTrimlinePropensity_NUM__c = ld.HondaHighValueTrimlinePropensity_NUM__c;
                newRec.HondaOwnershipStatus_TXT__c = ld.HondaOwnershipStatus_TXT__c;
                newRec.HondaOwnershipStatusHousehold_TXT__c = ld.HondaOwnershipStatusHousehold_TXT__c;
                newRec.Lead_SF_ID__c = ld.Lead_SF_ID__c;
                newRec.Location_Description_TXT__c = ld.Location_Description_TXT__c;
                newRec.Location_Error_CD__c = ld.Location_Error_CD__c;
                newRec.Location_Error_Description_TXT__c = ld.Location_Error_Description_TXT__c;
                newRec.Location_Status_TXT__c = ld.Location_Status_TXT__c;
                newRec.Model_Error_CD__c = ld.Model_Error_CD__c;
                newRec.Model_Error_Description_TXT__c = ld.Model_Error_Description_TXT__c;
                newRec.Model_IMG__c = ld.Model_IMG__c;
                newRec.Model_Name_NM__c = ld.Model_Name_NM__c;
                newRec.PECurrentProductsOwned_TXT__c = ld.PECurrentProductsOwned_TXT__c;
                newRec.PEOwnershipStatus_TXT__c = ld.PEOwnershipStatus_TXT__c;
                newRec.PEOwnershipStatusHousehold_TXT__c = ld.PEOwnershipStatusHousehold_TXT__c;
                newRec.PreferredDealerNumber_NUM__c = ld.PreferredDealerNumber_NUM__c;
                newRec.PSPCurrentProductsOwned_TXT__c = ld.PSPCurrentProductsOwned_TXT__c;
                newRec.PSPCurrentProductsOwned2_TXT__c =ld.PSPCurrentProductsOwned2_TXT__c;
                newRec.PSPOwnershipStatus_TXT__c = ld.PSPOwnershipStatus_TXT__c;
                newRec.PSPOwnershipStatusHousehold_TXT__c = ld.PSPOwnershipStatusHousehold_TXT__c;
                newRec.SalesRelatedDealerNumber__c = ld.SalesRelatedDealerNumber__c;
                newRec.ServiceRelatedDealerNumber__c = ld.ServiceRelatedDealerNumber__c;
           //     newRec.SFMC_description_TXT__c = ld.SFMC_description_TXT__c;
          //      newRec.SFMC_errorcode_TXT__c = ld.SFMC_errorcode_TXT__c;
         //       newRec.SFMC_errordescription_TXT__c = ld.SFMC_errordescription_TXT__c;
          //      newRec.SFMC_status_TXT__c = ld.SFMC_status_TXT__c;
                newRec.SFMC_Sales_status__c  = ld.SFMC_Sales_status__c ;
                newRec.SFMC_Sales_description__c = ld.SFMC_Sales_description__c;
                newRec.SFMC_Sales_errorcode__c = ld.SFMC_Sales_errorcode__c;
                newRec.SFMC_Sales_errordescription__c = ld.SFMC_Sales_errordescription__c;
                newRec.SFMC_Service_status__c = ld.SFMC_Service_status__c;
                newRec.SFMC_Service_description__c = ld.SFMC_Service_description__c;
                newRec.SFMC_Service_errorcode__c = ld.SFMC_Service_errorcode__c;
                newRec.SFMC_Service_errordescription__c = ld.SFMC_Service_errordescription__c;
                newRec.ValidAddress_FLG__c = ld.ValidAddress_FLG__c;
                newRec.ValidCellPhone_FLG__c = ld.ValidMobile_FLG__c;
                newRec.ValidEmail_FLG__c = ld.ValidEmail_FLG__c;
                newRec.Valid_Model_ID_FLG__c = ld.Valid_Model_ID_FLG__c;
                newRec.ValidPhoneNum_FLG__c = ld.ValidPhoneNum_FLG__c;
                newRec.YourDealershipServicesLast60Mths_NUM__c = ld.YourDealershipServicesAmountSpentLast60M__c;
                newRec.YourDealershipSvsSpentLast60Mth_NUM__c = ld.YourDealershipServicesLast60Months_NUM__c;
                //newRec.Reply_id__c = ld.ReplayId;  
                //ReplayId
                
            }
            insert newRec;
        }Catch(Exception ex){                        
            Logs__c  l =new Logs__c (name='Lead Enrichment ResponsePE- Custom Object Creation',Trigger_or_Class_Name__c='Custom Object Creation', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }   
    }
}