package tld.wvxvw.postscript {
    
    import flash.events.IEventDispatcher;

    [Event(type="flash.events.DataEvent", name="data")]
    
    public interface IAsyncInputStream {

        /**
         * <code>true</code> if the stream was all already read.
         */
        function get isAtEnd():Boolean;

        /**
         * <code>true</code> if no character was read yet.
         */
         function get isAtStart():Boolean;
        
        /**
         * Will invoke <code>callback</code> each time a new char is read.
         *
         * @param callback Function called each time new character is
         *                 read froms stream.
         *
         * @throws flash.errors.EOFError
         */
        function readChar(callback:Function):void;
    }
}