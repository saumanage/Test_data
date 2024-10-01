public class RecordIdEncryptionUtil {
    //@InvocableMethod
    public static String encryptRecordId(Id recId){
        String encodeIdMapStr = '';
    	/*Encrypts the Record Id*/    
        List<Lead> leadsToUpdate = new List<Lead>();
        Lead leadRec = [SELECT Id, Lead_SF_ID__c FROM Lead WHERE Id = :recId];
        String encodedId = '';
        Datetime dt = system.now();
        String s = string.valueof(dt);
        String s2 = s.replaceAll('\\D','');
        String sKey = userinfo.getOrganizationId() +s2;
        Blob sKeyBLob = blob.valueOf(sKey);
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', sKeyBLob, Blob.valueOf(recId));
        String encodedCipherText = EncodingUtil.convertToHex(cipherText); 
        encodeIdMapStr = EncodingUtil.urlEncode(encodedCipherText,'UTF-8') ;
        system.debug('encoded version' + encodeIdMapStr);
        return encodeIdMapStr;
    }
	
	public static String generateRandomString(Integer len) {
        Datetime dt = system.now();
        String s = string.valueof(dt);
        String s2 = s.replaceAll('\\D','');
        //String sKey = userinfo.getOrganizationId() +s2;
        String sKey = s2;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        String finalEncodedString = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        finalEncodedString = sKey+randStr;
        return finalEncodedString; 
    }

    
    /*public static String encryptId(){
        Datetime dt = system.now();
        String s = string.valueof(dt);
        String s2 = s.replaceAll('\\D','');
        String sKey = userinfo.getOrganizationId() +s2;
        // the list that you want to pick chars and numbers from
        String CharList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        // position in list, count will start from 0. EX. 'a' is in position 0, 'b' is in position 1
        Integer position;
        // length of random strings, ex. 20
        Integer LengthRequired = 20;
        // get 64 chars from list randomly
        
        String EncodedString = '';
        for(Integer i = 0; i <= LengthRequired; i++) {
            position = Integer.valueof(String.valueof(Math.roundToLong(CharList.length()*Math.random()))) -1;
            // the random Strings
            String Res = CharList.substring(position,position+1);
            //if( i == LengthRequired){
               // EncodedString = Res;
            //}
        }
        //EncodedString = Res+sKey;
        
        return EncodedString;
    }*/
    
    
}