package tld.wvxvw.drawpad.bus {
    
    public interface IClient {

        /**
         * Sets the server interacting with this client.
         */
        function set server(value:IServer):void;

        /**
         * Invoked by the server, in response to this client's
         * request.
         */
        function handle(response:String, data:Array):void;
    }
}