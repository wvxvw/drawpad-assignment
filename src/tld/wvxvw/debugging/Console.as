package tld.wvxvw.debugging {

    import flash.external.ExternalInterface;
    
    public class Console {

        public static const LOG:uint = 4;
        public static const DEBUG:uint = 3;
        public static const WARN:uint = 2;
        public static const ERROR:uint = 1;
        
        public static var level:uint = 4;
        
        public function Console() { super(); }

        public static function log(...rest:Array):void {
            if (level >= LOG) send("log", rest);
        }

        public static function debug(...rest:Array):void {
            if (level >= DEBUG) send("debug", rest);
        }

        public static function warn(...rest:Array):void {
            if (level >= WARN) send("warn", rest);
        }

        public static function error(...rest:Array):void {
            if (level >= ERROR) send("error", rest);
        }

        private static function send(command:String, args:Array):void {
            if (ExternalInterface.available) {
                ExternalInterface.call(
                    ["function () { console && console.", command,
                        "(JSON.stringify(", JSON.stringify(args), ")); }"].join(""));
            }
        }
    }
}