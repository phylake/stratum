package com.phylake.util
{
    /**
     * Uses strict equality
     * @param a Vector or Array
     * @param b Vector or Array
     * @return true is a is a subset of b
     */
    public function collectionSubset(a:Object, b:Object):Boolean
    {
        var shorter:Object;
        var longer:Object;

        if (a.length < b.length)
        {
            shorter = a;
            longer = b;
        }
        else if (b.length < a.length)
        {
            shorter = b;
            longer = a;
        }
        else
        {
            shorter = a;
            longer = b;
        }

        for (var i:int = 0; i < shorter.length; i++)
        {
            if (shorter[i] !== longer[i])
            {
                return false;
            }
        }

        return a == shorter;
    }
}
