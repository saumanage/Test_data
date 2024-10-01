public with sharing class HELMSOptionsinsertHandler {
 public static void handleLeadInsert(List<Opportunity> opty ){
        try{
        List<Options__c> optionsList = new List<Options__c>();
        for(Opportunity opp : opty){
                //if( (isInsert && opp.Options_TXT__c!=null) || (isUpdate && opp.Options_TXT__c!=null && oldMap.get(opp.id)!=null && opp.Options_TXT__c != oldMap.get(opp.id).Options_TXT__c) ){
                
                    String optionsField = (opp.Options_TXT__c).unescapeXml() ;
                    
                                   
                   //optionsField = optionsField.replace('&' , 'and');
                    //System.debug('optionsField--------'+optionsField);
                   
                    String[] options =(optionsField ).split('<option>');
                    //System.debug('options--------'+options);
                    options.remove(0);
                    //System.debug('options--------'+options);
                    for(string op:options){
                        
                        //System.debug('op--------'+op);
                        
                        Options__c opt = new Options__c();
                         //System.debug(op);
                         
                      
                        string s='<?xml version="1.0" encoding="UTF-8"?><option>';
                            String xml = (s+''+op); // XML 
                            // String s= (xml).unescapeXml();
                            
                            xml = xml.replace('&amp;' , '****');
                            xml = xml.replace('&' , '****');
                            xml = xml.replaceAll('\n','').replaceAll('\r','');
                            xml = xml.replace('<b>**' , '');
                            xml = xml.replace('**<b>' , '');
                            xml = xml.replace('<b>' , '');
                            xml = xml.replace('</b>' , '');
                            xml = xml.replaceAll('&reg;','');
                            xml = xml.replaceAll('<sup>','');
                            xml = xml.replaceAll('</sup>','');
                            //System.debug('xml --------'+xml);
                    
                            String jsonContent;
                            try{
                                jsonContent = XmlParser.xmlToJson(xml);
                                jsonContent = jsonContent.replace('****' , '&');
                            }Catch(Exception ex){
                                //System.debug('Exception at line : '+ ex.getLineNumber());
                                //System.debug('Exception Message : '+ ex.getMessage());
                                
                                Logs__c  l =new Logs__c (SF_Rec_Id__c=opp.id, name='Opportunity Trigger',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
                               insert l;
                            }   
                                //System.debug(jsonContent);
                        if(jsonContent!=null){
                            OptionsJSON2Apex jsondatawrapper = (OptionsJSON2Apex)JSON.deserialize(jsonContent,OptionsJSON2Apex.class);
                           // OptionsJSON2Apex jsondatawrapper =  OptionsJSON2Apex.parse(jsonContent);
                                //System.debug(jsondatawrapper);
                                
                            //Jsondatawrapper.option.optionname;
                            
                            opt.Opportunity_ID__C = opp.id; 
                            opt.ManufacturerCode_CD__C = jsondatawrapper.option.manufacturercode ;
                            opt.InventoryNumber_TXT__c = jsondatawrapper.option.stock ;
                            
                            opt.name = jsondatawrapper.option.optionname;
                            opt.OptionName__c =  jsondatawrapper.option.optionname;
                           
                            // option name is triming if it is morethan 80 characters  
                           if(!string.isblank(opt.name) && opt.name.length()>80){
                                opt.name= opt.name.substring(0,80);
                            }
                            
                         //   opt.name = jsondatawrapper.option.optionname;
                            //opt.Weighting_NUM__C = String.valueOf(Jsondatawrapper.option.weighting) ;
                            //opt.PriceType_AM__c
                            //opt.ModelDealerAccessoryPrice_AM__C
                            
                            List<OptionsJSON2Apex.price> plist = new List<OptionsJSON2Apex.price>();
                            
                            if(jsondatawrapper.option.price != null)
                                plist = jsondatawrapper.option.price;
                            
                            //System.debug('plist--------'+plist);
                            for(OptionsJSON2Apex.price  p: plist ){
                            //System.debug('price record--------'+p);
                                if (p.type=='appraisal') {
                                    opt.PriceAppraisalrelativeto_TXT__c =p.relativeto;
                                    opt.PriceAppraisalDelta_TXT__C = p.delta ;
                                     
                                    opt.PriceAppraisalSource_TXT__C  = p.source;
                                    if(p.currency_Z !=null){
                                    opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){
                                    opt.PriceAppraisal_AMT__C = Decimal.valueOf(p.ele_text);
                                    }
                                }
                                
                                if (p.type=='asking') {
                                    opt.PriceAskingrelativeto_TXT__c =p.relativeto;
                                    opt.PriceAskingDelta_TXT__C  = p.delta ;
                                    
                                    opt.PriceAskingSource_TXT__C = p.source;
                                    if(p.currency_Z !=null){
                                    opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){
                                    opt.PriceAsking_AMT__C = Decimal.valueOf(p.ele_text);
                                    }
                                }
                                
                                if (p.type=='MSRP') {
                                    opt.PriceMSRPDelta_TXT__C  = p.delta ;
                                    opt.PriceMSRPrelativeto_TXT__c =p.relativeto;
                                    
                                    opt.PriceMSRPSource_TXT__C = p.source;
                                    if(p.currency_Z !=null){
                                    opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){
                                    opt.PriceMSRP_AMT__C = Decimal.valueOf(p.ele_text); 
                                    }
                                }
                                
                                if (p.type=='call') {
                                    opt.PriceCallrelativeto_TXT__c =p.relativeto;
                                    opt.PriceCallDelta_TXT__C  = p.delta ;
                                    
                                    opt.PriceCallSource_TXT__C = p.source;
                                    
                                    if(p.currency_Z !=null){
                                    opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    
                                    if(p.ele_text !=null){
                                    opt.PriceCall_AMT__C = Decimal.valueOf(p.ele_text); 
                                    }
                                }
                                
                                if (p.type=='invoice') {
                                    opt.PriceInvoiceDelta_TXT__C  = p.delta ;
                                    opt.PriceInvoicerelativeto_TXT__c =p.relativeto;
                                    
                                    opt.PriceInvoiceSource_TXT__C = p.source;
                                    if(p.currency_Z !=null){
                                    opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    
                                    if(p.ele_text !=null){
                                    opt.PriceInvoice_AMT__C = Decimal.valueOf(p.ele_text); 
                                    }
                                }
                                
                                if (p.type=='offer') {
                                    opt.PriceOfferDelta_TXT__C  = p.delta ;
                                    opt.PriceOfferrelativeto_TXT__c =p.relativeto;
                                    
                                    opt.PriceOfferSource_TXT__C = p.source;
                                    if(p.currency_Z !=null){
                                        opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){                                  
                                    opt.PriceOffer_AMT__C =Decimal.valueOf(p.ele_text);  
                                    }
                                }
                                
                                if (p.type=='quote') {
                                    opt.PriceQuoteDelta_TXT__C  = p.delta ;
                                    opt.PriceQuoterelativeto_TXT__c =p.relativeto;
                                    
                                    opt.PriceQuoteSource_TXT__C = p.source;
                                    if(p.currency_Z !=null){
                                        opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){
                                    opt.PriceQuote_AMT__C = Decimal.valueOf(p.ele_text);
                                    }                                   
                                }
                                
                                if (p.type=='' || p.type=='null' || p.type== null) {
                                    if(p.delta !=null){
                                        opt.Pricedelta_TXT__c= p.delta;
                                    }
                                    if(p.relativeto !=null){
                                        opt.Pricerelativeto_TXT__c =p.relativeto;
                                    }
                                    if(p.source !=null){
                                        opt.PriceSource_TXT__c = p.source;
                                    }
                                    if(p.currency_Z !=null){
                                        opt.PriceCurrency_TXT__c = p.currency_Z ;
                                    }
                                    if(p.ele_text !=null){
                                    opt.Price_AMT__c = Decimal.valueOf(p.ele_text);
                                    }                                   
                                }
                            }                           
                            optionsList.add(opt);                       
                                                     
                        }
                    
                    
                
                }
                
        }
        //System.debug(optionsList);
               
        if(optionsList.size()>0){
         Database.SaveResult[]  optlistresult = Database.insert(optionsList, false);
            
             for (Database.SaveResult result : optlistresult){
                if (!result.isSuccess()){
              //Error ecountered              
             for(Database.Error error : result.getErrors()) {
             //Handle error
             // System.debug(error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
              Logs__c logRecord = new Logs__c(Name='Opportunity Trigger -Optins insert',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler',Error_Message__c = error.getMessage() + '' +error.getFields(),Error_Line_Number__c = 0);
               insert logRecord;
                     }
                }
             }             
        }
        
        }Catch(Exception ex){
            
            Logs__c  l =new Logs__c (name='Opportunity Trigger',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }   
    }


public static void optionsLeadInserthandle(List<Lead> leadList ){
        try{
        List<Lead_Option__c> optionsList = new List<Lead_Option__c>();
        for(Lead ld : leadList){
               
                    String optionsField = (ld.Options_TXT__c).unescapeXml() ;
                   //optionsField = optionsField.replace('&' , 'and');
                    //System.debug('optionsField--------'+optionsField);
                   
                    String[] options =(optionsField ).split('<option>');
                    //System.debug('options--------'+options);
                    options.remove(0);
                    //System.debug('options--------'+options);
                    
            for(string op:options){
                        
                        //System.debug('op--------'+op);
                        
                        Lead_Option__c ldopt = new Lead_Option__c();
                         //System.debug(op);
                         
                         string s='<?xml version="1.0" encoding="UTF-8"?><option>';
                            String xml = (s+''+op); // XML 
                            // String s= (xml).unescapeXml();
                            
                            xml = xml.replace('&amp;' , '****');
                            xml = xml.replace('&' , '****');
                            xml = xml.replaceAll('\n','').replaceAll('\r','');
                            xml = xml.replace('<b>**' , '');
                            xml = xml.replace('**<b>' , '');
                            xml = xml.replace('<b>' , '');
                            xml = xml.replace('</b>' , '');
                            xml = xml.replaceAll('&reg;','');
                            xml = xml.replaceAll('<sup>','');
                            xml = xml.replaceAll('</sup>','');
                            //System.debug('xml --------'+xml);
                    
                            String jsonContent;
                            try{
                                jsonContent = XmlParser.xmlToJson(xml);
                                jsonContent = jsonContent.replace('****' , '&');
                            }Catch(Exception ex){
                                //System.debug('Exception at line : '+ ex.getLineNumber());
                                //System.debug('Exception Message : '+ ex.getMessage());
                                
                                Logs__c  l =new Logs__c (SF_Rec_Id__c=ld.id, name='ldortunity Trigger',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
                               insert l;
                            }   
                                //System.debug(jsonContent);
                        if(jsonContent!=null){
                            OptionsJSON2Apex jsondatawrapper = (OptionsJSON2Apex)JSON.deserialize(jsonContent,OptionsJSON2Apex.class);
                           // OptionsJSON2Apex jsondatawrapper =  OptionsJSON2Apex.parse(jsonContent);
                                //System.debug(jsondatawrapper);
                                
                            //Jsondatawrapper.option.optionname;
                            
                            ldopt.Lead_Id__c= ld.id; 
                            ldopt.Manufacturer_Code__c = jsondatawrapper.option.manufacturercode ;
                            ldopt.Inventory_Number__c = jsondatawrapper.option.stock ;
                            
                           ldopt.name = jsondatawrapper.option.optionname;
                           ldopt.Lead_Option_Name__c =  jsondatawrapper.option.optionname;
                            
                            
                          // option name is triming if it is morethan 80 characters  
                           if(!string.isblank(ldopt.name) && ldopt.name.length()>80){
                                ldopt.name= ldopt.name.substring(0,80);
                            }
                           //updating AK_Lead_option field and it contains manufacturer code and lead id 
                            if(ldopt.AK_Lead_Option__c == null)
                            {
                              ldopt.AK_Lead_Option__c = ldopt.Manufacturer_Code__c+ldopt.Lead_Id__c;  
                            }
                          
                            if(ldopt.Lead_Option_Name__c != null ){
                                if( (ldopt.Lead_Option_Name__c.startswith('Factory Installed Feature'))||(ldopt.Lead_Option_Name__c.startswith('FIF'))){
                                    ldopt.Option_Type__c = 'Factory Installed Feature';
                                }else{
                                    ldopt.Option_Type__c = 'Accessory';
                                    }
                            }
                            
                            
                                    
                          List<OptionsJSON2Apex.price> plist = new List<OptionsJSON2Apex.price>();
                            
                            if(jsondatawrapper.option.price != null)
                                plist = jsondatawrapper.option.price;
                            
                            //System.debug('plist--------'+plist);
                            for(OptionsJSON2Apex.price  p: plist ){
                            //System.debug('price record--------'+p);
                                
                                if (p.type=='' || p.type=='null' || p.type== null) {
                                    if(p.ele_text !=null){
                                    ldopt.Price_Amount__c = Decimal.valueOf(p.ele_text);
                                    }                                   
                                }
                            }                          
                            optionsList.add(ldopt);                       
                                                     
                        }
                
            }
        }
        
            //System.debug(optionsList);
            if(optionsList.size()>0){
                
                Database.SaveResult[]  optlistresult = Database.insert(optionsList, false);
                
                for (Database.SaveResult result : optlistresult){
                    if (!result.isSuccess()){
                        
                        //Error ecountered              
                        for(Database.Error error : result.getErrors()) {
                            //Handle error
                            // System.debug(error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                            Logs__c logRecord = new Logs__c(Name='Lead Trigger -Optins insert',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler',Error_Message__c = error.getMessage() + '' +error.getFields(),Error_Line_Number__c = 0);
                            insert logRecord;

                        }
                    }
                }
            }
        
        } Catch(Exception ex){
            
            Logs__c  l =new Logs__c (name='Lead Trigger',Trigger_or_Class_Name__c='HELMSOptionsinsertHandler', Error_Message__c =ex.getMessage(), Error_Line_Number__c =Integer.valueOf(string.valueof(ex.getLineNumber() )) );
           insert l;
        }   
   }
}