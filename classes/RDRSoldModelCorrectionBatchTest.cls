@IsTest
public class RDRSoldModelCorrectionBatchTest {
    @IsTest
    static void batchmethodtest(){
        List<RDR_Sales__c> rdrList = new List<RDR_Sales__c>();
        RDR_Sales__c rdrRec = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='A',
                                               Customer_First_Name_NUM__c='Kiran301',New_Dealer_Number_From_Buy_Sell__c='90009',
                                              Model_ID__c='6793',Model_Name_Code_CD__c='ABCD8954');
        rdrList.add(rdrRec);
        RDR_Sales__c rdrRec1 = new RDR_Sales__c(Vin_TXT__c= '9D2ME1345NR403953',Status_Code_CD__c='03',
                                               Dealer_Number_NUM__c='104275',Auto_VIN_Status_Code__c='RR2',XPROD_DIV_CD__c='A',
                                               Customer_First_Name_NUM__c='Kiran302',New_Dealer_Number_From_Buy_Sell__c='90009',
                                               Model_ID__c='ABCD8954',Model_Name_Code_CD__c='8954');
        rdrList.add(rdrRec1);
        insert rdrList;
        
        List<Product_Model_Group__c> tPMGs = new List<Product_Model_Group__c>();
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG1',	Division__c='A',  Subdivision__c='Honda'));
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG2',	Division__c='B',  Subdivision__c='Acura'));
        tPMGs.add(new Product_Model_Group__c(Name='TestPMG3',	Division__c='M',  Subdivision__c='Motorcycle'));
        insert tPMGs;
        List<Product_Model__c> tPGs = new List<Product_Model__c>();
        List<Product_Model_Group__c> insertedPMGS = [select Id, Name FROM Product_Model_Group__c];
        tPGs.add(new Product_Model__c(Model_ID_Text__c='6793', 	Model_Marketing_Name__c = 'PMG1' ,	Product_Model_Group_Id__c=insertedPMGS[0].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='4545', Model_Marketing_Name__c = 'PMG1',	Product_Model_Group_Id__c=insertedPMGS[0].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='ABCD8954', 	Model_Marketing_Name__c = 'PMG2', Product_Model_Group_Id__c=insertedPMGS[1].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='4343', Model_Marketing_Name__c = 'PMG2', 	Product_Model_Group_Id__c=insertedPMGS[1].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='5945', Model_Marketing_Name__c = 'PMG3', 	Product_Model_Group_Id__c=insertedPMGS[2].Id));
        tPGs.add(new Product_Model__c(Model_ID_Text__c='9054', Model_Marketing_Name__c = 'PMG3', 	Product_Model_Group_Id__c=insertedPMGS[2].Id));
        insert tPGs;
        
        RDRSoldModelCorrectionBatch cs = new RDRSoldModelCorrectionBatch();
        Id JobID=Database.executeBatch(cs);
        String sch = '0 0 23 * * ?';
		system.schedule('Testing', sch, cs );
        
        
        
    }

}