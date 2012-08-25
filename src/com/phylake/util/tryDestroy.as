package com.phylake.util
{
    public function tryDestroy(value:Object, args:Array = null):Boolean
    {
        if ("destroy" in value && value["destroy"] is Function)
        {
            value.destroy.apply(null, args);
            return true;
        }
        return false;
    }
}
