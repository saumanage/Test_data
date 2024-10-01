public class HELMSJsonWrapper {

    public class Response {
        public String leadId{get; set;}
        public Consumer_detail consumer_detail{get; set;}
        public String msg_code{get; set;}
        public String msg_text{get; set;}
    }

    public Response response{get; set;}

    public class Consumer_detail {
        public Integer cid{get; set;}
        public String contact_key{get; set;}
    }

   /* 
    public static HELMSJsonWrapper parse(String json) {
        return (HELMSJsonWrapper) System.JSON.deserialize(json, HELMSJsonWrapper.class);
    }
    */
}