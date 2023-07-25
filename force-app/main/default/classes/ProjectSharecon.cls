public class ProjectSharecon {
    
    public static void provideAccess(list<Project__c> pro)
    {
        list<Project_Member__c> tmlist = new list<Project_Member__c>();
        Map<id,Project_Member__c> tmmap = new Map<id,Project_Member__c>();
        list<Project__Share> sharelist = new list<Project__Share>();
       	tmlist = [select id,name,Project__c,Contact__r.OwnerId from Project_Member__c where Project__c in : pro];
        system.debug('====tmlist===='+tmlist);
        for(Project_Member__c s : tmlist)
        {
            tmmap.put(s.Project__c,s);
        }
        system.debug('===tmmap==='+tmmap);
        for(Project__c rec: pro)
        {
            system.debug('===rec==='+rec);
            Project__Share pshare = new Project__Share();
            pshare.parentId = rec.id;
            pshare.AccessLevel = 'Edit';
            pshare.RowCause = Schema.Project__Share.RowCause.OwnerSharing__c;
            pshare.UserOrGroupId = tmmap.get(rec.id).Contact__r.OwnerId;
            sharelist.add(pshare);
        }
        system.debug('====sharelist==='+sharelist);
        if(sharelist != null && sharelist.size() > 0)
        {
            insert sharelist;
        }     
    }
        public static void removeaccess(list<Project__c> pro)
    {
        system.debug('===pro=='+pro);
        list<Project__Share> psharelist = new list<Project__Share>();
        psharelist = [select id from Project__Share where parentId in : pro AND RowCause ='OwnerSharing__c'];
        system.debug('====psharelist===='+psharelist);
        delete psharelist;
    }
    
}