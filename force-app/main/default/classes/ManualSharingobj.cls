public class ManualSharingobj {
    
    public static void mannualsharing(Id recordId, Id usergroupId)
    {
        system.debug('====recordId==='+recordId);
        system.debug('====usergroupId==='+usergroupId);
        Position__Share poshare = new Position__Share();
        poshare.ParentId = recordId;
        poshare.UserOrGroupId = usergroupId;
        poshare.AccessLevel = 'edit';
        poshare.RowCause = Schema.Position__Share.RowCause.PosSharing__c;
        
        system.debug('====poshare==='+poshare);
        
  		insert poshare;
        
        system.debug('====poshare::insert==='+poshare);
    }

}