public class dataTableCon {
 
    List<Lead> leadList;
 
    public List<Lead> getleadList() {
        if(leadList == null)
            leadList = [SELECT name, Owner.Name, CreatedBy.Name FROM Lead LIMIT 10];
        return leadList;
    }
 
}