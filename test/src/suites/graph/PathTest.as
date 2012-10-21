package suites.graph
{
    import org.flexunit.Assert;
    import com.phylake.graph.*;
    
    public class PathTest
    {
        [Test]
        public function push():void
        {
            var p1:Path = (new Path).push("1");
            var p2:Path = p1.push("2");
            var p3:Path = p2.push("3");

            Assert.assertEquals(1, p1._nodes.length);
            Assert.assertEquals(2, p2._nodes.length);
            Assert.assertEquals(3, p3._nodes.length);

            Assert.assertEquals("1", p1._nodes[0]);

            Assert.assertEquals("1", p2._nodes[0]);
            Assert.assertEquals("2", p2._nodes[1]);

            Assert.assertEquals("1", p3._nodes[0]);
            Assert.assertEquals("2", p3._nodes[1]);
            Assert.assertEquals("3", p3._nodes[2]);
        }

        [Test]
        public function equals():void
        {
            var p1:Path = (new Path).push("1").push("2");
            var p2:Path = (new Path).push("1").push("2");
            var p3:Path = (new Path).push("1").push("2").push("3");

            Assert.assertTrue(p1.equals(p2));
            Assert.assertTrue(p2.equals(p1));
            
            Assert.assertFalse(p1.equals(p3));
            Assert.assertFalse(p3.equals(p1));
        }

        [Test]
        public function subset():void
        {
            var p1:Path = (new Path).push("1").push("2");
            var p2:Path = (new Path).push("1").push("2");
            var p3:Path = (new Path).push("1").push("2").push("3");

            Assert.assertTrue(p2.isSubset(p1));
            Assert.assertTrue(p1.isSubset(p2));

            Assert.assertTrue(p1.isSubset(p3));
            Assert.assertFalse(p3.isSubset(p1));
        }
    }
}
