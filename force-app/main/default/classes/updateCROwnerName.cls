public Class updateCROwnerName
{
	public void updateContactRelationshipNameByOwner(list<Contact_Relationship__c> cont_Rel)
	{
		map<Id,Id> map_Id_Own = new map<id,id>();

		map<Id,string> map_id_Name = new map<id,string>();

		set<id> Idset = new set<id>();
		system.debug('===Idset==='+Idset);
		for(Contact_Relationship__c List_recs:cont_Rel)
		{
			Idset.add(List_recs.Ownerid);
		}
		system.debug('===Idset==='+Idset);
		list<user> u=[select id,Name from user where id in:Idset];
		system.debug('===u==='+u);
		for(user list_users:u)
		{
			map_id_Name.put(list_users.Id,list_users.Name);
		}
		if(u!=null && u.size()>0)
		{
			for(Contact_Relationship__c List_recs:cont_Rel)
			{
				if (List_recs.Ownerid !=null)
				{

				List_recs.Name = map_id_Name.get(List_recs.Ownerid);
				}
			}
		}
	}
}