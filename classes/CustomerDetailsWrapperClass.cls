global class CustomerDetailsWrapperClass {
    public boolean IsCreditAppExisting{get;set;}
    public CustomerDetailsWrapperClass(){
        IsCreditAppExisting=false;
    }
    public customer Customer {get;set;}
        
    
    public class Customer{
        
        public String FirstName{get; set;}
        public String LastName{get; set;}
        public String Address{get; set;}
        public String City{get; set;}
        public String State{get; set;}
        public String ZipCode{get; set;}
        public String Email{get; set;}
        public Phones Phones{get; set;}
        
    }
    global class Phone{
         
         public String text;
       
         public String type;
    }
    
    //public boolean IsCreditAppExisting{get;set;}
    //public String Phone{get; set;}
    public Integer StatusCode{get; set;}
    public String StatusMessage{get; set;}
    
    public Dealer Dealer {get;set;}
    public Vehicle Vehicle {get;set;}
    
    
    global class Phones {
       public list<Phone> Phone{get;set;}
    }
    
    global class Dealer {
        public String DealerId{get; set;}
        public String DealerName{get; set;}
        public String DealerAddress{get; set;}
        public boolean IsDealerAHFCActive{get;set;}
    }
    
    global class Vehicle {
        public boolean IsModelAHFCActive{get;set;}
        public string ModelGroup{get;set;}
        public string ModelSeries{get;set;}
        public String Year{get; set;}
        public String Make{get; set;}
        public string ModelId{get;set;}
        public String Model{get; set;}
        public String Trim{get; set;}
        public string PQRPrice{get;set;}
        //public string tradein{get;set;}
        public string Vehicletypecode{get;set;}
        public Tradein Tradein {get;set;}
        
    }
    
    global class Tradein {
        public String TradeinAmount{get; set;}
        public String BalanceOwed{get; set;}
        public String DownPayment{get; set;}
    }
    
}