package com.phylake.graph
{
    public class Edge
    {
        /**
         * Undirected
         */
        public static const DIRECTION_NA:int = 0;
        /**
         * From A to B
         */
        public static const DIRECTION_AB:int = 1;
        /**
         * From B to A
         */
        public static const DIRECTION_BA:int = 2;

        /**
         * String or Node?
         */
        public var a:Object;
        /**
         * String or Node?
         */
        public var b:Object;

        /**
         * One of the DIRECTION_* constants
         */
        public var direction:int;
        
        public var data:*;

        public function Edge(a:Object = null, b:Object = null, direction:int = DIRECTION_AB)
        {
            this.a = a;
            this.b = b;
            this.direction = direction;
        }
    }
}
