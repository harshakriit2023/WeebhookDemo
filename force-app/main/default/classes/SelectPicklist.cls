public class SelectPicklist
{
    public SelectPicklist(Apexpages.standardcontroller controller)
    {
        
    }
    public string yearValue{set;get;}
    public boolean yearValue1{set;get;}
    public boolean yearValue2{set;get;}
    public List<SelectOption> getyearList()
    {
        list<SelectOption> option = new list<SelectOption>();
        option.add(new SelectOption('','--None--'));
        option.add(new SelectOption('1','2021'));
        option.add(new SelectOption('2','2022'));
        system.debug('===option==='+option);
        return option;
    }
    public void picklist()
    {
        system.debug('===yearValue==='+yearValue);
        system.debug('===yearValue1==='+yearValue1);
        system.debug('===yearValue2==='+yearValue2);
        if(yearValue == '2')
        {
            yearValue1 = true;
            system.debug('===yearValue1==='+yearValue1);
        }
        else{
            yearValue2 = true;
            system.debug('===yearValue2==='+yearValue2);
        }
    }
}