public with sharing class LeadCreationController {
   @AuraEnabled
    public static void createLead(String firstName, String lastName,string company) {
        Lead newLead = new Lead();
        newLead.FirstName = firstName;
        newLead.LastName = lastName;
        newLead.company = company;
        // Set other required lead fields as needed
        
        Database.insert(newLead);
    }
}