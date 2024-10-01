//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class HELMSSSOCustomJITHandlerInternal implements Auth.SamlJitHandler {
    public Id conId;
    global String profilename;
    public string dlrinfo;
  
  private class JitException extends Exception{}
  
  private  void handleUser(boolean create, User u, Map<String, String> attributes,
    String federationIdentifier, boolean isStandard) {
        
    //try{
        if(create && attributes.containsKey('Username')) {      
          u.Username = attributes.get('Username')+''+SSO_Profile_Mapping__c.getInstance('InternalUser').username__c;          
          u.FederationIdentifier = attributes.get('Username');
        }
        
        dlrinfo= '';
        if(attributes.containsKey('Email'))
            dlrinfo = ','+'Email-'+attributes.get('email');
        if(attributes.containsKey('DealerNumber_NUM__c'))
            dlrinfo = dlrinfo+','+'DealerNumber_NUM__c-'+attributes.get('DealerNumber_NUM__c');
        if(attributes.containsKey('Division'))
            dlrinfo = dlrinfo+ ','+'Division-'+attributes.get('Division');
        if(attributes.containsKey('Federationidentifier'))
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('Federationidentifier');
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+attributes.get('JobCode_CD__c');
        
        
        if(attributes.containsKey('Phone')) {
          u.Phone = attributes.get('Phone');
        }
        if(attributes.containsKey('Email')) {
          u.Email = attributes.get('Email');
        } 
        //system.debug('--Email-------'+attributes.containsKey('Email'));
        //system.debug('-------aa--'+attributes.containsKey('email'));
       if(attributes.containsKey('email')) {
          u.Email = attributes.get('email');
        }
       
        if(u.Email==null || u.Email =='') {
            throw new JitException('EmailIsRequired,'+dlrinfo);
        }
        
        if(attributes.containsKey('Firstname')) {
          u.FirstName = attributes.get('Firstname');
        }
        if(attributes.containsKey('LastName')) {
          u.LastName = attributes.get('LastName');
        }
        if(attributes.containsKey('Title')) {
          u.Title = attributes.get('Title');
        }
        if(attributes.containsKey('CompanyName')) {
          u.CompanyName = attributes.get('CompanyName');
        }
        
        if(attributes.get('applicationname') != null){
            u.Application_Name__c = attributes.get('applicationname');
        }
        
        if(attributes.containsKey('applicationname')&& attributes.get('applicationname') != null){
            u.Application_Name__c = attributes.get('applicationname');
        }
        
        if(attributes.containsKey('ApplicationRole__c')) {
          u.ApplicationRole_NM__c = attributes.get('ApplicationRole__c');
        }
        
        Map<String,SSO_Job_Code_Mapping__c> csJobcode = new Map<string,SSO_Job_Code_Mapping__c>();
        List<SSO_Job_Code_Mapping__c> mcs = SSO_Job_Code_Mapping__c.getall().values();
    
        // support team roles
        Map<String,Boolean> csSupportTeamRole = new Map<string,Boolean>();
        
        for(SSO_Job_Code_Mapping__c sc:mcs){
            if(sc.Job_Code__c!=null){               
                csJobcode.put( sc.Job_Code__c.substringbefore('-').trim(), sc);
            }
            
            if(sc.Is_Support_Team__c){
                csSupportTeamRole.put( sc.ApplicationRole__c , true);
            }
        }
        
        if(attributes.containsKey('DealerNumber_NUM__c')) {
          u.DealerNumber_NUM__c = attributes.get('DealerNumber_NUM__c');
          
          String name=attributes.get('DealerNumber_NUM__c');
          
            String str = name;

            string Zone =str.left(3) ;
            
            string DZone = Zone.right(1);
                
           //  system.debug('ApplicationName:------------->' +Application_Name__c);
              
            /*if(name.isNumeric()){
             if(u.Application_Name__c ==  'Manage Orders' || u.Application_Name__c ==  'Manage Orders - UAT' || u.Application_Name__c ==  'Manage Orders - PAT'){
                 profilename = SSO_Profile_Mapping__c.getInstance('HDMCustomerCommunityPlusLogin').Profile__c;  
                }else {
                profilename = SSO_Profile_Mapping__c.getInstance('PartnerCommunityUser').Profile__c; //default prpfile name if there is no mapping profile name found.
                }*/
                if(name.isNumeric()){
                  profilename = SSO_Profile_Mapping__c.getInstance('PartnerCommunityUser').Profile__c;
                if(conId!=null){
                    u.ContactId = conId ;
                }
                /*
                if(SSO_Profile_Mapping__c.getInstance('PartnerCommunityUser').UserRole__c!=null) {
                  String userRole = SSO_Profile_Mapping__c.getInstance('PartnerCommunityUser').UserRole__c;
                  UserRole r = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:userRole];
                  u.UserRoleId = r.Id;
                }
                */
                if(attributes.containsKey('CommunityNickname')) {
                  u.CommunityNickname = attributes.get('CommunityNickname');
                }else{
                    u.CommunityNickname = attributes.get('Username');
                }
                
                /*
                Map<String,SSO_Job_Code_Mapping__c> csJobcode = new Map<string,SSO_Job_Code_Mapping__c>();
                List<SSO_Job_Code_Mapping__c> mcs = SSO_Job_Code_Mapping__c.getall().values();
            
                for(SSO_Job_Code_Mapping__c sc:mcs){
                    if(sc.Job_Code__c!=null){               
                        csJobcode.put( sc.Job_Code__c , sc);
                    }
                }
                
                */
                if(attributes.containsKey('JobCode_CD__c')) {
                
                    u.JobCode_CD__c = attributes.get('JobCode_CD__c');
                    
                    String s= attributes.get('JobCode_CD__c');
                    if(s !=null ){
                        Boolean isJobcode = false ;
                        if(s.contains(',') ){
                            String[] jcodes = s.split(',');
                                        
                            for(String jc : jcodes ){
                                
                                String Jobc= jc.substringbefore('-').trim();
                                //System.debug('******'+Jobc);
                                if(csJobcode.Containskey(Jobc)){
                                    isJobcode = true ;
                                }
                            }
                        }else{
                            s = s.substringbefore('-').trim();
                            if(csJobcode.Containskey(s)){
                                isJobcode = true ;
                            }
                        }
                        
                       if(!isJobcode){
                             throw new JitException('JobCodeMissing'+dlrinfo);
                      }
                    }
                }
                

            }else if(DZone =='D' || DZone =='Z' || DZone =='N' ){
                

                profilename=SSO_Profile_Mapping__c.getInstance('FieldLinkUser').Profile__c; 

                /*
                saml had dealer number 
                SMZ030 > SM + 'Z' + 03 to for match > SMZ03
                SMD05W > SM + 'Z' + 05 for match > SMZ05
                SMN010 >  SM + 'Z' + 01 for match > SMZ01
                if no match found, only use first 2 char and assign to the region
                SMZ10B > SM + 'Z' + 10 no match found > SM + 'Z' and match > SMZ
                if still no match, error.
                */
                
                
                string firstTwoChar =name.left(2) ;
                if(firstTwoChar.contains('E')){
                    
                    firstTwoChar = firstTwoChar.replace('E','P');
                    
                }
                string fourfiveChar =(name.left(5)).right(2) ;

                String roleAPIname =(firstTwoChar+'Z'+fourfiveChar);
                               
                
                if(fourfiveChar!=null){
                    
                    u.Zone__c = fourfiveChar;
                }
                
                if(firstTwoChar!=null){
                   
                    u.Division = firstTwoChar.right(1);
                    u.Division__c = firstTwoChar.right(1);
                }
                
                
                if(name.length()>=6){   
                    
                    if((name.left(6)).right(1)!='0'){
                        u.District__c = (name.left(6)).right(1) ;
                    }else{
                        u.District__c = '' ;
                    }
                }

                List<UserRole> r = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:roleAPIname];
                
                if(r.size()>0){
                    u.UserRoleId = r[0].Id;
                }else{
                    roleAPIname =(firstTwoChar+'Z');
                     
                    List<UserRole> rid = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:roleAPIname];
                    if(rid.size()>0){
                        u.UserRoleId = rid[0].Id;
                    }else{                       
                        throw new JitException('UserRole is require'+dlrinfo);
                    }
                }
                
            }else{
                String pname;
                String userRole;
                if(attributes.containsKey('ApplicationRole__c') && csSupportTeamRole.containsKey(attributes.get('ApplicationRole__c'))){                    
                    pname = 'HELMSSupportTeam';
                    userRole = attributes.get('ApplicationRole__c');
                    if (userRole=='Honda_Dealer_Strategist'){
                    u.Division__c='A';
                    u.Division='A';
                    }
                    else if(userRole=='Acura_Dealer_Strategist'){
                    u.Division__c='B';
                    u.Division='B';
                    }
                    else if(userRole=='PSP_Dealer_Strategist'){
                    u.Division__c='M';
                    u.Division='M';
                    }
                    else if(userRole=='PE_Dealer_Strategist'){
                    u.Division__c='P';
                    u.Division='P';
                    }
                      
                }else if(attributes.containsKey('ApplicationRole__c') && attributes.get('ApplicationRole__c')=='IT_Admin'){
                    pname= 'HELMSITAdmin';
                   // userRole = attributes.get('ApplicationRole__c');
                    if(SSO_Profile_Mapping__c.getInstance(pname).UserRole__c =='Integration_Data_Migration') {
                        userRole = SSO_Profile_Mapping__c.getInstance(pname).UserRole__c;
                    }
                    
                }else{
                    pname= 'InternalUser' ;
                    if(SSO_Profile_Mapping__c.getInstance(pname).UserRole__c!=null) {
                        userRole = SSO_Profile_Mapping__c.getInstance(pname).UserRole__c;
                    }
                    
                }
                
                profilename=SSO_Profile_Mapping__c.getInstance(pname).Profile__c;
                
                if(userRole!=null) {                    
                  List<UserRole> r = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:userRole];
                  if(r.size()>0){
                    u.UserRoleId = r[0].Id;
                  }
                }
            }
          
        }else{
            /*
            profilename=SSO_Profile_Mapping__c.getInstance('InternalUser').Profile__c;
            if(SSO_Profile_Mapping__c.getInstance('InternalUser').UserRole__c!=null) {
                  String userRole = SSO_Profile_Mapping__c.getInstance('InternalUser').UserRole__c;
                  List<UserRole> r = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:userRole];
                  if(r.size()>0){ u.UserRoleId = r[0].Id;}
            }
            */
            
            String pname;
            String userRole;
            if(attributes.containsKey('ApplicationRole__c') && csSupportTeamRole.containsKey(attributes.get('ApplicationRole__c'))){                    
                pname = 'HELMSSupportTeam';
                userRole = attributes.get('ApplicationRole__c');
                if (userRole=='Honda_Dealer_Strategist'){
                    u.Division__c='A';
                    u.Division='A';
                    }
                    else if(userRole=='Acura_Dealer_Strategist'){
                    u.Division__c='B';
                    u.Division='B';
                    }
                    else if(userRole=='PSP_Dealer_Strategist'){
                    u.Division__c='M';
                    u.Division='M';
                    }
                    else if(userRole=='PE_Dealer_Strategist'){
                    u.Division__c='P';
                    u.Division='P';
                    }
            }else if(attributes.containsKey('ApplicationRole__c') && attributes.get('ApplicationRole__c')=='IT_Admin'){
                    pname= 'HELMSITAdmin';
                   // userRole = attributes.get('ApplicationRole__c');
                    if(SSO_Profile_Mapping__c.getInstance(pname).UserRole__c=='Integration_Data_Migration') {
                        userRole = SSO_Profile_Mapping__c.getInstance(pname).UserRole__c;
                    }
            }else{
                pname= 'InternalUser' ;
                if(SSO_Profile_Mapping__c.getInstance(pname).UserRole__c!=null) {
                    userRole = SSO_Profile_Mapping__c.getInstance(pname).UserRole__c;
                }
        }
        
            profilename=SSO_Profile_Mapping__c.getInstance(pname).Profile__c;
            if(userRole!=null) {
              
              List<UserRole> r = [SELECT Id , DeveloperName  FROM UserRole WHERE DeveloperName =:userRole];
              if(r.size()>0){
                u.UserRoleId = r[0].Id;
              }
            }
        }
           
            
        if(attributes.containsKey('Division') && attributes.get('Division')!='null') {
          u.Division = attributes.get('Division');
          u.Division__c = attributes.get('Division');
        }
        
        
        if(attributes.containsKey('ActAsDealerNumber') && attributes.get('ActAsDealerNumber')!=null && attributes.get('ActAsDealerNumber')!='null') {
          u.ActAsDealerNumber__c = Integer.valueOf(attributes.get('ActAsDealerNumber'));
        }
        
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
        /*if(attributes.containsKey('TimeZoneSidKey')) {
          u.TimeZoneSidKey = attributes.get('TimeZoneSidKey');
        } else if(create) {
          u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
        }
        */
        if(create){         
            u.TimeZoneSidKey ='America/Los_Angeles';
        }
        if(attributes.containsKey('EmailEncodingKey')) {
          u.EmailEncodingKey = attributes.get('EmailEncodingKey');
        } else if(create) {
          u.EmailEncodingKey = currentUser.EmailEncodingKey;
        }

        /*
         * If you are updating Contact or Account object fields, you cannot update the following User fields at the same time.
         * If your identity provider sends these User fields as attributes along with Contact 
         * or Account fields, you must modify the logic in this class to update either these 
         * User fields or the Contact and Account fields.
         */
        
        u.IsActive=true;
            
        if(profilename!=null) {
          //String profileId = attributes.get('User.ProfileId');
          Profile p = [SELECT Id,name FROM Profile WHERE name=:profilename];
          u.ProfileId = p.Id;
          
        }
        
        if(attributes.containsKey('JobCode_CD__c')) {
        
            u.JobCode_CD__c = attributes.get('JobCode_CD__c');
            
        }
        
        
                     
            
        if(!create) {
          update(u);
        }else{
           Insert u;
        }
               
    /*
    }Catch(Exception e){
        throw new JitException('UnKownError');
    }
    */
    
    
  }
  

  private void handleContact(boolean create, String accountId, User u, Map<String, String> attributes) {
    Contact c;
    boolean newContact = false;
    
    dlrinfo = '';
        if(attributes.containsKey('Email'))
            dlrinfo = ','+'Email-'+attributes.get('email');
        if(attributes.containsKey('DealerNumber_NUM__c'))
            dlrinfo = dlrinfo+','+'DealerNumber_NUM__c-'+attributes.get('DealerNumber_NUM__c');
        if(attributes.containsKey('Division'))
            dlrinfo = dlrinfo+ ','+'Division-'+attributes.get('Division');
        if(attributes.containsKey('Federationidentifier'))
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('Federationidentifier');
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+attributes.get('JobCode_CD__c');
        
    
    if(create) {
    
        c = new Contact();
        newContact = true;
                
      
    } else {
        /*
      if(attributes.containsKey('User.Contact')) {
        String contact = attributes.get('User.Contact');
        c = [SELECT Id, AccountId FROM Contact WHERE Id=:contact];
        if(u.ContactId != c.Id) {
          throw new JitException('Cannot change User.ContactId');
        }
      } else {
        
        //c = [SELECT Id, AccountId, email FROM Contact WHERE accountId =:accountId and LastName=:attributes.get('LastName') and email =:attributes.get('Email')];
        Id dealerAccRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
        //c = [SELECT Id, AccountId, email FROM Contact WHERE accountId =:accountId and RecordTypeId =: dealerAccRecTypeId limit 1];
        c = [SELECT Id, AccountId, email FROM Contact WHERE accountId =:accountId and LastName=:attributes.get('LastName') and email =:attributes.get('Email') and recordtypeid=:dealerAccRecTypeId limit 1];
      
        
      }
      */
      
      Id dealerAccRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
       List<Contact> cList = [SELECT Id, AccountId, email,HelmsCRMEligible_FLAG__c FROM Contact WHERE accountId =:accountId and LastName=:attributes.get('LastName') and email =:attributes.get('Email') and recordtypeid=:dealerAccRecTypeId limit 1];
     
                                                                                    
     if(cList.size()>0){
          if(!cList[0].HelmsCRMEligible_FLAG__c){
              throw new JitException('Cannot change User.ContactId'+dlrinfo);
          }
          c=cList[0];
      }else{      
        c = new Contact();
      }
    }
   
    if(attributes.containsKey('Email')) {
          c.Email = attributes.get('Email');
        }
        if(attributes.containsKey('Firstname')) {
          c.FirstName = attributes.get('Firstname');
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
    } 
    else {
      //update(c);
    }
    
  }

    private String handleAccount(boolean create, User u, Map<String, String> attributes) {
        List<Account> alist = new List<Account>();
        boolean newAccount = false;
        //system.debug('create--------'+create);
        //system.debug('Account method attributes--------'+attributes);
        
        dlrinfo = '';
        if(attributes.containsKey('Email'))
            dlrinfo = ','+'Email-'+attributes.get('email');
        if(attributes.containsKey('DealerNumber_NUM__c'))
            dlrinfo = dlrinfo+','+'DealerNumber_NUM__c-'+attributes.get('DealerNumber_NUM__c');
        if(attributes.containsKey('Division'))
            dlrinfo = dlrinfo+ ','+'Division-'+attributes.get('Division');
        if(attributes.containsKey('Federationidentifier'))
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('Federationidentifier');
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+attributes.get('JobCode_CD__c');
          
        
        Account a = new Account();
        if(attributes.containsKey('DealerNumber_NUM__c')) {
              
            //alist = [SELECT Id FROM Account WHERE DealerCode_CD__c=:attributes.get('DealerNumber_NUM__c') and (DealerAccessLevel_TXT__c='Full Access' OR DealerAccessLevel_TXT__c='Reporting Only') limit 1];
            //HPS-114 verify dreamshop flag if applicationname is Manage Orders
            if(attributes.get('applicationname') != null && attributes.get('applicationname').contains('Manage Orders')){
                alist = [SELECT Id FROM Account WHERE ID IN (select Dealer_ID__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c =:attributes.get('DealerNumber_NUM__c') AND isActive_FLG__c =true AND Division_CD__c =:attributes.get('Division') AND (Is_Dealer_DreamShop_Active__c= true)) limit 1];
            }else{
                alist = [SELECT Id FROM Account WHERE ID IN (select Dealer_ID__c from Dealer_Division__c where Dealer_ID__r.DealerCode_CD__c =:attributes.get('DealerNumber_NUM__c') AND isActive_FLG__c =true AND Division_CD__c =:attributes.get('Division') AND (Dealer_Access_Level__c ='Full Access' OR Dealer_Access_Level__c='Reporting Only')) limit 1];
        
            }
        
        }
        system.debug('alist--------'+alist);
        if(alist.size()>0){     
        }else{
            
            //throw new JitException('Your dealership is not part of the two month Lead Management Tool Pilot. Lead Management tool enrollment opportunities will be made available to all dealers late summer. More details to come. Please contact your DSM if you have any questions');
       
            if(attributes.get('applicationname') != null && attributes.get('applicationname').contains('Manage Orders')){
                throw new JitException('HDMNoAccess Level for Dealer Account'+dlrinfo);
            }else{
                throw new JitException('HELMSNoAccess Level for Dealer Account'+dlrinfo);
            }
        }
        //return a.Id;
        return alist[0].id;
    }

    /*
    private String handleAccount(boolean create, User u, Map<String, String> attributes) {
        List<Account> alist = new List<Account>();
        boolean newAccount = false;
        //system.debug('create--------'+create);
        //system.debug('Account method attributes--------'+attributes);
          
        
        Account a = new Account();
        if(attributes.containsKey('DealerNumber_NUM__c')) {
              
            alist = [SELECT Id FROM Account WHERE DealerCode_CD__c=:attributes.get('DealerNumber_NUM__c') and (DealerAccessLevel_TXT__c='Full Access' OR DealerAccessLevel_TXT__c='Reporting Only') limit 1];
        }
        system.debug('alist--------'+alist);
        if(alist.size()>0){     
        }else{
            throw new JitException('No Access Level for Dealer Account');
        }
        //return a.Id;
        return alist[0].id;
    }
    
    */
  private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    
   if(communityId != null || portalId != null) {
       
       string account = handleAccount(create, u, attributes);
   
      handleContact(create, account, u, attributes);
      handleUser(create, u, attributes, federationIdentifier, false);
    } else {
      handleUser(create, u, attributes, federationIdentifier, true);
    }
    
        
  }

  global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    
    system.debug('attributes--------'+attributes);
    User u = new User();
    
    handleJit(true, u, samlSsoProviderId, communityId, portalId,
      federationIdentifier, attributes, assertion);
    return u;
  }
  
   global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    
    system.debug('attributes--------'+attributes);
    User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
    
    handleJit(false, u, samlSsoProviderId, communityId, portalId,
      federationIdentifier, attributes, assertion);
  }

/*
  global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    
    dlrinfo = '';
        if(attributes.containsKey('Email'))
            dlrinfo = ','+'Email-'+attributes.get('email');
        if(attributes.containsKey('DealerNumber_NUM__c'))
            dlrinfo = dlrinfo+','+'DealerNumber_NUM__c-'+attributes.get('DealerNumber_NUM__c');
        if(attributes.containsKey('Division'))
            dlrinfo = dlrinfo+ ','+'Division-'+attributes.get('Division');
        if(attributes.containsKey('Federationidentifier'))
            dlrinfo = dlrinfo+','+'Federationidentifier-'+attributes.get('Federationidentifier');
        if(attributes.containsKey('JobCode_CD__c'))
            dlrinfo = dlrinfo+','+'JobCode_CD__c-'+attributes.get('JobCode_CD__c');
          
    
    system.debug('attributes--------'+attributes);
    
    list<user> usrList = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId and isactive=true];
    if(usrList.size()==0){
        throw new JitException('user is inactive'+dlrinfo);
    }else{
        handleJit(false, usrList[0], samlSsoProviderId, communityId, portalId,
      federationIdentifier, attributes, assertion);
    }
  }
  
  */
  
}