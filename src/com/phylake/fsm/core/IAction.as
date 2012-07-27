package com.phylake.fsm.core
{
    public interface IAction
    {
        function execute(fsm:IFsm, ie:IEvent):void;
    }
}
