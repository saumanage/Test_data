@isTest
public class loadingRDRTest {
    
    @isTest
    static void updateRDR(){
        List<RDR_Sales__c> rdrList = new List<RDR_Sales__c>();
        RDR_Sales__c rdrRec = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='A',
                                               Customer_First_Name_NUM__c='Kiran301',New_Dealer_Number_From_Buy_Sell__c='90009');
        insert rdrRec;
        
         RDR_Sales__c rdrRec1 = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='A',
                                               Customer_First_Name_NUM__c='Kiran302',New_Dealer_Number_From_Buy_Sell__c='90009');
        insert rdrRec1;
        
           RDR_Sales__c rdrRec2 = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='B',
                                               Customer_First_Name_NUM__c='Kiran301',New_Dealer_Number_From_Buy_Sell__c='90009');
        insert rdrRec2;
        
         RDR_Sales__c rdrRec3 = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='B',
                                               Customer_First_Name_NUM__c='Kiran302',New_Dealer_Number_From_Buy_Sell__c='90009');
        insert rdrRec3;
        
        rdrList.add(rdrRec);
        
       system.assertEquals('9D2ME1345NR403953', rdrRec3.Vin_TXT__c);
     
    }

}