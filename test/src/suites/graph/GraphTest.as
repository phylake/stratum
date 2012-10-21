package suites.graph
{
    import org.flexunit.Assert;
    import com.phylake.graph.*;
    
    public class GraphTest
    {
        [Test]
        public function nodeLookup():void
        {
            const g:Graph = new Graph;
            g.addNodes("1", "2");
            g.addNodes("1", "3");

            const node:INode = g.getNode("1");
            Assert.assertEquals("1", node.id);
            Assert.assertEquals(2, node.edges.length);

            Assert.assertEquals("1", node.edges[0].a);
            Assert.assertEquals("2", node.edges[0].b);
            
            Assert.assertEquals("1", node.edges[1].a);
            Assert.assertEquals("3", node.edges[1].b);
        }
    }
}
