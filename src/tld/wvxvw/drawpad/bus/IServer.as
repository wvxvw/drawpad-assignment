package tld.wvxvw.drawpad.bus {
    
    public interface IServer {
        
        function addClient(client:IClient):void;

        function request(client:IClient, request:String, ...data:Array):void;
    }
}