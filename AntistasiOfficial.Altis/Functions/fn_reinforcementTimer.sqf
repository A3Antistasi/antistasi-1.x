params ["_marker"];
private ["_base", "_endTime"];

#define TIMER 30

if (_marker in mrkFIA) exitWith {diag_log format ["Reinforcement Timer: invalid zone: %1", _marker]};
if !(_marker in reducedGarrisons) exitWith {diag_log format ["Reinforcement Timer: zone fully garrisoned: %1", _marker]};
if !(spawner getVariable _marker) exitWith {diag_log format ["Reinforcement Timer: zone is inactive: %1", _marker]};

_base = [_marker] call AS_fnc_findBaseForCA;
if (_base == "") exitWith {diag_log format ["Reinforcement Timer: no base found: %1", _marker]};

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + TIMER];
_endTime = dateToNumber _endTime;

while {true} do {
	if (_marker in mrkFIA) exitWith {diag_log format ["Reinforcement Timer: zone was conquered: %1", _marker]};
	if (_endTime < dateToNumber date) exitWith {diag_log format ["Reinforcement Timer: timer ran out: %1", _marker]};
	sleep 10;
};

if ((_marker in mrkFIA) or !(_marker in reducedGarrisons)) exitWith {
	diag_log format ["Reinforcement Timer: timer was stopped: %1", _marker];
};

diag_log format ["Reinforcement Timer: timer ran out: %1 -- dispatching reinforcements", _marker];
[_marker, _base] remoteExec ["INT_Reinforcements", HCattack];

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (4*TIMER)];
_endTime = dateToNumber _endTime;

while {true} do {
	if (_marker in mrkFIA) exitWith {diag_log format ["Reinforcement Timer: zone was conquered after reinforcement: %1", _marker]};
	if (_endTime < dateToNumber date) exitWith {diag_log format ["Reinforcement Timer: final timer ran out: %1", _marker]};
	sleep 10;
};

if (!(_marker in mrkFIA) and (_marker in reducedGarrisons)) then {reducedGarrisons = reducedGarrisons - [_marker]; publicVariable "reducedGarrisons"};