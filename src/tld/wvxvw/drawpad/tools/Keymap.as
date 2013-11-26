package tld.wvxvw.drawpad.tools {

    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    /**
     * This class behaves similar to Emacs <code>keymap</code>
     * object. In much the same way it uses traditional Emacs semantics
     * for key codes. For example, `M-x' is what is more commonly known
     * in PC world as "meta ex" or <Alt>+x (using typical Windows userguide
     * style) or Option+x (using Mac userguide style).
     */
    public class Keymap {

        private var currentPrefix:String = "";
        private var defaultAction:Function;
        private var keyUp:Boolean;
        private const bindings:Object = {};
        private const prefixKeys:Object = {};
        private const defaultKeys:Vector.<String> =
            Vector.<String>(
                "CMSH`1234567890-=\\qwertyuiop[]asdfghjkl;'zxcvbnm,./"
                .split("").concat(["SPC", "RET", "ESC", "<backspace>",
                         "<deletechar>", "<insert>", "<home>", "<prior>",
                         "<end>", "<next>", "<up>", "<left>", "<down>",
                         "<right>", "<tab>", "f1", "f2", "f3", "f4", "f5",
                         "f6", "f7", "f8", "f9", "f10", "f11", "f12"]));
        
        public function Keymap(bindings:Object = null,
            defaultAction:Function = null) {
            super();
            this.defaultAction = defaultAction;
            if (bindings) {
                for (var p:String in bindings) this.bindings[p] = bindings[p];
            }
        }

        public function defineKey(keycode:String, handler:Function):void {
            this.bindings[keycode] = handler;
        }

        public function definePrefixKey(keycode:String):void {
            this.prefixKeys[this.parseKeycode(keycode)] = true;
        }

        public function dispatch(event:KeyboardEvent):void {
            var key:String = this.translate(event);
            if (!(key in this.prefixKeys)) {
                if (key in this.bindings) this.bindings[key]();
            }
        }

        private function translate(event:KeyboardEvent):String {
            var result:String = "", suffix:String;
            
            this.keyUp = event.type == KeyboardEvent.KEY_UP;
            if (event.altKey) result += this.parseKeycode("M");
            if (event.ctrlKey) result += this.parseKeycode("C");
            if (event.shiftKey) result += this.parseKeycode("S");
            switch (event.keyCode) {
                case Keyboard.A            : suffix = "a"; break;
 	 	        case Keyboard.B            : suffix = "b"; break;
 	 	        case Keyboard.BACKQUOTE    : suffix = "`"; break;
 	 	        case Keyboard.BACKSLASH    : suffix = "\\"; break;
 	 	        case Keyboard.BACKSPACE    : suffix = "<backspace>"; break;
 	 	        case Keyboard.C            : suffix = "c"; break;
 	 	        case Keyboard.COMMA        : suffix = ","; break;
 	 	        case Keyboard.COMMAND      : suffix = "H"; break;
 	 	        case Keyboard.CONTROL      : suffix = "C"; break;
 	 	        case Keyboard.D            : suffix = "d"; break;
 	 	        case Keyboard.DELETE       : suffix = "<deletechar>"; break;
 	 	        case Keyboard.DOWN         : suffix = "<down>"; break;
 	 	        case Keyboard.E            : suffix = "e"; break;
 	 	        case Keyboard.END          : suffix = "<end>"; break;
 	 	        case Keyboard.ENTER        : suffix = "RET"; break;
 	 	        case Keyboard.EQUAL        : suffix = "="; break;
 	 	        case Keyboard.ESCAPE       : suffix = "ESC"; break;
 	 	        case Keyboard.F            : suffix = "f"; break;
 	 	        case Keyboard.F1           : suffix = "f1"; break;
 	 	        case Keyboard.F10          : suffix = "f10"; break;
 	 	        case Keyboard.F11          : suffix = "f11"; break;
 	 	        case Keyboard.F12          : suffix = "f12"; break;
 	 	        case Keyboard.F13          : suffix = "f13"; break;
 	 	        case Keyboard.F14          : suffix = "f14"; break;
 	 	        case Keyboard.F15          : suffix = "f15"; break;
 	 	        case Keyboard.F2           : suffix = "f2"; break;
 	 	        case Keyboard.F3           : suffix = "f3"; break;
 	 	        case Keyboard.F4           : suffix = "f4"; break;
 	 	        case Keyboard.F5           : suffix = "f5"; break;
 	 	        case Keyboard.F6           : suffix = "f6"; break;
 	 	        case Keyboard.F7           : suffix = "f7"; break;
 	 	        case Keyboard.F8           : suffix = "f8"; break;
 	 	        case Keyboard.F9           : suffix = "f9"; break;
 	 	        case Keyboard.G            : suffix = "g"; break;
 	 	        case Keyboard.H            : suffix = "h"; break;
 	 	        case Keyboard.HOME         : suffix = "<home>"; break;
 	 	        case Keyboard.I            : suffix = "i"; break;
 	 	        case Keyboard.INSERT       : suffix = "<insert>"; break;
 	 	        case Keyboard.J            : suffix = "j"; break;
 	 	        case Keyboard.K            : suffix = "k"; break;
 	 	        case Keyboard.L            : suffix = "l"; break;
 	 	        case Keyboard.LEFT         : suffix = "<left>"; break;
 	 	        case Keyboard.LEFTBRACKET  : suffix = "["; break;
 	 	        case Keyboard.M            : suffix = "m"; break;
 	 	        case Keyboard.MINUS        : suffix = "-"; break;
 	 	        case Keyboard.N            : suffix = "n"; break;
 	 	        case Keyboard.NUMBER_0     : suffix = "0"; break;
 	 	        case Keyboard.NUMBER_1     : suffix = "1"; break;
 	 	        case Keyboard.NUMBER_2     : suffix = "2"; break;
 	 	        case Keyboard.NUMBER_3     : suffix = "3"; break;
 	 	        case Keyboard.NUMBER_4     : suffix = "4"; break;
 	 	        case Keyboard.NUMBER_5     : suffix = "5"; break;
 	 	        case Keyboard.NUMBER_6     : suffix = "6"; break;
 	 	        case Keyboard.NUMBER_7     : suffix = "7"; break;
 	 	        case Keyboard.NUMBER_8     : suffix = "8"; break;
 	 	        case Keyboard.NUMBER_9     : suffix = "9"; break;
 	 	        case Keyboard.O            : suffix = "o"; break;
 	 	        case Keyboard.P            : suffix = "p"; break;
 	 	        case Keyboard.PAGE_DOWN    : suffix = "<next>"; break;
 	 	        case Keyboard.PAGE_UP      : suffix = "<prior>"; break;
 	 	        case Keyboard.PERIOD       : suffix = "."; break;
 	 	        case Keyboard.Q            : suffix = "q"; break;
 	 	        case Keyboard.QUOTE        : suffix = "'"; break;
 	 	        case Keyboard.R            : suffix = "r"; break;
 	 	        case Keyboard.RIGHT        : suffix = "<right>"; break;
 	 	        case Keyboard.RIGHTBRACKET : suffix = "]"; break;
 	 	        case Keyboard.S            : suffix = "s"; break;
 	 	        case Keyboard.SEMICOLON    : suffix = ";"; break;
 	 	        case Keyboard.SLASH        : suffix = "/"; break;
 	 	        case Keyboard.SPACE        : suffix = "SPC"; break;
 	 	        case Keyboard.T            : suffix = "t"; break;
 	 	        case Keyboard.TAB          : suffix = "TAB"; break;
 	 	        case Keyboard.U            : suffix = "u"; break;
 	 	        case Keyboard.UP           : suffix = "up"; break;
 	 	        case Keyboard.V            : suffix = "v"; break;
 	 	        case Keyboard.W            : suffix = "w"; break;
 	 	        case Keyboard.X            : suffix = "x"; break;
 	 	        case Keyboard.Y            : suffix = "y"; break;
 	 	        case Keyboard.Z            : suffix = "z"; break;
            }
            return this.currentPrefix + this.parseKeycode(result + suffix);
        }

        private function parseKeycode(keycode:String):String {
            // For now we will require that keys are specified as
            // `S-2' rather then `@' to make the translation less
            // complicated
            return (keycode in this.prefixKeys) ?
                keycode + (this.keyUp ? " " : "-") : keycode;
        }

        private function init():void {
            if (this.defaultAction)
                for each (var key:String in this.defaultKeys)
                    if (!(key in this.bindings))
                        this.bindings[key] = this.defaultAction;
        }
    }
}