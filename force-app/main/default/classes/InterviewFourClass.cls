public with sharing class InterviewFourClass {
 public list<Account> lstAcc{get;set;}

 public InterviewFourClass(){

 lstAcc = new list<Account>();

 lstAcc = [select id,name,(select id,lastname,phone,firstname,email from Contacts),phone from Account limit 10];

 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'this page was created ONLY one Query'));

}

 }