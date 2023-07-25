public class ExampleofConstructor {

    //variable
    public String companyName;
    public String companyDep;
    public Integer companyNumber;
    
    //Declare without parameter Constructor
    public ExampleofConstructor(){
        
        companyName = 'Kriit';
        companyDep = 'Salesforce';
        companyNumber = 305;
    }
    
    //With parameter Constructor 
   	 public ExampleofConstructor(String companyNamber,String CompanyDep,Integer companyNumber){
        
        companyName = 'Kriit';
        companyDep = 'Salesforce';
        companyNumber = 305;
    }
    
    public void exampleMethod(Integer numberMethod){
        if(numberMethod > 10){
            System.debug('You have eligibale');
        }else{
            System.debug('You have not eligible');
        }
    }
}