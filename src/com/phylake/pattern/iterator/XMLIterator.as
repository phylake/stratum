package com.phylake.pattern.iterator
{
	public class XMLIterator implements IIterator
	{
		public function XMLIterator( value:XMLList ) {
			_xml = value;
			_idx = 0;
		}

		private var _xml:XMLList;
		private var _idx:uint;

		public function next():Object { return _xml[_idx++]; }
		
		public function hasNext():Boolean { return _idx < _xml.length(); }
		
		public function reset():void { _idx = 0; }
		
	}
}
