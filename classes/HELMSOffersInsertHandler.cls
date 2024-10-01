/**** Trigger Name:HELMSOffersInsertHandler
User story Number : LMS-1950
Show Customer Selected Offers to Dealers in Partner Community. 
****/

public with sharing class HELMSOffersInsertHandler {
    public static void handleOffersInsert(List<Opportunity> opty) {
        try{
            List<Offers__c> listOffers = new List<Offers__c>();
            //Iterating through opportunities
            for(Opportunity opp : opty){
                //String strLeadAdditionalInfos;
                if(opp.LeadAdditionalInfos__c!=null && opp.LeadAdditionalInfos__c != '' ){
                    //strLeadAdditionalInfos = HELMSLeadDealerAssignmentADFHandler.removeSpecialXMLChars(opp.LeadAdditionalInfos__c);
                    String addInfo= opp.LeadAdditionalInfos__c;
                    String comments = '';
                    Offers__c offer = new Offers__c();
                    /* New Code */
                    if(addInfo.contains('<LeadAdditionalInfo key="Offer Id">')){
                            offer.Offer_ID__c = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Id">','</LeadAdditionalInfo>');
                    		   
                    }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Name">')){
                            offer.Name = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Name">','</LeadAdditionalInfo>');
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="Offer Type">')){
                            offer.Offer_Type__c = addInfo.substringBetween('<LeadAdditionalInfo key="Offer Type">','</LeadAdditionalInfo>');
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="special_short_description">')){
                            offer.Special_Short_Description__c =addInfo.substringBetween('<LeadAdditionalInfo key="special_short_description">','</LeadAdditionalInfo>');
                        }
                    	if(addInfo.contains('<LeadAdditionalInfo key="special_description">')){
                            offer.Special_Description__c = addInfo.substringBetween('<LeadAdditionalInfo key="special_description">','</LeadAdditionalInfo>');
                        }
                    	if(addInfo.contains('<LeadAdditionalInfo key="AK Opportunity Offer">')){
                            offer.AK_Opportunity_Offer__c = addInfo.substringBetween('<LeadAdditionalInfo key="AK Opportunity Offer">','</LeadAdditionalInfo>');
                        }
                        if(addInfo.contains('<LeadAdditionalInfo key="end_date">')){
                            String strDate = addInfo.substringBetween('<LeadAdditionalInfo key="end_date">','</LeadAdditionalInfo>');
                            strDate = strDate.substring(7, strDate.length() - 1);
                            strDate = strDate.trim();
                            offer.End_Date__c = Date.Parse(strDate);
                        }
                    /* New Code */
                    /*
                    Dom.Document doc = new Dom.Document(); 
                    doc.load(strLeadAdditionalInfos);
                    Dom.XMLNode rootElement = doc.getRootElement();
                    //Iterating through child elements and assigning the values to Offers object
                    Offers__c offer = new Offers__c();
                    for(Dom.XMLNode childElement : rootElement.getChildElements()){
                        
                        offer.Opportunity__c = opp.Id;
                         if(childElement.getAttributeValue('key', null) == 'Offer Id'){
                            offer.Offer_ID__c = childElement.getText(); 
                            System.debug('OfferId'+childElement.getText());
                        } else if(childElement.getAttributeValue('key',null) == 'Offer Name'){
                            System.debug('OfferName'+childElement.getText());
                            offer.Name = childElement.getText();
                        } else if(childElement.getAttributeValue('key', null) == 'Offer Type'){
                            offer.Offer_Type__c = childElement.getText();
                        } else if(childElement.getAttributeValue('key', null) == 'end_date'){
                            String strDate = childElement.getText();
                            strDate = strDate.substring(7, strDate.length() - 1);
                            //strDate = strDate.substring(0, strDate.indexOf('Expires'));
                            strDate = strDate.trim();
                            offer.End_Date__c = Date.Parse(strDate);
                        } else if(childElement.getAttributeValue('key', null) == 'special_short_description'){
                            offer.Special_Short_Description__c = childElement.getText();
                        } else if(childElement.getAttributeValue('key', null) == 'special_description'){
                            offer.Special_Description__c = childElement.getText();
                        }else if(childElement.getAttributeValue('key', null) == 'AK Opportunity Offer'){
                            offer.AK_Opportunity_Offer__c = childElement.getText();
                        }
                        
                    }
					*/
                    listOffers.add(offer);
                }
            }
            Integer j = 0;
            while(j< listOffers.Size()){
                if(listOffers[j].Offer_ID__c == null && listOffers[j].Name == null && listOffers[j].End_Date__c == null && listOffers[j].Special_Short_Description__c == null && listOffers[j].Special_Description__c == null && listOffers[j].AK_Opportunity_Offer__c == null){
                    listOffers.remove(j);
                } else {
                    j++;

            }
            
            
            if(listOffers.Size() > 0){
                insert listOffers;
            }
            }}Catch(Exception ex){
            System.debug('exception=====>>>>>>'+ex.getMessage());
            Logs__c  l =new Logs__c (name='Opportunity Trigger',Trigger_or_Class_Name__c='HELMSOffersInsertHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
    }
}