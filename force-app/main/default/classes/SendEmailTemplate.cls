public with sharing class SendEmailTemplate {
    
    static Contact mCon;
    
    @InvocableMethod(
            Label='Send Email Template Custom'
            Description='Send an email to a set of recipients using a Lightning Email Template'
            Category='Email'
    )
    public static void sendEmails(List<Request> requests) {
        for (Request request : requests) {
            sendEmails(request.emailTemplateName, request.orgWideEmailAddressId, request.relatedRecord);
        }
    }

    public class Request {
        @InvocableVariable(
                Label='Email Template Name'
                Description='The ID of the Email Template to use.'
                Required=true
        )
        public String emailTemplateName;

        @InvocableVariable(
                Label='Org-Wide Address ID'
                Description='The ID of the organization-wide email address associated with the outgoing email.'
                Required=true
        )
        public Id orgWideEmailAddressId;

        @InvocableVariable(
                Label='Related Records'
                Description='Records that are of the Email Template\'s related entity type'
                Required=true
        )
        public SObject relatedRecord;
    }

    public class Response {
        @InvocableVariable(
                Label='Successful Records'
                Description='Records that were successfully sent the Email Template'
                Required=true
        )
        public List<SObject> successes;

        @InvocableVariable(
                Label='Failed Records'
                Description='Records that failed to be sent the Email Template'
                Required=true
        )
        public List<SObject> failures;
    }

    private static void sendEmails(String emailTemplateName, Id orgWideEmailAddressId, SObject relatedRecord) {
        sendEmail(emailTemplateName, orgWideEmailAddressId, relatedRecord);
    }

    private static void sendEmail(String emailTemplateName, Id orgWideEmailAddressId, SObject relatedRecord) {
        try{ 
            mCon = new Contact(Lastname = 'CloudZLab', Email=((Case)relatedRecord).ContactEmail);
            insert mCon;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSaveAsActivity(false);
            message.setTargetObjectId( mCon.Id ); 
            message.setWhatId(relatedRecord.Id);
            
            EmailTemplate mEmailTemplate = [SELECT Id,DeveloperName FROM EmailTemplate WHERE DeveloperName =: emailTemplateName LIMIT 1];
            
            message.setTemplateId(mEmailTemplate.Id);
            message.setOrgWideEmailAddressId(orgWideEmailAddressId);
            message.setOptOutPolicy('FILTER');
            message.setUseSignature(false);
            message.setBccSender(false);
            message.setToAddresses(new List<String>{
                    getToAddress(relatedRecord)
            });
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
                    message
            };
            Messaging.SendEmailResult sendEmailResult = Messaging.sendEmail(messages)[0];
            
            if (!sendEmailResult.isSuccess()) {
                
                System.debug(String.format(
                        'ERROR: SendLightningEmail: failed to send template={0} orgWideEmailAddressId={1} relatedRecord.Id={2} error="{3}',
                    new List<Object> {emailTemplateName, orgWideEmailAddressId, relatedRecord.Id, sendEmailResult.errors[0].message}
                ));
            }
        }catch(Exception e){
            System.debug(String.format(
                'Exception occured: {0}, at Class {1}, Line Number: {2}',
                new List<Object> {e.getMessage(), 'SendEmailTemplate', e.getLineNumber()}
            ));
        }finally{
            delete mCon;
        }
    }

    private static Id getTargetObjectId(SObject relatedRecord) {
        return relatedRecord.Id;
    }

    private static String getToAddress(SObject relatedRecord) {
        // There is *definitely* an Enterprise programming pattern to make this pluggable
        if (relatedRecord instanceof Case) {
            return ((Case) relatedRecord).ContactEmail;
        } else if (relatedRecord instanceof Contact) {
            return ((Contact) relatedRecord).Email;
        } else if (relatedRecord instanceof User) {
            return ((User) relatedRecord).Email;
        } else if (relatedRecord instanceof Lead) {
            return ((Lead) relatedRecord).Email;
        } else {
            throw new IllegalArgumentException('Unsupported related record of type: ' + getClassName(relatedRecord));
        }
    }

    private static String getClassName(Object theObject) {
        return String.valueOf(theObject).split(':')[0];
    }

    private static Boolean isSaveAsActivity(Object theObject) {
        return !getClassName(theObject).equals('User');
    }
}