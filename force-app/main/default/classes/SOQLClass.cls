public class SOQLClass {  
    public void fireQuery(){
	
        List<AggregateResult> oppList = [SELECT count(Id),Name FROM opportunity Group by Name HAVING count(Id) > 1 AND Name LIKE '%TEST%'];
     System.debug('oppList::'+oppList); //Group by use for Aggregate Result and also Having working as a WHERE case
     
     //Child to Parent
     //Custom object used __r
     List<contact> con = [SELECT ID,Account.Name,Account.City__c,AccountId FROM contact];
     
     //parent to child
     //ex. (Standrad object) Contacts or Custom Object(My_Custom_Objects__r)
     List<Account> acc = [SELECT Id,Name,(SELECT ID,AccountID FROM contacts) FROM Account];
     
     //Aggregate Queries
     //1.Count :COUNT() / COUNT(fieldName) – Counts the number of rows returned by a query. Usually used with the Id field, or other lookups.
      List<AggregateResult> oppr = [SELECT count(Id),StageName FROM Opportunity Group by StageName];
     
     //2.COUNT_DISTINCT(fieldName) – Counts the number of unique, nonnull, values for the query.
      List<AggregateResult> oppCount = [SELECT COUNT_DISTINCT(StageName) FROM Opportunity];
    
     //3.AVG(fieldName) - Returns the average value for a field based on the rows returned by the query.
      List<AggregateResult> oppAmt = [SELECT AVG(amount) FROM opportunity WHERE Name = 'TEST'];
     
     //4.MIN(fieldName) – Returns the minimum value for a field based on the query. Can even be used on picklists, which returns based on the picklist sort order.
      List<AggregateResult> conMin = [SELECT MIN(Status__c) FROM Contact WHERE Status__c != null];
     
     //5.MAX(fieldName) – Returns the maximum value for a field based on the query. Can even be used on picklists, which returns based on the picklist sort order.
     List<AggregateResult> conM = [SELECT MAX(Status__c) FROM Contact WHERE Status__c != null];
   	
    //6.SUM(fieldName) – Returns the numeric sum of a field based on the query results.
    List<AggregateResult> conSum = [SELECT SUM(amount) FROM Opportunity WHERE amount != null];
	 
    //7. Rollup Aggregate
    List<AggregateResult> rollAvg = [SELECT Account.Name account,stageName stage,SUM(Amount) amt FROM Opportunity GROUP BY ROLLUP(Account.Name,stageName)];
    
   	//8. GROUP BY CUBE(fieldName, fieldName2, ….)
   	List<AggregateResult> cubeAvg = [SELECT Account.Name account,StageName stage,SUM(Amount) amt FROM Opportunity GROUP BY CUBE(Account.Name,StageName)];
   
    //9.Having use Rollup and Cube
    List<AggregateResult> havGroup = [SELECT Count(Id),Name FROM Opportunity WHERE Name IN ('harsha-','TodayTest','test') Group by Name HAVING count(Id) = 1];
    
    //10. count with 2 opportunity and account with sum of amount
    List<AggregateResult> oppGroup = [SELECT Account.Name account,StageName stage,SUM(Amount) amt FROM Opportunity GROUP BY CUBE(Account.Name,StageName) HAVING Count(Id) = 2];
    
    //11.Date/Time [SELECT Name FROM Account WHERE CALENDAR_YEAR(CreatedDate) = 2022]
    
   	//12.Date Time literal [SELECT Name FROM Account WHERE LastModifiedDate = THIS_WEEK]	
   
    //100 maximum number of aliased fields you can have in Aggregate Query
    
    //no contact with account //with Contact
    List<Account> acc1 = [SELECT Id,Name FROM Account WHERE ID not In (SELECT AccountID FROM Contact)];
    List<Account> acc2 = [SELECT Id,Name FROM Account WHERE ID In (SELECT AccountID FROM Contact)]; 
    
    //How to get the oldest contact “created date” on the Account Object
    //--> Min aggregate function is used on Account
    // A Query which will get all unique value in Aggregate Query? (SOQL aggregated query for unique values)
    List<AggregateResult> addResult = [SELECT COUNT_DISTINCT(AccountId),Name FROM Contact GROUP By Name];
        
    // Write a soql to get the recent account records ?
    List<Account> accList = [SELECT ID,Name,CreatedDate FROM Account order By CreatedDate ASC ];
    
   	//Query to SUM up values for each specified value (StageName)
   	List<AggregateResult> aggSUM = [SELECT SUM(Amount),stageName FROM Opportunity GROUP By StageName];
   	
    //query for obtaining records in a particular fiscal year
    List<Account> accAgg = [SELECT Name FROM Account WHERE FISCAL_YEAR(Account.CreatedDate) = 2022];
    
    //query to group the values with the lead source in opportunities and display the amount sorted by lead source of which the record count is more than 5?
    List<AggregateResult> sortLeadSource = [SELECT SUM(amount),Leadsource FROM Opportunity GROUP BY leadsource having count(id) > 1];
    
    //query for sum up the sales by fiscal year? Use Group By in query.
    List<AggregateResult> aggResult = [SELECT FISCAL_YEAR(CloseDate),SUm(Amount) FROM Opportunity GROUP By FISCAL_YEAR(CloseDate)];
    
   	//query for obtaining records which were updated this week
   	List<Opportunity> weekResult = [SELECT ID,Name FROM Opportunity WHERE LastModifiedDate = THIS_WEEK];
    
   //query to return sum of payment amount for an Account?
   List<aggregateResult> sumResult = [SELECT Account.Name,Sum(Amount) FROM Opportunity Group by  Account.Name];

	//SOQL Query With Object
	
   	//WHERE    
    List<Account> accWHERE = [SELECT id, Name, Industry, Rating FROM Account WHERE Rating = 'Cold']; 
    
   	//OR    
    List<Account> accOR = [SELECT id, Name, Industry, Rating FROM Account WHERE Rating = 'Cold' OR Industry = 'Consulting'];
    
    //AND
    List<Account> accAND = [SELECT id, Name, Industry, Rating FROM Account WHERE Rating = 'Cold' AND Industry = 'Consulting'];
    
   	//AND OR 
   	List<Account> accORAND = [SELECT id, Name, Industry, Rating FROM Account WHERE (Rating = 'Cold' OR Industry = 'Consulting') AND Industry = 'Transportation'];   
    
    //Multiple OR With IN 
    List<Account> multipleOR = [SELECT Id,Name,Rating,Industry FROM Account WHERE Rating = 'Cold' OR Rating = 'Hot' OR Rating = 'Warm'];
    List<Account> multipleWithIn = [SELECT Id,Name,Rating,Industry FROM Account WHERE Rating In ('Cold','Hot','Warm')];
 	
    //LIKE
    //1.start and end with 'Test' 
    List<Account> accLIKE1 = [SELECT ID,Name,Industry FROM Account WHERE Name LIKE 'Test'];
    //2.start with any and end with 'Test'
    List<Account> accLIKE2 = [SELECT ID,Name,Industry FROM Account WHERE Name LIKE '%Test'];
    //3.start with 'Test' end with Any  
    List<Account> accLIKE3 = [SELECT ID,Name,Industry FROM Account WHERE Name LIKE 'Test%'];  
    //4.start with 'Any' end with 'Any'  
    List<Account> accLIKE4 = [SELECT ID,Name,Industry FROM Account WHERE Name LIKE '%Test%'];
    //5.start with 'T' and third with 's' and secound with 'any'  
    List<Account> accLIKE5 = [SELECT ID,Name,Industry FROM Account WHERE Name LIKE 'T_s%'];
    
    //Sort Order
    List<Account> accSortOrder = [SELECT ID,Name,Industry,Rating, Phone FROM Account ORDER By Phone DESC];
    
    //Date Fields With SOQL(Date Literal)
    List<Account> accDate = [SELECT ID,Name,Industry,Rating, Phone, CreatedDate FROM Account WHERE CreatedDate = TODAY];
   	
   	//Limit Keyword
   	List<Account> accListLimit = [SELECT Id, Name, Phone, Industry, Status__c, Rating FROM Account WHERE Rating = 'Cold' LIMIT 10 ];
   	
    //Offset
    List<Account> accOffSet = [SELECT ID,Name,Industry FROM Account OFFSET 5];
    
    //RelationShip (parent to Child) Query
    //Standard Object
    List<Account> accRelation = [SELECT Id,Name,(SELECT ID,Name FROM Contacts WHERE Name LIKE '%test%') FROM Account WHERE Name LIKE '%Test%'];
   	//Custom object
   	List<Statistics__c> statsLimit = [SELECT Id,Name,(SELECT Id,Payment_Succeed__c FROM Donations__r WHERE Payment_Succeed__c = 'Yes') FROM Statistics__c WHERE Stats__c = 'Yes'];
   
   	//Child to Parent
	List<Contact> conRel = [SELECT Id,Name,Account.Rating,Account.Industry FROM Contact WHERE Account.Rating = 'Hold' AND Name LIKE 'A%'];
    List<Donation__c> donRel = [SELECT Id,Payment_Succeed__c, Statistics__r.Stats__c , Statistics__r.Date__c FROM Donation__c];
    
	//Aggregate Query
	List<aggregateResult> accCount = [SELECT Count(Total_amount__c) FROM Account]; 
    List<AggregateResult> accMin = [SELECT MIN(Total_amount__c) FROM Account];
    List<AggregateResult> accMax = [SELECT MAX(Total_amount__c) FROM Account];
    List<AggregateResult> accsum = [SELECT SUM(Total_amount__c) FROM Account];
    
    //Group By Query
    List<aggregateResult> oppGroup1 = [SELECT Count(LeadSource),StageName FROM Opportunity GROUP BY StageName]; 
    List<aggregateResult> oppGroup2 = [SELECT Count(StageName),Account.City__c FROM Opportunity GROUP BY Account.City__c];
    }
}