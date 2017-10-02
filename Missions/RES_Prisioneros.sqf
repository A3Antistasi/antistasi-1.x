if (!isServer and hasInterface) exitWith {};

params ["_marker"];
[localize "STR_TSK_RESPRISONERS",localize "STR_TSKDESC_RESPRISONERS",[],[]] params ["_taskTitle","_taskDesc","_POWs","_housePositions"];

private ["_markerPos","_duration","_endTime","_houses","_house","_townName","_task","_groupPOW","_count","_unit","_blacklistbld","_options","_tempPos"];

_markerPos = getMarkerPos _marker;
_duration = 120;//120
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;

_townName = [_marker] call AS_fnc_localizar;

_task = ["RES",[side_blue,civilian],[format [_taskDesc,_townName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_taskTitle,_marker],_markerPos,"CREATED",5,true,true,"run"] call BIS_fnc_setTask;
misiones pushBack _task; publicVariable "misiones";

_blacklistbld = ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V1_No1_F","Land_Cargo_Tower_V1_No2_F","Land_Cargo_Tower_V1_No3_F","Land_Cargo_Tower_V1_No4_F","Land_Cargo_Tower_V1_No5_F","Land_Cargo_Tower_V1_No6_F","Land_Cargo_Tower_V1_No7_F","Land_Cargo_Tower_V2_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F"];

_houses = nearestObjects [_markerPos, ["house"], 50];

_options = [];
for "_i" from 0 to (count _houses - 1) do {
	_house = (_houses select _i);
	_housePositions = [_house] call BIS_fnc_buildingPositions;
	if ((count _housePositions > 1) AND !(typeOf _house in _blacklistbld)) then {_options pushBack _house};
};

if (count _options > 0) then {
	_house = _options call BIS_Fnc_selectRandom;
	_housePositions = [_house] call BIS_fnc_buildingPositions;
	_count = ((count _housePositions) - 1) min 10;
} else {
	_count = round random 10;
	for "_i" from 0 to _count do {
		_tempPos = [_markerPos, 5, random 360] call BIS_Fnc_relPos;
		_housePositions = _housePositions + [_tempPos];
	};
};

_groupPOW = createGroup side_blue;
for "_i" from 0 to _count do
	{
	_unit = _groupPOW createUnit [guer_POW, (_housePositions select _i), [], 0, "NONE"];
	_unit allowDamage false;
	_unit setCaptive true;
	_unit disableAI "MOVE";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit setUnitPos "UP";
	_unit setBehaviour "CARELESS";
	_unit allowFleeing 0;
	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	sleep 1;
	_POWS pushBack _unit;
	[_unit,"prisionero"] remoteExec ["AS_fnc_addActionMP"];
};

sleep 5;

{_x allowDamage true} forEach _POWS;

waitUntil {sleep 1; ({alive _x} count _POWs == 0) OR ({(alive _x) AND (_x distance getMarkerPos guer_respawn < 50)} count _POWs > 0) OR (dateToNumber date > _endTime)};

if (dateToNumber date > _endTime) then {
	if !(spawner getVariable _marker) then {
		{
			if (group _x == _groupPOW) then {
				_x setDamage 1;
			};
		} forEach _POWS;
	} else {
		{
			if (group _x == _groupPOW) then {
				_x setCaptive false;
				_x enableAI "MOVE";
				_x doMove _markerPos;
			};
		} forEach _POWS;
	};
};

waitUntil {sleep 1; ({alive _x} count _POWs == 0) OR ({(alive _x) AND (_x distance getMarkerPos guer_respawn < 50)} count _POWs > 0)};

if ({alive _x} count _POWs == 0) then {
	_task = ["RES",[side_blue,civilian],[format [_taskDesc,_townName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_taskTitle,_marker],_markerPos,"FAILED",5,true,true,"run"] call BIS_fnc_setTask;
	{_x setCaptive false} forEach _POWs;
	_count = 2 * (count _POWs);
	[_count,0] remoteExec ["prestige",2];
	[-10,Slowhand] call playerScoreAdd;
};

if ({(alive _x) AND (_x distance getMarkerPos guer_respawn < 50)} count _POWs > 0) then {
	_task = ["RES",[side_blue,civilian],[format [_taskDesc,_townName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_taskTitle,_marker],_markerPos,"SUCCEEDED",5,true,true,"run"] call BIS_fnc_setTask;
	_count = {(alive _x) AND (_x distance getMarkerPos guer_respawn < 150)} count _POWs;
	[2*_count,100*_count] remoteExec ["resourcesFIA",2];
	[0,10,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	[_count,0] remoteExec ["prestige",2];
	{if (_x distance getMarkerPos guer_respawn < 500) then {[_count,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
	[round (_count/2),Slowhand] call playerScoreAdd;
	{[_x] join _groupPOW; [_x] orderGetin false} forEach _POWs;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

sleep 60;
{deleteVehicle _x} forEach _POWs;
deleteGroup _groupPOW;

[1200,_task] spawn borrarTask;