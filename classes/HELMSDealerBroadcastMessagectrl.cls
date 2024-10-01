/*----------------------------------------------------------------------------------------------------------------------------------------------------
Class Name : HELMSDealerBroadcastMessagectrl 
Test Class Name : HELMSDealerBroadcastMessagectrlTest
Owner : Talapalle Vinay
Comments : Code to Display Custom Settings Data on Partner Community Home Page based on Start & End Date
-------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public with sharing class HELMSDealerBroadcastMessagectrl {
     @AuraEnabled( cacheable=true )
    //Fetching Data From Custom Settings - HELMS_Dealer_Broadcast_Message__c
    public static List<HELMS_Dealer_Broadcast_Message__c>  fetchMetaListLwc()
    {        
      
       List<HELMS_Dealer_Broadcast_Message__c> fetchMeta = new List<HELMS_Dealer_Broadcast_Message__c>(); 
           for(HELMS_Dealer_Broadcast_Message__c dbm : [Select Message__c,Start_Date__c,End_Date__c from HELMS_Dealer_Broadcast_Message__c WITH SECURITY_ENFORCED])
       {
         if(dbm.Start_Date__c <= system.now() && dbm.End_Date__c >= system.now())
         {
           fetchMeta.add(dbm);
         }
       } 
      return fetchMeta;
    } 
}