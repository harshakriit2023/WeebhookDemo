public class ContactMasterHandler
{
	public void createContactRelationshipByContact(List<Contact> List_Contacts)
	{
		List<Contact_Relationship__c> conList = new List<Contact_Relationship__c>();
		for(Contact newconts : List_Contacts)
		{
			if(newconts.Contact_Relationship__c == true)
			{
				Contact_Relationship__c cr = new Contact_Relationship__c();
				cr.name = newconts.Lastname;
				cr.Contact__c = newconts.id;
				conList.add(cr);
				system.debug('==conList=='+conList);
			}
		}
		if(conList != null && conList.size() > 0)
		{
			insert conList;
			system.debug('==conList=='+conList);
		}
	}
}