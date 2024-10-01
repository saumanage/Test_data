@IsTest
public class HPDSSOCustomJITHandlerTest {
    
static testMethod void testCreateAndUpdateUser() {

        String pid2 =[Select Id from Profile Where name ='System Administrator' LIMIT 1].Id ;

        UserRole r = new UserRole(DeveloperName = 'HELMS_Standard', Name = 'HELMS_Standard');
        insert r;
    
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pid2, country='United States',IsActive =true,UserRoleid=r.id,
                             timezonesidkey='America/Los_Angeles', username='tester253245helmsdealer@noemail.com',
                            CommunityNickname='testerhelmsdealer@noemail.com');
        
        insert user;
    
                          
        System.runAs(user) {
            
            Id p2 = [select Id from profile where name='HELMS Partner Community'].Id;
            List<SSO_Profile_Mapping__c> slist = new List<SSO_Profile_Mapping__c>();
            SSO_Profile_Mapping__c s= new SSO_Profile_Mapping__c(name='PartnerCommunityUser', ProfileId__c=p2, Profile__c='HELMS Partner Community', 
                                                                 UserRole__c='Dealer_Salesxx');
            slist.add(s);
            insert slist;
            
            List<SSO_Job_Code_Mapping__c> slist2 = new List<SSO_Job_Code_Mapping__c>();
            SSO_Job_Code_Mapping__c cj = new SSO_Job_Code_Mapping__c(name='test5', Job_Code__c='PA0022 - PARTS MANAGER', Permission_set_Group__c='DreamShop_Order_Managemnt', Persona__c ='DreamShop User');
            slist2.add(cj);            
            insert slist2;
            
            List<Account> alist = new List<Account>();
            Account ac = new Account(name ='Grazitti' ,DealerCode_CD__c='HRC000', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            alist.add(ac); 
            
            insert alist; 
            
            List<Dealer_Division__c> dlist = new List<Dealer_Division__c>();
            Dealer_Division__c d = new Dealer_Division__c(Dealer_ID__c=ac.id , Is_Dealer_DreamShop_Active__c = true, isActive_FLG__c = true, Division_CD__c='9');
           
            dlist.add(d); 
            
            insert dlist; 
            
            Contact con = new Contact(LastName ='asdjhgasjhd', FirstName ='asdjhgasjhd', email ='lavanyahrc@gmail.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con; 
            
             Contact con1 = new Contact(LastName ='bijayhrc', FirstName ='lavanyahrc', email ='lavanyahrc123@gmail.com', recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId(),AccountId = ac.Id);
            insert con1; 
            
   			User user2 = new User(alias = 'test1223', email='te22st123@noemail.com',
                             emailencodingkey='UTF-8', lastname='T22esting', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p2, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='testerhel2265msdeale12r@noemail.com', Division__c = '9',
                               CommunityNickname='testerhel22msdealer@noemail.com', contactId= con.id, DealerNumber_NUM__c = 'HRC000', JobCode_CD__c = 'PA0022 - PARTS MANAGER' );
        
			insert user2;
       
            
            Map<string,String> tempUser=  new Map<String, String>
           
            {'language' => 'en_US' ,
                'UserName'=>'hrclavanyahrc123436756',
                'DealerNumber_NUM__c'=>'HRC000' ,
                'FirstName'=>'asdjhgasjhd12343',
                'LastName'=>'asdjhgasjhd1234',
                'Email'=>'lavanyahrc@gmail.com',
                'Alias'=>'asdhagsd',
                'CommunityNickname'=>'lavanya0121hrc',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                'ProfileId'=>p2,
                'Division'=>'9',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'PA0022 - PARTS MANAGER',
                'LanguageLocaleKey'=>'en_US'
                }; 
                    
          Network cid =[SELECT Id from Network where Name = 'HRC' limit 1];        
            
            String uid = user.id;
            
            Test.startTest();
            HPDSSOCustomJITHandler handler = new HPDSSOCustomJITHandler();
            
               Map<string,String> tempUserc=  new Map<String, String>
               {'language' => 'en_US' ,
                'UserName'=>'bijaykumarsahoohrc23445',
                'DealerNumber_NUM__c'=>'HRC000' ,
                'FirstName'=>'asdjhgasjhd12343',
                'LastName'=>'asdjhgasjhd1234',
                'Email'=>'lavanyahrc123@gmail.com',
               // 'Alias'=>'asdhagsd',
                'CommunityNickname'=>'lavanya0121123hrc',
                'TimeZoneSidKey'=>'America/Los_Angeles',
                //'LocaleSidKey'=>'en_US',
                'EmailEncodingKey'=>'UTF-8',
                'Phone'=>'1234567890',
                'Title'=>'helms',
                //'ProfileId'=>p2, 
                'Division'=>'9',
                'ActAsDealerNumber'=>'123',
                'District'=>'Dist',
                'Zone'=>'01',
                'ApplicationRole__c'=>'xyz',
                'JobCode_CD__c'=>'PA0022 - PARTS MANAGER',
                //'LanguageLocaleKey'=>'en_US',
                'ApplicationRole_NM__c'=>'HRC'
                };
                 
               handler.createUser(null, cid.id,null,'', tempUserc ,null);
            
                
               try{            
                handler.createUser(null, null,null,'', tempUserc ,null);
            }catch(exception e){}
            
            //handler.updateUser(user2.id, null,null,'', tempUserc ,null);
            
          /*     Map<string,String> tempUserdum=  new Map<String, String>
            {'Firstname'=>'asdjhgasjhd1',
                'LastName'=>'asdjhgasjhd23',
                'Email'=>'askdasgdhga12s@sdjktfd.com'      
                }; 
                       
                handler.updateUser( user3.id , null, null, null, '', tempUserdum, null) ;*/
            
             Test.stopTest();
        }
        
    }
    
    static testMethod void testupdateUser() {
        Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Test Account1234',RecordTypeId=dealerAccRecTypeId,
                                         DealerCode_CD__c='123456'
                                        );
        insert accTestRec;
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Contact conTestRec = new Contact(FirstName='YashLead123456788',LastName='Record123412345',Email='yash12534@testing.com',Title='Mr',
                                         AccountId=accTestRec.Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
        
        conTestRec.HelmsCRMEligible_FLAG__c=true;
          
}   
}