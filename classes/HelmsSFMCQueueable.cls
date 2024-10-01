/**** 
 * This class is used for the email notifications and sms notifications 
****/
public class HelmsSFMCQueueable implements Queueable ,Database.AllowsCallouts {
    private set<id> ledids;
    private set<id> oppids;
    Public List<Lead> pSPLead;
    Public List<Lead> acuraLead;
     Public List<Lead> pEMarineLead;
    Public List<Lead> hondaLead;
    public HelmsSFMCQueueable(set<id> ids,set<id> opids) {
      
      acuraLead=[SELECT Id,FirstName,Exterior_Color__c,Interior_Color__c,PreferredDealerContact_ID__r.email, ContactKey_TXT__c,
                            Email, Model_TXT__c, SubDiv_TXT__c,Division_CD__c,PreferredDealerAccount_ID__r.Phone,
                            PreferredDealerAccount_ID__r.name,PreferredDealerAccount_ID__r.ShippingStreet,
                            PreferredDealerAccount_ID__r.ShippingCity,PreferredDealerAccount_ID__r.ShippingState,
                            PreferredDealerAccount_ID__r.ShippingPostalCode,PreferredDealerAccount_ID__r.ShippingCountry,
                            BrandsiteShoppingTool_TXT__c,Send_confirmation_Email__c,Year_YR__c,PreferredDealerContact_ID__r.name  FROM Lead
                            where SubDiv_TXT__c='Acura'  AND BrandsiteShoppingTool_TXT__c =null  AND isConverted = true AND Send_confirmation_Email__c = true AND
                            LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c = true AND id IN: ids];
        
 	 pSPLead=[SELECT Id,Exterior_Color__c,Interior_Color__c,FirstName, ContactKey_TXT__c,
                            PreferredDealerContact_ID__r.email, Email, Model_TXT__c, SubDiv_TXT__c,Division_CD__c,
                            PreferredDealerAccount_ID__r.Phone,PreferredDealerAccount_ID__r.name,
                            PreferredDealerAccount_ID__r.ShippingStreet,PreferredDealerAccount_ID__r.ShippingCity,
                            PreferredDealerAccount_ID__r.ShippingState,PreferredDealerAccount_ID__r.ShippingPostalCode,
                            PreferredDealerAccount_ID__r.ShippingCountry,BrandsiteShoppingTool_TXT__c,
                            Send_confirmation_Email__c,Year_YR__c,PreferredDealerContact_ID__r.name  FROM Lead 
                            where SubDiv_TXT__c='Motorcycle'  AND BrandsiteShoppingTool_TXT__c =null AND isConverted = true AND Send_confirmation_Email__c = true AND
                            LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c = true AND id IN: ids];
        
      hondaLead = [Select Id, FirstName,Odometer_TXT__c, BodyStyle_TXT__c,  MSRP_AMT__c, ModelDestinationCharge_AM__c, 
                               ModelDealerAccessoryPrice_AM__c, Interior_Color__c, Exterior_Color__c, Transmission_TXT__c, Address_Street__c, Model_ID__c, 
                               State, Marketing_Campaign_Name__c, Make_TXT__c, Year_YR__c, ConvertedOpportunityId, LastName, Source_Name__c, Division_CD__c, 
                               Address, street,City, PostalCode, Email, PreferredDealerAccount_ID__c, PreferredDealerNumber_NUM__c, 
                               LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c From Lead where SubDiv_TXT__c='Honda' 
                               AND isConverted = true AND Send_confirmation_Email__c = true AND
                               LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c= true AND Id IN : ids];
        
      pEMarineLead =[SELECT Id, ContactKey_TXT__c, Email, Model_TXT__c, SubDiv_TXT__c,Division_CD__c,ConvertedOpportunityId,
                        PreferredDealerAccount_ID__r.Phone,PreferredDealerAccount_ID__r.name,
                        PreferredDealerAccount_ID__r.ShippingStreet,PreferredDealerAccount_ID__r.ShippingCity,
                        PreferredDealerAccount_ID__r.ShippingPostalCode,PreferredDealerAccount_ID__r.ShippingCountry,
                        BrandsiteShoppingTool_TXT__c,Send_confirmation_Email__c  FROM Lead 
                        where (SubDiv_TXT__c='Marine' OR SubDiv_TXT__c='PowerEquipment')   AND isConverted = true AND Send_confirmation_Email__c = true AND
                        LeadProvider_ID__r.Send_Customer_Acknowledgement_Email_Flag__c = true AND BrandsiteShoppingTool_TXT__c =null AND id IN: ids];
    
    
        this.ledids = ids;
        this.oppids = opids;
        
    }
    public void execute(System.QueueableContext qc) {
       
        if(oppids.size()>0){
             HelmsOpportunityNotificationSms.opportunityCreation(oppids);
        }
        if(acuraLead.size()>0){
             HelmsLeadCrationNotificationSFMCAcura.leadCreationSFMCAura(acuraLead); 
        }
        if(pSPLead.size()>0){
             HelmsLeadCrationNotificationSFMCPSP.leadCreationSFMCPSP(pSPLead);
        }
       if(pEMarineLead.size()>0){
             HelmsLeadCrationNotificationSFMC.leadCreationSFMC(pEMarineLead);
       }
       if(hondaLead.size()>0){
             //Sending Email once Lead from Honda is converted to Opportunity
             HELMSeShoppingSendNotification.eshoppingAPi(hondaLead);
       }
     }
}