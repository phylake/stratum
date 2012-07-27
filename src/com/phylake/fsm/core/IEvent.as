package com.phylake.fsm.core
{
    public interface IEvent
    {
        function get name():String;
        function get data():*;
    }
}
