/*Twice a year the majority of Americans change their clocks for Daylight Saving Time. 
The change happens on the second Sunday of March and the first Sunday of November each year. 
The shift is always done on the weekend at 2:00 am to limit the amount of disruption caused
UserStory:LMS-6077
*/
public  with sharing class HELMSDstDatesClass implements schedulable {
    //execute method
   public void execute(SchedulableContext sc){
       DstCalculate();
    }
    /*Logic to calculate the DST start date and End Date*/
    public void dstCalculate()
    {
        datetime dt=system.now();             //Getting the current time
		integer year=dt.year();               // Getting the current year
		date d=date.newinstance(year,3,1);    //Storing first of march date in d field
		datetime dt2=d;                       //converting it to datetime field
		datetime st;                          //Variable to store start date time of DST
		datetime et;                          //Variable to store end date time of DST
		dt2=dt2.addhours(10);                 //The clocks are scheduled at 2 am so adding 2 hours + 8 hours for UTC offset from PST
		integer i;                            
		integer a=2;                          //Assigned a=2 to stop the loop once 2nd sunday is found
		for( i=0;i<a;i){
    		if(dt2.format('EEEE')=='Sunday'){  
        	i=i+1;
        	if (i==a){
            //system.debug(dt2);
            st=dt2;
        	} 
    		}     
    		dt2=dt2.adddays(1);                // Adding one more day to the date till 2nd sunday is found
			}                                  //Logic ends to find second sunday of march for the year
			d=date.newinstance(year,11,1);     //Storing the first date of november for the current year in variable d
			dt2=d;
			dt2=dt2.addhours(10);
			a=1;                               //Assigned a=1 to stop the loop once first sunday is found
			for (i=0;i<a;i){
    			if(dt2.format('EEEE')=='Sunday'){
    			i=i+1;
    			//system.debug(dt2);
                et=dt2;
				}
    		  dt2=dt2.adddays(1);              //Adding one day till first sunday of november is found
			}                                  //Logic to find first sunday of november for the year ends
    //Updating the default organisation Custom setting  
    DST_Setting__c sett = DST_Setting__c.getInstance(UserInfo.getOrganizationId());
        sett.DST_Start_Date__c = st;
        sett.DST_End_Date__c=et;
         update sett ; 
    }

}