/*********************************************************************************
Class Name: Employee

Purpose:    1. This is the class for creating data.

Please maintain only the last 5 history changes/modifications in the audit log

History of Changes:                
--------------------------------------------------------------------------------------------------------------------------
Date                                          Developer                               Comments
--------------------------------------------------------------------------------------------------------------------------
15-05-2023                         Harsha         Added new method
********************************************************************************/
public class Employee {
    //variable
    public String empName;
    public String empId;
    public String empSalary;
    public Date empDOB;
    
    //Display employee info
    public void displayEmpInfo(){
        System.debug('Employee Name:'+empName);
        System.debug('Employee Id:'+empId);
        System.debug('Employee Salary:'+empSalary);
        System.debug('Employee DOB:'+empDOB);
    }
}