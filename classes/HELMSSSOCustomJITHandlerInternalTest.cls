@IsTest
public class HELMSSSOCustomJITHandlerInternalTest{
    static testMethod void testCreateAndUpdateUser() {
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
           SSO_Job_Code_Mapping__c cj3 = new SSO_Job_Code_Mapping__c(name='test', Job_Code__c='WPPM15 - MARINE GENERAL MGMT2', Level__c=1 , Permission_set_Group__c='Dealer_Management', Persona__c ='Dealer management');
            
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
    
    static testMethod void testupdateUser() {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account123',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456'
                                        );
        insert accTestRec;
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead1234',LastName='Record1234',Email='yash1234@testing.com',Title='Mr',
                                         AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
       // insert conTestRec;
        
        conTestRec.HelmsCRMEligible_FLAG__c=true;
        //update conTestRec;           
}
    static testMethod void testupdateUser1() {
        
            //HELMSSSOCustomJITHandlerInternal.handleUser('Division');  
   }
    
}