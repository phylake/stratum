package com.phylake.fsm.core
{
	public interface IState
	{
		/*
		this is useful if you don't want to create new concrete classes per
		state
		*/
		function get id():*;
		function set id(value:*):void;

		/*
		there is no exit state because we're modeling Moore
		*/
		function get enterState():IAction;

		function get subMachines():Vector.<IFsm>;
	}
}
