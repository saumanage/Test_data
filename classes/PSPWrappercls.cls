public class PSPWrappercls {
    public To To{get;set;}
    public class To{
        public String SubscriberKey{get;set;}
        public ContactAttributes ContactAttributes{get;set;}
        public String Address{get;set;}
    }
    public class SubscriberAttributes{
        public String DATA2{get;set;}
        public String DATA39{get;set;}
        public String Fname{get;set;}
        public String DATA41{get;set;}
        //public String DATA42{get;set;}
        public String SENDERFNAME{get;set;}
        public String DATA9{get;set;}
        public String DATA10{get;set;}
        public String DATA11{get;set;}
        public String DATA6{get;set;}
        public String REPLYTOEMAIL{get;set;}
        
    }
    public class ContactAttributes{
        public SubscriberAttributes SubscriberAttributes{get;set;}
    }    
}