package com.phylake.util
{
    public function tryDestroy(value:Object, ...rest):Boolean
    {
        if ("destroy" in value && value["destroy"] is Function)
        {
            value.destroy.apply(null, rest);
            return true;
        }
        return false;
    }
}
