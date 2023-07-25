/*********************************************************************************
Class Name: Customer

Purpose:    1. This is the class for creating data.

Please maintain only the last 5 history changes/modifications in the audit log

History of Changes:                
--------------------------------------------------------------------------------------------------------------------------
Date                                          Developer                               Comments
--------------------------------------------------------------------------------------------------------------------------
15-05-2023                         Harsha         Added new method
********************************************************************************/
public class Customer {
	//variable
    public String cusName;
    public String accType;
    public String accPin;
    public Decimal accBalance;
    
    //Constructor 
    public Customer(){
        accBalance = 1000;
        accPin = '1234';
        deposit(15);
    }
    
    //Deposit
    public void deposit(Decimal amount){
        accBalance = accBalance + amount;
        bankBalance(accBalance);
    }
    public void bankBalance(Decimal Amount){
        accBalance = accBalance + amount;
        accPin = '1234';
        accBalance ++;
    }
}