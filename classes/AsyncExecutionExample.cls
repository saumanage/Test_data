public class AsyncExecutionExample implements Queueable {
    
    public Set<id> nledSet;
    public AsyncExecutionExample(Set<id> ledSet){
        this.nledSet =ledSet;
    }
    public void execute(QueueableContext context) {
    System.debug('ECRM Enrichment Call nledSet'+nledSet + 'flag is: ' + HELMSAdditionalDataScoringService.flag);
        if(HELMSAdditionalDataScoringService.flag == false){
                    HELMSAdditionalDataScoringService.flag =true;
                    System.debug('ECRM Enrichment Call nledSet'+nledSet + 'flag is: ' + HELMSAdditionalDataScoringService.flag);
                    HELMSAdditionalDataScoringService.GetAdditionaldata(nledSet);
                  }
    }
}