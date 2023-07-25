public without sharing class CaseReopenLWCHandler {
	@Auraenabled 
    public static String checkCaseCloseDate(String caseId)
    {
        System.debug('caseId ==========' + caseId);
       	Case caseDetails = [SELECT Id,ClosedDate FROM Case WHERE Id =: caseId];
		System.debug('caseDetails ==========' + caseDetails);
        
        Datetime now = Datetime.now(); // get the current datetime
        //Datetime now = Datetime.now().addDays(+7); // get the current datetime
        Datetime afterSevenDays;
        String result;
        List<case> childListOfCase = caseDetails.cases;
        
        if(!childListOfCase.isEmpty()){
            result = 'pass' + childListOfCase[0].CaseNumber;  
            return result;
        }
        if(caseDetails.ClosedDate != null)
        {
            afterSevenDays = caseDetails.ClosedDate.addDays(+7);
            System.debug('afterSevenDays ==========' + afterSevenDays);
            System.debug('now=========' + now);
            System.debug('caseDetails.ClosedDate=========' + caseDetails.ClosedDate);
        }
        if(now >= caseDetails.ClosedDate && now <= afterSevenDays)
        {
            System.debug('In the if ========');
            /*Case caseUpdate = new Case();
            caseUpdate.Id = caseDetails.Id;
            caseUpdate.Type = 'Complaint';
            caseUpdate.Case_Source__c = 'Closure Notification Communication';
            caseUpdate.Status = 'Reassigned';
            System.debug('---caseUpdate---'+caseUpdate);
            update caseUpdate;
            System.debug('caseUpdate.CaseNumber=========' + caseDetails.CaseNumber);
            result = 'pass' + caseDetails.CaseNumber;
            return result;*/
            //Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Land_Resell').getRecordTypeId();            
            Case caseReOpenCreate = new Case(); 
            //caseReOpenCreate.recordTypeId = recordTypeId;
            caseReOpenCreate.Type = 'Complaint';
            //caseReOpenCreate.Case_Source__c = 'Closure Notification Communication';
            caseReOpenCreate.Status = 'New';
            //caseReOpenCreate.Payment_threshold__c = caseDetails.Payment_threshold__c;
            caseReOpenCreate.ParentId = caseDetails.Id;
            System.debug('---caseReOpenCreate---'+caseReOpenCreate);
            insert caseReOpenCreate;
            //isCaseCreate = true;
            System.debug('caseReOpenCreate=========' + caseReOpenCreate);
            caseReOpenCreate = [SELECT Id,CaseNumber FROM case WHERE ID =:caseReOpenCreate.Id];
            System.debug('caseReOpenCreate.CaseNumber=========' + caseReOpenCreate.CaseNumber);
            result = 'pass' + caseReOpenCreate.CaseNumber;
            return result;
        }
        else if(caseDetails.Status == 'Reassigned'){
            result = 'pass' + caseDetails.CaseNumber;
            return result;
        }
        else
        {
            System.debug('In the else ========');
            result = 'fail' + caseDetails.CaseNumber;
            System.debug('result==============' + result);
            return result;
        }
    }
}