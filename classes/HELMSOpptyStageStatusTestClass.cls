@isTest
public class HELMSOpptyStageStatusTestClass {
      @isTest static void method1(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Task> tsk = new List<Task>();
        Task task = new Task(WhatId = Opp.Id, Subject = 'inbound Call');
       		tsk.add(task);
        insert task;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforTask(tsk);
        
    }
    @isTest static void method2(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Acknowledged',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Task> tsk = new List<Task>();
        Task task = new Task(WhatId = Opp.Id, Subject = 'outbound Call');
       		tsk.add(task);
        insert task;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforTask(tsk);
        
    }
    @isTest static void method3(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Assigned to Dealer',
                                          OpportunityStatus_TXT__c = 'Auto-response sent', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Task> tsk = new List<Task>();
        Task task = new Task(WhatId = Opp.Id, Subject = 'abc');
       		tsk.add(task);
        insert task;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforTask(tsk);
        
    }
    @isTest static void method4(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'In Conversation',
                                          OpportunityStatus_TXT__c = 'abc', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Task> tsk = new List<Task>();
        Task task = new Task(WhatId = Opp.Id, Subject = 'abc');
       		tsk.add(task);
        insert task;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforTask(tsk);
        
    }
	@isTest static void method5(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'In Conversation',
                                          OpportunityStatus_TXT__c = 'Note', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Event> evt = new List<Event>();
        Event event1 = new Event(WhatId = Opp.Id, Subject = 'abc', StartDatetime  = System.now(), EndDateTime = system.now()+2);
       		evt.add(event1);
        insert event1;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforEvent(evt);
        
    }
	@isTest static void method6(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Assigned to Dealer',
                                          OpportunityStatus_TXT__c = 'Note', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        List<Event> evt = new List<Event>();
        Event event1 = new Event(WhatId = Opp.Id, Subject = 'abc', StartDatetime  = System.now(), EndDateTime = system.now()+2);
       		evt.add(event1);
        insert event1;
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforEvent(evt);
        
    }  

     @isTest static void method7(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Assigned to Dealer',
                                          OpportunityStatus_TXT__c = 'Note', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        
         List <EmailMessage> emailMessage = new List <EmailMessage> ();
        EmailMessage et =new EmailMessage(RelatedToId = opp.Id) ;
        emailMessage.add(et);
        insert et;
       
        
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id, 'user has been inserted');
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforEmailMessage(EmailMessage);
        
    } 

     @isTest static void method8(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'Assigned to Dealer',
                                          OpportunityStatus_TXT__c = 'Note', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        
        //List<ContentDocumentLink> ContentDocumentLink = new List<ContentDocumentLink>();
        //ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId = Opp.Id);
       	//ContentDocumentLink.add(cdl);
         ContentVersion cv = new ContentVersion();
		cv.Title = 'Test Document';
		cv.PathOnClient = 'TestDocument.pdf';
		cv.VersionData = Blob.valueOf('Test Content');
		cv.IsMajorVersion = true;
		Insert cv;
 
		//Get Content Documents
		Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
 
		//Create ContentDocumentLink 
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = opp.Id;
		cdl.ContentDocumentId = conDocId;
		cdl.shareType = 'V';
		Insert cdl;
        List<ContentDocumentlink> cdlist = new list<ContentDocumentlink>();
        cdlist.add(cdl);
        
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id);
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforNote(cdlist);
        
    }  
     @isTest static void method9(){
        List<Account> alist = new List<Account>();
            Account ac3 = new Account(name ='testgazi', DealerCode_CD__c='30Z214', recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId()) ;
            
            insert ac3;
            ac3.name ='Grazittilav';
           
            alist.add(ac3); 
            update alist;
       
        Id conRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Contact conTestRec = new Contact(FirstName='YashLeadlav',LastName='Recordlav',Email='yashlav@testing.com',Title='Mr',
                                             AccountId=alist[0].Id,RecordTypeId=conRecordTypeId,HelmsCRMEligible_FLAG__c=false);
            insert conTestRec;
        
        Profile p = [Select Id From Profile Where Name = 'HELMS Partner Community'];
        User u = new User(firstname= 'Test',
                          lastname='User',
                          Alias='TUser',
                          email = 'test@test.com',
                          username= 'testWipro@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',
                         ContactId = conTestRec.Id);
        insert u; 
        
        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        Opportunity opp = new Opportunity( Name = 'Test Oppo', CloseDate = System.today()+10, 
                                          LeadProvider_ID__c = alist[0].Id, Email__c = 'test@test.com',ZipCode_TXT__c = '88763',
                                          First_Name_TXT__c = 'Test', Last_Name_TXT__c = 'Opp', StageName = 'In Conversation',
                                          OpportunityStatus_TXT__c = 'Abc', CreatedDate = System.today());
        
           insert opp;
        listOpp.add(opp);
        
         ContentVersion cv = new ContentVersion();
		cv.Title = 'Test Document';
		cv.PathOnClient = 'TestDocument.pdf';
		cv.VersionData = Blob.valueOf('Test Content');
		cv.IsMajorVersion = true;
		Insert cv;
 
		//Get Content Documents
		Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
 
		//Create ContentDocumentLink 
		ContentDocumentLink cdl = New ContentDocumentLink();
		cdl.LinkedEntityId = opp.Id;
		cdl.ContentDocumentId = conDocId;
		cdl.shareType = 'V';
		Insert cdl;
        List<ContentDocumentlink> cdlist = new list<ContentDocumentlink>();
        cdlist.add(cdl);
        
        System.runAs(u) {
        System.assertEquals(UserInfo.getUserId(), u.Id);
        
        }
        HELMSOpptystageandstatusonTaskandevent.updateopptyStageandStatusforNote(cdlist);
        
    }  
  
}