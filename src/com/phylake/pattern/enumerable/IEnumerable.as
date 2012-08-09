package com.phylake.pattern.enumerable
{
    public interface IEnumerable 
    {
        // ruby each, haskell map
        function map(f:Function):void;
        
        // ruby select
        function filter(f:Function):IEnumerable;

        // haskell fold
        function reduce(acc:*, f:Function):*;

        function get first():*;
        function get last():*;
        function empty():Boolean;
    }
}
