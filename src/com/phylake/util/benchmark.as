package com.phylake.util
{
    import flash.utils.getTimer;

    public function benchmark(value:Function, n:int = 1):int
    {
        const t0:int = getTimer();
        while (n-- > 0) value.call();
        return getTimer() - t0;
    }
}
