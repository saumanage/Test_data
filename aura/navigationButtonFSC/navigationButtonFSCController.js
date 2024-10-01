({
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    
    handleClick : function(component, event, helper) {
        		console.log('entering handleclick');
        		
        		component.set("v.fire", true);
              	var destType = component.get("v.destinationType");

              	if (destType == 'url') {
                   
                    //var urlEvent = $A.get("e.force:navigateToURL");
    				//var destUrl = component.get("v.destinationURL");
					
					
          			if( (typeof sforce != 'undefined') && (sforce.one != null) ) {
						 sforce.one.navigateToURL('/006/o');
                        
        			}
    				
                }
            	
    }  
})