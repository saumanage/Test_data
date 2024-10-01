public class AsyncExecutionLocationAPI implements Queueable {
	public Set<id> leadIdSet;
    public AsyncExecutionLocationAPI(Set<id> ledSet){
        this.leadIdSet =ledSet;
    }
    public void execute(QueueableContext context) {
        if(HelmsDealerLocatorService.dealerLocatorFlag == false){
        	HelmsDealerLocatorService.dealerLocatorFlag =true;
            HelmsDealerLocatorService.dealerLocatorService(leadIdSet);
        }
    }
    
}