package tld.wvxvw.drawpad.bus {
    
    public interface IServer {
        
        function add(client:IClient):void;

        function request(client:IClient, request:String, ...data:Array):void;
    }
}