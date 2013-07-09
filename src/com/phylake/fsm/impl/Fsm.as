package com.phylake.fsm.impl
{
    import com.phylake.fsm.core.*;
    import com.phylake.util.tryDestroy;
    import flash.errors.IllegalOperationError;

    public class Fsm implements IFsm
    {
        public var unmappedEventException:Boolean;
        public var noTransitionException:Boolean;

        /**
         *   key: IEvent.name
         * value: [ITransition]
         */
        protected var _eventMap:Object = {};
        protected var _events:Vector.<IEvent> = new Vector.<IEvent>;
        protected var _states:Vector.<IState> = new Vector.<IState>;
        protected var _initialState:IState;
        protected var _currentState:IState;
        protected var _inEventLoop:Boolean;
        protected var _destroyed:Boolean;
        protected var _actionFsm:IFsm;
        protected var _guardFsm:IFsm;
        protected var _rootFsm:IFsm;

        public function set rootFsm(value:IFsm):void
        {
            _rootFsm = value;
        }

        /**
         * An optional IFsm to use for IAction#execute
         */
        public function set actionFsm(value:IFsm):void
        {
            _actionFsm = value;
        }

        /**
         * An optional IFsm to use for IGuard#evaluate
         */
        public function set guardFsm(value:IFsm):void
        {
            _guardFsm = value;
        }

        public function init(value:IState):void
        {
            _initialState = _currentState = value;
        }

        public function reset():void
        {
            mapSubmachines(function(value:Object):void {
                if ("reset" in value)
                {
                    value.reset();
                }
            });
            
            _currentState = _initialState;
            _events = new Vector.<IEvent>;

            /*
                Accept new events because you could be on the same stack frame
                and end up queueing events
            */
            _inEventLoop = false;
        }

        public function destroy():void
        {
            mapSubmachines(tryDestroy);

            _destroyed = true;
            _eventMap = null;
            _events = null;
            _states = null;
            _initialState = null;
            _currentState = null;
            _actionFsm = null;
            _guardFsm = null;
            _rootFsm = null;
        }

        public function get currentState():IState
        {
            return _currentState;
        }

        // TODO validate reachability of states
        public function set states(value:Vector.<IState>):void
        {
            _states = value;
        }

        public function mapEvent(event:String, it:ITransition):void
        {
            _eventMap[event] ||= [];
            _eventMap[event].push(it);

            /* TODO
            verify single transition out of a state for a given event
            when the transition is unguarded*/
        }

        public function pushEvent(value:IEvent):void
        {
            _events.push(value);
            eventLoop();
        }

        /**
         * Map a function f over the submachines of all states
         * @param f function(value:Fsm):void
         */
        public function mapSubmachines(f:Function):void
        {
            if (!_states) return;
            for each (var state:IState in _states)
            {
                if (!state.subMachines) continue;
                for each (var submachine:IFsm in state.subMachines)
                {
                    f(submachine);
                }
            }
        }

        protected function executeAction(action:IAction, event:IEvent):void
        {
            if (action)
            {
                action.execute(_actionFsm || this, event);
            }
        }

        protected function executeSubmachines(state:IState, event:IEvent):void
        {
            if (state.subMachines)
            {
                for each (var fsm:IFsm in state.subMachines)
                {
                    fsm.pushEvent(event);
                }
            }
        }

        protected function eventLoop():void
        {
            if (_inEventLoop) return;
            _inEventLoop = true;
            
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
                        throw new IllegalOperationError("event " + event.name + " isn't mapped");
                    }
                    
                    executeSubmachines(currentState, event);
                    continue;
                }

                trueGuard = null;
                foundTransition = null;

                outer: for each (transition in _eventMap[event.name])
                {
                    if (transition.from != currentState) continue;
                    
                    if (transition.guards)
                    {
                        for each (guard in transition.guards)
                        {
                            if (guard.evaluate(_guardFsm || this, event))
                            {
                                if (trueGuard)
                                {
                                    nTransitions(event);
                                    // while this is an exception we have a valid
                                    // transition from which to continue
                                    break outer;
                                }

                                trueGuard = guard;
                                foundTransition = transition;
                            }
                        }
                    }
                    else
                    {
                        if (foundTransition) nTransitions(event);
                        foundTransition = transition;
                    }
                }

                if (foundTransition)
                {
                    // execute exitState action for the current state
                    executeAction(currentState.exitState, event);
                    if (_destroyed) return;

                    // execute transition action
                    executeAction(foundTransition.action, event);
                    if (_destroyed) return;

                    // complete transition
                    _currentState = foundTransition.to;

                    // execute enterState action for the new state
                    executeAction(currentState.enterState, event);
                    if (_destroyed) return;
                }
                else if (noTransitionException)
                {
                    throw new IllegalOperationError("no transition out of " + currentState.id + " for event " + event.name);
                }

                // execute submachines with current event
                executeSubmachines(currentState, event);
            }
            
            _inEventLoop = false;
        }

        protected function nTransitions(event:IEvent):void
        {
            throw new IllegalOperationError("multiple transitions out of " + currentState.id + " for event " + event.name);
        }
    }
}
