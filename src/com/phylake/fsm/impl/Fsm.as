package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    public class Fsm implements IFsm
    {
        public static function mapEvent(fsm:IFsm, event:IEvent, t:ITransition):void
        {
            fsm.mapEvent(event, t);
        }

        public static function executeAction(fsm:IFsm, action:IAction, event:IEvent):void
        {
            if( action )
                action.execute(fsm, event);
        }

        public static function executeSubmachines(state:IState, event:IEvent):void
        {
            for each( var fsm:IFsm in state.subMachines )
            {
                fsm.pushEvent(event);
            }
        }

        protected static function eventLoop(fsm:Fsm):void
        {
            // with this loop I'm leaving the possibility open to altering
            // _events outside of pushEvent while still clearing the queue
            var event:IEvent;
            var transition:ITransition;
            var foundTransition:ITransition;
            var guard:IGuard;
            var submachine:IFsm;

            while( event = fsm._events.shift() )
            {
                if( !(event.name in fsm._eventMap) )
                {
                    //throw new IllegalOperationError("event isn't mapped");
                    continue;
                }

                foundTransition = null;

                outer: for each (transition in fsm._eventMap[event.name])
                {
                    if( transition.from == fsm._currentState )
                    {
                        for each( guard in transition.guards )
                        {
                            if( guard.evaluate(fsm, event) )
                            {
                                foundTransition = transition;
                                break outer;
                            }
                        }
                    }
                }

                if( foundTransition )
                {
                    // execute transition action
                    executeAction(fsm, foundTransition.action, event);

                    // complete transition
                    fsm._currentState = foundTransition.to;
                    
                    // execute enterState action for the new state
                    executeAction(fsm, fsm._currentState.enterState, event);
                }

                // execute submachines with current event
                executeSubmachines(fsm._currentState, event);
            }
        }

        // TODO iterators
        private var _events:Array = [];
        private var _states:Vector.<IState>;
        private var _subMachines:Vector.<IFsm>;
        private var _currentState:IState;

        /*
          key: IEvent.name
        value: [ITransition]
        */
        private var _eventMap:Object = {};

        public function init(value:IState):void
        {
            _currentState = value;
        }

        public function get currentState():IState
        {
            return _currentState;
        }

        public function set states(value:Vector.<IState>):void
        {
            _states = value;
        }

        public function mapEvent(ie:IEvent, it:ITransition):void
        {
            _eventMap[ie.name] ||= [];// Object
            const ts:Array = _eventMap[ie.name];

            /*
            Simple check to ensure ie.name, "foo", does not map to more than 1
            transition out of the same state

            TODO allow 2 transitions out of the same state for the same event.
            the new condition for failure should be that only 1 guard condition
            of each transition out of a state should be true. This logic will
            move to pushEvent for run-time guard checking.
            */
            //const dict:Dictionary = new Dictionary;
            //for each( var t:ITransition in ts )
            //{
            //  if( t.from in dict )
            //  {
            //      throw new ArgumentError("can not make 2 transitions from a single state");
            //      return;
            //  }
            //  dict[t.from] = null;
            //}

            ts.push(it);
        }

        public function pushEvent(value:IEvent):void
        {
            _events.push(value);
            eventLoop(this);
        }
    }
}
