Status : Experimental
=====================

Description
===========

Basic object pooling.

Example usage
=============

    package {
        import flash.display.*;
        import flash.events.*;

        public class Main extends Sprite {
            private var pool:ObjectPool;

            public function Main() {
                pool = new ObjectPool;
                pool.instantiateFunction = PoolingExample.initialize;
                pool.reclaimFunction     = PoolingExample.reclaim;
                pool.destroyFunction     = PoolingExample.destroy;
            }
        }
    }

    class PoolingExample {
        public static function initialize():PoolingExample {
            return new PoolingExample;
        }

        public static function reclaim(value:PoolingExample):void {
            value.one = null;
            value.two = 0;
        }

        public static function destroy(value:PoolingExample):void {
            value.one = null;
            value.two = 0;
            value.three = null;// additional cleanup
        }

        public var one:String;
        public var two:int;
        public var three:Object;

        public function PoolingExample {
            one = "hi";
            two = 1;
        }
    }
