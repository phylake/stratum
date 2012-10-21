package 
{
    import flash.external.ExternalInterface;
    
    public function log(...rest):void
    {
        if (ExternalInterface.available)
        {
            rest.unshift('log');
            ExternalInterface.call.apply(null, rest);
        }
    }
}
