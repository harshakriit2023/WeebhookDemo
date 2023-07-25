public with sharing class SearchDataUsingImpController {
    
    @AuraEnabled
    public static list<contact> getSearchName(string searchKey){
        try {
            string cStr = '%'+ searchKey +'%';
            List<contact> conList = [SELECT Id,Name,Account.Name FROM contact WHERE Name LIKE :cStr];
            system.debug('---conList--'+conList);
            if(conList != null && conList.size() >0){
                return conList;
            }
            else{
                return null;
            }      
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static list<contact> getSearchNameWire(string searchKey){
        try{
            string cStr = '%'+ searchKey +'%';
            List<contact> conList = [SELECT Id,Name,AccountId,Account.Name FROM contact WHERE Name LIKE :cStr];
            system.debug('---conList--'+conList);
            if(conList != null && conList.size() >0){
                return conList;
            }
            else{
                return null;
            }      
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }     
}