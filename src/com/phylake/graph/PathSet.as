package com.phylake.graph
{
    import flash.utils.Dictionary;

    public class PathSet
    {
        CONFIG::test
        {
            protected var _paths:Vector.<Path> = new Vector.<Path>;
        }
        CONFIG::release
        {
            public var _paths:Vector.<Path> = new Vector.<Path>;
        }

        public function get paths():Vector.<Path>
        {
            return _paths.concat();
        }

        public function pushEdges(value:Vector.<Edge>):void
        {
            var edge:Edge;
            while (edge = value.shift()) pushEdge(edge);
        }

        CONFIG::test
        {
            public function printPaths():void
            {
                return;

                log("PathSet#printPaths");
                for each (var path:Path in _paths)
                {
                    log(String(path));
                }
            }
        }

        /* TODO work with DFS and BFS */
        public function pushEdge(edge:Edge):void
        {
            if (!edge) return;
            //log("PathSet#pushEdge");

            //log("edge.a", edge.a);
            //log("edge.b", edge.b);

            if (_paths.length == 0)
            {
                //log("_paths.length == 0");

                var p1:Path = (new Path).push(edge.a);
                var p2:Path = p1.push(edge.b);
                _paths.push(p1, p2);
                return;
            }

            const newPaths:Vector.<Path> = new Vector.<Path>;
            for each (var path:Path in _paths)
            {
                if (path.last == edge.a)
                {
                    newPaths.push(path.push(edge.b));
                }
            }
            _paths = _paths.concat(newPaths);

            printPaths();
        }

        /**
         * Remove any Paths where a Path is fully contained in another
         */
        public function pruneSubsets():void
        {
            //log("PathSet#pruneSubsets");
            var i:int;
            var j:int;
            var path:Path;

            /* 
              based on the assumption that a Path#push()
              is a superset of the original Path
            */
            for (i = 0; i < _paths.length;)
            {
                j = _paths.indexOf(_paths[i].clonedFrom);

                if (j != -1 && i != j && _paths[j].isSubset(_paths[i]))
                {
                    _paths.splice(j, 1);
                    continue;
                }
                i++;
            }

            // the above works for now. once i include direction i may need this
            /*outer: for (i = 0; i < _paths.length;)
            {
                for (j = 0; j < _paths.length; j++)
                {
                    if (i != j && _paths[i].isSubset(_paths[j]))
                    {
                        _paths.splice(i, 1);
                        continue outer;
                    }
                }
                i++;
            }*/
        }
    }
}
