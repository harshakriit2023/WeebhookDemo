public class wrapperEmployeeAttendanceController {    
   
    @AuraEnabled
    public static List<Employee_Attendance__c> getempData(){
        return [Select id,Name,Account_Name__c,Date__c,End_Time__c,Start_Time__c,Notes__c From Employee_Attendance__c];
    }
    @AuraEnabled
    public static List<Employee_Attendance__c> Editemp(String updateempId)
    {
        system.debug('===Editemp::updateempId=='+updateempId);
        Employee_Attendance__c updatemp=[Select Id,Name,Account_Name__c,Date__c,End_Time__c,Start_Time__c,Notes__c from Employee_Attendance__c where id=:updateempId];
        Update updatemp;
        return getempData();
    }
    @AuraEnabled
    public static List<Employee_Attendance__c> deleteemp(String empId)
    {
        system.debug('===empId=='+empId);
        Employee_Attendance__c delemp=[Select Id from Employee_Attendance__c where id=:empId];
        delete delemp;
        return getempData();
    }
    
}