package com.phylake.fsm.core
{
    public interface ITransition
    {
        function get to():IState;
        function get from():IState;

        function get guards():Vector.<IGuard>;
        function get action():IAction;
    }
}
