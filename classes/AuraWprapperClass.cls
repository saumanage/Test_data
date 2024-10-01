/*This wrapper class is used in HelmsLeadCrationNotificationSFMCAcura */
public class AuraWprapperClass {
    public To to{get;set;}
    public class To{
        public String subscriberKey{get;set;}
        public ContactAttributes contactAttributes{get;set;}
        public String address{get;set;}
    }
    public class SubscriberAttributes{
        public String dATA2{get;set;}
        public String dATA39{get;set;}
        public String fName{get;set;}
        public String dATA41{get;set;}
        public String dATA42{get;set;}
        public String sENDERFNAME{get;set;}
        public String dATA9{get;set;}
        public String dATA10{get;set;}
        public String dATA11{get;set;}
        public String dATA6{get;set;}
        public String rEPLYTOEMAIL{get;set;}
        
    }
    public class ContactAttributes{
        public SubscriberAttributes subscriberAttributes{get;set;}
    }    
}