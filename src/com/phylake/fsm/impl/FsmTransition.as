package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;

    public class FsmTransition implements ITransition
    {
        protected var _to:IState;
        protected var _from:IState;
        protected var _guards:Vector.<IGuard>;
        protected var _actions:Vector.<IAction>;
        
        public function FsmTransition(fromState:IState=null, toState:IState=null)
        {
            linkStates(fromState, toState);
        }

        public function linkStates(from:IState, to:IState):void
        {
            _from = from;
            _to   = to;
        }

        public function get to():IState
        {
            return _to;
        }

        public function get from():IState
        {
            return _from;
        }

        public function get guards():Vector.<IGuard>
        {
            return _guards;
        }
        
        public function set guards(value:Vector.<IGuard>):void
        {
            _guards = value;
        }

        public function get actions():Vector.<IAction>
        {
            return _actions;
        }
        
        public function set actions(value:Vector.<IAction>):void
        {
            _actions = value;
        }
    }
}
