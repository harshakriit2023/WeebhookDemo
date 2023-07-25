public class createContactClass {
    public void method1(List<Account> newList,List<Account> oldList,Map<id,Account> newMap,Map<id,Account> oldMap){
        system.debug('====newList=='+newList);
        system.debug('====oldList=='+oldList);
        system.debug('====newMap=='+newMap);
        system.debug('====oldMap=='+oldMap);
        for(Account obj:newList){
            system.debug('New Value of phone from newMap'+newMap.get(obj.id).phone);
        }
        for(Account obj1:oldList){
            system.debug('Old Value of phone from oldMap'+oldMap.get(obj1.id).phone);
        }


    }
}