package com.phylake.pooling
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
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
                    _available.push(value());
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

        protected var _available:Dictionary = new Dictionary;
        protected var _availableCount:int;

        protected var _inUse:Dictionary = new Dictionary;
        protected var _inUseCount:int;
        
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
            if (_bounded && _inUseCount >= _maxSize)
            {
                if (maxSizeException)
                {
                    throw new IllegalOperationError("ObjectPool size exceeded maxSize");
                }
                return _instantiateFunction();
            }

            var instance:Object;
            for (instance in _available)
            {
                break;
            }
            
            if (instance)
            {
                delete _available[instance];
                _availableCount--;
            }
            else
            {
                instance = _instantiateFunction();
            }

            if (instance)
            {
                _inUse[instance] = null;
                _inUseCount++;
            }
            
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

            if (_bounded && _inUseCount >= _maxSize)
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
            if (!instance) return;
            
            if (instance in _inUse)
            {
                delete _inUse[instance];
                _inUseCount--;
            }

            if (_bounded && _availableCount >= _maxSize)
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
                _available[instance] = null;
                _availableCount++;

                var f:Function;
                if (_bounded)
                {
                    while (_inUseCount < _maxSize && (f = _callbacks.shift()))
                    {
                        f(getObject());
                    }
                }
                else
                {
                    while (f = _callbacks.shift()) f(getObject());
                }
            }
        }

        public function get size():int
        {
            return _inUseCount + _availableCount;
        }

        public function get available():int
        {
            return _availableCount;
        }

        public function get inUse():int
        {
            return _inUseCount;
        }

        public function destroy(destroyInstances:Boolean = true):void
        {
            if (destroyInstances && destroyFunction != null)
            {
                var instance:Object;
                for (instance in _inUse)
                {
                    delete _inUse[instance];
                    destroyFunction(instance);
                }
                for (instance in _available)
                {
                    delete _available[instance];
                    destroyFunction(instance);
                }
            }

            _instantiateFunction = null;
            reclaimFunction = null;
            destroyFunction = null;
            _available = null;
            _inUse = null;
        }
    }
}
