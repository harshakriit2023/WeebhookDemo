public inherited sharing class LWCExamples {
 
    @AuraEnabled(Cacheable = true)
    public static list<Account> retriveAccs(String strAccName) {
        system.debug('--retriveAccs::strAccName---'+strAccName);
        strAccName = '%' + strAccName + '%';
        system.debug('--strAccName---'+strAccName);
        list<Account> lstAccs = [SELECT  Id, Name, Industry, Phone, Type From Account WHERE Name LIKE :strAccName LIMIT 10];
        system.debug('--lstAccs--'+lstAccs);
        if(lstAccs.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return lstAccs; 
    }
}