public with sharing class CaseAssignmentService {
    PriorityQueue pq;

    public CaseAssignmentService() {
        pq = new PriorityQueue();
        List<Representative__c> reps = [SELECT Id,Name, Score__c,OwnerId FROM Representative__c ORDER BY Score__c DESC];
        System.debug('CaseAssignmentService::reps'+reps);
        for (Representative__c rep : reps) {
            pq.enqueue(rep);
        }
    }

    public void assignCases(List<Case> cases) {
        for (Case c : cases) {
            Representative__c rep = pq.dequeue();
            c.Assigned_Rep__c = rep.Id;
            c.OwnerId = rep.OwnerId;
            pq.enqueue(rep);
        }
        System.debug('assignCases::cases:'+cases);
        update cases;
    }
}