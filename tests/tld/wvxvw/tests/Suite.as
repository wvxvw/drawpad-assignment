package tld.wvxvw.tests {

    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import tld.wvxvw.debugging.Console;

    public class Suite extends Sprite {

        public function Suite() {
            super();
            if (super.stage) this.init();
            else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        private function init(event:Event = null):void {
            Console.debug("Test suite");
            super.stage.scaleMode = StageScaleMode.NO_SCALE;
            super.stage.align = StageAlign.TOP_LEFT;
            new PostScriptParser().testSquare(
                super.addChild(new Shape()) as Shape);
        }
    }
}