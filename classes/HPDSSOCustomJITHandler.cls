/*-------------------------------------------------------------------------------------------
Class Name : HPDSSOCustomJITHandler 
Test Class Name : HPDSSOCustomJITHandlerTest
Last Modified Version Owner : Grandhi Lavanya
Comments : This class is using for login to HRC dealer users via Single sign on 
Story No:  HDMP-24614
----------------------------------------------------------------------------------------------
*/
//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.

global class HPDSSOCustomJITHandler implements Auth.SamlJitHandler{
    public Id conId;
    global String profilename;
    public string dlrinfo;
    public String dealerNumber = 'HRC000';
    public String division = '9';
    public String jobCodeCD = 'PA0022 - PARTS MANAGER';
    
    private class JitException extends Exception{}
    
    public void handleUser(boolean create, User u, Map<String, String> attributes,
                           String federationIdentifier, boolean isStandard) {
                               
                               system.debug('attribute--------->'+attributes);
                               
                               if(create && attributes.containskey('UserName')!= null){
                                   u.Username = attributes.get('UserName')+'@honda.hrc.qa'; 
                               }
                               u.FederationIdentifier = attributes.get('federationidentifier');
                               
                               dlrinfo= '';
                               if(attributes.containsKey('Email')){
                                   dlrinfo = ','+'Email-'+attributes.get('Email');
                               }
                               
                               if(attributes.containsKey('Phone')) {
                                   u.Phone = attributes.get('Phone');
                               }
                               if(attributes.containsKey('Email')) {
                                   u.Email = attributes.get('Email');
                               } 
                               
                               if(u.Email==null || u.Email =='') {
                                   throw new JitException('EmailIsRequired,'+dlrinfo);
                               }
                               
                               if(attributes.containsKey('FirstName')) {
                                   u.FirstName = attributes.get('FirstName');
                               }
                               if(attributes.containsKey('LastName')) {
                                   u.LastName = attributes.get('LastName');
                               }
                               
                               if(attributes.containsKey('ApplicationRole_NM__c')) {
                                   u.ApplicationRole_NM__c = attributes.get('ApplicationRole_NM__c');
                               }else{
                                   u.ApplicationRole_NM__c = 'HRC';
                               }
                             
                                   u.DealerNumber_NUM__c = dealerNumber;  
                                   u.JobCode_CD__c = jobCodeCD;
                                   u.Division__c = division;
                                   profilename = SSO_Profile_Mapping__c.getInstance('PartnerCommunityUser').Profile__c; 
                               
                               
                               if(conId!=null){
                                   u.ContactId = conId ;
                               }
                               
                               system.debug('conId------>'+conId);
                               
                               u.CommunityNickname=attributes.get('federationidentifier')+'@honda.hrc.com';  
                               
                               
                               if(attributes.containsKey('District') && attributes.get('District')!='null') { 
                                   u.District__c = attributes.get('District');
                               }
                               
                               
                               if(attributes.containsKey('Zone') && attributes.get('Zone')!='null')  {
                                   u.Zone__c = attributes.get('Zone');
                               }
                               
                               String uid = UserInfo.getUserId();
                               User currentUser = 
                                   [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
                               
                               if(attributes.containsKey('LocaleSidKey')) {
                                   u.LocaleSidKey = attributes.get('LocaleSidKey');
                               } else if(create) {
                                   u.LocaleSidKey = currentUser.LocaleSidKey;
                               }
                               
                               if(attributes.containsKey('LanguageLocaleKey')) {
                                   u.LanguageLocaleKey = attributes.get('LanguageLocaleKey');
                               } else if(create) {
                                   u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
                               }
                               if(attributes.containsKey('Alias')) {
                                   u.Alias = attributes.get('Alias');
                               } else if(create) {
                                   String alias = '';
                                   if(u.FirstName == null) {
                                       alias = u.LastName;
                                   } else {
                                       alias = u.FirstName.charAt(0) + u.LastName;
                                   }
                                   if(alias.length() > 5) {
                                       alias = alias.substring(0, 5);
                                   }
                                   u.Alias = alias;
                               }
                               
                               if(create){         
                                   u.TimeZoneSidKey ='America/Los_Angeles';
                               }
                               if(attributes.containsKey('EmailEncodingKey')) {
                                   u.EmailEncodingKey = attributes.get('EmailEncodingKey');
                               } else if(create) {
                                   u.EmailEncodingKey = currentUser.EmailEncodingKey;
                               }
                               
                               u.IsActive=true;   
                               
                               if(profilename!=null) {
                                   Profile p = [SELECT Id,name FROM Profile WHERE name=:profilename];
                                   u.ProfileId = p.Id;
                                   
                               }
                               
                               if(!create) {
                                   update(u);
                               }else{
                                   Insert u;
                               }
                           }
    
    
    
    
    public void handleContact(boolean create, String accountId, User u, Map<String, String> attributes) {
        Contact c;
        
        
        boolean newContact = false;
        
        dlrinfo = '';
        if(attributes.containsKey('Email'))
            dlrinfo = ','+'Email-'+attributes.get('email');
        if(division!= null)
            //dlrinfo = dlrinfo+','+ +'Division-'+Division__c;
            dlrinfo = dlrinfo+ ','+'Division-'+division;
        if(attributes.containsKey('federationidentifier'))
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('federationidentifier');
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+jobCodeCD;
        
        
        if(create) {
            
            c = new Contact();
            newContact = true;
            
        } else {
            
            Id dealerAccRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            List<Contact> cList = [SELECT Id, AccountId, email,HelmsCRMEligible_FLAG__c FROM Contact WHERE accountId =:accountId and LastName=:attributes.get('LastName') and email =:attributes.get('Email') and recordtypeid=:dealerAccRecTypeId limit 1];
            
            
            if(cList.size()>0){
                if(!cList[0].HelmsCRMEligible_FLAG__c){
                    throw new JitException('Cannot change User.ContactId'+dlrinfo);
                }
                c=cList[0];
            }else{      
                c = new Contact();
                system.debug('Contact--->'+c);
            }
        }
        
        if(attributes.containsKey('Email')) {
            c.Email = attributes.get('Email');
        }
        if(attributes.containsKey('FirstName')) {
            c.FirstName = attributes.get('FirstName');
        }
        if(attributes.containsKey('LastName')) {
            c.LastName = attributes.get('LastName');
        }
        if(attributes.containsKey('Phone')) {
            c.Phone = attributes.get('Phone');
        }
        
        if(accountId!=null){
            c.AccountId = accountId;
            c.recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            c.HelmsCRMEligible_FLAG__c=true;
        }
        
        if(newContact) {
            
            insert(c);
            conId = c.Id;
            system.debug('Contact--->'+conId);
        } 
        else {
            //update(c);
        }
        
    }
    
    public String handleAccount(boolean create, User u, Map<String, String> attributes) {
        List<Account> alist = new List<Account>();
        boolean newAccount = false;
        
        dlrinfo = '';
        if(attributes.containsKey('Email')){
            dlrinfo = ','+'Email-'+attributes.get('Email');
        }
        if(attributes.containsKey('Division')){
            dlrinfo = dlrinfo+ ','+division;
        }
        if(attributes.containsKey('federationidentifier')){
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('federationidentifier');
        }
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+jobCodeCD;
        
        Account a = new Account();
        if(dealerNumber != null) {
            
            alist = [SELECT Id FROM Account WHERE ID IN (select Dealer_ID__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c =:dealerNumber AND isActive_FLG__c =true AND Division_CD__c =:division AND (Is_Dealer_DreamShop_Active__c= true)) limit 1]; 
            
        }
        system.debug('alist--------'+alist);
        if(alist.size()>0){     
        }else{
            
            throw new JitException('HDMNoAccess Level for Dealer Account'+dlrinfo);
        }
        
        return alist[0].id;
    }
    
    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               
                                   string account = handleAccount(create, u, attributes);  
                                   handleContact(create, account, u, attributes);
                                   handleUser(create, u, attributes, federationIdentifier, false);  
                               
                           }
    
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               
                               system.debug('attributes--------'+attributes);
                               User u = new User();
                               
                               handleJit(true, u, samlSsoProviderId, communityId, portalId,
                                         federationIdentifier, attributes, assertion);
                               
                               system.debug('return u--------'+u);
                               return u;
                               
                           }
    
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               
                               system.debug('attributes--------'+attributes);
                               User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
                               system.debug('updateuser u--------'+u);
                               handleJit(false, u, samlSsoProviderId, communityId, portalId,
                                         federationIdentifier, attributes, assertion);
                           }
}