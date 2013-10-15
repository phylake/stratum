package com.phylake.fsm
{
    import com.phylake.fsm.core.IFsm;
    import com.phylake.fsm.core.IState;

    public function reachableStates(fsm:IFsm, ret:Vector.<IState>=null):Vector.<IState>
    {
        ret || (ret = new Vector.<IState>);

        ret.push(fsm.currentState);

        if (fsm.currentState.subMachines)
        {
            for each (var submachine:IFsm in fsm.currentState.subMachines)
            {
                reachableStates(submachine, ret);
            }
        }

        return ret;
    }
}
