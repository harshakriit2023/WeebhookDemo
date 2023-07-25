public class setx
{
    public static void setmtd()
    {
        set<integer> setInt = new set<integer>();
        setInt.add(1);
        setInt.add(2);
        setInt.add(3);
        setInt.add(2);
        setInt.add(4);
        system.debug('====myset is=='+setInt);
        system.debug('===myset size==='+setInt.size());
        setInt.remove(3);
        system.debug('===myset is==='+setInt.size());
        setInt.clear();
        system.debug('==myset is=='+setInt);
        system.debug('==myset is==='+setInt.IsEmpty());     
    }
    public static void Mapmtd()
    {
        Map<integer,string> mapInt = new Map<integer,string>();
        MapInt.put(1,'One');
        MapInt.put(2,'Two');
        MapInt.put(3,'Three');
        MapInt.put(4,'Four');
        
        system.debug('====MapInt=='+MapInt);
        system.debug('===MapInt size==='+MapInt.size());
        System.debug('====MapInt Get value==='+MapInt.get(3));  
        MapInt.remove(3);
        system.debug('===MapInt Remove value=='+MapInt.keySet());
        system.debug('===MapInt Remove value=='+MapInt.values());
        MapInt.clear();
        system.debug('===MapInt Remove value=='+MapInt);                
    }
 
}