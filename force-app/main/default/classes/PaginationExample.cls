public class PaginationExample
{
    public Integer totalrec = 0;
    public Integer index = 0;
    public Integer blocksize = 5 ;

    public PaginationExample()
    {
        totalrec = [select count() from Account];
        system.debug('===totalrec==='+totalrec);
    }
    public list<Account> getacc(){
        
        list<Account> Acclist = [select id,Name,Phone from Account limit : blocksize OFFSET :index];
        system.debug('===Acclist=='+Acclist);
        return Acclist;
    }
    public void beggin()
    {
        system.debug('====beggin===');
        index = 0;
    }
    public void next()
    {
        index = index + blocksize;
        system.debug('===next::index==='+index);
    }
    public void previous()
    {
        index = index - blocksize;
        system.debug('===previous::index=='+index);
    }
    public void end()
    {
        index = totalrec - math.mod(totalrec,blocksize);
    }
    public boolean getnext()
    {
        if(index == 0)
        {
            return true;
        }
        else{
            return false;
        }
    }
    public boolean getprev()
    {
        if((index+blocksize) > totalrec)
        {
            return true;
        }
        else{
            return false;
        }
    }
}