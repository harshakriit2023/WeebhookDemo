public class SFDCBlogWrapperclass {

    public String author;
    public List<Blogs> blogs;

    public class Blogs {
        public String id;
        public String title;
        public String url;
    }

    
    public static SFDCBlogWrapperclass parse(String json) {
        system.debug('====SFDCBlogWrapperclass.class====');
        return (SFDCBlogWrapperclass) System.JSON.deserialize(json, SFDCBlogWrapperclass.class);
    }
}