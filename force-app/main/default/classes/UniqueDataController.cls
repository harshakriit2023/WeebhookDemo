public with sharing class UniqueDataController {
   
    @AuraEnabled
    public static string getContactData(string cLname,string cEmail, string cPhone){
        try {
            List<contact> conList = [SELECT Id,Name,Email,Phone FROM contact WHERE Name =:cLname and Email =:cEmail and Phone =:cPhone];
            System.debug('---conList--'+conList);
            if(conList != null && conList.size() >0){
                system.debug('--if---');
                return 'Dublicate Record Found';
            }else{
                system.debug('--else---'); 
                contact con = new contact();
                con.LastName = cLname;
                con.Email = cEmail;
                con.Phone = cPhone;
                conList.add(con);    
                insert conList;          
                return 'Success';               
            }        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        //return null;   
    }
}