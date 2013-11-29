package tld.wvxvw.drawpad.config {

    import flash.utils.ByteArray;
    import tld.wvxvw.debugging.Console;

    // These will be gnerated by script some day
    [Embed(mimeType="application/octet-stream",
            source="../../../../../config/init.json")]
    public class Init extends ByteArray {

        private var resource:Object;
        
        public function Init() {
            super();
            this.resource = JSON.parse(super.readUTFBytes(super.length));
        }

        public function keybindings():Object {
            return this.resource.keybindings;
        }

        public function server():Object {
            return this.resource.server;
        }
    }
}