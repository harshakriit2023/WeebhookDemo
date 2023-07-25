public class AccountTriggerHandler {
    
    public static void undeleteAccount(List<Account> unDeleteAccount){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Account accRec :unDeleteAccount){
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            List<String> userEmail = new List<String>();
            userEmail.add(UserInfo.getUserEmail());
            emailMessage.setToAddresses(userEmail);
            emailMessage.setSubject('Account is successfully UnDelete'+accRec.Name);
            emailMessage.setPlainTextBody('Hi..No body is here');
            emails.add(emailMessage); 
        }
        Messaging.sendEmail(emails);
    }
}