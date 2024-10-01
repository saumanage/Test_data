/* LMS-2679 -- As a customer I should be able to extract the lead status from salesforce from Brand site for a given application no. */
@RestResource(urlMapping='/CreditApps/*')
global with sharing class HELMSCreditCheckCustomerHandler {
    // global static final String middleUUID = 'idMiddlewareUUID';
    @HttpGet
    global static void GetCustDetails() {
        
        RestResponse resp = System.RestContext.response; 
        RestRequest req = RestContext.request;
        String middleUUID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        //Fetch the lead records based on MiddlewareUUID__c
        List<Lead> led =[select id,LastName,FirstName,MiddlewareUUID__c,street,City,State, postalCode,Phone,Email,MobilePhone,PreferredDealerAccount_ID__r.name,PreferredDealerAccount_ID__r.DealerCode_CD__c,Dealer_Address_TXT__c,VehicleStatus_TXT__c,Year_YR__c,Make_TXT__c,Model_ID__c,Model_TXT__c,Trim_TXT__c,Price_TXT__c,TradeBalanceOwed_TXT__c,TradeValue_TXT__c,ModelDealerAccessoryPrice_AM__c,ModelDestinationCharge_AM__c,MSRP_AMT__c from Lead where MiddlewareUUID__c =:middleUUID  order by CreatedDate desc limit 1 ];
        //Add Lead data to this wrapper class 
        CustomerDetailsWrapperClass cus = new CustomerDetailsWrapperClass();
        //IsCreditAppExisting=false;
        CustomerDetailsWrapperClass.customer customer = new CustomerDetailsWrapperClass.customer();
        List<CustomerDetailsWrapperClass.Phone> phList = new List<CustomerDetailsWrapperClass.Phone>();
        CustomerDetailsWrapperClass.Phones ph = new CustomerDetailsWrapperClass.Phones();
        CustomerDetailsWrapperClass.Phone ph1 = new CustomerDetailsWrapperClass.Phone();
         CustomerDetailsWrapperClass.Phone ph2 = new CustomerDetailsWrapperClass.Phone();
        
  		 CustomerDetailsWrapperClass.Dealer Dealer = new CustomerDetailsWrapperClass.Dealer();
        CustomerDetailsWrapperClass.Vehicle Vehicle = new CustomerDetailsWrapperClass.Vehicle();
        CustomerDetailsWrapperClass.Tradein Tradein = new CustomerDetailsWrapperClass.Tradein();

        if(led.size()>0 && led[0].MiddlewareUUID__c !=NULL ){
                   
            if(led[0].FirstName !=null){
                customer.FirstName = led[0].FirstName;
            }else{
                customer.FirstName ='';
            }
            
            if(led[0].LastName !=null){
                customer.LastName = led[0].LastName;
            }else{
                customer.LastName = '' ;
            }
            
            if(led[0].street !=null){
                customer.Address = led[0].street;
            }else{
                customer.Address = '';
            }
            
            if(led[0].City!=null){
                customer.City = led[0].City;
            }else{
                customer.City ='';
            }
            
            if(led[0].State !=null){
                customer.State = led[0].State;
            }else{
                customer.State ='';
            }
            
            if(led[0].postalCode != null){
                customer.ZipCode = led[0].postalCode;
            }else{
                customer.ZipCode = '';
            }
            
            if(led[0].Email !=null){
                customer.Email = led[0].Email;
            }else{
                customer.Email ='';
            }
            
            if(led[0].Phone!=null){
                ph1.text= '';
                ph1.type=HELMSConstants.employerphone;
                phList.add(ph1);
                ph2.text= led[0].Phone;
                ph2.type=HELMSConstants.homephone;
                phList.add(ph2);
            }else{
                ph1.text= '';
                ph1.type=HELMSConstants.employerphone;
                phList.add(ph1);
                ph2.text= '';
                ph2.type=HELMSConstants.homephone;
                phList.add(ph2);
            }
            ph.phone = phList;
            customer.Phones = ph;
            
            
            
            if(led[0].PreferredDealerAccount_ID__r.DealerCode_CD__c!=null ){
                Dealer.DealerId= led[0].PreferredDealerAccount_ID__r.DealerCode_CD__c;
            }else{
                Dealer.DealerId= '';
            }
            Dealer.IsDealerAHFCActive=false;
            if(led[0].PreferredDealerAccount_ID__r.name!=null ){
                Dealer.DealerName=led[0].PreferredDealerAccount_ID__r.name;
            }else{
                Dealer.DealerName='';
            }
            
            
            if(led[0].Dealer_Address_TXT__c!=null ){
                Dealer.DealerAddress= led[0].Dealer_Address_TXT__c;
            }else{
                Dealer.DealerAddress= '';
            }
            
            
            //v.vehicletypecode = 'N';
            If(led[0].VehicleStatus_TXT__c!=null){
                String s=led[0].VehicleStatus_TXT__c;
                //system.debug('-----'+s.LEFT(1));
                Vehicle.vehicletypecode = s.LEFT(1);
            }else{
                Vehicle.vehicletypecode= '';
            }
            Vehicle.IsModelAHFCActive=false;
            Vehicle.ModelGroup='';
            Vehicle.ModelSeries='';
            if(led[0].Year_YR__c!=null ){
                Vehicle.Year= led[0].Year_YR__c;
            }else{
                Vehicle.Year= '';
            } 
            if(led[0].Make_TXT__c!=null ){
                Vehicle.Make= led[0].Make_TXT__c;
            }else{
                Vehicle.Make= '';
            } 
            if(led[0].Model_ID__c!=null ){
                Vehicle.ModelId= led[0].Model_ID__c;
            }else{
                Vehicle.ModelId= '';
            } 
            
            if(led[0].Model_TXT__c!=null ){
                Vehicle.Model= led[0].Model_TXT__c;
            }else{
                Vehicle.Model= '';
            } 
            if(led[0].Trim_TXT__c!=null ){
                Vehicle.trim= led[0].Trim_TXT__c;
            }else{
                Vehicle.trim= '';
            }
            if(led[0].ModelDealerAccessoryPrice_AM__c==null){
                led[0].ModelDealerAccessoryPrice_AM__c=0;
                
            }
              if(led[0].ModelDestinationCharge_AM__c==null){
                led[0].ModelDestinationCharge_AM__c=0;
                
            }
               if(led[0].MSRP_AMT__c==null){
                led[0].MSRP_AMT__c=0;
                
            }
            if(led[0].ModelDealerAccessoryPrice_AM__c!=null || led[0].ModelDestinationCharge_AM__c!=null || led[0].MSRP_AMT__c!=null){
                Vehicle.PQRPrice= '$'+string.valueof(led[0].ModelDealerAccessoryPrice_AM__c+led[0].ModelDestinationCharge_AM__c+led[0].MSRP_AMT__c);
                //system.debug(' Vehicle.PQRPrice-----'+ Vehicle.PQRPrice);
            }else{
                Vehicle.PQRPrice= '';
            } 
            if(led[0].TradeBalanceOwed_TXT__c!=null ){
                //  Vehicle.tradein= led[0].TradeBalanceOwed_TXT__c;
                Tradein.BalanceOwed=led[0].TradeBalanceOwed_TXT__c+'.00';
              
               
            }else{
                Tradein.BalanceOwed= '0.00';              
            }
            if(led[0].TradeValue_TXT__c!=null ){               
                Tradein.TradeinAmount=led[0].TradeValue_TXT__c+'.00';               
               
            }else{               
                Tradein.TradeinAmount= '0.00';               
            }
           
            if(led[0].TradeBalanceOwed_TXT__c!=null ){
              
                Tradein.DownPayment=led[0].TradeBalanceOwed_TXT__c+'.00';
               
            }else{
               
                Tradein.DownPayment= '0.00';
            }
            
            /*if(led[0].TradeBalanceOwed_TXT__c!=null ){
                //  Vehicle.tradein= led[0].TradeBalanceOwed_TXT__c;
                Tradein.BalanceOwned=led[0].TradeBalanceOwed_TXT__c;
                Tradein.TradeinAmount=led[0].TradeValue_TXT__c;
                Tradein.DownPayment=led[0].TradeBalanceOwed_TXT__c;
                
            }else{
                Tradein.BalanceOwned= '';
                Tradein.TradeinAmount= '';
                Tradein.DownPayment= '';
            } */
            Vehicle.Tradein=Tradein;
            cus.Vehicle=Vehicle;
            cus.Dealer = Dealer;
            cus.StatusCode= 200;
            cus.StatusMessage= 'OK';
            cus.customer = customer;
            
            String jsonString=JSON.serialize(cus);
            
            ///services/apexrest/CreditApps/9a8f3825-2f11-424c-a48e-71a45ee03bbf
            //Your URL should be :- services/apexrest/CreditApps/9a8f3825-2f11-424c-a48e-71a45ee03bbf
            //Method :- Get
            //Postman Get access token:/services/oauth2/token?grant_type=password&client_id=___&client_secret=__&username=___&password=____
            //postman to  get Leadinfo : /services/apexrest/CreditApps/3b03fa65-dad2-4de4-ab9a-3e4ecadecfaa
            
            //resp.statusCode = 200;
            RestContext.response.addHeader('Content-Type', 'application/json');
            //JsonString = JsonString.replaceAll('"text":','"#text":');
            //JsonString = JsonString.replaceAll('"type":','"@type":');
            resp.responseBody = blob.valueOf(JsonString);
            
        } else {
            
            customer.FirstName ='';
            customer.LastName = '' ;
            customer.Address = '';
            customer.City ='';
            customer.State ='';
            customer.ZipCode = '';
            customer.Email ='';
           // IsCreditAppExisting=false;
            
            ph1.text= '';
            ph1.type=HELMSConstants.employerphone;
            phList.add(ph1);
             ph2.text= '';
            ph2.type=HELMSConstants.homephone;
            phList.add(ph2);
            ph.Phone = phList;
            customer.Phones= ph;
            Dealer.DealerId='';
            Dealer.DealerName='';
            Dealer.DealerAddress='';
            Dealer.IsDealerAHFCActive=false;
            Vehicle.Year='';
            Vehicle.Make='';
            Vehicle.ModelId='';
            Vehicle.trim='';
            Vehicle.PQRPrice='';
            Vehicle.Model='';
            Vehicle.tradein=Tradein;
            Vehicle.vehicletypecode='';
            Vehicle.IsModelAHFCActive=false;
            Vehicle.ModelGroup='';
            Vehicle.ModelSeries='';
            Tradein.TradeinAmount='';
            Tradein.BalanceOwed='';
            Tradein.DownPayment='';
            cus.customer=customer;
            cus.Dealer= Dealer;
            cus.Vehicle= Vehicle;
            cus.statusCode= 400;
            cus.statusMessage= 'NOT FOUND';
            String jsonString=JSON.serialize(cus);
            RestContext.response.addHeader('Content-Type', 'application/json');
           // JsonString = JsonString.replaceAll('"text":','"#text":');
           // JsonString = JsonString.replaceAll('"type":','"@type":');
            
            resp.responseBody = blob.valueOf(JsonString);
            
            //resp.statusCode = 400;
            //resp.responseBody = blob.valueOf(json.serialize(label.Missing_MiddlewareUUID));
            
            
        }
        
        
    }
    
    
    
}