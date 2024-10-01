/****************************************************************************** 
File Name:      HELMSUserPermissionsetGroupAssignment   
Created On:     7th June, 2021
Created By:     Bandi Sujatha, Appirio
Test Classes:   HELMSUserPGAssignmentTest        
HELMS Jira Story: 
===============================================================================
Modification Log: 
*******************************************************************************
*/
@isTest
//Assigning permissionset groups based on profiles
public class HELMSUserPGAssignmentTest {
//Retriving profiles for SSO mapping    
 	@isTest public static void HELMSUserPermissionsetGrouptest(){
        Integer level=Null;
        String pid =[Select Id from Profile Where name ='HELMS Standard User'].Id ;
        String pid3 =[Select Id from Profile Where name ='HELMS Field User'].Id ;
        String p2 = [select id from profile where name='HELMS Partner Community'].id;
        List<SSO_Profile_Mapping__c> slist = new List<SSO_Profile_Mapping__c>();
        
        SSO_Profile_Mapping__c s2= new SSO_Profile_Mapping__c(name='InternalUser', ProfileId__c=pid, Profile__c='HELMS Standard User',
                                                              UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
        
        SSO_Profile_Mapping__c s3= new SSO_Profile_Mapping__c(name='FieldLinkUser', ProfileId__c=pid3, Profile__c='HELMS Field User',
                                                              UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
        SSO_Profile_Mapping__c s4= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p2, Profile__c='HELMS Partner Community', 
                                                                 UserRole__c='Dealer_Salesxx', username__c='@honda.ahmdevTest');                                                      
        slist.add(s2);
        slist.add(s3);
        slist.add(s4);
        insert slist;
        
        SSO_Job_Code_Mapping__c s = new SSO_Job_Code_Mapping__c();
        s.ApplicationRole__c ='test';
        s.Name = 'test';
        s.Level__c =1;
        s.Job_Code__c ='st';
        
        insert s;
        
        SSO_Job_Code_Mapping__c s22 = new SSO_Job_Code_Mapping__c();
        s22.ApplicationRole__c ='test';
        s22.Name = 'tes';
        s22.Is_Required_Tableau_Permission__c = true;
        s22.Level__c =2;
        s22.Job_Code__c ='tes';
        
        insert s22;
        
        User useradmin = [Select Id, UserRoleId from User where id=: userinfo.getUserId()];  
            
    
       User user_1 = new User( 
            Email = 'Test1233username@gmail.com',
            ProfileId = pid, 
            UserName = 'Test3211name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            //  ContactId = conTestRec.Id,
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname',
            JobCode_CD__c ='tes,st',
            ApplicationRole_NM__c ='role'
        );
        insert user_1;
        user_1.JobCode_CD__c ='st';
        user_1.ApplicationRole_NM__c ='role1';
        update user_1;
        
        UserRole ur ;
        User user_11;
                
        user_11 = new User( 
        //UserRoleId = ur.Id,
                Email = 'Test1233username@gmail.com',
                ProfileId = pid3, 
                UserName = 'Test123456name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname',
                JobCode_CD__c ='tes, st',
                ApplicationRole_NM__c ='role'
            );
            insert user_11;
            
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456', ownerid= useradmin.id 
                                        );
        
        List<Dealer_Division__c> dlist = new List<Dealer_Division__c>();
        Dealer_Division__c d;
            
        //System.runAs(user_11) {
            insert accTestRec;
        
            d = new Dealer_Division__c(Dealer_ID__c=accTestRec.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
        
            dlist.add(d);
        
            insert dlist; 
        //}
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                         AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
        //System.runAs(user_11) {
        insert conTestRec;
      // }
       
        User user_pat = new User( 
            Email = 'Test1233username@gmail.com',
            ProfileId = p2, 
            UserName = 'Test123456namepat@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname',
            contactid= conTestRec.id,
            JobCode_CD__c ='tes, st',
            ApplicationRole_NM__c ='role',
            Division ='P',
            Division__c = 'P',
            DealerNumber_NUM__c = '123456'
        );
        insert user_pat;
        
           
        
        Test.startTest();
    } 
  //Retriving profiles for SSO mapping
	 @isTest  public static  void HELMSUserPermissionsetGrouptest2(){
        Integer level=Null;
        String pid =[Select Id from Profile Where name ='HELMS Standard User'].Id ;
        String pid3 =[Select Id from Profile Where name ='HELMS Field User'].Id ;
        String p2 = [select id from profile where name='HELMS Partner Community'].id;
        List<SSO_Profile_Mapping__c> slist = new List<SSO_Profile_Mapping__c>();
        
        SSO_Profile_Mapping__c s2= new SSO_Profile_Mapping__c(name='InternalUser', ProfileId__c=pid, Profile__c='HELMS Standard User',
                                                              UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
        
        SSO_Profile_Mapping__c s3= new SSO_Profile_Mapping__c(name='FieldLinkUser', ProfileId__c=pid3, Profile__c='HELMS Field User',
                                                              UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
        SSO_Profile_Mapping__c s4= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p2, Profile__c='HELMS Partner Community', 
                                                                 UserRole__c='Dealer_Salesxx', username__c='@honda.ahmdevTest');                                                      
        slist.add(s2);
        slist.add(s3);
        slist.add(s4);
        insert slist;
        
        SSO_Job_Code_Mapping__c s = new SSO_Job_Code_Mapping__c();
        s.ApplicationRole__c ='test';
        s.Name = 'test';
        s.Level__c =1;
        s.Job_Code__c ='st';
        
        insert s;
        
        SSO_Job_Code_Mapping__c s22 = new SSO_Job_Code_Mapping__c();
        s22.ApplicationRole__c ='test';
        s22.Name = 'tes';
        s22.Is_Required_Tableau_Permission__c = true;
        s22.Level__c =2;
        s22.Job_Code__c ='tes';
        
        insert s22;
        
        User useradmin = [Select Id, UserRoleId from User where id=: userinfo.getUserId()];  
            
    
       User user_1 = new User( 
            Email = 'Test1233username@gmail.com',
            ProfileId = pid, 
            UserName = 'Test3211name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            //  ContactId = conTestRec.Id,
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname',
            JobCode_CD__c ='tes,st',
            ApplicationRole_NM__c ='role'
        );
        insert user_1;
        user_1.JobCode_CD__c ='st';
        user_1.ApplicationRole_NM__c ='role1';
        update user_1;
        
        UserRole ur ;
        User user_11;
                
        user_11 = new User( 
        //UserRoleId = ur.Id,
                Email = 'Test1233username@gmail.com',
                ProfileId = pid3, 
                UserName = 'Test123456name@gmail.com', 
                Alias = 'Test',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'ISO-8859-1',
                LocaleSidKey = 'en_US', 
                LanguageLocaleKey = 'en_US',
                PortalRole = 'Manager',
                FirstName = 'Firstname',
                LastName = 'Lastname',
                JobCode_CD__c ='tes, st',
                ApplicationRole_NM__c ='role'
            );
            insert user_11;
            
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456', ownerid= useradmin.id 
                                        );
        
        List<Dealer_Division__c> dlist = new List<Dealer_Division__c>();
        Dealer_Division__c d;
            
       // System.runAs(user_11) {
            insert accTestRec;
        
            d = new Dealer_Division__c(Dealer_ID__c=accTestRec.id , Dealer_Access_Level__c = 'Reporting Only' , isActive_FLG__c = true, Division_CD__c='P');
        
            dlist.add(d);
        
            insert dlist; 
       // }
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                         AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
        //System.runAs(user_11) {
        insert conTestRec;
       //}
       
        User user_pat = new User( 
            Email = 'Test1233username@gmail.com',
            ProfileId = p2, 
            UserName = 'Test123456namepat@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            PortalRole = 'Manager',
            FirstName = 'Firstname',
            LastName = 'Lastname',
            contactid= conTestRec.id,
            JobCode_CD__c ='tes, st',
            ApplicationRole_NM__c ='role',
            Division ='P',
            Division__c = 'P',
            DealerNumber_NUM__c = '123456'
        );
        insert user_pat;
        
        //System.runAs(user_11) {
          user_pat.JobCode_CD__c ='st, tes';
       
        // update user_pat;
      // }
     
    } 	
    @isTest
    static  void testCreateAndUpdateUser() {
        String pid =[Select Id from Profile Where name ='HELMS Standard User'].Id ;
        String pid2 =[Select Id from Profile Where name ='System Administrator'].Id ;
        String pid3 =[Select Id from Profile Where name ='HELMS Field User'].Id ;
        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pid2, country='United States',IsActive =true,UserRoleid=r.id,
                             timezonesidkey='America/Los_Angeles', username='testerhelmsdealer@noemail.com');
        
        insert user;
        
        Id p2 = [select id from profile where name='HELMS Partner Community'].id;
         User user2 = new User(alias = 'test1223', email='te22st123@noemail.com',
                             emailencodingkey='UTF-8', lastname='T22esting', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pid, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='testerhel22msdealer@noemail.com');
        
        insert user2;
        
        
                                        
        System.runAs(user) {
            
            List<SSO_Profile_Mapping__c> slist = new List<SSO_Profile_Mapping__c>();
            SSO_Profile_Mapping__c s= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p2, Profile__c='HELMS Partner Community', 
                                                                 UserRole__c='Dealer_Salesxx', username__c='@honda.ahmdevTest');
            SSO_Profile_Mapping__c s2= new SSO_Profile_Mapping__c(name='InternalUser', ProfileId__c=pid, Profile__c='HELMS Standard User',
                                                                  UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
            
             SSO_Profile_Mapping__c s3= new SSO_Profile_Mapping__c(name='FieldLinkUser', ProfileId__c=pid3, Profile__c='HELMS Field User',
                                                                  UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
            slist.add(s);
            slist.add(s2);
            slist.add(s3);
            insert slist;
            
            List<SSO_Job_Code_Mapping__c> slist2 = new List<SSO_Job_Code_Mapping__c>();
            SSO_Job_Code_Mapping__c cj = new SSO_Job_Code_Mapping__c(name='test', Job_Code__c='WPPM15 - MARINE GENERAL MGMT', Level__c=1 , Permission_set_Group__c='Dealer_Management', Persona__c ='Dealer management');
            SSO_Job_Code_Mapping__c cj2 = new SSO_Job_Code_Mapping__c(name='test2',ApplicationRole__c ='IT_Admin' , Permission_set_Group__c='IT_Admin');
         //  SSO_Job_Code_Mapping__c cj3 = new SSO_Job_Code_Mapping__c(name='test', Job_Code__c='WPPM15 - MARINE GENERAL MGMT2', Level__c=1 , Permission_set_Group__c='Dealer_Management', Persona__c ='Dealer management');
            
            slist2.add(cj);
            slist2.add(cj2);
            insert slist2;
            List<Account> alist = new List<Account>();
            Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='301514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac); 
            Account ac4 = new Account(name ='Grazitti' ,DealerCode_CD__c='305514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac4); 
            Account ac2 = new Account(name ='Grazitti' ,DealerCode_CD__c='30A514', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac2); 
            Account ac3 = new Account(name ='Grazitti' ,DealerCode_CD__c='30Z514',recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac3); 
            insert alist; 
            
            List<Dealer_Division__c> dlist = new List<Dealer_Division__c>();
            Dealer_Division__c d = new Dealer_Division__c(Dealer_ID__c=ac.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
            Dealer_Division__c d2 = new Dealer_Division__c(Dealer_ID__c=ac4.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
            Dealer_Division__c d3 = new Dealer_Division__c(Dealer_ID__c=ac2.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
            Dealer_Division__c d4 = new Dealer_Division__c(Dealer_ID__c=ac3.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
            dlist.add(d); 
            dlist.add(d2);
            dlist.add(d3);
            dlist.add(d4);
            
            insert dlist; 
            
            Contact con = new Contact(LastName ='asdjhgasjhd', firstname ='asdjhgasjhd', email ='askdasgdhgas@sdjkfd.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con; 
            
            Map<string,String> tempUser=  new Map<String, String>
            {'language' => 'en_US' ,
                'Username'=>'askdasgdhgas@sdjkfd.com.ahmdev' ,
                'DealerNumber_NUM__c'=>'305514' ,
                'Firstname'=>'asdjhgasjhd',
                'LastName'=>'asdjhgasjhd',
                'Email'=>'askdasgdhgas@sdjkfd.com',
                'email'=>'askdasgdhgas@sdjkfd.com',
                'Alias'=>'asdhagsd',
                'CommunityNickname'=>'asdjasgdjhahsdhasd',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                'ProfileId'=>pid,
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'WPPM15 - MARINE GENERAL MGMT,WPPM15 - MARINE GENERAL MGMT2',
                'LanguageLocaleKey'=>'en_US',
                'UserRoleId'=>r.Id
                }; 
                    
          Network cid =[SELECT Id from Network limit 1];        
            
            String uid = user.id;
            
            Test.startTest();
           
            HELMSSSOCustomJITHandlerInternal handler = new HELMSSSOCustomJITHandlerInternal();
            //handler.createUser(null, cid.id,null,'', tempUser ,null);
            //handler.updateUser(uid, null , null, null, 'iNg_30Z514_HELMS33', tempUser, null) ;
            
            
             Map<string,String> tempUserc=  new Map<String, String>
            {'language' => 'en_US' ,
                'Username'=>'askda@sdjkfd.com.ahmdev' ,
                'DealerNumber_NUM__c'=>'301514' ,
                'Firstname'=>'asdjhgasjhd',
                'LastName'=>'asdjhgasjhd',
                'Email'=>'askdasgdhgas@sdjkfd.com',
                /* 'email'=>'askdasgdhgas@sdjkfd.com',
                'Alias'=>'asdhagsd',
               'CommunityNickname'=>'asdjasgdjhahsdhasd',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                'ProfileId'=>pid,
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01', */
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'WPPM15 - MARINE GENERAL MGMT,WPPM15 - MARINE GENERAL MGMT2',
                'CompanyName'=>'HELMS',
                'UserRoleId'=>r.Id
                }; 
                
            handler.createUser(null, cid.id,null,'', tempUserc ,null);
            
                  Map<string,String> tempUser2=  new Map<String, String>
            {'language' => 'en_US' ,
                'Username'=>'askda2@sdjkfd.com.ahmdev' ,
                'DealerNumber_NUM__c'=>'30A514' ,
                'Firstname'=>'asdjhgasjhd',
                'LastName'=>'asdjhgasjhd',
                'Email'=>'askdasgdhgas@sdjkfd.com',
                /* 'email'=>'askdasgdhgas@sdjkfd.com',
                'Alias'=>'asdhagsd',
               'CommunityNickname'=>'asdjasgdjhahsdhasd',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                'ProfileId'=>pid,
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01', */
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'WPPM15 - MARINE GENERAL MGMT,WPPM15 - MARINE GENERAL MGMT2',
                'CompanyName'=>'HELMS',
                'UserRoleId'=>r.Id
                }; 
                
            handler.createUser(null, cid.id,null,'', tempUser2 ,null);
            
            Map<string,String> tempUser3=  new Map<String, String>
            {'language' => 'en_US' ,
                'Username'=>'iNg_30Z514_HELMS33' ,
                'DealerNumber_NUM__c'=>'30Z514' ,
                'Firstname'=>'asdjhgasjhd',
                'LastName'=>'asdjhgasjhd',
                'Email'=>'askdasgdhgas@sdjkfd.com',
                /* 'email'=>'askdasgdhgas@sdjkfd.com',
                'Alias'=>'asdhagsd',
               'CommunityNickname'=>'asdjasgdjhahsdhasd',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                
                'ProfileId'=>pid,
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01', */
                'Division'=>'P',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                'email'=>'askdasgdhgas@sdjkfd.com',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'WPPM15 - MARINE GENERAL MGMT',
                'CompanyName'=>'HELMS',
                'UserRoleId'=>r.Id
                }; 
                
            try{            
                handler.createUser(null, null,null,'', tempUser3 ,null);
            }catch(exception e){}
                
            Map<string,String> tempUserdum=  new Map<String, String>
            {'Firstname'=>'asdjhgasjhd',
                'LastName'=>'asdjhgasjhd',
                'Email'=>'askdasgdhgas@sdjkfd.com'                
                }; 
                       
                handler.updateUser(user2.id, null , null, null, null, tempUserdum, null) ;
            
            Test.stopTest();
        }
        
    }
  @isTest
    public static void HELMSUserPermissionsetGrouptest4(){
        
        String pid =[Select Id from Profile Where name ='HELMS Standard User'].Id ;
       
        SSO_Profile_Mapping__c s2= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=pid, Profile__c='HELMS Standard User',
                                                              UserRole__c='IT_Admin', username__c='@honda.ahmdevTest');
               
      
        insert s2;
        
        SSO_Job_Code_Mapping__c s = new SSO_Job_Code_Mapping__c();
        s.ApplicationRole__c ='test';
        s.Name = 'test';
        s.Level__c =1;
        s.Job_Code__c ='1234';
        
        insert s;
        
        SSO_Job_Code_Mapping__c jb2 = new SSO_Job_Code_Mapping__c();
        jb2.ApplicationRole__c ='test2';
        jb2.Name = 'test2';
        jb2.Level__c =1;
        jb2.Job_Code__c ='567';
        
        insert jb2;
        
        
       Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='1234', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
        
       insert ac;
            
          
       Dealer_Division__c d = new Dealer_Division__c(Dealer_ID__c=ac.id , Dealer_Access_Level__c = 'Full Access' , isActive_FLG__c = true, Division_CD__c='P');
          
       insert d;
          
          
       User user_1 = new User( 
            Email = 'Test1233username@gmail.com',
            ProfileId = pid, 
            UserName = 'Test3211name@gmail.com', 
            Alias = 'Test',
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'ISO-8859-1',
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US',
            FirstName = 'Firstname',
            LastName = 'Lastname',
            JobCode_CD__c ='1234',
            Division__c = 'P',
            DealerNumber_NUM__c = '1234',
            ApplicationRole_NM__c ='role'
        );
        
        insert user_1;
        
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer randomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        System.runAs(uu) {
               
        user_1.JobCode_CD__c ='1234';
        update user_1;
        
        user_1.JobCode_CD__c ='567';
        update user_1;
        
        
        }
        
        
    }
    

}