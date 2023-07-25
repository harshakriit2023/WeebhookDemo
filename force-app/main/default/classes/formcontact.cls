public with sharing class formcontact {
    
    @AuraEnabled
    public static contact CreateNewContact(contact con)
    {
        system.debug('===con==='+con);
        upsert con;
        system.debug('===upsert::con==='+con);
        return con;
    }
}