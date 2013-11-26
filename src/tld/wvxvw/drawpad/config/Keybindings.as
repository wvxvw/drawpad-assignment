package tld.wvxvw.drawpad.config {

    import flash.utils.ByteArray;
    import tld.wvxvw.debugging.Console;

    // These will be gnerated by script some day
    [Embed(mimeType="application/octet-stream",
            source="../../../../../config/keybindings.json")]
    public class Keybindings extends ByteArray {

        public var resource:Object;
        
        public function Keybindings() {
            super();
            this.resource = JSON.parse(super.readUTFBytes(super.length));
        }
    }
}