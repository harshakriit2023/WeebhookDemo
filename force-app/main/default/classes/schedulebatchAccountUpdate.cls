global class schedulebatchAccountUpdate implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        system.debug('==Execute====');
        batchAccountUpdate ba = new batchAccountUpdate();
        Database.executebatch(ba,1);
        systemNow();
    }
    global void systemNow()
    {
        system.debug('==systemnow====');
        schedulebatchAccountUpdate scb = new schedulebatchAccountUpdate();
        string sch = '0 0 * ? * *   ';
        string JobId = system.schedule('Every 1 hours::',sch,scb);
    }
}