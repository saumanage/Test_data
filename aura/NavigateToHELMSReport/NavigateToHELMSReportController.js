({
	doInit : function(component, event, helper) {
        
       
	},
    gotoURL : function(component, event, helper) {
        /*var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/006/o"
        });
        urlEvent.fire(); */	
        
         console.log('@@In Init');
        var urlEvent = $A.get("e.force:navigateToURL");
        var dashboardURL = $A.get("$Label.c.Dashboard_URL");// To store the dashboard URL
        console.log('@@dashboardURL : '+dashboardURL);
        var urlInstance = window.location.hostname;
        //Map<String, SSO_Redirects__c> mapSSORedirect = SSO_Redirects__c.getAll();
        //console.log('@@mapSSORedirect : '+mapSSORedirect);
        urlEvent.setParams({
         //"url": "https://americanhondamotorcohelms--ahmdev.lightning.force.com/lightning/r/Report/00O7c000000iTasEAE/view"
       // "url": "https://americanhondamotorcohelms--ahmdev.lightning.force.com/analytics/dashboard/0FK7c0000004E29GAE"
        "url": dashboardURL
        });
        urlEvent.fire();
	}
})