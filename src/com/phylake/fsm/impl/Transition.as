package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class Transition implements ITransition
    {
        public function Transition(fromState:IState=null, toState:IState=null)
        {
            linkStates(fromState, toState);
        }

        protected var _to:IState;
        public function get to():IState
        {
            return _to;
        }

        protected var _from:IState;
        public function get from():IState
        {
            return _from;
        }

        public function linkStates(from:IState, to:IState):void
        {
            _from = from;
            _to   = to;
        }

        protected var _guards:Vector.<IGuard>;
        public function get guards():Vector.<IGuard>
        {
            return _guards;
        }
        public function set guards(value:Vector.<IGuard>):void
        {
            _guards = value;
        }

        protected var _action:IAction;
        public function get action():IAction
        {
            return _action;
        }
        public function set action(value:IAction):void
        {
            _action = value;
        }
    }
}
