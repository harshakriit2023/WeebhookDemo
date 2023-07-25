public class ExampleController {

    DateTime t1;
    transient DateTime t2;

    public String getT1() {
        if (t1 == null) 
        
        t1 = System.now();
        system.debug('===t1=='+t1);
        return '' + t1;
    }

    public String getT2() {
        if (t2 == null) t2 = System.now();
        system.debug('===t2=='+t2);
        return '' + t2;
    }
}