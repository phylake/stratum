package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class Action implements IAction
    {
        private var _f:Function;

        // hand in a function with the same signature as evaluate to get
        // protyping quickly
        public function Action(value:Function):void
        {
            _f = value;
        }

        public function execute(fsm:IFsm, ie:IEvent):void
        {
            _f(fsm, ie);
        }
    }
}
