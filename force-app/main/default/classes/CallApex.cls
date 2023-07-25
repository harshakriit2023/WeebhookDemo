public with sharing class CallApex {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        system.debug('===getAccountList==');
        return [SELECT Id, Name, Type, Phone 
            FROM Account];
            
    }
}