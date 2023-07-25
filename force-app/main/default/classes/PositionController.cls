public class PositionController
{
    public String currentRecordId {get;set;}
    public string currentLocId{get;set;}
    public String parameterValue {get;set;}
    public Position__c pos{get;set;}
    public Location__c loc{get;set;}
    public boolean ischeckbox {get;set;}
    public PositionController(ApexPages.StandardController controller) 
    {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        currentLocId = ApexPages.CurrentPage().getparameters().get('locId');
        List<Position__c> posList = [select id ,name, TestCheckbox__c from Position__c where id =: currentRecordId ];
        system.debug('====posList==='+posList);
        pos = posList.get(0);
        system.debug('===pos=='+pos);
        if(pos.TestCheckbox__c)
        {
            ischeckbox = true;
        }
        List<Location__c> locList = [Select id,Name,TestCheckboxLoc__c from Location__c where id =: currentLocId];
        system.debug('===locList===='+locList);
        loc = locList.get(0);
        system.debug('===loc=='+loc);
        if(ischeckbox)
        {
                loc.TestCheckboxLoc__c = ischeckbox;
        }
        submitPos();
        //Database.update(pos);
        //system.debug('====ischeckbox=='+loc.TestCheckboxLoc__c);
        //parameterValue = ApexPages.CurrentPage().getparameters().get('nameParam');
                
    }
    public void submitPos()
    {
        system.debug('===pos=='+pos);
    }
}