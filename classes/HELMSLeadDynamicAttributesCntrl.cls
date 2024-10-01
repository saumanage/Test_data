//Getting Data in Lead Additional Info from Lead Object and storing in Lead Additional Object which is related to Lead Object
public class HELMSLeadDynamicAttributesCntrl { 
    
//Fetching Lead Records
    public static void createDynamicFields(List<Lead> leadObjLst){
        Try{
            Map<String,String> dynamicFieldsInfoMap =  new Map<String,String>();
            Map<String,String> leadDynamicFieldsMap =  new Map<String,String>();
            Set<String> leadDynSet =  new Set<String>();
            for(Lead leadData : leadObjLst){
                
                if(leadData.LeadAdditionalInfos__c != null && leadData.LeadAdditionalInfos__c.contains('LeadAdditionalInfos')){
                    //String strLeadAdditionalInfos = HELMSLeadDealerAssignmentADFHandler.removeSpecialXMLChars(leadData.LeadAdditionalInfos__c);
                    /* New Code */
                    String addInfo = leadData.LeadAdditionalInfos__c;
                    String comments = '';
                    if(addInfo.contains('<LeadAdditionalInfo key="VehicleComment">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="VehicleComment">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'VehicleComment',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="CustomerComment">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="CustomerComment">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'CustomerComment',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Models Selected">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Models Selected">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Models Selected',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="AdditionalInfo">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="AdditionalInfo">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'AdditionalInfo',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="visitNotes">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="visitNotes">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'visitNotes',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="originationUrl">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="originationUrl">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'originationUrl',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="transcript">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="transcript">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'transcript',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="DepositConfirmationNumber">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="DepositConfirmationNumber">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'DepositConfirmationNumber',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="PriceComment">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="PriceComment">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'PriceComment',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Comment">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Comment">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Comment',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Customer Preferred Contact Method">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Customer Preferred Contact Method">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Customer Preferred Contact Method',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="UserComments">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="UserComments">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'UserComments',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="special_description">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="special_description">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'special_description',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="special_short_description">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="special_short_description">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'special_short_description',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Id">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Id">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Offer Id',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Name">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Name">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Offer Name',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Type">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Type">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'Offer Type',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="OfferName">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="OfferName">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'OfferName',comments);
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="end_date">')){
                            comments = addInfo.substringBetween('<LeadAdditionalInfo key="end_date">','</LeadAdditionalInfo>');
                        	dynamicFieldsInfoMap.put(leadData.Id+ '-'+'end_date ',comments);
                        }
                    /* New Code */
                    
                    
                    /*Dom.Document doc = new Dom.Document(); 
                    //doc.load(leadData.LeadAdditionalInfos__c);
                    doc.load(strLeadAdditionalInfos);
                    Dom.XMLNode rootElement = doc.getRootElement();
                    for(Dom.XMLNode childElement : rootElement.getChildElements()){
                        dynamicFieldsInfoMap.put(leadData.Id+ '-'+childElement.getAttributeValue('key', null),childElement.getText());
                    }*/
                    
                }
            }
            if(dynamicFieldsInfoMap.size() > 0){
                Set<String> leadDynFieldsSet = new Set<String>();
              //  List<Lead_Additional_Attribute_Definition__c> insertLeadDynFields = new List<Lead_Additional_Attribute_Definition__c>();
                List<Lead_Additional_Attribute__c> insertLeadAddtnlFields = new List<Lead_Additional_Attribute__c>();
                /*    
List<Lead_Additional_Attribute_Definition__c> leadDynamicFields = [SELECT Id,Name FROM Lead_Additional_Attribute_Definition__c LIMIT 50000 ];
for(Lead_Additional_Attribute_Definition__c leadDynamic : leadDynamicFields){
leadDynFieldsSet.add(leadDynamic.Name);
}
for(String fieldsDataStr : dynamicFieldsInfoMap.keyset()){
System.debug('===leadDynFieldsSet==='+leadDynFieldsSet);
System.debug('===fieldsDataStr==='+fieldsDataStr.substringAfter('-'));
if(!leadDynFieldsSet.contains(fieldsDataStr.substringAfter('-'))){
leadDynSet.add(fieldsDataStr.substringAfter('-'));

}
}
if(leadDynSet.size() > 0){
for(String str : leadDynSet){
insertLeadDynFields.add(new Lead_Additional_Attribute_Definition__c(Name = str));
}
if(insertLeadDynFields.size() > 0){
INSERT insertLeadDynFields;
}
}*/
                
                List<Lead_Additional_Attribute_Definition__c> leadDynList = [SELECT Id,Name FROM Lead_Additional_Attribute_Definition__c LIMIT 50000];
                for(Lead_Additional_Attribute_Definition__c dynFields : leadDynList){
                    leadDynamicFieldsMap.put(dynFields.Name ,dynFields.Id);
                }
                for(Lead leadData : leadObjLst){
                    //Integer sequenceNumber = 1;
                    for(String fieldsDataStr : dynamicFieldsInfoMap.keyset()){
                        if(fieldsDataStr.substringBefore('-') == leadData.Id && leadDynamicFieldsMap.containsKey(fieldsDataStr.substringAfter('-'))){
                            insertLeadAddtnlFields.add(new Lead_Additional_Attribute__c(Name = fieldsDataStr.substringAfter('-'),Definition_Name__c=leadDynamicFieldsMap.get(fieldsDataStr.substringAfter('-')),Attribute_Value__c	= dynamicFieldsInfoMap.get(leadData.Id+'-'+fieldsDataStr.substringAfter('-')),
                                                                                        Lead_Id__c = leadData.Id,Sequence_Number__c = 1));
                        }
                    }
                }
                if(insertLeadAddtnlFields.size() > 0){
                    INSERT insertLeadAddtnlFields;
                    }
            }
        }catch(Exception e){
            //System.debug('===='+e.getMessage());
        }
    }
//Getting Data in Opportunity Additional Info from Opportunity Object and storing in Opportunity Additional Object which is related to Lead Object   
    public static void createOpportunityAttributes(Set<Id> opptySetIds){
        Try{
            Map<Id,List<Opportunity_Additional_Attribute__c>> opptyToOpptyAttrMap = new Map<Id,List<Opportunity_Additional_Attribute__c>>();
            List<Opportunity> opptyList = [SELECT Id,Lead_ID__c FROM Opportunity WHERE ID IN: opptySetIds];
            List<Opportunity_Additional_Attribute__c> oppAddInfoList = new List<Opportunity_Additional_Attribute__c>();
            Map<String,String> leadToOppMap = new Map<String,String>();
            for(Opportunity opp : opptyList){
                leadToOppMap.put(opp.Lead_ID__c,opp.Id);
            }
            
            if(leadToOppMap.size() > 0){
                Map<Id,Opportunity_Additional_Attribute__c> opptyAttrMap = new Map<Id,Opportunity_Additional_Attribute__c>([SELECT id,Opportunity_Id__c,Name,Definition_Name__c,Sequence_Number__c,Attribute_Value__c FROM Opportunity_Additional_Attribute__c WHERE Opportunity_Id__c IN: opptySetIds]);
                if(opptyAttrMap.size() > 0){
                    for(Opportunity_Additional_Attribute__c oppAttr : opptyAttrMap.values()){
                        if(!opptyToOpptyAttrMap.containsKey(oppAttr.Opportunity_Id__c))
                            opptyToOpptyAttrMap.put(oppAttr.Opportunity_Id__c,new List<Opportunity_Additional_Attribute__c>());
                        opptyToOpptyAttrMap.get(oppAttr.Opportunity_Id__c).add(oppAttr);
                    }
                }
                List<Lead_Additional_Attribute__c> addInfoList = [SELECT id,Lead_Id__c,Name,Definition_Name__c,Sequence_Number__c,Attribute_Value__c FROM Lead_Additional_Attribute__c WHERE Lead_Id__c IN: leadToOppMap.keyset()];
                for(Lead_Additional_Attribute__c leadAddInfo : addInfoList){
                    Boolean OppAttrBool = false;
                    if(leadToOppMap.containsKey(leadAddInfo.Lead_Id__c)){
                        if(leadToOppMap.get(leadAddInfo.Lead_Id__c) != null && !opptyToOpptyAttrMap.containsKey(leadToOppMap.get(leadAddInfo.Lead_Id__c))){
                            if(opptyToOpptyAttrMap.containsKey(leadToOppMap.get(leadAddInfo.Lead_Id__c)) != null && opptyToOpptyAttrMap.get(leadToOppMap.get(leadAddInfo.Lead_Id__c)) != null && opptyToOpptyAttrMap.get(leadToOppMap.get(leadAddInfo.Lead_Id__c)).size() > 0){
                                for(Opportunity_Additional_Attribute__c opptyAttr : opptyToOpptyAttrMap.get(leadToOppMap.get(leadAddInfo.Lead_Id__c))){
                                    if(opptyAttr.Definition_Name__c == leadAddInfo.Definition_Name__c){
                                        OppAttrBool = true;
                                        break;
                                    }
                                }
                            }
                            Opportunity_Additional_Attribute__c oppAttribute = new Opportunity_Additional_Attribute__c();
                            oppAttribute.Name = leadAddInfo.Name;
                            oppAttribute.Definition_Name__c = leadAddInfo.Definition_Name__c;
                            oppAttribute.Sequence_Number__c = leadAddInfo.Sequence_Number__c;
                            oppAttribute.Attribute_Value__c = leadAddInfo.Attribute_Value__c;
                            oppAttribute.Opportunity_Id__c  = leadToOppMap.get(leadAddInfo.Lead_Id__c); 
                            if(!OppAttrBool){
                                oppAddInfoList.add(oppAttribute);
                                }
                        }
                    }
                }
            }
            //System.debug('==olist==oppAddInfoList='+oppAddInfoList);
            //System.debug('==olist==size='+oppAddInfoList.size());
            if(oppAddInfoList.size() > 0){
                INSERT oppAddInfoList;
                }
        }catch(Exception e){
            //System.debug('===='+e.getMessage());
        }
    }
}