public with sharing class CaseProviders {
    @AuraEnabled
    public static list<case> getCaseDetails(string AccName)
    {
        System.debug('--AccName----'+AccName);
        List<case> caselist = new List<case>();
        try{
        String AccIds = [select Id,Name from Account where Name=:AccName].Id;
        system.debug('--AccIds---'+AccIds);
        caselist = [select Id,CaseNumber,AccountId,ContactId,ExternalId__c from case where AccountId =:AccIds]; 
        system.debug('---caselist---'+caselist);                
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        } 
        return caselist;    
    }
}