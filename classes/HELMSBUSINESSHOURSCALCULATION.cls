/*
LMS-1885 - This class is used to calculate business hours and update SLA's based on which will send email notification 
            to dealer users. So that the customers are contacted in a timely manner.
*/
public class HELMSBUSINESSHOURSCALCULATION implements Database.Batchable<sObject>,Schedulable{
     public Database.QueryLocator start(Database.BatchableContext bc){
         string ack = HELMSConstants.Acknowledged;
         String assign= HELMSConstants.Assigned_to_Dealer;
         string duser= System.Label.Data_User;
         integer bhourslimit= integer.valueof(System.Label.Business_Hours_Job_Limit);
         string slalimit=HELMSConstants.SLA_limit;
         string rstatus=HELMSConstants.Routing_Failure;
         // The below query gets the opportunities from database to calculate the business hours
         string query='Select Id,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
         query += ' Where (StageName = :ack or StageName = :assign) and Business_Hours_Elasped__c <= :bhourslimit and CreatedBy.Name !=: duser and Service_Level_Agreement_TXT__c!=:slalimit and Routing_Status__c!=:rstatus and (SubDiv_TXT__c =\'Motorcycle\' or SubDiv_TXT__c =\'PowerEquipment\') and PreferredDealerAccount_TXT__r.MonOpenHour__c!=null  order by PreferredDealerAccount_TXT__c' ;
         return Database.getQueryLocator(query); 
     }
    //Below is the execute method responsible for handling the logic
    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        try{
            List<Opportunity> updateOpportunityList= new List<Opportunity>();
            For(Opportunity o:scope){
                IF(o.PreferredDealerAccount_TXT__r.MonOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.MonCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.TueOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.TueCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.WedOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.WedCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.ThuOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.ThuCloseHour__c!=NULL && 
                  o.PreferredDealerAccount_TXT__r.FriOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.FriCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.SatOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.SatCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.SunOpenHour__c!=NULL && o.PreferredDealerAccount_TXT__r.SunCloseHour__c!=NULL &&
                  o.PreferredDealerAccount_TXT__r.Account_Timezone__c!=NULL && o.SubDiv_TXT__c!=NULL && o.Business_Hours_Elasped__c!=NULL)
                {
                    //converting the created date to the required timezone
                    string stime = o.CreatedDate.format('yyyy-MM-dd HH:mm:ss',o.PreferredDealerAccount_TXT__r.Account_Timezone__c);
                    IF(o.Routing_Status__c== 'Success'){
                        //converting the created date to the required timezone
                        stime = o.Routing_Success_Date_Time__c.format('yyyy-MM-dd HH:mm:ss',o.PreferredDealerAccount_TXT__r.Account_Timezone__c);
                    } 
                    boolean changeflag=False;
                    //using value of gmt function to avoid auto offset while conversion
                    datetime asgnDateTime = datetime.valueOfGmt(stime);
                    //converting the desired timezone to GMT so while getting the day of week and todays date it doesnt automatically get the offset
                    datetime assgndttimegmt=datetime.valueOf(stime);
                    //system.debug('asgnDateTime or created date='+asgnDateTime);
                    datetime currenttime= system.now();
                    stime = currenttime.format('yyyy-MM-dd HH:mm:ss',o.PreferredDealerAccount_TXT__r.Account_Timezone__c);
                    //using value of gmt function to avoid auto offset while conversion
                    datetime resDateTime=datetime.valueofGmt(stime);
                    datetime resdttime=datetime.valueof(stime);
                    //system.debug('resDateTime or last modified date='+resDateTime);
                    //finding number of days between created date and respond date
                    integer noOfDays = assgndttimegmt.date().daysBetween(resdttime.date());
                    integer opnHour =0;
                    integer clsHour =0;
                    integer opnMin =0;
                    integer clsMin =0;
                    Decimal totalRsTime  =0;
                    
                    datetime opendatetime =  system.Now();
                    datetime closedatetime =  system.Now();
                    date todaydate =  system.Today();
                    //system.debug('updated assigndate or created date time='+asgnDateTime);
                    //system.debug('updated resdate or lastmod date time='+resDateTime);
                    for(integer i=0; i<=noOfDays; i++){
                        
                        String dayOfWeek = '';
                        Decimal rsTime  =0;
                         
                        if(i==0){
                            dayOfWeek = assgndttimegmt.format('EEEE');
                            todaydate = assgndttimegmt.date();
                        }else{
                            dayOfWeek = assgndttimegmt.addDays(i).format('EEEE');
                            todaydate = assgndttimegmt.addDays(i).date();
                        }
                        
                        if(dayOfWeek=='Monday'){
                            
                                opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.MonOpenHour__c.left(2));
                                opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.MonOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                                //system.debug('opendatetime='+opendatetime);
                            
                            
                                clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.MonCloseHour__c.left(2));
                                clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.MonCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                                //system.debug('closedatetime='+closedatetime);
                            
                            
                            if(clsHour!=00 ){
                             
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    
                                    totalRsTime = totalRsTime+ rsTime;
                              
                            }
                        }else if(dayOfWeek=='Tuesday'){
                           
                                opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.TueOpenHour__c.left(2));
                                opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.TueOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                            
                            
                                clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.TueCloseHour__c.left(2));
                                clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.TueCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                            
                            
                            if(clsHour!=00 ){
                             
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                                
                            }
                        
                        }else if(dayOfWeek=='Wednesday'){
                           
                                opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.WedOpenHour__c.left(2));
                                opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.WedOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                           
                          
                                clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.WedCloseHour__c.left(2));
                                clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.WedCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                           
                            
                            if(clsHour!=00 ){
                             
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                                
                            }
                        
                        }else if(dayOfWeek=='Thursday'){
                           
                                opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuOpenHour__c.left(2));
                                opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                          
                           
                                clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuCloseHour__c.left(2));
                                clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                          
                            
                            if(clsHour!=00 ){
                             
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                              
                            }
                            
                        
                        }else if(dayOfWeek=='Friday'){
                        
                                 opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.FriOpenHour__c.left(2));
                                 opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.FriOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                        
                     
                                 clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.FriCloseHour__c.left(2));
                                 clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.FriCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                          
                            
                             if(clsHour!=00 ){
                              
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime  && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                              
                             } 
                            
                        }
                        else if(dayOfWeek=='Saturday'){
                      
                                 opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.SatOpenHour__c.left(2));
                                 opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.SatOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                            
               
                         
                                 clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.SatCloseHour__c.left(2));
                                 clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.SatCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                      
                            
                             if(clsHour!=00 ){
                                    
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                             }
                        }
                        else if(dayOfWeek=='Sunday'){
                     
                                 opnHour = integer.valueof(o.PreferredDealerAccount_TXT__r.SunOpenHour__c.left(2));
                                 opnMin = integer.valueof(o.PreferredDealerAccount_TXT__r.SunOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opnHour+':'+opnMin+':0'));
                                              
                          
                                 clsHour = integer.valueof(o.PreferredDealerAccount_TXT__r.SunCloseHour__c.left(2));
                                 clsMin = integer.valueof(o.PreferredDealerAccount_TXT__r.SunCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+clsHour+':'+clsMin+':0'));
                  
                             
                             if(clsHour!=00 ){
                                    
                                    if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                        rsTime = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                        rsTime = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                    }
                                    totalRsTime = totalRsTime+ rsTime;
                             }
                            
                        }
                        
                        o.Business_Hours_Elasped__c=totalRsTime/60;
                           //End
                           //changeflag=True;
                            //system.debug('line 66');
                        }
                    //Service Level Agreement Calculation
                    IF(o.SubDiv_TXT__c !=Null){
                        //Getting subdivision and its respective business hours from Custom Metadata
                        SLA_Levels__mdt slaMetadata = SLA_Levels__mdt.getInstance(o.SubDiv_TXT__c);
                        If((o.Business_Hours_Elasped__c >= slaMetadata.Level_1_SLA_Hours__c && o.Business_Hours_Elasped__c < slaMetadata.Level_2_SLA_Hours__c && slaMetadata.Level_1_SLA_Hours__c!=0)
                            && o.Service_Level_Agreement_TXT__c!= 'Level 1' ){
                           o.Service_Level_Agreement_TXT__c= 'Level 1'; 
                           changeflag=True;
                           
                        }else If((o.Business_Hours_Elasped__c >= slaMetadata.Level_2_SLA_Hours__c && o.Business_Hours_Elasped__c < slaMetadata.Level_3_SLA_Hours__c && slaMetadata.Level_2_SLA_Hours__c!=0 )
                                && o.Service_Level_Agreement_TXT__c!= 'Level 2'){
                            
                            o.Service_Level_Agreement_TXT__c= 'Level 2'; 
                            changeflag=True;
                           
                        } else If(o.Business_Hours_Elasped__c >= slaMetadata.Level_3_SLA_Hours__c && o.Service_Level_Agreement_TXT__c!= 'Level 3' && slaMetadata.Level_1_SLA_Hours__c!=0){
                            o.Service_Level_Agreement_TXT__c= 'Level 3';
                            changeflag=True;
                            
                        } else If(o.Business_Hours_Elasped__c >= slaMetadata.Level_4_SLA_Hours__c && o.Service_Level_Agreement_TXT__c!= 'Level 4' && slaMetadata.Level_4_SLA_Hours__c!=null){
                            o.Service_Level_Agreement_TXT__c= 'Level 4';
                            changeflag=True;   
                    }
                    }
                
                    IF(changeflag){
                        UpdateOpportunityList.add(o);
                        //system.debug('opp '+ o);
                    }
                }
                
                
            }
            if(UpdateOpportunityList.size()>0){
                         
                //Update UpdateOpportunityList;
                Database.SaveResult[] results = Database.update(UpdateOpportunityList, false);
                List<Logs__c> loglist = new List<Logs__c>();
                for (Integer i = 0; i < UpdateOpportunityList.size(); i++) {
                    Database.SaveResult s = results[i];
                    //Opportunity origRecord = UpdateOpportunityList[i];
                    if (!s.isSuccess()) {
                        
                        for(Database.Error error : results[i].getErrors()){
                                
                            Logs__c  l =new Logs__c (SF_Rec_Id__c=UpdateOpportunityList[i].id, name='SLA update batch class' ,Trigger_or_Class_Name__c='HELMSBUSINESSHOURSCALCULATION', Error_Message__c =error.getMessage());
                            loglist.add(l);
                            
                        }
                     } 
                }
                if(loglist.size()>0){
                    insert loglist;
                }
            }
             

        }Catch(Exception ex){
            //System.debug('ex>>>'+ex);
            Logs__c  l =new Logs__c (name='SLA update',Trigger_or_Class_Name__c='HELMSBUSINESSHOURSCALCULATION', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
    }
    //Finish method to handle any logic after completion of execute method
    public void finish(Database.BatchableContext bc){
        
    }
    public void execute(SchedulableContext sc){
        HELMSBUSINESSHOURSCALCULATION cs = new HELMSBUSINESSHOURSCALCULATION();
        Id jobId=Database.executeBatch(cs,Integer.valueOf(Label.Business_Hours_Class_Batch_Size));
    }
}