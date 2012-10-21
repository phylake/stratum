package com.phylake.graph
{
    /* TODO does this framework expose a concrete INode? */
    internal class Node implements INode
    {
        protected var _id:String;
        protected var _edges:Vector.<Edge>;

        public function Node(id:String):void
        {
            this.id = id;
        }
        
        public function get id():String
        {
            return _id;
        }
        public function set id(value:String):void
        {
            _id = value;
        }
        
        public function get edges():Vector.<Edge>
        {
            return _edges || (_edges = new Vector.<Edge>);
        }
        public function set edges(value:Vector.<Edge>):void
        {
            _edges = value;
        }
    }
}
