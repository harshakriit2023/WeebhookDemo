@isTest
public class AutoincrementAccountTest 
{
    static testMethod void TestMethod1() {
        
        Test.startTest();
        
        Account acc = new Account();
        acc.name = 'Test';
        acc.AccountNumber = '1234'; 
        
        insert acc;
        
        Account objacc = new Account();
        objacc.id = acc.id;
        objacc.AccountNumber = '12345';
        
        update objacc;

        Test.stopTest();
    }
}