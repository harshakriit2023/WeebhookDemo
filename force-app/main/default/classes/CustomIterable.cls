global class CustomIterable implements Iterator<contact>{

  List<Contact> con {get;set;}
   Integer i {get;set;}
 
   public CustomIterable(){
      con = [select Id,LastName From Contact LIMIT 5];
      i=0;
   }
    
   global boolean hasNext(){
      if(i>=con.size()){
     return false;
   }else{
     return true;
   }
   }
 
  
   global Contact next(){
     if(i==5){return null;}
  i++;
  return con[i-1];
   }
 
}