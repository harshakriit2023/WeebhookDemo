public with sharing class CaseService {
    public static void updateRepScore(Map<Id, Case> newCaseMap, Map<Id, Case> oldCaseMap) {
        System.debug('newCaseMap::'+newCaseMap);
        System.debug('oldCaseMap::'+oldCaseMap);
        List<Representative__c> repsToUpdate = new List<Representative__c>();
        System.debug('newCaseMap.values()::'+newCaseMap.values());
        Set<Id> repId = new Set<Id>();
        for(Case c : newCaseMap.values()){
            Case oldCase = oldCaseMap.get(c.Id);
            if (c.Status == 'Closed' && oldCase.Status != 'Closed' && c.Assigned_Rep__c != null) {
                repId.add(c.Assigned_Rep__c);
            }
        }

       	List<Representative__c> repList = [SELECT Id, Score__c FROM Representative__c WHERE Id = :repId];
        System.debug('--repList--'+repList);
        if(!repList.isEmpty()){
            for(Representative__c rep :repList){
                Representative__c r = new Representative__c();
                r.Id =rep.Id;
                r.Score__c = rep.Score__c + 1;
                repsToUpdate.add(r);
        	}
        }  
        System.debug('--repsToUpdate--'+repsToUpdate);
 		/*for (Case c : newCaseMap.values()) {
            Case oldCase = oldCaseMap.get(c.Id);
            System.debug('oldCaseMap::'+oldCaseMap);
            System.debug('oldCaseMap::'+oldCaseMap.get(c.Id));           
            if (c.Status == 'Closed' && oldCase.Status != 'Closed' && c.Assigned_Rep__c != null) {
                System.debug('Assigned_Rep__c::'+c.Assigned_Rep__c);
                System.debug('Assigned_Rep__c::'+c.Assigned_Rep__r.Score__c);
                Representative__c rr = new Representative__c();
                rr.Id = c.Assigned_Rep__c;
                rr.Score__c = c.Assigned_Rep__r.Score__c + 1;
                repsToUpdate.add(rr);
                System.debug('IF::repsToUpdate::'+repsToUpdate);
                //repsToUpdate.add(new Representative__c(Id = c.Assigned_Rep__c, Score__c = c.Assigned_Rep__r.Score__c + 1));
            }
        }*/
        System.debug('repsToUpdate::'+repsToUpdate);
        if(!repsToUpdate.isEmpty()){
           update repsToUpdate; 
        }

    }
}