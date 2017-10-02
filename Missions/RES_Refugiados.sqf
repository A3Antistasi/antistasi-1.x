if (!isServer and hasInterface) exitWith {};

params ["_marker"];
[localize "STR_TSK_RESREFUGEES",localize "STR_TSKDESC_RESREFUGEES",[],[]] params ["_taskTitle","_taskDesc","_POWs","_housePositions"];

private ["_markerPos","_size","_houses","_house","_townName","_task","_groupPOW","_count","_unit"];

_markerPos = getMarkerPos _marker;
_size = [_marker] call sizeMarker;
_townName = [_marker] call AS_fnc_localizar;

_houses = nearestObjects [_markerPos, ["house"], _size];
if (count _houses == 0) exitWith {};
while {count _housePositions < 5} do {
	_house = _houses call BIS_Fnc_selectRandom;
	_housePositions = [_house] call BIS_fnc_buildingPositions;
	if (count _housePositions < 5) then {_houses = _houses - [_house]};
};


_task = ["RES",[side_blue,civilian],[format [_taskDesc,_townName, A3_Str_INDEP],_taskTitle,_marker],getPos _house,"CREATED",5,true,true,"run"] call BIS_fnc_setTask;
misiones pushBack _task; publicVariable "misiones";

_groupPOW = createGroup side_blue;

_count = (count _housePositions) min 8;

for "_i" from 1 to (_count - 1) do {
	_unit = _groupPOW createUnit [guer_POW, _housePositions select _i, [], 0, "NONE"];
	_unit allowDamage false;
	_unit disableAI "MOVE";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit setBehaviour "CARELESS";
	_unit setUnitPos "MIDDLE";
	_unit allowFleeing 0;
	_unit setSkill 0;
	removeHeadgear _unit;
	removeGoggles _unit;
	removeAllWeapons _unit;
	removeVest _unit;
	removeBackpack _unit;
	_POWs pushBack _unit;
	[_unit,"refugiado"] remoteExec ["AS_fnc_addActionMP"];
};

sleep 5;

{_x allowDamage true} forEach _POWs;

sleep 30;

// Spawn a patrol after 5-30 minutes
[_house] spawn {
	private ["_house"];
	_house = _this select 0;
	sleep 300 + (random 1800);
	if ("RES" in misiones) then {[position _house] remoteExec ["patrolCA",HCattack]};
};

waitUntil {sleep 1; ({alive _x} count _POWs == 0) OR ({(alive _x) AND (_x distance getMarkerPos guer_respawn < 50)} count _POWs > 0)};

if ({alive _x} count _POWs == 0) then {
	_task = ["RES",[side_blue,civilian],[format [_taskDesc,_marker, A3_Str_INDEP],_taskTitle,_townName],getPos _house,"FAILED",5,true,true,"run"] call BIS_fnc_setTask;
	_count = count _POWs;
	[_count,0] remoteExec ["prestige",2];
	[0,-15,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_task = ["RES",[side_blue,civilian],[format [_taskDesc,_marker, A3_Str_INDEP],_taskTitle,_townName],getPos _house,"SUCCEEDED",5,true,true,"run"] call BIS_fnc_setTask;
	_count = {(alive _x) and (_x distance getMarkerPos guer_respawn < 150)} count _POWs;
	[_count,_count*100] remoteExec ["resourcesFIA",2];
	[0,_count,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
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