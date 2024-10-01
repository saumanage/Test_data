public Class HelmsCheckRecursive{
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
             run=false;
             return true;
        }else{
            return run;
        }
    }
    
    private static boolean isRun = true;
    public static boolean isRunOnce(){
        if(isRun){
             isRun=false;
             return true;
        }else{
            return isRun;
        }
    }
    
    private static boolean opptyisRun = true;
    public static boolean opptyisRunOnce(){
        if(opptyisRun){
             opptyisRun=false;
             return true;
        }else{
            return opptyisRun;
        }
    }
    
    private static boolean updateLeadGroupId = true;
    public static boolean updateLeadGroupIdValueOnceUpdate(){
        if(updateLeadGroupId){
             updateLeadGroupId=false;
             return true;
        }else{
            return updateLeadGroupId;
        }
    }
    
    private static boolean isCheck= true;
    public static boolean run_Once(){
        if(isCheck){
             isCheck=false;
             return true;
        }else{
            return isCheck;
        }
    }
}