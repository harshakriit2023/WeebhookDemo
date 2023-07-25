public class myContactExtension
{
        public contact con;
        public myContactExtension()
        {
        }
        public PageReference save() {
            PageReference pref = new ApexPages.StandardController(con).view();
              pref .setRedirect(true);
                return pref ;
            }

}