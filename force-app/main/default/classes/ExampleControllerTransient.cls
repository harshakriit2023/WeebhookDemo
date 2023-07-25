public class ExampleControllerTransient {
	 DateTime t1;
    transient DateTime t2;
    Transient Integer currentTotal;

    public String getT1() {
        if (t1 == null) t1 = System.now();
        system.debug('---t1---'+t1);
        currentTotal = 12;
        return '' + t1;
    }

    public String getT2() {
        if (t2 == null) t2 = System.now();
          system.debug('---t=2---'+t2);
        currentTotal = 12;
        return '' + t2;
    }
}