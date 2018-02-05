/*
Pluggable interceptors

Example: profiling interceptors
{
UPSMON_MAINLOOP_cycleArr =[];
UPSMON_MAINLOOP_betweenCycleArr =[];
UPSMON_MAINLOOP_timer0 = diag_tickTime;
UPSMON_MAINLOOP_timer1 = diag_tickTime;
UPSMON_MAINLOOP_index1 = 0;
UPSMON_MAINLOOP_preCycle = {
                            UPSMON_MAINLOOP_betweenCycleArr set [UPSMON_MAINLOOP_index1, diag_tickTime - UPSMON_MAINLOOP_timer0];
                            UPSMON_MAINLOOP_timer0 = diag_tickTime;
                            UPSMON_MAINLOOP_timer1 = diag_tickTime;
                           };
UPSMON_MAINLOOP_postCycle = {
                            UPSMON_MAINLOOP_cycleArr set [UPSMON_MAINLOOP_index1, diag_tickTime - UPSMON_MAINLOOP_timer1];
                            UPSMON_MAINLOOP_index1 = UPSMON_MAINLOOP_index1 + 1;
                            if(UPSMON_MAINLOOP_index1 == 10)then {UPSMON_MAINLOOP_index1=0;};
                            };


UPSMON_MAINLOOP_itemArr =[];
UPSMON_MAINLOOP_timer2 = diag_tickTime;
UPSMON_MAINLOOP_index2 = 0;

UPSMON_MAINLOOP_preItem = {UPSMON_MAINLOOP_timer2 = diag_tickTime;};
UPSMON_MAINLOOP_postItem = {
                           UPSMON_MAINLOOP_itemArr set [UPSMON_MAINLOOP_index2, diag_tickTime - UPSMON_MAINLOOP_timer2];
                           UPSMON_MAINLOOP_index2 = UPSMON_MAINLOOP_index2 + 1;
                           if(UPSMON_MAINLOOP_index2 == 10)then {UPSMON_MAINLOOP_index2=0;};
                           };
}
remoteExec ["call", 2];
================================
{
    private _unitsCount = 0;
    private _output =[UPSMON_MAINLOOP_betweenCycleArr, UPSMON_MAINLOOP_cycleArr, UPSMON_MAINLOOP_itemArr, {_unitsCount= _unitsCount +(count units _x);true;}count UPSMON_NPCs, _unitsCount];
    [
		_output,
		{
			params["_between","_a","_b","_c", "_d"];
			systemchat "=====================";
			systemchat format["Time between cycle starts (sec):%1", _between];
			systemchat format["Time to run one cycle (sec):%1", _a];
			systemchat format["Time for one UPSMON group (sec):%1", _b];
			systemchat format["UPSMON controlled groups:%1", _c];
			systemchat format["UPSMON controlled units:%1", _d];
		}
	]
	remoteExec ["call", remoteExecutedOwner];
}
remoteExec ["call", 2];

================================
Example: dummy interceptors
{
UPSMON_MAINLOOP_cycleArr =nil;
UPSMON_MAINLOOP_betweenCycleArr =nil;
UPSMON_MAINLOOP_timer0 = nil;
UPSMON_MAINLOOP_timer1 = nil;
UPSMON_MAINLOOP_index1 = nil;
UPSMON_MAINLOOP_itemArr =nil;
UPSMON_MAINLOOP_timer2 = nil;
UPSMON_MAINLOOP_index2 = nil;

UPSMON_MAINLOOP_preCycle = {};
UPSMON_MAINLOOP_postCycle = {};
UPSMON_MAINLOOP_preItem = {};
UPSMON_MAINLOOP_postItem = {};
}
remoteExec ["call", 2];

*/
#define PROFILE_UPSMON

#ifdef PROFILE_UPSMON
UPSMON_MAINLOOP_preCycle = {};
UPSMON_MAINLOOP_postCycle = {};
UPSMON_MAINLOOP_preItem = {};
UPSMON_MAINLOOP_postItem = {};
#endif
scriptname "UPSMON_MAINLOOP";
UPSMON_MAINLOOP_cycle = 10;

UPSMON_MAINLOOP_body = compile preProcessFileLineNumbers "Scripts\UPSMON\UPSMON_MAINLOOP_body.sqf";

while {true} do
{
    #ifdef PROFILE_UPSMON
    call UPSMON_MAINLOOP_preCycle;
    #endif
	{
		#ifdef PROFILE_UPSMON
		call UPSMON_MAINLOOP_preItem;
		#endif

        _x call UPSMON_MAINLOOP_body;

		#ifdef PROFILE_UPSMON
        call UPSMON_MAINLOOP_postItem;
        #endif
	} foreach UPSMON_NPCs;

	If (ObjNull in UPSMON_NPCs) then {UPSMON_NPCs = UPSMON_NPCs - [ObjNull]};
	#ifdef PROFILE_UPSMON
	call UPSMON_MAINLOOP_postCycle;
	#endif
	sleep UPSMON_MAINLOOP_cycle;
};
