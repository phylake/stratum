package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class FsmEvent implements IEvent
    {
        protected var _name:String;
        protected var _data:*;

        public function FsmEvent(name:String, data:*):void
        {
            _name = name;
            _data = data;
        }

        public function get name():String { return _name; }
        
        public function get data():* { return _data; }
    }
}
