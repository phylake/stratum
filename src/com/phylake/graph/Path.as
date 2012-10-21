package com.phylake.graph
{
    public class Path
    {
        CONFIG::test
        {
            public var _nodes:Vector.<Object> = new Vector.<Object>;
        }
        CONFIG::release
        {
            internal var _nodes:Vector.<Object> = new Vector.<Object>;
        }

        CONFIG::test
        {
            internal var _clonedFrom:Path;
        }
        CONFIG::release
        {
            public var _clonedFrom:Path;
        }

        public function get clonedFrom():Path
        {
            return _clonedFrom;
        }

        public function get last():Object
        {
            return _nodes.length > 0 ? _nodes[_nodes.length - 1] : null;
        }

        public function get nodes():Vector.<Object>
        {
            // need to keep the linear path
            return null;
        }

        public function push(node:Object):Path
        {
            const newPath:Path = new Path;
            newPath._clonedFrom = this;
            newPath._nodes = _nodes.concat();
            newPath._nodes.push(node);

            return newPath;
        }

        public function equals(that:Path):Boolean
        {
            if (this._nodes.length != that._nodes.length)
            {
                return false;
            }
            
            for (var i:int = 0; i < _nodes.length; i++)
            {
                if (this._nodes[i] !== that._nodes[i])
                {
                    return false;
                }
            }

            return true;
        }

        /**
         * @return true if this is a subset of that
         */
        public function isSubset(that:Path):Boolean
        {
            var shorter:Path;
            var longer:Path;

            if (this._nodes.length < that._nodes.length)
            {
                shorter = this;
                longer = that;
            }
            else if (that._nodes.length < this._nodes.length)
            {
                shorter = that;
                longer = this;
            }
            else
            {
                return this.equals(that);
            }

            for (var i:int = 0; i < shorter._nodes.length; i++)
            {
                if (shorter._nodes[i] !== longer._nodes[i])
                {
                    return false;
                }
            }

            return this == shorter;
        }

        public function destroy():void
        {
            _nodes = null;
            _clonedFrom = null;
        }

        public function toString():String
        {
            var str:Array = [];
            for each (var obj:Object in _nodes)
            {
                str.push(obj.toString());
            }
            return str.join(', ');
        }
    }
}
