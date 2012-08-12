package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    public class Fsm implements IFsm
    {
        private var _events:Vector.<IEvent> = new Vector.<IEvent>();
        private var _currentState:IState;
        public var unmappedEventException:Boolean;

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

        // TODO validate reachability of states
        public function set states(value:Vector.<IState>):void {}

        public function mapEvent(ie:IEvent, it:ITransition):void
        {
            _eventMap[ie.name] ||= [];
            _eventMap[ie.name].push(it);
        }

        public function pushEvent(value:IEvent):void
        {
            _events.push(value);
            eventLoop();
        }

        protected function executeAction(action:IAction, event:IEvent):void
        {
            if (action)
            {
                action.execute(this, event);
            }
        }

        protected function executeSubmachines(state:IState, event:IEvent):void
        {
            for each ( var fsm:IFsm in state.subMachines )
            {
                fsm.pushEvent(event);
            }
        }

        protected function eventLoop():void
        {
            // with this loop I'm leaving the possibility open to altering
            // _events outside of pushEvent while still clearing the queue
            var event:IEvent;
            var transition:ITransition;
            var foundTransition:ITransition;
            var guard:IGuard;
            var trueGuard:IGuard;//the guard allowing a state transition
            var submachine:IFsm;

            while (event = _events.shift())
            {
                if (!(event.name in _eventMap))
                {
                    if (unmappedEventException)
                    {
                        throw new IllegalOperationError("event" + event.name + " isn't mapped");
                    }
                    continue;
                }

                trueGuard = null;
                foundTransition = null;

                outer: for each (transition in _eventMap[event.name])
                {
                    if (transition.from == currentState)
                    {
                        for each (guard in transition.guards)
                        {
                            if (guard.evaluate(this, event))
                            {
                                if (trueGuard)
                                {
                                    throw new IllegalOperationError("> 1 unguarded transition for " + currentState.id);
                                    // while this is an exception we have a valid transition from which to continue
                                    continue outer;// TODO consider returning instead
                                }

                                trueGuard = guard;
                                foundTransition = transition;
                            }
                        }
                    }
                }

                if (foundTransition)
                {
                    // execute transition action
                    executeAction(foundTransition.action, event);

                    // complete transition
                    _currentState = foundTransition.to;
                    
                    // execute enterState action for the new state
                    executeAction(currentState.enterState, event);
                }

                // execute submachines with current event
                executeSubmachines(currentState, event);
            }
        }
    }
}
