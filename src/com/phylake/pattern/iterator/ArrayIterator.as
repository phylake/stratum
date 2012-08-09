package com.phylake.pattern.iterator
{
    public class ArrayIterator implements IIterator
    {
        private var _idx:uint = 0;
        private var _collection:Array;
        private var _autoReset:Boolean;
        
        /**
         * @param value
         * @param autoReset If true, obviates the need for hasNext() and reset()
         */
        public function ArrayIterator(value:Array, autoReset:Boolean = true) {
            _collection = value;
            _autoReset = autoReset
        }

        public function next():Object
        {
            const ret:Object = _collection[_idx++];
            if( _autoReset && !hasNext() ) reset();
            return ret;
        }
        
        public function hasNext():Boolean { return _idx < _collection.length; }
        
        public function reset():void { _idx = 0; }
    }
}
