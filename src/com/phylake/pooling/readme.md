Status : Experimental
=====================

Description
===========

Managed object pooling

- bounded and unbounded pools
- queued continuations
- optional exceptions

Example usage
=============

    package {
        import com.phylake.pooling.ObjectPool;
        import flash.display.*;
        import flash.events.*;

        public class Main extends Sprite {
            private var pool:ObjectPool;

            public function Main() {
                pool = new ObjectPool;
                pool.instantiateFunction = PoolingExample.initialize;
                pool.reclaimFunction     = PoolingExample.reclaim;
                pool.destroyFunction     = PoolingExample.destroy;

                var pe1:PoolingExample = pool.getObject();
                pe1.doSomething();
                pool.setObject(pe1);// return object to be reclaimed

                pool.getObjectAsync(function(pe2:PoolingExample):void {
                    pe2.doSomething();
                    pool.setObject(pe2);// return object to be reclaimed
                });
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

        public function PoolingExample() {
            one = "hi";
            two = 1;
        }

        public function doSomething():void {}
    }
