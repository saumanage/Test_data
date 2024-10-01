@IsTest
public class HELMSSSOCustomJITHandlerPartnerTest{
    public static testMethod void testSSOMsgMethod() {
    
       
        Test.StartTest();
      
        PageReference pageRef = Page.HondaSingleSignOnErrorPage; // Add your VF page Name here
        pageRef.getParameters().put('ErrorDetails', 'HELMSSSOCustomJITHandlerInternal : Required');
        
        Test.setCurrentPage(pageRef);
        
        HELMSSSOCustomJITHandlerPartner pc = new HELMSSSOCustomJITHandlerPartner();
        pc.jiterrolog = 'HDMNoAccess Level for Dealer Account';
        pc.createLog();
        
        Test.StopTest();
    
    }
    public static testMethod void testSSOMsgMethod2() {
    
       
        Test.StartTest();
      
        PageReference pageRef = Page.HondaSingleSignOnErrorPage; // Add your VF page Name here
        pageRef.getParameters().put('ErrorDetails', 'HELMSSSOCustomJITHandlerInternal : NoAccess');
        
        Test.setCurrentPage(pageRef);
        
        HELMSSSOCustomJITHandlerPartner pc = new HELMSSSOCustomJITHandlerPartner();
        
        
        Test.StopTest();
    
    }
    public static testMethod void testSSOMsgMethod3() {
    
       
        Test.StartTest();
      
        PageReference pageRef = Page.HondaSingleSignOnErrorPage; // Add your VF page Name here
        pageRef.getParameters().put('ErrorDetails', 'HELMSSSOCustomJITHandlerInternal : SSORequired');
        
        Test.setCurrentPage(pageRef);
        
        HELMSSSOCustomJITHandlerPartner pc = new HELMSSSOCustomJITHandlerPartner();
        
        
        Test.StopTest();
    
    }
}