public class CaseReopenVfEmailHandler {
    
    @InvocableMethod
	public static void sendEmailForReopenCase(List<String> caseId)
    {
        System.debug('======caseId========' + caseId);
        
        Case caseDetails = [SELECT Id,CaseNumber,ContactEmail,Account_Email__c,Status FROM Case WHERE Id =:caseId[0]];
        System.debug('caseDetails ::::::' + caseDetails);
        EmailTemplate template = [SELECT Id, Markup, Name, DeveloperName, NamespacePrefix,Body, HtmlValue, Subject, Description, TemplateType, IsActive 
                                    FROM EmailTemplate 
                                    WHERE DeveloperName = 'Case_Closed_with_Survey_Link'];
        System.debug('template=='+template);
        
        String hBody = template.Markup.substringBetween('<messaging:htmlEmailBody >','</messaging:htmlEmailBody>');
        system.debug('----hBody---'+hBody);
        if(!String.isBlank(caseDetails.CaseNumber)){
            hBody = hBody.replace('{@CaseNumber}', caseDetails.CaseNumber);
        }
      //String link = 'https://dubaiproperties--cloudzlab--c.sandbox.vf.force.com/apex/CaseReopenMessage?core.apexpages.request.devconsole=1';
        String link = 'https://patel081996-dev-ed.my.salesforce.com/CaseReopenMessage?c__cid=' + caseId[0];
        System.debug('=======link=======' + link);
       hBody = hBody.replace('{@link}', link);
      //if(!String.isBlank(userFName)) { hBody = hBody.replace('{@FirstName}', userFName); }
        
        system.debug('hBody WITH DATA =='+hBody);
        string subj = 'Reopen the case';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> toAddresses = new List<String>();
        system.debug('ContactEmail ' + caseDetails.Account_Email__c);
        toAddresses.add(caseDetails.Account_Email__c);
        System.debug('toAddresses--- ' + toAddresses);
        
        mail.setToAddresses(toAddresses);
        mail.setSubject(subj);
        mail.setUseSignature(false); 
        mail.setBccSender(false); 
        mail.setHtmlBody(hBody);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 	
}