package com.phylake.graph
{
    import flash.utils.Dictionary;

    /**
     * Trying to keep a node limited to an id and a list of edges.
     * Other layers should build data/logic on the queries.
     */
    public class Graph
    {
        /**
         *   key id:String
         * value edges:Vector.<Edge>
         */
        public var nodeToEdges:Object = {};
        public var edges:Dictionary = new Dictionary;

        /*public function addNode(value:Node):void
        {
            for each (var edge:Edge in value.edges)
            {
                addEdge(edge);
            }
        }*/

        public function getNode(id:String):INode
        {
            const vEdges:Dictionary = new Dictionary;
            const ret:Node = new Node(id);

            for each (var edge:Edge in nodeToEdges[id])
            {
                if (edge in vEdges) continue;
                vEdges[edge] = null;

                ret.edges.push(edge);
            }
            return ret;
        }

        public function addNodes(a:Object, b:Object, direction:int = Edge.DIRECTION_AB):void
        {
            if (direction != Edge.DIRECTION_AB)
            {
                throw new ArgumentError("not supporting anything else yet");
            }
            /*if (!(a is String && b is String))
            {
                throw new ArgumentError("only strings at the moment");
            }*/
            
            //if (a is String) a = new Node(a);
            //if (b is String) b = new Node(b);

            if (a is INode) a = INode(a).id;
            if (b is INode) b = INode(b).id;
            
            const e:Edge = new Edge;
            e.a = a;
            e.b = b;
            e.direction = direction;

            nodeToEdges[a] ||= new Vector.<Edge>;
            nodeToEdges[a].push(e);
            nodeToEdges[b] ||= new Vector.<Edge>;
            nodeToEdges[b].push(e);

            /*var node:Node = idToNode[a] || (idToNode[a] = new Node(a as String));
            node.children.push(new Node(b as String));*/
        }

        public function addEdge(value:Edge):void
        {
            switch (value.direction)
            {
                case Edge.DIRECTION_NA:
                    break;
                case Edge.DIRECTION_AB:
                    break;
                case Edge.DIRECTION_BA:
                    break;
            }
        }

        /* TODO factor out traversal */
        public function allPaths():Vector.<Path>
        {
            const ps:PathSet = new PathSet;
            for (var e:Object in edges)
            {
                ps.pushEdge(e as Edge);
            }
            ps.pruneSubsets();
            return ps.paths;
        }
    }
}
