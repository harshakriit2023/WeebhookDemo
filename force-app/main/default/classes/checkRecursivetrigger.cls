public class checkRecursivetrigger {
    public static boolean run = true;
    public static boolean checkRecursiverun()
    {
        if(run)
        {
            system.debug('===run==='+run);
            run = false;
            return true;
        }
        else
        {
            return run;
        }
    }

}