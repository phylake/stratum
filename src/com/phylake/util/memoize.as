package com.phylake.util
{
    import flash.utils.Dictionary;
    /**
     * For functions with only 1 argument
     */
    public function memoize(f:Function, useDictionary:Boolean = false):Function
    {
        const cache:Object = useDictionary ? new Dictionary : new Object;

        return function(arg:*):* {
            if (arg in cache)
            {
                return cache[arg];
            }
            else
            {
                return cache[arg] = f(arg);
            }
        };
    }
}
