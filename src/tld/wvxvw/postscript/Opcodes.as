package tld.wvxvw.postscript {

    import tld.wvxvw.postscript.ops.ClosepathOp;
    import tld.wvxvw.postscript.ops.LinetoOp;
    import tld.wvxvw.postscript.ops.MovetoOp;
    import tld.wvxvw.postscript.ops.RlinetoOp;
    import tld.wvxvw.postscript.ops.RmovetoOp;
    import tld.wvxvw.postscript.ops.FillOp;
    import tld.wvxvw.postscript.ops.SetlinewidthOp;
    import tld.wvxvw.postscript.ops.StrokeOp;
    import tld.wvxvw.postscript.ops.ShowpageOp;
    import tld.wvxvw.postscript.ops.SetrgbcolorOp;
    
    public class Opcodes {
        
        public function Opcodes() { super(); }

        public var closepath:ClosepathOp = new ClosepathOp();

        public var lineto:LinetoOp = new LinetoOp();

        public var moveto:MovetoOp = new MovetoOp();

        public var rlineto:RlinetoOp = new RlinetoOp();

        public var rmoveto:RmovetoOp = new RmovetoOp();

        public var fill:FillOp = new FillOp();

        public var setlinewidth:SetlinewidthOp = new SetlinewidthOp();

        public var stroke:StrokeOp = new StrokeOp();

        public var showpage:ShowpageOp = new ShowpageOp();

        public var setrgbcolor:SetrgbcolorOp = new SetrgbcolorOp();
    }
}