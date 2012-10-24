package suites.util
{
    import org.flexunit.Assert;
    import com.phylake.util.*;
    
    public class CollectionSubsetTest
    {
        [Test]
        public function subset():void
        {
            Assert.assertEquals(true, collectionSubset([1,2,3], [1,2,3,4]));
        }

        [Test]
        public function superset():void
        {
            Assert.assertEquals(false, collectionSubset([1,2,3], [1,2]));
        }

        [Test]
        public function equal():void
        {
            Assert.assertEquals(true, collectionSubset([1,2,3], [1,2,3]));
        }
    }
}
