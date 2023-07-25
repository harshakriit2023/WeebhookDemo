public class ListExample {

    public void listMethods(){
        //List is ordered
        //list is index needed
        //list allow dublicate
        //Declaration of LIst
        //How we can add element in list
        //1.Add in constructor 
        //2.Add method
        List<String> lstTeam1 = new List<String>{'Dhoni','Kholi'};
        System.debug('--lstTeam1---'+lstTeam1);
        
       //Add method call list
       lstTeam1.add('Rohit');
       lstTeam1.add('DS');
       System.debug('--lstTeam1---'+lstTeam1);
	 
       //size :Count of the elements
       Integer count = lstTeam1.Size();
       System.debug('--count---'+count); 
        
     	//Contains(Case sensitive): element is exist or not
        boolean IsContians= lstTeam1.contains('dhoni');
        System.debug('--IsContians---'+IsContians); 
        
		//set : we need to pass index with element
		lstTeam1.set(3,'Parth'); 
        System.debug('--set lstTeam1---'+lstTeam1);        
        System.debug('----get value--'+lstTeam1[1]);
        
        lstTeam1.add('Rohit');
        
        //Remove: specific index
		lstTeam1.remove(4);
		
		//isEmpty: is empty or not
		Boolean isEmptyorNot = lstTeam1.isEmpty(); 
        System.debug('----isEmptyorNot--'+isEmptyorNot);
       
        //Clone : copy one list to another
        List<String> lstTeam2 = lstTeam1.clone();
        System.debug('--lstTeam2--'+lstTeam2);
        
        List<String> lastTeam3 = new List<String>{'Panthh','jadeja'};
        //Add all:pass list or set also
        lastTeam3.addAll(lstTeam2);
        System.debug('--lastTeam3--'+lastTeam3);    
        
        //Equal
        Boolean isEqual = lstTeam1.equals(lstTeam2);
        System.debug('--lstTeam1--'+lstTeam1); 
        
        //clear
        lstTeam2.clear();
        System.debug('---lstTeam2--'+lstTeam2);
        System.debug('List Empty'+lstTeam2.isEmpty());
        
        //if
        //else
        //elseif
        //nestedif if(){if()}
        
        //loops
        //1.While loop
        //initialize
        integer i =0;
        //Condition
        while(i < 20){
            System.debug('---i---');
            //Increment
            i = i + 1;
            System.debug('---i'+i);
        }
        System.debug('---i---'+i);
        
        integer i1 = 20;
        while(i1 > 0){
           i1 = i1-2;
           System.debug('---i1'+i1);
        }
        //2.Do while
        integer i2 = 0;
        do{
            i2 = i2 + 2;
            System.debug('i2--'+i2);
        }while(i2 < 20);
        
        //For Loop
        for(integer i3 = 0; i3 <100; i3++){
            if(math.mod(i3, 2) != 0){
                System.debug('event number is'+i3);
            } 
        }
        
        // For Each
        List<String> lstNumber = new List<String>{'A','B','C','D'};
        for(String str : lstNumber){
   		 	System.debug('----str--'+str);
		}
    }
                        
}