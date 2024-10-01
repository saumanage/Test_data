public class SFMCResponse {
		public list<responses> responses{get;set;}
		public String requestId{get;set;}
	public class responses{
		public Boolean hasErrors{get;set;}
		public list<String> messages{get;set;}
		public String recipientSendId{get;set;}
	}
}