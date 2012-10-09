package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class FsmState implements IState
    {
        protected var _id:*;
        protected var _enterState:IAction;
        protected var _exitState:IAction;
        protected var _subMachines:Vector.<IFsm>
        
        public function FsmState(id:*, enterState:IAction=null, exitState:IAction=null, subMachines:Vector.<IFsm>=null)
        {
            _id = id;
            _enterState = enterState;
            _exitState = exitState;
            _subMachines = subMachines;
        }

        public function get id():* { return _id; }
        public function set id(value:*):void { _id = value; }

        public function get enterState():IAction { return _enterState; }
        public function set enterState(value:IAction):void { _enterState = value; }

        public function get exitState():IAction { return _exitState; }
        public function set exitState(value:IAction):void { _exitState = value; }

        public function get subMachines():Vector.<IFsm> { return _subMachines; }
        public function set subMachines(value:Vector.<IFsm>):void { _subMachines = value; }
    }
}
