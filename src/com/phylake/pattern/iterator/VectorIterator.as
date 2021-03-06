package com.phylake.pattern.iterator
{
    public class VectorIterator implements IIterator
    {
        private var _idx:uint;
        private var _collection:Vector.<*>;
        private var _autoReset:Boolean;

        /**
         * @param value
         * @param autoReset If true, obviates the need for hasNext() and reset()
         */
        public function VectorIterator(value:Vector.<*>, autoReset:Boolean = true) {
            _collection = value;
            _autoReset = autoReset
            _idx = 0;
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
