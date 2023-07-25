public class GetRoles {
	public static List<Id> getChildRolesWithUsers(Set<Id> roleIds)
    {
        List<UserRole> childRoles = [SELECT Id, Name,(SELECT Id,Name,IsActive FROM Users) FROM UserRole WHERE ParentRoleId IN :roleIds AND Id IN (SELECT UserRoleId FROM User)];
		System.debug('childRoles :::::::::'+childRoles);
        
        List<Id> userList = new List<Id>();
        
        for (UserRole roleRecord : childRoles) {
            // Perform desired actions with the child role records
            System.debug('Child Role ID: ' + roleRecord.Id);
            System.debug('Child Role Name: ' + roleRecord.Name);

            // Retrieve the associated users for the current child role
            List<User> users = roleRecord.Users;

            // Process the associated users
            for (User userRecord : users) {
                System.debug('User ID: ' + userRecord.Id);
                System.debug('User Name: ' + userRecord.Name);
                if(userRecord.IsActive)
                {
                    userList.add(userRecord.Id);
                }
            }
			System.debug('userList ::::::::' + userList);
            // Recursively call the method to fetch child roles of the current role
            userList.addAll(getChildRolesWithUsers(new Set<Id>{ roleRecord.Id }));
        }
        return userList;
    }
}