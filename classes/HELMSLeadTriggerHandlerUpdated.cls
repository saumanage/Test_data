public class HELMSLeadTriggerHandlerUpdated {
    
    public static void handleLeadInsert(List<Lead> leadList){
        try{
            Map<String,String> SubdivisiomMap = new Map<String,String>();
            for(Lead_Division_Mapping_From_Subdivision__mdt m :[select id,Subdivision__c, Division_CD__c from Lead_Division_Mapping_From_Subdivision__mdt])
            {
                SubdivisiomMap.put(m.Subdivision__c , m.Division_CD__c);
            }
            
            List<String> pnamelist = new List<String>();
            Map<string, id> Providermap = new Map<string, id>(); 
            
            Set<String> leadPreffereddealerNumber = new Set<String>();
            for(Lead leadRec : leadList)
            {
                if(leadRec.PreferredDealerNumber_NUM__c!=null){
                    leadPreffereddealerNumber.add(leadRec.PreferredDealerNumber_NUM__c);
                }
                if(leadRec.PreferredDealerAccount_ID__c!=null){
                    if(leadRec.SubDiv_TXT__c !=null){
                        leadRec.Division_CD__c = SubdivisiomMap.get(leadRec.SubDiv_TXT__c);
                    }
                }
                
                if(leadRec.ProviderDetail_TXT__c!=null){ 
                    string providename =  leadRec.ProviderDetail_TXT__c;
                   
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null){
                            pnamelist.add((pdn1[0]).toLowerCase());
                        }
                    }else{
                        pnamelist.add((leadRec.ProviderDetail_TXT__c).toLowerCase());
                                                    
                    }
                }
                if(String.isNotEmpty(leadRec.Color_TXT__c) ){
                    // leadRec.Color_XML__c to store xml value
                    if(leadRec.Color_XML__c == null ){
                        leadRec.Color_XML__c = leadRec.Color_TXT__c;
                    }
                   // leadRec.Color_TXT__c = getColorCombination(leadRec.Color_TXT__c);
                    Map<String,String> colorsInEx = getColorCombination(leadRec.Color_TXT__c);
                    leadRec.Color_TXT__c = colorsInEx.get('color');
                    leadRec.Interior_Color__c = colorsInEx.get('interior');
                    leadRec.Exterior_Color__c = colorsInEx.get('exterior');
                }
                
                
            }
            
            Id dealerAccRecTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            for(Account a:[select id,name from account where name IN: pnamelist and RecordTypeId=:dealerAccRecTypeId2]){               
                
                Providermap.put((a.name).toLowerCase(),a.id);
                
            }
            
          //  system.debug('test '+leadPreffereddealerNumber);
            Map<String,Account> accountDealerCodeMap = new Map<String,Account>();
            Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            for(Account accRec : [Select id,DealerCode_CD__c,(Select id,Name,FirstName,LastName,Email from Contacts) from Account where DealerCode_CD__c in:leadPreffereddealerNumber and
                                  RecordTypeId=:dealerAccRecTypeId
                                 ])
            {
             //   system.debug('here inside for');
                accountDealerCodeMap.put(accRec.DealerCode_CD__c,accRec);
            }
            //modified as part of CAPS-4336
            Map<String,Dealer_Division__c> dealDivMap = New Map<String,Dealer_Division__c>();
            for(Dealer_Division__c dealDiv:[select id,Division_CD__c, SubDiv_TXT__c,Dealer_ID__r.DealerCode_CD__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c in: accountDealerCodeMap.keySet() WITH SECURITY_ENFORCED]){
                dealDivMap.put(dealDiv.Dealer_ID__r.DealerCode_CD__c,dealDiv);
            }
            for(Lead leadRecord : leadList)
            {
                if(accountDealerCodeMap.containsKey(leadRecord.PreferredDealerNumber_NUM__c))
                {
                    leadRecord.PreferredDealerAccount_ID__c=accountDealerCodeMap.get(leadRecord.PreferredDealerNumber_NUM__c).Id;
                    //modified as part of CAPS-4336
                    if(dealDivMap.containsKey(leadRecord.PreferredDealerNumber_NUM__c))
                    	leadRecord.SubDiv_TXT__c = dealDivMap.get(leadRecord.PreferredDealerNumber_NUM__c).SubDiv_TXT__c;
                    if(leadRecord.SubDiv_TXT__c !=null){
                        leadRecord.Division_CD__c = SubdivisiomMap.get(leadRecord.SubDiv_TXT__c);
                    }
                    for(Contact conRec : accountDealerCodeMap.get(leadRecord.PreferredDealerNumber_NUM__c).Contacts)
                    {
                        //system.debug('here insidecontact '+conRec+' '+leadRecord.Name+' '+conRec.Name);
                        if(leadRecord.FirstName==conRec.FirstName && leadRecord.LastName==conRec.LastName && leadRecord.Email==conRec.Email)
                        {
                            leadRecord.PreferredDealerContact_ID__c=conRec.Id;
                            break;
                        }
                    }
                }
                if(leadRecord.ProviderDetail_TXT__c!=null){ 
                    string providename =  leadRecord.ProviderDetail_TXT__c;
                   
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null && Providermap.containsKey((pdn1[0]).toLowerCase())){
                            leadRecord.LeadProvider_ID__c = Providermap.get((pdn1[0]).toLowerCase());
                        }
                    }else if(Providermap.containsKey((leadRecord.ProviderDetail_TXT__c).toLowerCase())){
                       leadRecord.LeadProvider_ID__c = Providermap.get((leadRecord.ProviderDetail_TXT__c).toLowerCase());
                                                    
                    }
                }
                
                
            }
        }Catch(Exception ex){
           // System.debug('Exception at line : '+ ex.getLineNumber());
          //  System.debug('Exception Message : '+ ex.getMessage());
            
            Logs__c  l =new Logs__c (name='Lead - handleLeadInsert',Trigger_or_Class_Name__c='LeadTriggerHandlerUpdated', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
    }
    
    
    public static void handleLeadUpdate(Map<Id,Lead> LeadOldMap,Map<Id,Lead> LeadNewMap)
    {
        try{
            Map<String,String> SubdivisiomMap = new Map<String,String>();
            for(Lead_Division_Mapping_From_Subdivision__mdt m :[select id,Subdivision__c, Division_CD__c from Lead_Division_Mapping_From_Subdivision__mdt])
            {
                SubdivisiomMap.put(m.Subdivision__c , m.Division_CD__c);
            }
            Set<String> leadPreffereddealerNumber = new Set<String>();
            
            List<String> pnamelist = new List<String>();
            Map<string, id> Providermap = new Map<string, id>(); 
            List<String> dealerNumbers = New List<String>();
            for(Id leadId :  LeadNewMap.keySet()){
                dealerNumbers.add(LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c);
            }
            //modified as part of CAPS-4336
            Map<String,Dealer_Division__c> dealDivMap = New Map<String,Dealer_Division__c>();
            for(Dealer_Division__c dealDiv:[select id,Division_CD__c, SubDiv_TXT__c,Dealer_ID__r.DealerCode_CD__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c in: dealerNumbers WITH SECURITY_ENFORCED]){
                dealDivMap.put(dealDiv.Dealer_ID__r.DealerCode_CD__c,dealDiv);
            }
            for(Id leadId :  LeadNewMap.keySet())
            {
                if(LeadOldMap.get(leadId).PreferredDealerNumber_NUM__c!=LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c && LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c!=null)
                {
                    leadPreffereddealerNumber.add(LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c);
                }
                
                if(LeadNewMap.get(leadId).PreferredDealerAccount_ID__c!=null){
                    //modified as part of CAPS-4336
                    if(dealDivMap.containsKey(LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c))
                        LeadNewMap.get(leadId).SubDiv_TXT__c = dealDivMap.get(LeadNewMap.get(leadId).PreferredDealerNumber_NUM__c).SubDiv_TXT__c;
                    if(LeadNewMap.get(leadId).SubDiv_TXT__c !=null){
                        LeadNewMap.get(leadId).Division_CD__c = SubdivisiomMap.get(LeadNewMap.get(leadId).SubDiv_TXT__c);
                    }
                }
                
                if(LeadNewMap.get(leadId).ProviderDetail_TXT__c!=null && LeadOldMap.get(leadId).ProviderDetail_TXT__c!=LeadNewMap.get(leadId).ProviderDetail_TXT__c){ 
                    string providename =  LeadNewMap.get(leadId).ProviderDetail_TXT__c;
                   
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null){
                            pnamelist.add((pdn1[0]).toLowerCase());
                        }
                    }else{
                        pnamelist.add((LeadNewMap.get(leadId).ProviderDetail_TXT__c).toLowerCase());
                                                    
                    }
                }
                
                if(String.isNotEmpty(LeadNewMap.get(leadId).Color_TXT__c) && LeadOldMap.get(leadId).Color_TXT__c!=LeadNewMap.get(leadId).Color_TXT__c ){
                    // leadRec.Color_XML__c to store xml value
                    if(LeadNewMap.get(leadId).Color_XML__c == null ){
                        LeadNewMap.get(leadId).Color_XML__c = LeadNewMap.get(leadId).Color_TXT__c;
                    }
                  //  LeadNewMap.get(leadId).Color_TXT__c = getColorCombination(LeadNewMap.get(leadId).Color_TXT__c);
                 Map<String,String> colorsInEx = getColorCombination(LeadNewMap.get(leadId).Color_TXT__c);
                    LeadNewMap.get(leadId).Color_TXT__c = colorsInEx.get('color');
                    LeadNewMap.get(leadId).Interior_Color__c = colorsInEx.get('interior');
                    LeadNewMap.get(leadId).Exterior_Color__c = colorsInEx.get('exterior');
                }
                
            }
            
            
            Id dealerAccRecTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider').getRecordTypeId();
            for(Account a:[select id,name from account where name IN: pnamelist and RecordTypeId=:dealerAccRecTypeId2]){               
                
                Providermap.put((a.name).toLowerCase(),a.id);
                
            }
            
            Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            Map<String,Account> accountDealerCodeMap = new Map<String,Account>();
            for(Account accRec : [Select id,DealerCode_CD__c,(Select id,FirstName,LastName,Email from Contacts) from Account where DealerCode_CD__c in:leadPreffereddealerNumber and
                               RecordTypeId=:dealerAccRecTypeId
                              ])
            {
                accountDealerCodeMap.put(accRec.DealerCode_CD__c,accRec);
            }
            
            for(Id leadRecId : LeadNewMap.keySet())
            {
                if(accountDealerCodeMap.containsKey(LeadNewMap.get(leadRecId).PreferredDealerNumber_NUM__c))
                {
                    LeadNewMap.get(leadRecId).PreferredDealerAccount_ID__c=accountDealerCodeMap.get(LeadNewMap.get(leadRecId).PreferredDealerNumber_NUM__c).Id;
                    if(LeadNewMap.get(leadRecId).SubDiv_TXT__c !=null){
                        LeadNewMap.get(leadRecId).Division_CD__c = SubdivisiomMap.get(LeadNewMap.get(leadRecId).SubDiv_TXT__c);
                    }
                   for(Contact conRec : accountDealerCodeMap.get(LeadNewMap.get(leadRecId).PreferredDealerNumber_NUM__c).Contacts)
                    {
                        if(LeadNewMap.get(leadRecId).FirstName==conRec.FirstName && LeadNewMap.get(leadRecId).LastName==conRec.LastName && LeadNewMap.get(leadRecId).Email==conRec.Email)
                            {
                                LeadNewMap.get(leadRecId).PreferredDealerContact_ID__c=conRec.Id;
                                break;
                            }
                    }
                }
                
                if(LeadNewMap.get(leadRecId).ProviderDetail_TXT__c!=null && LeadOldMap.get(leadRecId).ProviderDetail_TXT__c!=LeadNewMap.get(leadRecId).ProviderDetail_TXT__c){ 
                    string providename =  LeadNewMap.get(leadRecId).ProviderDetail_TXT__c;
                   
                    if(providename.contains(':')){
                        String[] pdn1 = providename.split(':');
                        if(pdn1[0]!=null && Providermap.containsKey((pdn1[0]).toLowerCase())){
                            LeadNewMap.get(leadRecId).LeadProvider_ID__c = Providermap.get((pdn1[0]).toLowerCase());
                        }
                    }else if(Providermap.containsKey((LeadNewMap.get(leadRecId).ProviderDetail_TXT__c).toLowerCase())){
                        LeadNewMap.get(leadRecId).LeadProvider_ID__c = Providermap.get((LeadNewMap.get(leadRecId).ProviderDetail_TXT__c).toLowerCase());
                                                    
                    }
                }
                
            }
        }Catch(Exception ex){
          //  System.debug('Exception at line : '+ ex.getLineNumber());
          //  System.debug('Exception Message : '+ ex.getMessage());
            
            Logs__c  l =new Logs__c (name='Lead - handleLeadUpdate',Trigger_or_Class_Name__c='LeadTriggerHandlerUpdated', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }
        
    }

    // public static String getColorCombination(String colorTXT){
    public static Map<string,String> getColorCombination(String colorTXT){
        String color = '';
        String interior = '';
        String exterior= '';
            Map<string, String> colorsInEx= new Map<String, String>();
        try{
            Integer size = 0;
            List<String> colorCombinations = new List<String>();
            if(String.isNotEmpty(colorTXT)){
                colorCombinations.addAll(colorTXT.split('</colorcombination>'));
            }
            if( colorTXT != '<colorcombination/>'){
            for(String colorCombination : colorCombinations){
                size += 1;
                Dom.Document doc = new Dom.Document();                
                doc.load( colorCombination + '</colorcombination>' );  
                //Retrieve the root element for this document.
                Dom.XMLNode root = doc.getRootElement();               
                // Alternatively, loop through the child elements.
                // This prints out all the elements of the address
                for(Dom.XMLNode child : root.getChildElements()) {                
                    if(child.getName() =='interiorcolor'){
                        
                        //color += child.getName() + ':' + child.getText() + ', ';
                        color += 'Interior Color:' + child.getText() + ',  ';
                        //system.debug('@@@@@@Childtext-----'+child.getText());
                       interior += child.getText() + ', ';
                        interior = interior.removeEnd(', ');
                    }
                    if(child.getName() =='exteriorcolor'){
                        //color += child.getName() + ':' + child.getText() + ', ';
                        color += 'Exterior Color:' + child.getText() + ',  ';
                        exterior += child.getText() + ', ';
                        exterior = exterior.removeEnd(', ');
                    }
                    if(child.getName() =='preference'){
                        //color += child.getName() + ':' + child.getText() + ', ';
                        color += 'Preference:' + child.getText();
                    }
                } 
                }
                //color = color.removeEnd(', ');
                if(size != colorCombinations.size()){
                    
                    color += '\n';
                }
            }
        }Catch(Exception ex){
            Logs__c logRecord = new Logs__c(Name='getColorCombination', Trigger_or_Class_Name__c='HELMSLeadTriggerHandlerUpdated',  Error_Message__c = ex.getMessage(),
            Error_Line_Number__c = Integer.valueOf(ex.getLineNumber()));
            insert logRecord;
        }
        colorsInEx.put('interior',interior);
        colorsInEx.put('exterior',exterior);
        colorsInEx.put('color',color);
       // system.debug(colorsInEx);
         return colorsInEx;
       //  return color;
       
    } 
}