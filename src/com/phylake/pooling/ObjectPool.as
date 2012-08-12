package com.phylake.pooling
{
    import flash.errors.IllegalOperationError;
    
    public class ObjectPool
    {
        /**
         * The function used to instantiate a new object.
         *
         * We could have easily taken a reference to a Class instead but this
         * allows object construction to be colocated with object reclamation
         * in a file. This method also makes the least assumptions.
         */
        public var instantiateFunction:Function;
        
        /**
         * The function used to reset/reclaim or otherwise prepare the
         * instance of a Class to be reused
         */
        public var reclaimFunction:Function;

        /**
         * The function used to destroy/dispose or otherwise prepare the
         * instance of a Class for garbage collection
         */
        public var destroyFunction:Function;

        public var maxSizeException:Boolean;

        private var _available:Vector.<Object> = new Vector.<Object>;
        private var _inUse:Vector.<Object> = new Vector.<Object>;

        private var _minSize:uint;
        private var _maxSize:int;

        /**
         * @param minSize The initial size of the pool
         * @param maxSize The maximum size of the pool.
         *                minSize &gt; maxSize == an unbounded pool size
         */
        public function ObjectPool(minSize:uint = 0, maxSize:int = -1)
        {
            _minSize = minSize;
            _maxSize = maxSize;

            while (minSize-- > 0)
            {
                this.object;
            }
        }
        
        public function get object():Object
        {
            const instance:Object = _available.pop() || instantiateFunction();

            // this is a bounded pool and we're about to run out of room
            if (_minSize < _maxSize && _inUse.length-1 >= _maxSize)
            {
                if (maxSizeException)
                {
                    throw new IllegalOperationError("ObjectPool size exceeded maxSize");
                }
            }
            else
            {
                _inUse.push(instance);
            }
            
            return instance;
        }

        public function set object(instance:Object):void
        {
            if (!instance) return;
            
            _inUse.pop();

            if (_minSize < _maxSize && _available.length >= _maxSize)
            {
                if (destroyFunction != null)
                {
                    destroyFunction(instance);
                }
            }
            else
            {
                reclaimFunction(instance);
                _available.push(instance);
            }
        }

        public function destroy(destroyInstances:Boolean = true):void
        {
            if (destroyInstances && destroyFunction != null)
            {
                var instance:Object;
                while (instance = _inUse.pop())
                {
                    destroyFunction(instance);
                }
                while (instance = _available.pop())
                {
                    destroyFunction(instance);
                }
            }

            instantiateFunction = null;
            reclaimFunction = null;
            destroyFunction = null;
            _available = null;
            _inUse = null;
        }
    }
}
