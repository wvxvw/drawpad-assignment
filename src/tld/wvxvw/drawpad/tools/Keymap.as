package tld.wvxvw.drawpad.tools {

    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.ui.Keyboard;
    import tld.wvxvw.debugging.Console;

    /**
     * This class behaves similar to Emacs <code>keymap</code>
     * object. In much the same way it uses traditional Emacs semantics
     * for key codes. For example, `M-x' is what is more commonly known
     * in PC world as "meta ex" or <Alt>+x (using typical Windows userguide
     * style) or Option+x (using Mac userguide style).
     */
    public class Keymap {

        private var currentPrefix:Vector.<Vector.<String>> = new <Vector.<String>>[];
        private var currentCord:Vector.<String> = new <String>[];
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
                         "f6", "f7", "f8", "f9", "f10", "f11", "f12",
                         "<down-mouse-1>", "<up-mouse-1>"]));
        
        public function Keymap(bindings:Object = null,
            defaultAction:Function = null) {
            super();
            this.defaultAction = defaultAction;
            if (bindings) {
                for (var p:String in bindings) this.bindings[p] = bindings[p];
            }
        }

        public function defineKey(keycode:String, handler:Function):void {
            // TODO: This needs to be normalized before adding, but leaving
            // it like this for now, don't have time for that.
            this.bindings[keycode] = handler;
        }

        public function definePrefixKey(key:String):void {
            // TODO: Similar to the one above, this needs to be normalized,
            // but I will just rely on all the bindings to be already normalized
            Console.debug("definePrefixKey", key);
            this.prefixKeys[key] = true;
        }

        public function dispatch(event:Event):void {
            var collected:Vector.<String> = new <String>[];
            if (event is KeyboardEvent) {
                var keyEvent:KeyboardEvent = event as KeyboardEvent;
                if (keyEvent.type == KeyboardEvent.KEY_DOWN) {
                    if (keyEvent.altKey) collected.push("M");
                    if (keyEvent.ctrlKey) collected.push("C");
                    if (keyEvent.shiftKey) collected.push("S");
                    collected.push(this.translate(keyEvent));
                    this.addToCord(collected);
                } else if (keyEvent.type == KeyboardEvent.KEY_UP) {
                    this.doDispatch();
                }
                // not sure what to do with keypress yet.
            } else if (event is MouseEvent) {
                var mouseEvent:MouseEvent = event as MouseEvent;
                if (mouseEvent.type == MouseEvent.MOUSE_DOWN) {
                    // Nice planning! Adobe...
                    if (mouseEvent.altKey) collected.push("M");
                    if (mouseEvent.ctrlKey) collected.push("C");
                    if (mouseEvent.shiftKey) collected.push("S");
                    collected.push("<down-mouse-1>");
                    this.addToCord(collected);
                    this.doDispatch();
                } else if (mouseEvent.type == MouseEvent.MOUSE_UP) {
                    // Not sure what's the point of modifier keys
                    // on a key-up event...
                    collected.push("<up-mouse-1>");
                    this.addToCord(collected);
                    this.doDispatch();
                }
                // there's a lot of other mouse events, which
                // I don't know how to treat yet.
            }
            Console.debug("Current combo:", this.currentCombo());
        }

        private function doDispatch():void {
            // We must take some action, either wait for more input
            // (because the user typed a prefix key)
            // or act now (because we have a matched handler).
            var combo:String = this.currentCombo();
            if (!(combo in this.prefixKeys)) {
                if (combo in this.bindings) {
                    this.bindings[combo]();
                } else if (combo)
                Console.error("Key", combo, "has no handler");
                // Don't trigger error for empty bindings
                // these happen after we release multiple keys one
                // after another.
                this.flush();
            } else {
                // We aren't done yet, must wait for more input.
                this.currentPrefix.push(this.currentCord);
                this.currentCord.splice(0, this.currentCord.length);
            }
        }

        private function currentCombo():String {
            var parts:Vector.<String> = new <String>[], part:String;
            for each (var cord:Vector.<String> in this.currentPrefix) {
                part = cord.join("-");
                if (part) parts.push(part);
            }
            return parts.join(" ");
        }
        
        private function addToCord(keys:Vector.<String>):void {
            var hash:Object = {};
            keys = keys.concat(this.currentCord);
            for each (var key:String in keys) hash[key] = true;
            this.currentCord.splice(0, this.currentCord.length);
            Console.debug("Cord must be empty:", this.currentCord.join("-"), hash);
            for (key in hash) this.currentCord.push(key);
            this.currentCord.sort(this.keySortHelper);
            if (!this.currentPrefix.length ||
                this.currentPrefix[this.currentPrefix.length - 1] != this.currentCord)
                this.currentPrefix.push(this.currentCord);
            Console.debug("Current cord:", this.currentCord.join("-"));
        }

        private function keySortHelper(a:String, b:String):int {
            var aIsUpper:Boolean = a.toLowerCase() != a,
                bIsUpper:Boolean = b.toLowerCase() != b,
                aIsMouse:Boolean = /^<(:?up|down)-mouse-/.test(a),
                bIsMouse:Boolean = /^<(:?up|down)-mouse-/.test(a);
            // Put all upper-case (modal keys) first
            if (a == b) return 0;
            if (aIsUpper && !bIsUpper) return -1;
            else if (!aIsUpper && bIsUpper) return 1;
            else if (aIsMouse && !bIsMouse) return -1;
            else if (!aIsMouse && bIsMouse) return 1;
            else if (a >= b) return -1;
            return 1;
        }
        
        private function flush():void {
            this.currentCord.splice(0, this.currentCord.length);
            this.currentPrefix.splice(0, this.currentCord.length);
        }
        
        private function translate(event:KeyboardEvent):String {
            var result:String;
            
            switch (event.keyCode) {
                case Keyboard.A            : result = "a"; break;
 	 	        case Keyboard.B            : result = "b"; break;
 	 	        case Keyboard.BACKQUOTE    : result = "`"; break;
 	 	        case Keyboard.BACKSLASH    : result = "\\"; break;
 	 	        case Keyboard.BACKSPACE    : result = "<backspace>"; break;
 	 	        case Keyboard.C            : result = "c"; break;
 	 	        case Keyboard.COMMA        : result = ","; break;
 	 	        case Keyboard.COMMAND      : result = "H"; break;
 	 	        case Keyboard.CONTROL      : result = "C"; break;
 	 	        case Keyboard.D            : result = "d"; break;
 	 	        case Keyboard.DELETE       : result = "<deletechar>"; break;
 	 	        case Keyboard.DOWN         : result = "<down>"; break;
 	 	        case Keyboard.E            : result = "e"; break;
 	 	        case Keyboard.END          : result = "<end>"; break;
 	 	        case Keyboard.ENTER        : result = "RET"; break;
 	 	        case Keyboard.EQUAL        : result = "="; break;
 	 	        case Keyboard.ESCAPE       : result = "ESC"; break;
 	 	        case Keyboard.F            : result = "f"; break;
 	 	        case Keyboard.F1           : result = "f1"; break;
 	 	        case Keyboard.F10          : result = "f10"; break;
 	 	        case Keyboard.F11          : result = "f11"; break;
 	 	        case Keyboard.F12          : result = "f12"; break;
 	 	        case Keyboard.F13          : result = "f13"; break;
 	 	        case Keyboard.F14          : result = "f14"; break;
 	 	        case Keyboard.F15          : result = "f15"; break;
 	 	        case Keyboard.F2           : result = "f2"; break;
 	 	        case Keyboard.F3           : result = "f3"; break;
 	 	        case Keyboard.F4           : result = "f4"; break;
 	 	        case Keyboard.F5           : result = "f5"; break;
 	 	        case Keyboard.F6           : result = "f6"; break;
 	 	        case Keyboard.F7           : result = "f7"; break;
 	 	        case Keyboard.F8           : result = "f8"; break;
 	 	        case Keyboard.F9           : result = "f9"; break;
 	 	        case Keyboard.G            : result = "g"; break;
 	 	        case Keyboard.H            : result = "h"; break;
 	 	        case Keyboard.HOME         : result = "<home>"; break;
 	 	        case Keyboard.I            : result = "i"; break;
 	 	        case Keyboard.INSERT       : result = "<insert>"; break;
 	 	        case Keyboard.J            : result = "j"; break;
 	 	        case Keyboard.K            : result = "k"; break;
 	 	        case Keyboard.L            : result = "l"; break;
 	 	        case Keyboard.LEFT         : result = "<left>"; break;
 	 	        case Keyboard.LEFTBRACKET  : result = "["; break;
 	 	        case Keyboard.M            : result = "m"; break;
 	 	        case Keyboard.MINUS        : result = "-"; break;
 	 	        case Keyboard.N            : result = "n"; break;
 	 	        case Keyboard.NUMBER_0     : result = "0"; break;
 	 	        case Keyboard.NUMBER_1     : result = "1"; break;
 	 	        case Keyboard.NUMBER_2     : result = "2"; break;
 	 	        case Keyboard.NUMBER_3     : result = "3"; break;
 	 	        case Keyboard.NUMBER_4     : result = "4"; break;
 	 	        case Keyboard.NUMBER_5     : result = "5"; break;
 	 	        case Keyboard.NUMBER_6     : result = "6"; break;
 	 	        case Keyboard.NUMBER_7     : result = "7"; break;
 	 	        case Keyboard.NUMBER_8     : result = "8"; break;
 	 	        case Keyboard.NUMBER_9     : result = "9"; break;
 	 	        case Keyboard.O            : result = "o"; break;
 	 	        case Keyboard.P            : result = "p"; break;
 	 	        case Keyboard.PAGE_DOWN    : result = "<next>"; break;
 	 	        case Keyboard.PAGE_UP      : result = "<prior>"; break;
 	 	        case Keyboard.PERIOD       : result = "."; break;
 	 	        case Keyboard.Q            : result = "q"; break;
 	 	        case Keyboard.QUOTE        : result = "'"; break;
 	 	        case Keyboard.R            : result = "r"; break;
 	 	        case Keyboard.RIGHT        : result = "<right>"; break;
 	 	        case Keyboard.RIGHTBRACKET : result = "]"; break;
 	 	        case Keyboard.S            : result = "s"; break;
 	 	        case Keyboard.SEMICOLON    : result = ";"; break;
 	 	        case Keyboard.SLASH        : result = "/"; break;
 	 	        case Keyboard.SPACE        : result = "SPC"; break;
 	 	        case Keyboard.T            : result = "t"; break;
 	 	        case Keyboard.TAB          : result = "TAB"; break;
 	 	        case Keyboard.U            : result = "u"; break;
 	 	        case Keyboard.UP           : result = "<up>"; break;
 	 	        case Keyboard.V            : result = "v"; break;
 	 	        case Keyboard.W            : result = "w"; break;
 	 	        case Keyboard.X            : result = "x"; break;
 	 	        case Keyboard.Y            : result = "y"; break;
 	 	        case Keyboard.Z            : result = "z"; break;
            }
            return result;
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