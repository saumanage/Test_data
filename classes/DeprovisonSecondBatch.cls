global class DeprovisonSecondBatch implements Database.Batchable<sObject> {
    
     List<User> newList1= new List<User>();
   public DeprovisonSecondBatch(List<User> newList){
        newList1.addAll(newList);
    //   system.debug('newList1 ::'+newList1);
    }
    
    global List<sObject> start(Database.BatchableContext bC) {
        // collect the batches of records or objects to be passed to execute
                 return newList1;
    }
     
    global void execute(Database.BatchableContext bC, List<User> ddccList) {
        
        // process each batch of records default size is 200
              
        
        	if(ddccList.size()>0){			
           update ddccList;
         //    system.debug(' ddccList : '+ddccList);
		}  
        
    }   
     
    global void finish(Database.BatchableContext bC) {
        // execute any post-processing operations like sending email
    }
}
//updated code on feb 17