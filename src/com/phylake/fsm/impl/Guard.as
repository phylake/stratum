package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class Guard implements IGuard
    {
        private var _f:Function;

        // hand in a function with the same signature as evaluate to get
        // protyping quickly
        public function Guard(value:Function):void
        {
            _f = value;
        }

        public function evaluate(fsm:IFsm, ie:IEvent):Boolean
        {
            return _f(fsm, ie);
        }
    }
}
