package com.phylake.pattern.enumerable 
{
    public class VectorEnumerable implements IEnumerable 
    {
        protected var _collection:Vector.<*>;

        public function VectorEnumerable(value:Vector.<*> = null)
        {
            _collection = value || new Vector.<*>;//never allow a null collection
        }
        
        public function map(f:Function):void
        {
            for (var i:int = 0; i < _collection.length; i++)
            {
                _collection[i] = f(_collection[i]);
            }
        }

        public function filter(f:Function):IEnumerable
        {
            const ret:Vector.<*> = new Vector.<*>;
            for each (var item:* in _collection)
            {
                if (f(item))
                {
                    ret.push(item);
                }
            }
            return new VectorEnumerable(ret);
        }

        public function reduce(acc:*, f:Function):*
        {
            
        }

        public function take(value:uint):IEnumerable
        {
            return new VectorEnumerable(_collection.slice(0, value+1));
        }

        public function takeWhile(f:Function):IEnumerable
        {
            for (var i:int = 0; i < _collection.length; i++)
            {
                if (f(_collection[i]))
                {
                    continue;
                }
                else
                {
                    break;
                }
            }
            return take(i);
        }

        public function drop(value:uint):IEnumerable
        {
            return new VectorEnumerable(_collection.slice(value, _collection.length));
        }

        public function dropWhile(f:Function):IEnumerable
        {
            for (var i:int = 0; i < _collection.length; i++)
            {
                if (!f(_collection[i]))
                {
                    continue;
                }
                else
                {
                    break;
                }
            }
            return drop(i);
        }
        
        public function get first():*
        {
            return _collection[0];
        }
        
        public function get last():*
        {
            return _collection[Math.max(_collection.length-1,0)];
        }
        
        public function empty():Boolean
        {
            return _collection.length == 0;
        }
    }
}
