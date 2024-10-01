//****************************************************************************** 
// File Name:       HELMSOpportunityController.cls
//===============================================================================
// Modification Log: 
// May 28, 2021 Arunprasad N (Wipro) initial coding
//*******************************************************************************
public with sharing class HELMSOpportunityController {
  @AuraEnabled(cacheable = true)
    public static List<Action> getActions(){
        try{
            List<Action> actions = new List<Action>();
            List<String> subDivisions = new List<String>();
            //String userId = UserInfo.getUserId();
            User u = [SELECT AccountId, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if(u.Profile.Name == 'System Administrator'){
                // Describe the Dealer_Division__c.SubDiv_TXT__c field
                Schema.DescribeFieldResult fieldSubDiv = Dealer_Division__c.SubDiv_TXT__c.getDescribe();
                // Get picklist values from field SubDiv_TXT__c
                List<Schema.PicklistEntry> entires = getPicklistValues(fieldSubDiv.getSobjectField());
                // Do something with entries
                for (Schema.PicklistEntry entry : entires) {
                    subDivisions.add(entry.getValue());
                }
            }else{
                if(!String.isEmpty(u.AccountId)){
                    List<Dealer_Division__c> dealerDivisions = [SELECT Id, Name, Dealer_ID__c, SubDiv_TXT__c, Dealer_Access_Level__c FROM Dealer_Division__c WHERE Dealer_ID__c = :u.AccountId and Dealer_Access_Level__c='Full Access'];
                   // List<Dealer_Division__c> dealerDivisions = [SELECT Id, Name, Dealer_ID__c, SubDiv_TXT__c, Dealer_Access_Level__c FROM Dealer_Division__c WHERE Dealer_ID__c = :u.AccountId and Dealer_Access_Level__c IN ('Full Access','Reporting Only')];
                    for(Dealer_Division__c dealerDivision : dealerDivisions){
                        subDivisions.add(dealerDivision.SubDiv_TXT__c);
                    }
                }
            }
            Map<String,String> recordTypeSubDivisionMap = new Map<String,String>();
            Map<String,String> subDivsionRecordTypeMap = new Map<String,String>();
            for(Lead_Division_Mapping_From_Subdivision__mdt m :[SELECT Id, Subdivision__c, Opp_Recortype_API_name__c, Division_CD__c FROM Lead_Division_Mapping_From_Subdivision__mdt])
            {
                recordTypeSubDivisionMap.put(m.Opp_Recortype_API_name__c , m.Subdivision__c);
                subDivsionRecordTypeMap.put(m.Subdivision__c , m.Opp_Recortype_API_name__c);
            }
            List<RecordType> recordTypes = [SELECT Id, Name, DeveloperName, IsActive FROM RecordType WHERE SobjectType = 'Opportunity' AND IsActive = true AND DeveloperName IN :recordTypeSubDivisionMap.keySet()];
            Map<String, Id> recordTypeMap = new Map<String, Id>();
            for(RecordType rt : recordTypes){
                recordTypeMap.put(rt.DeveloperName, rt.Id);
            }
            for(String subDivision : subDivisions){
                if(subDivsionRecordTypeMap.get(subDivision) != null){
                    Action ac = new Action();
                    ac.name = subDivision;
                    ac.label = 'New ' + subDivision + ' Opportunity';
                    ac.recordTypeId = recordTypeMap.get(subDivsionRecordTypeMap.get(subDivision));
                    actions.add(ac);
                }
            }
            return actions;
        }catch (Exception ex) {
            throw new AuraHandledException(ex.getLineNumber() + ':' + ex.getMessage());
        }
    }
    
    // Retrieves active picklist values for a given object and field
    // Example: getPicklistValues(Dealer_Division__c.Dealer_ID__c)
    public static List<Schema.PicklistEntry> getPicklistValues(
            Schema.sObjectField field) {
        // Get all picklist values
        List<Schema.PicklistEntry> entries = field.getDescribe().getPickListValues();
        // Only return active picklist values
        List<Schema.PicklistEntry> activeEntries = new List<Schema.PicklistEntry>();
        for (Schema.PicklistEntry entry : entries) {
            if (entry.isActive()) {
                activeEntries.add(entry);
            }
        }
        return activeEntries;
    }
    
    public class Action {
        @AuraEnabled
        public String recordTypeId {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String label {get; set;}
        
    }
      @AuraEnabled(cacheable = true)
    public static List<Action> getActionsImage(){
        try{
            List<Action> actions = new List<Action>();
            List<String> subDivisions = new List<String>();
           // String userId = UserInfo.getUserId();
            User u = [SELECT AccountId, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if(u.Profile.Name == 'System Administrator'){
                // Describe the Dealer_Division__c.SubDiv_TXT__c field
              //  Schema.DescribeFieldResult fieldSubDiv = Dealer_Division__c.SubDiv_TXT__c.getDescribe();
                // Get picklist values from field SubDiv_TXT__c
              //  List<Schema.PicklistEntry> entires = getPicklistValues(fieldSubDiv.getSobjectField());
                // Do something with entries
           //     for (Schema.PicklistEntry entry : entires) {
            //        subDivisions.add(entry.getValue());
            //    }
            }else
            { 
                if(!String.isEmpty(u.AccountId)){
                    //List<Dealer_Division__c> dealerDivisions = [SELECT Id, Name, Dealer_ID__c, SubDiv_TXT__c, Dealer_Access_Level__c FROM Dealer_Division__c WHERE Dealer_ID__c = :u.AccountId and Dealer_Access_Level__c='Full Access'];
                    List<Dealer_Division__c> dealerDivisions = [SELECT Id, Name, Dealer_ID__c, SubDiv_TXT__c, Dealer_Access_Level__c FROM Dealer_Division__c WHERE Dealer_ID__c = :u.AccountId and Dealer_Access_Level__c IN ('Full Access','Reporting Only')];
                    for(Dealer_Division__c dealerDivision : dealerDivisions){
                        subDivisions.add(dealerDivision.SubDiv_TXT__c);
                    }
                }
            }
          //  Map<String,String> recordTypeSubDivisionMap = new Map<String,String>();
            Map<String,String> subDivsionRecordTypeMap = new Map<String,String>();
            for(Lead_Division_Mapping_From_Subdivision__mdt m :[SELECT Id, Subdivision__c, Opp_Recortype_API_name__c, Division_CD__c FROM Lead_Division_Mapping_From_Subdivision__mdt])
            {
              //  recordTypeSubDivisionMap.put(m.Opp_Recortype_API_name__c , m.Subdivision__c);
                subDivsionRecordTypeMap.put(m.Subdivision__c , m.Opp_Recortype_API_name__c);
            } 
           // List<RecordType> recordTypes = [SELECT Id, Name, DeveloperName, IsActive FROM RecordType WHERE SobjectType = 'Opportunity' AND IsActive = true AND DeveloperName IN :recordTypeSubDivisionMap.keySet()];
          //  Map<String, Id> recordTypeMap = new Map<String, Id>();
          //  for(RecordType rt : recordTypes){
         //       recordTypeMap.put(rt.DeveloperName, rt.Id);
         //   }
            for(String subDivision : subDivisions){
                if(subDivsionRecordTypeMap.get(subDivision) != null){
                    Action ac = new Action();
                    ac.name = subDivision;
                    ac.label = 'New ' + subDivision + ' Opportunity';
              //      ac.recordTypeId = recordTypeMap.get(subDivsionRecordTypeMap.get(subDivision));
                    actions.add(ac);
                }
            } 
            return actions;
        }catch (Exception ex) {
            throw new AuraHandledException(ex.getLineNumber() + ':' + ex.getMessage());
        }
    }

}