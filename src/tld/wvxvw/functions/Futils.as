package tld.wvxvw.functions {
    
    public class Futils {
        
        public static function bind(func:Function, scope:Object):Function {
            return function ():* { return func.apply(scope, arguments); }
        }
    }
}