@istest

public class circle_exTest
{
    
    static testmethod void circle_ex1()
    { 
        
        
        circle_ex c1 = new circle_ex();
        system.assertEquals(0,c1.a);
        system.assertEquals(0,c1.b);
        system.assertEquals(0,c1.k);
        system.assertEquals(null,c1.d1);
        system.assertEquals(null,c1.s1);
        c1.show();
        
        circle_ex c2 = new circle_ex(10,10);
        system.assertEquals(10,c2.a);
        system.assertEquals(10,c2.b);
        system.assertEquals(null,c2.k);
        system.assertEquals(null,c2.d1);
        system.assertEquals(null,c2.s1);
        c2.show();
    
        circle_ex c3 = new circle_ex(10,10,10);
        system.assertEquals(10,c3.a);
        system.assertEquals(10,c3.b);
        system.assertEquals(10,c3.k);
        system.assertEquals(null,c3.d1);
        system.assertEquals(null,c3.s1);
        c3.show();
        
        circle_ex c4 = new circle_ex(10,1.5,10);
        system.assertEquals(10,c4.a);
        system.assertEquals(null,c4.b);
        system.assertEquals(10,c4.k);
        system.assertEquals(1.5,c4.d1);
        system.assertEquals(null,c4.s1);
        c4.show();
        
        circle_ex c5 = new circle_ex(10,'circle',10);
        system.assertEquals(10,c5.a);
        system.assertEquals(null,c5.b);
        system.assertEquals(10,c5.k);
        system.assertEquals(null,c5.d1);
        system.assertEquals('circle',c5.s1);
        c5.show();
    }

}