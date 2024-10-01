public class SFMCRequest {
    public To To{get;set;}
   // public String grant_type{get; set;}
    //public String client_id{get; set;}
   // public String client_secret{get; set;}
   // public String account_id{get; set;} 
    public class To{
        public String SubscriberKey{get;set;}
        public ContactAttributes ContactAttributes{get;set;}
        public String Address{get;set;}
    }
    public class SubscriberAttributes{
        public String Dealer_Phone{get;set;}
        public String Sub_Division{get;set;}
        public String Dealer_Address{get;set;}
        public String Dealer_Name{get;set;}
        public String Model_Name{get;set;}
    }
    public class ContactAttributes{
        public SubscriberAttributes SubscriberAttributes{get;set;}
    }  
    
    /*public void SFMCAuth(String str1,string str2,String str3,string str4){
        this.grant_type=str1;
        this.client_id=str2;
        this.client_secret=str3;
        this.account_id=str4;
    }*/
}