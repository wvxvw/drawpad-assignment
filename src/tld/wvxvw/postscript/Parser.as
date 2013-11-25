package tld.wvxvw.postscript {

    import flash.display.Graphics;
    
    public class Interpreter {

        private var stream:IAsyncInputStream;
        private var symbolTable:Object = {};
        
        public function Parser(stream:IAsyncInputStream = null,
            graphics:Graphics) {
            super();
            if (stream) this.parse(stream);
        }

        public function init(stream:IAsyncInputStream):Parser {
            return this;
        }
    }
}