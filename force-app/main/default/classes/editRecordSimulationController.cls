public class editRecordSimulationController {

    @AuraEnabled
    public static Employee_Attendance__c getTypeFromAccount(string recordId)
    {
        Employee_Attendance__c acc = [Select id,Name,Account_Name__c,Date__c,End_Time__c,Start_Time__c,Notes__c From Employee_Attendance__c Where Id = :recordId limit 1];
        return acc;
    }
}