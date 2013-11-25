package tld.wvxvw.postscript {
    
    public class PostScriptError extends Error {
        
        public function PostScriptError(text:String, ...args:Array) {
            super(text);
        }
    }
}