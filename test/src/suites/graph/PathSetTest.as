package suites.graph
{
    import org.flexunit.Assert;
    import com.phylake.graph.*;
    
    public class PathSetTest
    {
        [Test]
        public function pushOne():void
        {
            var path:Path;
            var ps:PathSet = new PathSet;
            ps.pushEdge(new Edge("1", "2"));

            Assert.assertEquals(2, ps.paths.length);

            path = ps.paths[0];
            Assert.assertEquals("1", path._nodes[0]);

            path = ps.paths[1];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("2", path._nodes[1]);
        }

        [Test]
        public function pushN():void
        {
            var path:Path;
            var ps:PathSet = new PathSet;
            ps.pushEdges(new <Edge>[
                  new Edge("1", "2")
                , new Edge("1", "3")
                , new Edge("3", "4")
                //, new Edge("3", "6")
                //, new Edge("4", "5")
                //, new Edge("6", "5")
            ]);

            Assert.assertEquals(4, ps.paths.length);

            path = ps.paths[0];
            Assert.assertEquals("1", path._nodes[0]);

            path = ps.paths[1];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("2", path._nodes[1]);

            path = ps.paths[2];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("3", path._nodes[1]);

            path = ps.paths[3];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("3", path._nodes[1]);
            Assert.assertEquals("4", path._nodes[2]);
        }

        [Test]
        public function pruneSubsets():void
        {
            var path:Path;
            var ps:PathSet = new PathSet;
            ps.pushEdges(new <Edge>[
                  new Edge("1", "2")
                , new Edge("1", "3")
                , new Edge("3", "4")
                , new Edge("3", "6")
                , new Edge("4", "5")
                , new Edge("6", "5")
            ]);
            ps.pruneSubsets();

            Assert.assertEquals(3, ps.paths.length);

            path = ps.paths[0];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("2", path._nodes[1]);

            path = ps.paths[1];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("3", path._nodes[1]);
            Assert.assertEquals("4", path._nodes[2]);
            Assert.assertEquals("5", path._nodes[3]);

            path = ps.paths[2];
            Assert.assertEquals("1", path._nodes[0]);
            Assert.assertEquals("3", path._nodes[1]);
            Assert.assertEquals("6", path._nodes[2]);
            Assert.assertEquals("5", path._nodes[3]);
        }
    }
}
