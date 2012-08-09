package com.phylake.pattern.iterator
{
    public interface IIterator
    {
        function next():Object;
        function hasNext():Boolean;
        function reset():void;
    }
}
