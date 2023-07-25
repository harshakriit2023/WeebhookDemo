@isTest
private class DataGenerationTest {
  @testSetup
  static void dataCreation() {
      Account account = TestFactory.getAccount('Surya consultant', true);
      Contact contact = TestFactory.getContact(account.Id, 'Harsha', 'Patel', true);
      Opportunity opp = New Opportunity();
      opp.Name = 'Long lost record';
      opp.AccountId = account.Id;
      opp.CloseDate = Date.today().addDays(14);
      opp.StageName = 'Prospecting';
      insert opp;
  }
  static void testBruteForceAccountCreation() {
      List<Account> accts = new List<Account>();
      Test.startTest();
      	accts = [SELECT Id FROM Account];
      Test.stopTest();
      Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account created on the Test Setup');
  }
  static void testUseTestFactoryToCreateAccountsWithContacts() {
      List<Account> accts;
      List<Contact> contacts;
      TestFactory.generateAccountWithContacts(5);
      Test.startTest();
          accts = [SELECT Id FROM Account];
          contacts = [SELECT Id FROM Contact];
      Test.stopTest();
      Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account created');
      Assert.isTrue(contacts.size() == 6, 'Was expecting to find 6 contacts');
      Assert.areNotEqual(accts.size(), contacts.size(), 'Was expecting there to be a different number of account and contacts');
  }
  static void testAtTestSetupMethodsRule() {
      List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity];
      Assert.areEqual(1, opps.size(), 'Expected test to find a single Opp');
  }
}