package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class FsmEvent implements IEvent
    {
        private var _name:String;
        private var _data:Object;

        public function FsmEvent(name:String, data:Object):void
        {
            _name = name;
            _data = data;
        }

        public function get name():String
        {
            return _name;
        }
        public function get data():*
        {
            return _data;
        }
    }
}
