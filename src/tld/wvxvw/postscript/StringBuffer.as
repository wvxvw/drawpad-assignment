package tld.wvxvw.postscript {

    public class StringBuffer extends ByteArray {

        public function StringBuffer(bytes:ByteArray = null) {
            super();
            if (bytes) this.reset(bytes);
        }

        public function reset(bytes:ByteArray):void {
            super.position = 0;
            bytes.position = 0;
            this.writeUTFbytes(bytes.readUTFBytes(bytes.length));
        }

        public function readString():String {
            return super.readUTFBytes(super.bytesAvailable);
        }
    }
}