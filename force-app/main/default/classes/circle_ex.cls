public class circle_ex
{
    public integer a,b,c,k;
    public decimal d1;
    public string s1;
    public circle_ex()
    {
        a=b=k=0;
    }
    public circle_ex(integer n1,integer n2)
    {
        this.a=n1;
        this.b=n2;
    }
    public circle_ex(integer n1,integer n2,integer n3)
    {
        this.a=n1;
        this.b=n2;
        this.k=n3;
    }
    public circle_ex(integer n1,decimal d2,integer n3)
    {
        this.a=n1;
        this.d1=d2;
        this.k=n3;
    }
    public circle_ex(integer n1,string s2,integer n3)
    {
        this.a=n1;
        this.s1=s2;
        this.k=n3;
    }
    public void show()
    {
        system.debug('a is::a'+a);
        system.debug('b is::b'+b);
        system.debug('k is::k'+k);
        system.debug('d1 is::d1'+d1);
        system.debug('s1 is::s1'+s1);
    }

}