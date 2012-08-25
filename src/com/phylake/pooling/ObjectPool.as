package com.phylake.pooling
{
    import flash.errors.IllegalOperationError;
    
    public class ObjectPool
    {
        /**
         * Required function used to instantiate an object.
         *
         * We could have easily taken a reference to a Class instead but this
         * allows object construction to be colocated with object reclamation
         * in a file. This approach also makes the least assumptions.
         */
        protected var _instantiateFunction:Function;
        public function set instantiateFunction(value:Function):void
        {
            if (value == null) throw new ArgumentError("value is null");

            const neverSet:Boolean = _instantiateFunction == null;
            _instantiateFunction = value;

            if (neverSet)
            {
                var minSize:uint = _minSize;
                while (minSize-- > 0)
                {
                    getObject();
                }
            }
        }
        
        /**
         * Required function used to reset/reclaim or otherwise prepare the
         * instance of a Class to be reused
         */
        public var reclaimFunction:Function;

        /**
         * Optional function used to destroy/dispose or otherwise prepare the
         * instance of a Class for garbage collection
         */
        public var destroyFunction:Function;

        public var maxSizeException:Boolean = true;

        protected var _available:Vector.<Object> = new Vector.<Object>;
        protected var _inUse:Vector.<Object> = new Vector.<Object>;
        protected var _callbacks:Vector.<Function> = new Vector.<Function>;

        protected var _minSize:uint;
        protected var _maxSize:int;
        protected var _bounded:Boolean;

        /**
         * @param minSize The initial size of the pool
         * @param maxSize The maximum size of the pool.
         *                minSize &gt; maxSize == an unbounded pool size
         */
        public function ObjectPool(minSize:uint = 0, maxSize:int = -1)
        {
            _minSize = minSize;
            _maxSize = maxSize;
            _bounded = _minSize < _maxSize;
        }

        public function getObject():Object
        {
            if (_bounded && _inUse.length >= _maxSize)
            {
                if (maxSizeException)
                {
                    throw new IllegalOperationError("ObjectPool size exceeded maxSize");
                }
                return null;
            }

            const instance:Object = _available.pop() || _instantiateFunction();
            _inUse.push(instance);
            return instance;
        }

        /**
         * Provides queue management using a continuation.
         *
         * With this mechanism there's no need to monitor how the ObjectPool was
         * set up or maintain knowledge of the internal pool size.
         *
         * Only useful for bounded pools. Also if you don't know if your pool
         * needs to be bounded, using this will allow seamless switching between
         * bounded and unbounded with no refactor required.
         */
        public function getObjectAsync(value:Function):void
        {
            if (value == null) throw new ArgumentError("value is null");

            if (_bounded && _inUse.length >= _maxSize)
            {
                _callbacks.push(value);
            }
            else
            {
                value(getObject());
            }
        }

        /**
         * @param instance the object to place in the pool. a value of null will
         * shrink the pool size
         */
        public function setObject(instance:Object):void
        {
            _inUse.pop();
            
            if (!instance) return;

            if (_bounded && _available.length >= _maxSize)
            {
                if (destroyFunction != null) destroyFunction(instance);
                
                if (maxSizeException)
                {
                    throw new IllegalOperationError("ObjectPool size exceeded maxSize");
                }
            }
            else
            {
                reclaimFunction(instance);
                _available.push(instance);

                if (_callbacks.length > 0)
                {
                    _callbacks.shift().call(null, getObject());
                }
            }
        }

        public function get size():int
        {
            return _inUse.length + _available.length;
        }

        public function destroy(destroyInstances:Boolean = true):void
        {
            if (destroyInstances && destroyFunction != null)
            {
                var instance:Object;
                while (instance = _inUse.pop())     destroyFunction(instance);
                while (instance = _available.pop()) destroyFunction(instance);
            }

            _instantiateFunction = null;
            reclaimFunction = null;
            destroyFunction = null;
            _available = null;
            _inUse = null;
        }
    }
}
