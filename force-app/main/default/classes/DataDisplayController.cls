public class DataDisplayController {

    public String PDFData {get; set;}
    public Integer evtsubtotal{get;set;}
    public Integer evtdisCount{get;set;}
    public Integer evttotalQuoteprice{get;set;}
    //public List<Vinci_Quote__c> evtquoteCurrentRecDetails{get;set;}
    // Determines what kind of rendering to use for the page request
    public String renderingService { get; private set; }
    
    public DataDisplayController(ApexPages.StandardController controller) {
        system.debug('---standardcontroller ---');   
        PDFData = 'Test';
        system.debug('---standrad::PDFdatasubtotal ---'+evtsubtotal);
        //evtquoteCurrentRecDetails = [select Quote_Date__c,Value__c from Vinci_Quote__c];
        //system.debug('--standard::evtquoteCurrentRecDetails----'+evtquoteCurrentRecDetails);
    }
    public DataDisplayController(){
    PDFData = 'Test';
    system.debug('--custom controller ---');
    system.debug('---PDFdatasubtotal ---'+string.valueof(evtsubtotal));
    system.debug('---evtdisCount ---'+evtdisCount);
    system.debug('---evttotalQuoteprice ---'+evttotalQuoteprice);
    //evtquoteCurrentRecDetails = [select Quote_Date__c,Value__c from Vinci_Quote__c];
    //system.debug('--custom::evtquoteCurrentRecDetails----'+evtquoteCurrentRecDetails);
    }
    
    public PageReference downloadPDF(){
    system.debug('---downloadPDF---');
    system.debug('---downloadPDF::PDFdatasubtotal ---'+string.valueof(evtsubtotal));
    system.debug('---downloadPDF::evtdisCount ---'+evtdisCount);
    system.debug('---downloadPDF::evttotalQuoteprice ---'+evttotalQuoteprice);
    //evtquoteCurrentRecDetails = [select Quote_Date__c,Value__c from Vinci_Quote__c];
    //system.debug('--evtquoteCurrentRecDetails----'+evtquoteCurrentRecDetails);    
    string params = 'Subtotal='+evtsubtotal+ 'Discount=' +evtdisCount+ 'Total=' +evttotalQuoteprice;
    system.debug('--params--'+params);
    //string pageURL = '/apex/PDFGenerator?' + params;
    string pageURL = '/apex/PDFGenerator';
    system.debug('--pageURL--'+pageURL);
     
    PageReference pageRef = new PageReference(pageURL);
    ////ensure pdf downloads and is assigned with defined name
    pageRef.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');
     
    return pageRef;
    }
     // Rendered content MIME type, used to affect HTTP response
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            
            if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document 
                renderedContentType = 'application/pdf';
                
                // Add a file name for the PDF file
                if( this.renderedFileName != null) {
                    // This is supposed to set the file name, but it doesn't work
                    renderedContentType += '#' + this.renderedFileName;
                    
                    // This is a work-around to set the file name
                    ApexPages.currentPage().getHeaders().put(
                        'content-disposition', 'attachment; filename=' + 
                         this.renderedFileName);
                }
            }
            
            return renderedContentType;
        }
    }
     // Are we rendering to HTML or PDF?
  
    // Allow the page to set the PDF file name
        public String renderedFileName { 
            get; 
            set { renderedFileName = this.sanitizeFileName(value); }
        }
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) || 
                 ( ! renderingService.startsWith('PDF')) );
    }
      // Private helper -- basic, conservative santization
    private String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName = 
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        // You might also want to check filename length, 
        // that the filename ends in '.pdf', etc.
        return(sanitizedName);
    }

}