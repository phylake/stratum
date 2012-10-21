package com.phylake.graph
{
    public interface INode
    {
        function get id():String;

        function get edges():Vector.<Edge>;
        function set edges(value:Vector.<Edge>):void;
    }
}
