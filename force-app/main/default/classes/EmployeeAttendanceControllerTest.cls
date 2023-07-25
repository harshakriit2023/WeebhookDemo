@isTest
Public class EmployeeAttendanceControllerTest{
    static testMethod void testMethod1()
     { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        String startTime = '21:30:00.000Z';
        Integer hour = Integer.valueOf(startTime.left(2)); //first 2 characters are hour
        Integer minute = Integer.valueOf(startTime.substringBetween(':',':'));
        
        Time t = Time.newInstance(hour, minute, 0, 0);
        
        Employee_Attendance__c emp = new Employee_Attendance__c();
        emp.Account_Name__c = acc.id;
        emp.Date__c = Date.Today();
        emp.End_Time__c = t;
        emp.Start_Time__c = t;
        emp.Notes__c = 'Test';
        insert emp;
        
        Employee_Attendance__c emp1 = new Employee_Attendance__c();         
        emp1.Account_Name__c = acc.id;
        emp1.Date__c = Date.Today();
        emp1.End_Time__c = t;
        emp1.Start_Time__c = t;
        emp1.Notes__c = 'Test';
        insert emp1;

   
        Test.startTest();
        
        EmployeeAttendanceController.getempData();
        EmployeeAttendanceController.deleteemp(emp.id);
        
        Test.stopTest();
        
     }
}