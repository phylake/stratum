package com.phylake.util
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public function getClass(value:Object):Class
    {
        const fqcn:String = getQualifiedClassName(value);
        return Class(getDefinitionByName(fqcn));
    }
}
