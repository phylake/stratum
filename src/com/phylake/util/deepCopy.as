package com.phylake.util
{
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * Only works for user defined types
     */
    public function deepCopy(value:Object):Object
    {
        const fqcn:String = getQualifiedClassName(value);
        const klass:Class = Class(getDefinitionByName(fqcn));
        
        registerClassAlias(fqcn, klass);
        
        const ba:ByteArray = new ByteArray;
        ba.writeObject(value);
        ba.position = 0;
        return ba.readObject();
    }
}
