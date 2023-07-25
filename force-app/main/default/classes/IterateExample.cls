global class IterateExample implements Iterator<Contact>{
	
    list<contact> con{get;set;}
    integer i {get;set;}
    
    public IterateExample(){
      	con = [select Id,LastName From Contact LIMIT 5];
  		i=0;
   }
    global boolean hasNext()
    {
        if(i>=con.size())
        {
            return false;
        }
        else
        {
            return true;
        }        
    }
    global contact next()
    {
        if(i==5){return null;}
        i++;
        return con[i-1];
    }
    
}