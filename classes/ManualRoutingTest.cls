@isTest
public class ManualRoutingTest {
   

   @isTest
    static void manualRoutingTestMethod1(){
        
         Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308',
                                         HondaDigitalSolutions_FLG__c = true
                                        );
        insert accTestRec;
        Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Account accTestRec1 = new Account(Name='abcd', RecordTypeId=providerAccRecTypeId
                                        );
         insert accTestRec1;
        //Set<id> oppList= new Set<id>();
        //set<id> leadList=new set<id>();
 
        
         //Set<id> ddIds= new Set<id>();
       
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
     Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
         o.LeadProvider_ID__c=accTestRec.id;
        o.SendOnlyToUrbanScience__c = false;
          o.Routable_FLG__c = false; 
        o.Routing_Status__c = 'Success';
        o.Routing_Success_Date_Time__c = system.now(); 
        o.Urban_Science_Routing_Response_Message__c = 'abcd';
        o.Routing_Status_Message__c = 'abcd'; 
        
            
        
        insert o;
      
       oppToUpdate.add(o);  
        
          Test.startTest();
        List<String> ss=new List<String>();
        ss.add(oppToUpdate[0].Id);
        
        ManualRouting.FlowOutput flow=new ManualRouting.FlowOutput();
        flow.listOfOppIds= ss;
                
        ManualRouting.opportunityRoutingFlow(new List<ManualRouting.FlowOutput>{flow});
        
               Test.stopTest();
    }
    @isTest
    static void manualRoutingTestMethod2(){
        
        
         Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308',
                                         HondaDigitalSolutions_FLG__c = false
                                        );
        insert accTestRec;
        
         Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Account accTestRec1 = new Account(Name='abcd',RecordTypeId=providerAccRecTypeId, Routable_FLG__c = false
                                        );
        
         insert accTestRec1;
        
            
        //Set<id> oppList= new Set<id>();
        //set<id> leadList=new set<id>();
        
         //Set<id> ddIds= new Set<id>();
       
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
     Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
        o.LeadProvider_ID__c=accTestRec.id;
        o.SendOnlyToUrbanScience__c = false;
          o.Routable_FLG__c = false; 
        o.Routing_Status__c = 'Success';
        o.Routing_Success_Date_Time__c = system.now(); 
        o.Urban_Science_Routing_Response_Message__c = 'abcd';
        o.Routing_Status_Message__c = 'abcd'; 
        
            
        
        insert o;
      
       oppToUpdate.add(o);  

          Test.startTest();
        List<String> ss=new List<String>();
        ss.add(oppToUpdate[0].Id);
        
        ManualRouting.FlowOutput flow=new ManualRouting.FlowOutput();
        flow.listOfOppIds= ss;
                
        ManualRouting.opportunityRoutingFlow(new List<ManualRouting.FlowOutput>{flow});
        
               Test.stopTest();
    } 
   @isTest
    static void manualRoutingTestMethod3(){
        
        
         Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308'
                                        );
        insert accTestRec;
        
         Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Account accTestRec1 = new Account(Name='abcd',RecordTypeId=providerAccRecTypeId,Routable_FLG__c = false , Send_to_Urban_Science_Flag__c = true 
                                        );
        
         insert accTestRec1;
        
            
        //Set<id> oppList= new Set<id>();
        //set<id> leadList=new set<id>();
        
         //Set<id> ddIds= new Set<id>();
       
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
     Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
        o.LeadProvider_ID__c=accTestRec.id;
        o.SendOnlyToUrbanScience__c = true;
          o.Routable_FLG__c = false; 
        o.Routing_Status__c = 'Success';
        o.Routing_Success_Date_Time__c = system.now(); 
        o.Urban_Science_Routing_Response_Message__c = 'abcd';
        o.Routing_Status_Message__c = 'abcd'; 
        
            
        
        insert o;
      
       oppToUpdate.add(o);  
        

          Test.startTest();
        List<String> ss=new List<String>();
        ss.add(oppToUpdate[0].Id);
        
        ManualRouting.FlowOutput flow=new ManualRouting.FlowOutput();
        flow.listOfOppIds= ss;
                
        ManualRouting.opportunityRoutingFlow(new List<ManualRouting.FlowOutput>{flow});
        
               Test.stopTest();
    }
     @isTest
    static void manualRoutingTestMethod4(){
   
         Id dealerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account accTestRec = new Account(Name='Chapman Honda',RecordTypeId=dealerAccRecTypeId,DealerCode_CD__c='123456',Contact_Key__c='E150363308', HondaDigitalSolutions_FLG__c = true
                                        );
        insert accTestRec;
        
         Id providerAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Account accTestRec1 = new Account(Name='abcd',RecordTypeId=providerAccRecTypeId,Routable_FLG__c = true , Send_to_Urban_Science_Flag__c = false 
                                        );
        
         insert accTestRec1;
       
         Id vendorAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        Account accVendor = new Account(Name='Hello vendor',RecordTypeId=vendorAccRecTypeId,
                                  DealerCode_CD__c='1234Z',HondaDigitalSolutions_FLG__c=true,
                                 Routable_FLG__c=true);
        insert accvendor;
        Id oppHondaRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Honda Opportunity').getRecordTypeId();
        
    
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
     Opportunity o = new Opportunity();
        o.name='Test';
        o.First_Name_TXT__c='OppTest';
        o.Last_Name_TXT__c='OppKiran';
        o.Email__c='kiransiddipeta1199@gmail.com';
        o.StageName='Assigned to Dealer';
        o.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o.CloseDate= date.parse('10/10/2021');
        o.ZipCode_TXT__c='59505';
        o.PreferredDealerAccount_TXT__c=accTestRec.id;
        o.LeadProvider_ID__c=accTestRec.id;
        o.SendOnlyToUrbanScience__c = true;
          o.Routable_FLG__c = true; 
        o.Routing_Status__c = 'Success';
        o.Routing_Success_Date_Time__c = system.now(); 
        o.Urban_Science_Routing_Response_Message__c = 'abcd';
        o.Routing_Status_Message__c = 'abcd'; 
        o.recordtypeID=oppHondaRecTypeId;
        o.Division_CD__c = 'A';
        o.SubDiv_TXT__c='Honda';

        insert o;
        
        //bj
        Opportunity o1 = new Opportunity();
        o1.name='Test';
        o1.First_Name_TXT__c='OppTest';
        o1.Last_Name_TXT__c='OppKiran';
        o1.Email__c='kiransiddipeta1199@gmail.com';
        o1.StageName='Assigned to Dealer';
        o1.OpportunityStatus_TXT__c='Assigned/Routed to Dealer';
        o1.CloseDate= date.parse('10/10/2021');
        o1.ZipCode_TXT__c='59505';
        o1.PreferredDealerAccount_TXT__c=accTestRec.id;
        o1.LeadProvider_ID__c=accTestRec.id;
        o1.SendOnlyToUrbanScience__c = true;
          o1.Routable_FLG__c = False; 
        o1.Routing_Status__c = 'Success';
        o1.Routing_Success_Date_Time__c = system.now(); 
        o1.Urban_Science_Routing_Response_Message__c = 'abcd';
        o1.Routing_Status_Message__c = 'abcd'; 
        o1.recordtypeID=oppHondaRecTypeId;
        o1.Division_CD__c = 'A';
        o1.SubDiv_TXT__c='Honda';

        insert o1;

     
      Dealer_Division__c dealerD = new Dealer_Division__c(First_Name_TXT__c='Test', 
                                                            InternetCertified_FLG__c=true, 
                                                            Dealer_ID__c=accTestRec.Id,
                                                            Division_CD__c = 'A' ,
                                                            SubDiv_TXT__c='Honda',
                                                           isActive_FLG__c=true);
      insert dealerD;
        

      
      CRM_System__c crmSystem = new CRM_System__c(Name='Test crm system',Vendor_ID__c=accVendor.Id,ISActive_FLG__c=true,Division_CD__c ='A');
      insert crmSystem;
      

        
      Dealer_Participation__c dealerParticipationList = new Dealer_Participation__c(DealerAccount_ID__c =accTestRec.Id,Division__c='A',
                                                               CRM_System__c = crmSystem.Id, LeadReceivingStartDate_DT__c=System.NOW()-12,Dealer_Subdivision__c =dealerD.id);
       
      insert dealerParticipationList;
        

      
      oppToUpdate.add(o);
 
        

       Test.startTest();
      
        List<String> ss=new List<String>();
        ss.add(oppToUpdate[0].Id);
        
        ManualRouting.FlowOutput flow=new ManualRouting.FlowOutput();
        flow.listOfOppIds= ss;
                
        ManualRouting.opportunityRoutingFlow(new List<ManualRouting.FlowOutput>{flow});
        
       Test.stopTest();
    }
    
    
    
 
}