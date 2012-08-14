Status : Experimental
=====================

Description
===========

A finite state machine modeling Moore insofar as is practical.

A rough translation of the formalism is provided:
FSM = (Σ,Γ,S,i,δ,ω)
where
- Σ is the alphabet, modeled by IEvent#name
- Γ is the output alphabet, modeled by any IEvent produced from within FSM (via ω)
- S is the set of states, modeled by IFsm#states and IState
- i is the initial state, modeled by IFsm#init
- δ is the the state transition function, modeled by ITransition
- ω is the output function S⟶Γ, modeled by a certain interaction of IAction and
the Fsm implementation. This (i.e. ⟶) boils down to the executeAction calls in
Fsm when a transition is found. Put another way, ω is not an AS3 function, nor
is it a class or interface, but rather it is an abstraction, specified in AS3 by
the steps allowing an IAction (accepting an IFsm) to call IFsm#pushEvent

Not included in the formalism is guarded transitions allowing multiple IEvents
to be mapped to a single IState. A runtime exception is thrown if it becomes
possible to transit out of a state into more than 1 state.
