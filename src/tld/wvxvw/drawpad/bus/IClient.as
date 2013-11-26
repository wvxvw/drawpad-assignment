package tld.wvxvw.drawpad.bus {
    
    public interface IClient {
        
        function set server(value:IServer):void;

        function handle(response:String, ...data:Array):void;
    }
}