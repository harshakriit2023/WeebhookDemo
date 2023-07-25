public class ContactList {
   
    list<contact> listofContact = new list<contact>();
    public void contactmethod()
    {
        for(integer i=0;i<=1;i++)
        {
            contact con = new contact(LastName='contact'+i);
            listofContact.add(con);
            system.debug('===listofcontact=='+listofcontact);
        }
        insert listofContact;
        system.debug('===listofContact=='+listofContact);
    }

}