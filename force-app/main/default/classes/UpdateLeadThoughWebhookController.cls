@RestResource(urlMapping = '/leadUpdate/*')
global without sharing class UpdateLeadThoughWebhookController{
   @HttpPost
    global static String updateLead(String firstName, String lastName,String company) {
        System.debug('-----updateLead---');
        Lead newLead = new Lead();
        newLead.FirstName = firstName;
        newLead.LastName = lastName;
        newLead.company = company;
        // Set other required lead fields as needed
        insert newLead;
        return newLead.Id;
    }
}