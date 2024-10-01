/*LMS-5481 - This class helps in calculating the response time in minutes for opportunities which are moved from the first opportunity
stage to any other stage except acknowledged 
*/

public with sharing class HELMSResponseTimeTriggerHelper{

        public static void calculateTime(list<opportunity> oppList) {
        
            String inconv= HELMSConstants.In_Conversation;
            String dvisit= HELMSConstants.Dealer_Visit;
            String onhold= HELMSConstants.On_Hold;
            String closedwon= HELMSConstants.Closed_Won;
            String closedlost= HELMSConstants.Closed_Lost;
            String closedinactive= HELMSConstants.Closed_Inactive;
            datetime asgnDateTime= system.now();
            datetime resDateTime = system.now();
            integer no_ofdays = 0;
            Set<id> accounids= new Set<id>();
            for(opportunity opp: oppList){
                accounids.add(opp.PreferredDealerAccount_TXT__c);
            }

            Map<id,account> accmap= new Map<Id, Account>([select id,Account_Timezone__c,MonOpenHour__c,MonCloseHour__c,TueOpenHour__c,WedCloseHour__c,ThuCloseHour__c,ThuOpenHour__c,
                                WedOpenHour__c,TueCloseHour__c,FriOpenHour__c,FriCloseHour__c,SatOpenHour__c,SatCloseHour__c,SunOpenHour__c,SunCloseHour__c from account where id in :accounids limit 1000]);
            string stime = '';
            try{
            for(opportunity opp: oppList){
                   //checking local timezone value of the preferred dealer account
                   if(accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c!=null)
                        //converting the created date to the required timezone
                        stime = opp.createddate.format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                if(opp.Routing_Status__c=='Success'){
                    stime=opp.Routing_Success_Date_Time__c.format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                }
                   //using value of gmt function to avoid auto offset while conversion
                   asgnDateTime = datetime.valueofGmt(stime);
                   //converting the desired timezone to GMT so while getting the day of week and todays date it doesnt automatically get the offset
                   datetime assgndttimegmt=datetime.valueof(stime);
                   //system.debug('asgnDateTime or created date='+asgnDateTime);
                   
               if((opp.stagename==inconv || opp.stagename==dvisit || opp.stagename==onhold || opp.stagename==closedwon || opp.stagename==closedlost || opp.stagename==closedinactive) && Opp.Response_Time_in_Minutes__c==null){
                   if(accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c!=null)
                        //converting the last modified date to the required timezone
                     //system.debug('last mod date='+opp.lastmodifieddate);
                   //system.debug('current time'+system.now());
                    //stime = opp.lastmodifieddate.format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                     if(opp.Response_Date_Time__c!=null){
                           stime=opp.Response_Date_Time__c.format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                       }
                   else{
                       stime = system.now().format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                   }
                       //stime = system.now().format('yyyy-MM-dd HH:mm:ss',''+accmap.get(opp.PreferredDealerAccount_TXT__c).Account_Timezone__c+'');
                   //using value of gmt function to avoid auto offset while conversion-
                    resDateTime=datetime.valueofGmt(stime);
                    datetime resdttime=datetime.valueof(stime);
                    //system.debug('resDateTime or last modified date='+resDateTime);
                    //finding number of days between created date and respond date
                    no_ofdays = assgndttimegmt.date().daysBetween(resdttime.date());
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
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).MonOpenHour__c!=null){
                                opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).MonOpenHour__c.left(2));
                                opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).MonOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                //system.debug('opendatetime='+opendatetime);
                            }
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).MonCloseHour__c!=null){
                                cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).MonCloseHour__c.left(2));
                                cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).MonCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                                //system.debug('closedatetime='+closedatetime);
                            }
                            
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
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).TueOpenHour__c!=null){
                                opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).TueOpenHour__c.left(2));
                                opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).TueOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                            }
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).TueCloseHour__c!=null){
                                cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).TueCloseHour__c.left(2));
                                cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).TueCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                            }
                            
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
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).WedOpenHour__c!=null){
                                opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).WedOpenHour__c.left(2));
                                opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).WedOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                            }
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).WedCloseHour__c!=null){
                                cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).WedCloseHour__c.left(2));
                                cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).WedCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                            }
                            
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
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuOpenHour__c!=null){
                                opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuOpenHour__c.left(2));
                                opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuOpenHour__c.right(2));
                                opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                            }
                            if(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuCloseHour__c!=null){
                                cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuCloseHour__c.left(2));
                                cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).ThuCloseHour__c.right(2));
                                closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                            }
                            
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
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).FriOpenHour__c!=null){
                                 opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).FriOpenHour__c.left(2));
                                 opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).FriOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                             }
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).FriCloseHour__c!=null){
                                 cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).FriCloseHour__c.left(2));
                                 cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).FriCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                             }
                            
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
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).SatOpenHour__c!=null){
                                 opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SatOpenHour__c.left(2));
                                 opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SatOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                            
                             }
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).SatCloseHour__c!=null){
                                 cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SatCloseHour__c.left(2));
                                 cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SatCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                             }
                            
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
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).SunOpenHour__c!=null){
                                 opn_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SunOpenHour__c.left(2));
                                 opn_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SunOpenHour__c.right(2));
                                 opendatetime = DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+opn_hour+':'+opn_min+':0'));
                                                          }
                             if(accmap.get(opp.PreferredDealerAccount_TXT__c).SunCloseHour__c!=null){
                                 cls_hour = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SunCloseHour__c.left(2));
                                 cls_min = integer.valueof(accmap.get(opp.PreferredDealerAccount_TXT__c).SunCloseHour__c.right(2));
                                 closedatetime =  DateTime.valueOfGmt((''+string.valueof(todaydate)+' '+cls_hour+':'+cls_min+':0'));
                             }
                             
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
                        /*
                        system.debug('######i#####'+i);
                        system.debug('######dayOfWeek#####'+dayOfWeek);                        
                        
                        System.debug('todaydate testing debug  : ' + todaydate );
                       
                        System.debug('asgnDateTime testing debug  : ' + asgnDateTime );
                        System.debug('opendatetime testing debug  : ' + opendatetime);
                        System.debug('resDateTime testing debug  : ' + resDateTime);
                        System.debug('closedatetime testing debug  : ' + closedatetime);
                        
                        System.debug('rs_time testing debug  : ' + rs_time );
                        System.debug('total_rs_time testing debug  : ' + total_rs_time );                        
                       */
                    }
                    Opp.Response_Time_in_Minutes__c =total_rs_time;
                }
            }
            }catch(Exception e){
                //System.debug('Error--'+e.getMessage());
            }
        }
        
        
}