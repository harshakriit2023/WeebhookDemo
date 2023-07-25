public class contactTriggerHandler {
	
    public static boolean isTriggerRun = false;
    public static void getcontactInsertList(List<Contact> conInsertList){
    	List<Contact> conInsertOfList = new List<Contact>();
        for(Contact con:conInsertList){
            contact c = new Contact();
            c.AccountId = con.AccountId;
            c.LastName = con.LastName + 'Dublicates Contacts';
            conInsertOfList.add(c);
        }
        if(conInsertOfList.size() >0){
            Insert conInsertOfList;
        }
    }
    public static void getContactWithAccountInsertList(List<Contact> conInsertList){
        List<Account> accInsertList = new List<Account>();
        for(Contact con:conInsertList){
            Account acc = new Account();
            acc.Name = con.LastName;
            accInsertList.add(acc);
        }
        if(!accInsertList.isEmpty()){
            Insert accInsertList;
        }
    }
    public static void getContactRelatedAccount(List<Contact> conInsertList){
        System.debug('---conInsertList----'+conInsertList);
        set<Id> accId = new set<Id>();
        for(Contact con:conInsertList){
            accId.add(con.AccountId);
        }
        System.debug('---accId----'+accId);
        List<Account> accNumbetofContactList = [SELECT ID,Name,(SELECT ID,Name FROM contacts) FROM Account WHERE ID in:accId];
        System.debug('--accNumbetofContactList--'+accNumbetofContactList);
        List<Account> accUpdate = new List<Account>();
        for(Account acc:accNumbetofContactList){
            System.debug('acc.contacts.Size()'+acc.contacts.Size());
            acc.NumberofLocations__c = acc.contacts.Size();
            System.debug(' acc.NumberofLocations__c'+ acc.NumberofLocations__c);
            accUpdate.add(acc);
        }
        if(!accUpdate.isEmpty()){
            Update accUpdate;
        }
        System.debug(' acc.contacts.Size()'+ accUpdate);
    }
}