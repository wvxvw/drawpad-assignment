package tld.wvxvw.drawpad {
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class Application extends Sprite {

        public function Application() {
            super();
            if (super.stage) this.init();
            else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        private function init(event:Event = null):void {
            trace("it works!");
        }
    }
}