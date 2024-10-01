public class sendListofIdsToFlow {
    
    @InvocableMethod(label='Get records with IN clause filter')
    public static list<FlowOutputParameters> filterRecords(list<FlowInputParameters> input){
        list<FlowOutputParameters> result = new  list<FlowOutputParameters>();        
        /*Convert the filter value string list to a string of comma separated values*/
        string filterValuesList='(';
        system.debug('input'+input);
        system.debug('input[0]'+input[0]);
        for(integer i=0 ; i < input[0].filteringValuesCollection.size();i++){/* converting into the query format */
            string filterValue = input[0].filteringValuesCollection[i];
            filterValuesList += '\''+filterValue+'\'';
            if(i != input[0].filteringValuesCollection.size()-1)
                filterValuesList += ',';
        }
        filterValuesList += ')';
        /*Dynamic query to fetch all the Opportunity fields */
        List<String> fields = new List<String>(Opportunity.SObjectType.getDescribe().fields.getMap().keySet());
        String query = ''
            + ' select ' + String.join(fields, ',')
            + ' from Opportunity'
            + ' where ID IN '+filterValuesList;
        
        try{
            list<Opportunity> opportunityList = database.query(query);
            FlowOutputParameters obj = new FlowOutputParameters();
            obj.records = opportunityList;
            result.add(obj);
            //system.debug('result'+result);
        }catch(Exception e){
            //system.debug(e.getMessage());
            throw e;
        }
        return result;
    }
    
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        @auraenabled
        @InvocableVariable(label='Text type collection of filter values' required = true)
        public string[] filteringValuesCollection;
        
    }
    
    /* Output parameters of the Apex action */
    public class FlowOutputParameters{
        
        public FlowOutputParameters(){
            records = new sObject[]{};
                
                }
        @auraenabled
        @InvocableVariable(label='Record Collection')
        public sObject[] records;
        
        
        
        
    }
}