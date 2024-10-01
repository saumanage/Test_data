global class ResponseTimeCorrectionBatch implements Database.Batchable<sObject>,Schedulable{
    global string query='';
    global ResponseTimeCorrectionBatch(){
        
    }
    
    global ResponseTimeCorrectionBatch(string query){
        this.query=query;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){  
        return Database.getQueryLocator(query);
    }
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
                    datetime asgnDateTime = datetime.valueofGmt(stime);
                    //converting the desired timezone to GMT so while getting the day of week and todays date it doesnt automatically get the offset
                    datetime assgndttimegmt=datetime.valueof(stime);
                    //system.debug('asgnDateTime or created date='+asgnDateTime);
                    //datetime currenttime= system.now();
                    //boolean cflag=false;
                    //datetime tdt=system.now();
                    //system.debug('Class run');
                    if(o.Opportunity_SF_ID__c!=null){
                        List<Routing_Dealer_CRM_Disposition__c> rdcList= [Select id,Response_Time__c,HELMS_Opportunity_External_Key__c from Routing_Dealer_CRM_Disposition__c where HELMS_Opportunity_External_Key__c=:o.Opportunity_SF_ID__c order by createddate asc LIMIT 1];
                            if(rdcList.size()>0){
                                o.Response_Date_Time__c=rdcList[0].Response_Time__c;
                                if (rdcList[0].Response_Time__c!=null){
                                    stime=rdcList[0].Response_Time__c.format('yyyy-MM-dd HH:mm:ss',o.PreferredDealerAccount_TXT__r.Account_Timezone__c);
                                }                       
                                        //using value of gmt function to avoid auto offset while conversion
                                        datetime resDateTime=datetime.valueofGmt(stime);
                                        datetime resdttime=datetime.valueof(stime);
                                        //system.debug('resDateTime or last modified date='+resDateTime);
                                        //finding number of days between created date and respond date
                                        integer no_ofdays = assgndttimegmt.date().daysBetween(resdttime.date());
                                        integer opn_hour =0;
                                        integer cls_hour =0;
                                        integer opn_min =0;
                                        integer cls_min =0;
                                        Decimal total_rs_time  =0;
                                        
                                        datetime opendatetime =  system.now();
                                        datetime closedatetime =  system.now();
                                        date todaydate =  system.today();
                                        //system.debug('updated assigndate or created date time='+asgnDateTime);
                                        //system.debug('updated resdate or lastmod date time='+resDateTime);
                                        for(integer i=0; i<=no_ofdays; i++){
                                            
                                            String dayOfWeek = '';
                                            Decimal rs_time  =0;
                                             
                                            if(i==0){
                                                dayOfWeek = assgndttimegmt.format('EEEE');
                                                todaydate = assgndttimegmt.date();
                                            }else{
                                                dayOfWeek = assgndttimegmt.addDays(i).format('EEEE');
                                                todaydate = assgndttimegmt.addDays(i).date();
                                            }
                                            
                                            if(dayOfWeek=='Monday'){
                                                
                                                    opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.MonOpenHour__c.left(2));
                                                    opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.MonOpenHour__c.right(2));
                                                    opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                                    //system.debug('opendatetime='+opendatetime);
                                                
                                                
                                                    cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.MonCloseHour__c.left(2));
                                                    cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.MonCloseHour__c.right(2));
                                                    closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                                    //system.debug('closedatetime='+closedatetime);
                                                
                                                
                                                if(cls_hour!=00 ){
                                                 
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        
                                                        total_rs_time = total_rs_time+ rs_time;
                                                  
                                                }
                                            }else if(dayOfWeek=='Tuesday'){
                                               
                                                    opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.TueOpenHour__c.left(2));
                                                    opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.TueOpenHour__c.right(2));
                                                    opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                                
                                                
                                                    cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.TueCloseHour__c.left(2));
                                                    cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.TueCloseHour__c.right(2));
                                                    closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                                
                                                
                                                if(cls_hour!=00 ){
                                                 
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                    
                                                }
                                            
                                            }else if(dayOfWeek=='Wednesday'){
                                               
                                                    opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.WedOpenHour__c.left(2));
                                                    opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.WedOpenHour__c.right(2));
                                                    opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                               
                                              
                                                    cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.WedCloseHour__c.left(2));
                                                    cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.WedCloseHour__c.right(2));
                                                    closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                               
                                                
                                                if(cls_hour!=00 ){
                                                 
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                    
                                                }
                                            
                                            }else if(dayOfWeek=='Thursday'){
                                               
                                                    opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuOpenHour__c.left(2));
                                                    opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuOpenHour__c.right(2));
                                                    opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                              
                                               
                                                    cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuCloseHour__c.left(2));
                                                    cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.ThuCloseHour__c.right(2));
                                                    closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                              
                                                
                                                if(cls_hour!=00 ){
                                                 
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                  
                                                }
                                                
                                            
                                            }else if(dayOfWeek=='Friday'){
                                            
                                                     opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.FriOpenHour__c.left(2));
                                                     opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.FriOpenHour__c.right(2));
                                                     opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                            
                                         
                                                     cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.FriCloseHour__c.left(2));
                                                     cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.FriCloseHour__c.right(2));
                                                     closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                              
                                                
                                                 if(cls_hour!=00 ){
                                                  
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime  && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                  
                                                 } 
                                                
                                            }
                                            else if(dayOfWeek=='Saturday'){
                                          
                                                     opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.SatOpenHour__c.left(2));
                                                     opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.SatOpenHour__c.right(2));
                                                     opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                                
                                   
                                             
                                                     cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.SatCloseHour__c.left(2));
                                                     cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.SatCloseHour__c.right(2));
                                                     closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                          
                                                
                                                 if(cls_hour!=00 ){
                                                        
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                 }
                                            }
                                            else if(dayOfWeek=='Sunday'){
                                         
                                                     opn_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.SunOpenHour__c.left(2));
                                                     opn_min = integer.valueof(o.PreferredDealerAccount_TXT__r.SunOpenHour__c.right(2));
                                                     opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                                                  
                                              
                                                     cls_hour = integer.valueof(o.PreferredDealerAccount_TXT__r.SunCloseHour__c.left(2));
                                                     cls_min = integer.valueof(o.PreferredDealerAccount_TXT__r.SunCloseHour__c.right(2));
                                                     closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                      
                                                 
                                                 if(cls_hour!=00 ){
                                                        
                                                        if(asgnDateTime<opendatetime && resDateTime>closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime<opendatetime && resDateTime<closedatetime && resDateTime>opendatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - opendatetime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((resDateTime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }else if(asgnDateTime>opendatetime && resDateTime>closedatetime && asgnDateTime<closedatetime){
                                                            rs_time = Integer.valueOf((closedatetime.getTime() - asgnDateTime.getTime())/(1000*60));
                                                        }
                                                        total_rs_time = total_rs_time+ rs_time;
                                                 }
                                                
                                            }
                                            
                                            o.Response_Time_in_Minutes__c=total_rs_time;
                                               //End
                                               changeflag=True;
                                                
                                            }
                                    
                                            updateOpportunityList.add(o);
                                            
                            }
                    }
                       
               
            }
                //system.debug('Opptylist'+UpdateOpportunityList);
            if(updateOpportunityList.size()>0){
                
                         
                //Update UpdateOpportunityList;
                Database.SaveResult[] results = Database.update(updateOpportunityList, false);
                List<Logs__c> loglist = new List<Logs__c>();
                for (Integer i = 0; i < updateOpportunityList.size(); i++) {
                    Database.SaveResult s = results[i];
                    //system.debug('Opptylist'+UpdateOpportunityList[i]);
                    //Opportunity origRecord = UpdateOpportunityList[i];
                    if (!s.isSuccess()) {
                        
                        for(Database.Error error : results[i].getErrors()){
                                
                            Logs__c  l =new Logs__c (SF_Rec_Id__c=updateOpportunityList[i].id, name='ResponseTimeCorrectionBatch' ,Trigger_or_Class_Name__c='ResponseTimeCorrectionBatch', Error_Message__c =error.getMessage());
                            loglist.add(l);
                            
                        }
                     } 
                }
                if(loglist.size()>0){
                    insert loglist;
                }
            }
        }
             

        }Catch(Exception ex){
            //System.debug('ex>>>'+ex);
            Logs__c  l =new Logs__c (name='ResponseTimeCorrectionBatch',Trigger_or_Class_Name__c='ResponseTimeCorrectionBatch', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
            insert l;
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
    public void execute(SchedulableContext sc){
        string query='Select Id,Opportunity_SF_ID__c,Routing_Status__c,CreatedDate,name,Service_Level_Agreement_TXT__c,SubDiv_TXT__c , PreferredDealerAccount_TXT__r.Account_Timezone__c,PreferredDealerAccount_TXT__r.MonOpenHour__c,PreferredDealerAccount_TXT__r.MonCloseHour__c,PreferredDealerAccount_TXT__r.TueOpenHour__c,PreferredDealerAccount_TXT__r.TueCloseHour__c,PreferredDealerAccount_TXT__r.WedOpenHour__c,PreferredDealerAccount_TXT__r.WedCloseHour__c,PreferredDealerAccount_TXT__r.ThuOpenHour__c,PreferredDealerAccount_TXT__r.ThuCloseHour__c,PreferredDealerAccount_TXT__r.FriOpenHour__c,PreferredDealerAccount_TXT__r.FriCloseHour__c,PreferredDealerAccount_TXT__r.SatOpenHour__c,PreferredDealerAccount_TXT__r.SatCloseHour__c,PreferredDealerAccount_TXT__r.SunOpenHour__c,PreferredDealerAccount_TXT__r.SunCloseHour__c,Business_Hours_Elasped__c,Routing_Success_Date_Time__c from Opportunity';
        query += ' Where (StageName != \'Acknowledged\' AND StageName != \'Assigned to Dealer\')   and Routing_Status__c=\'Success\' and Response_Date_Time__c=null and createddate>=2022-03-03T00:05:30.000+0000  ' ;
        ResponseTimeCorrectionBatch cs = new ResponseTimeCorrectionBatch(query);
        Id jobID=Database.executeBatch(cs);
    }

}