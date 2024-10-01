public class JSONRequest {

    public class Vehicle {
        public String modelId{get; set;}
        public String businessunit{get; set;}
        public String vehicletypecode{get; set;}
                
    }

    public String leadId{get; set;}
    public Customer customer{get; set;}
    public Location location{get; set;}
    public List<Vehicle> vehicle{get; set;}
    public String source{get; set;}
    //LMS-1733
    public String LeadSFId{get; set;}
    //end LMS-1733
    
    //Lead Enrichment during Update
    public Boolean ValidEmail{get; set;}
    public Boolean ValidAddress{get; set;}
    public Boolean ValidPhone{get; set;}
    public Boolean ValidMobilePhone{get; set;}
    public Boolean IsDealerized{get; set;}
    public Boolean PESynchronous{get; set;}
    public String ContactKey{get; set;}
    //Lead Enrichment during Update
    
    
    
    public class Address {
        public String address_line1{get; set;}
        public String address_line2{get; set;}
        public String city{get; set;}
        public String state{get; set;}
        public String zip{get; set;}
        public String plus4{get; set;}
        public String country{get; set;}
    }

    public class Customer {
        public Name name{get; set;}
        public List<Address> address{get; set;}
        public String email{get; set;}
        public String home_phone{get; set;}
        public String cell_phone{get; set;}
    }

    public class Name {
        public String prefix{get; set;}
        public String first_name{get; set;}
        public String middle_name{get; set;}
        public String last_name{get; set;}
        public String suffix{get; set;}
    }

    public class Location {
        public String poi_id{get; set;}
        public String poi_radius{get; set;}
        public String NumberOfPOIs{get; set;}
        public String ModelCode{get; set;}
    }
    
    
    

}