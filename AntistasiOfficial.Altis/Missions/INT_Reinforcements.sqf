if (!isServer and hasInterface) exitWith {};

params ["_target", "_base"];
private ["_posTarget", "_posBase", "_soldiers", "_groups", "_vehicles", "_endTime", "_targetName", "_baseName", "_data", "_numSoldiers"];

#define DURATION 30
#define DELAY 5

if ("INT" in misiones) exitWith {"Info: Reinforcement task killed, reinforcements task active already."};
//if ((format ["INT_%1",_target]) in misiones) exitWith {format ["Info: Reinforcement task killed, %1 already receiving reinforcements.", _target]};

_tskTitle = localize "STR_TSK_INTREINF";
_tskDesc = localize "STR_TSKDESC_INTREINF";

_posBase = getMarkerPos _base;
_posTarget = getMarkerPos _target;

_posData = [];
_posRoad = [];
_dir = 0;

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + DURATION];
_endTime = dateToNumber _endTime;

_targetName = [_target] call AS_fnc_localizar;
_baseName = [_base] call AS_fnc_localizar;
[_base, 15] spawn AS_fnc_addTimeForIdle;

_tsk = ["INT",[side_blue,civilian],[format [_tskDesc, A3_Str_INDEP, _targetName, _baseName],format [_tskTitle, A3_Str_INDEP],_target],_posTarget,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

sleep (DELAY * 60);

//Probably where the error is because sometimes QRF doesn't appear at all
_data = [_base, getMarkerPos _target, _target, 15, "mixed", "small", "", true] call enemyQRF;
_soldiers = _data select 0;
_groups = _data select 1;
_vehicles = _data select 2;

(_vehicles select 0) limitSpeed 50;
(_vehicles select 1) limitSpeed 55;

_numSoldiers = count _soldiers;

waitUntil {
	sleep 1;
	(dateToNumber date > _endTime) or
	({_x distance _posTarget < 150} count _soldiers > 5) or
	(3*({(alive _x) and !(captive _x)} count _soldiers) < _numSoldiers)
};

if ({_x distance _posTarget < 150} count _soldiers > 5) then {
	_tsk = ["INT",[side_blue,civilian],[format [_tskDesc, A3_Str_INDEP, _targetName, _baseName],format [_tskTitle, A3_Str_INDEP],_target],_posTarget,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[-10, Slowhand] call playerScoreAdd;
	[5, 0, _posTarget] remoteExec ["AS_fnc_changeCitySupport", 2];
} else {
	_tsk = ["INT",[side_blue,civilian],[format [_tskDesc, A3_Str_INDEP, _targetName, _baseName],format [_tskTitle, A3_Str_INDEP],_target],_posTarget,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[10, Slowhand] call playerScoreAdd;
	[0, 5, _posTarget] remoteExec ["AS_fnc_changeCitySupport", 2];
};

reducedGarrisons = reducedGarrisons - [_target];
publicVariable "reducedGarrisons";

[5, _tsk] spawn borrarTask;

{
	[_x] spawn {
		waitUntil {sleep 3; (!([distanciaSPWN,1,_this select 0,"BLUFORSpawn"] call distanceUnits))};
		deleteVehicle (_this select 0);
	};
} forEach (_soldiers + _vehicles);

{
	[_x] spawn {
		waitUntil {sleep 5; (count (units (_this select 0)) < 1)};
		deleteGroup (_this select 0);
	};
} forEach _groups;