package com.phylake.fsm.core
{
	public interface IGuard
	{
		function evaluate(fsm:IFsm, ie:IEvent):Boolean;
	}
}
