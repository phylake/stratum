package com.phylake.pattern.iterator
{
	public class NullIterator implements IIterator
	{
		public function next():Object { return null; }
		public function hasNext():Boolean { return false; }
		public function reset():void {}		
	}
}
