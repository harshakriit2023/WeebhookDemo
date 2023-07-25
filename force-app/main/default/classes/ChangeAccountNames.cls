public class ChangeAccountNames {
  @InvocableMethod(label='Update Account Name' description='Extend profile to account names' category='Account')
  public static List<String> changeAccNames(List<String> accountIds) {
    List<String> updatedIds = new List<String>();
    if(accountIds != null && !accountIds.isEmpty()){
        List<Account> accToUpdateList = new List<Account>();
        For(Account acc : [Select Id, Name From Account Where id in:accountIds]){
            acc.Name = acc.Name + '-profile';
            accToUpdateList.add(acc);
        }
        if(!accToUpdateList.isEmpty()){
            Database.saveResult[] srList = Database.Insert(accToUpdateList,false);
            For(Database.saveResult sr : srList){
                if(sr.isSuccess()){
                    updatedIds.add(sr.getId());
                }else{
                    system.debug('----error saving---'+sr.getErrors());
                }
            }
        }
    }
    return updatedIds;
  }
}