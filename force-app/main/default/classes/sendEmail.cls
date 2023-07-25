public with sharing class sendEmail {
   
    @AuraEnabled(cacheable=true)
    public static list<EmailTemplate> getemailTemplt() {
        system.debug('---getemailTemplt---');
        list<EmailTemplate> emailtemplst = new list<EmailTemplate>();
        emailtemplst = [select Id,Name,folderid,folderName from EmailTemplate where Folder.name = 'Test Folder'];
        system.debug('---emailtemplst---'+emailtemplst);
        return emailtemplst;
    }
    @AuraEnabled(cacheable=true)
    public static string getSelectedtemplate(string selecttempId,string accountId)
    {
        system.debug('---getSelectedtemplate---');
        system.debug('---selecttempId---'+selecttempId);
        system.debug('---accountId---'+accountId);
        
        Account acc = [select Id,Name,CYSP__Email__c,OwnerId from Account where id =:accountId];
        system.debug('---Account record--'+acc);

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(acc.OwnerId);
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        message.setTemplateID(selecttempId);
        message.setWhatId(accountId); 
        message.toAddresses = new String[] { acc.CYSP__Email__c};
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        system.debug('---results----'+results);
        
        return selecttempId;
    }
}