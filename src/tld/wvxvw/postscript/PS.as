package tld.wvxvw.postscript {

    import flash.events.EventDispatcher;
    import flash.display.Shape;
    import tld.wvxvw.debugging.Console;
    import tld.wvxvw.postscript.IAsyncInputStream;

    public class PS {

        public function PS() { super(); }

        public function load(source:IAsyncInputStream,
            where:Shape = null):EventDispatcher {
            return new Interpreter(source, new Context(where || new Shape()));
        }
    }
}