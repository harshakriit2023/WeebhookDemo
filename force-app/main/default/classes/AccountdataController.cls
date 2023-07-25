public with sharing class AccountdataController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Type, Phone 
            FROM Account limit 10];
    }
}