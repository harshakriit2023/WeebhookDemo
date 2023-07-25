public class EmployeeAttendanceController {    
   
    @AuraEnabled
    public static List<Employee_Attendance__c> getempData(){
        return [Select id,Name,Account_Name__c,Date__c,End_Time__c,Start_Time__c,Notes__c From Employee_Attendance__c];
    }
    @AuraEnabled
    public static List<Employee_Attendance__c> deleteemp(String empId)
    {
        system.debug('===empId=='+empId);
        Employee_Attendance__c delemp=[Select id,Name,Account_Name__c,Date__c,End_Time__c,Start_Time__c,Notes__c from Employee_Attendance__c where id=:empId];
        delete delemp;
        return getempData();
    }
    
}