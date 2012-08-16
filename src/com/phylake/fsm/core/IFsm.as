package com.phylake.fsm.core
{
    public interface IFsm
    {
        function init(value:IState):void;
        function get currentState():IState;
        function set states(value:Vector.<IState>):void;

        function mapEvent(event:String, it:ITransition):void;

        function pushEvent(value:IEvent):void;
    }
}
