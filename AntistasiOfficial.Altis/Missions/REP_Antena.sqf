if (!isServer and hasInterface) exitWith {};

params ["_marker","_posAntenna"];
[localize "STR_TSK_REPANTENNA",localize "STR_TSKDESC_REPANTENNA",""] params ["_tskTitle","_tskDesc","_group"];

private ["_duration","_endTime","_targetName","_task","_size","_position","_vehicle","_unit","_antenna","_resourcesAAF"];

_duration = 60;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;
_targetName = [_marker] call AS_fnc_localizar;

_task = ["REP",[side_blue,civilian],[format [_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_posAntenna,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _task; publicVariable "misiones";

waitUntil {sleep 1;(dateToNumber date > _endTime) OR (spawner getVariable _marker)};

if (spawner getVariable _marker) then {
	_group = createGroup side_green;
	_size = [_marker] call sizeMarker;
	_position = [];
	_position = _posAntenna findEmptyPosition [10,60,selectRandom vehTruckBox];
	_vehicle = createVehicle [selectRandom vehTruckBox, _position, [], 0, "NONE"];
	_vehicle allowdamage false;
	_vehicle setDir random 360;
	[_vehicle] spawn genVEHinit;

	sleep 5;
	_vehicle allowDamage true;

	for "_i" from 1 to 3 do {
		_unit = ([_position, 0, sol_CREW, _group] call bis_fnc_spawnvehicle) select 0;
		[_unit] spawn genInit;
		sleep 2;
	};

	waitUntil {sleep 1;(dateToNumber date > _endTime) OR !(alive _vehicle)};

	if !(alive _vehicle) then {
		_task = ["REP",[side_blue,civilian],[format [_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4, A3_Str_INDEP],_tskTitle,_marker],_posAntenna,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		[2,0] remoteExec ["prestige",2];
		[1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (_x distance _vehicle < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,Slowhand] call playerScoreAdd;
	};
};

if (dateToNumber date > _endTime) then {
	if (_marker in mrkFIA) then {
		_task = ["REP",[side_blue,civilian],[format [_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4, A3_Str_INDEP],_tskTitle,_marker],_posAntenna,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		[2,0] remoteExec ["prestige",2];
		[1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (_x distance _vehicle < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,Slowhand] call playerScoreAdd;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	} else {
		_task = ["REP",[side_blue,civilian],[format [_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4, A3_Str_INDEP],_tskTitle,_marker],_posAntenna,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		//[5,0,_posAntenna] remoteExec ["AS_fnc_changeCitySupport",2];
		[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
		[-10,Slowhand] call playerScoreAdd;
	};

	antenasMuertas = antenasMuertas - [_posAntenna];
	_antenna = nearestBuilding _posAntenna;
	if (isMultiplayer) then {_antenna hideObjectGlobal true} else {_antenna hideObject true};
	_antenna = createVehicle ["Land_Communication_F", _posAntenna, [], 0, "NONE"];
	antenas pushBack _antenna;
	publicVariable "antenas";

	_mrkfin = createMarker [format ["Ant%1", count antenas], _posAntenna];
	_mrkfin setMarkerShape "ICON";
	_mrkfin setMarkerType "loc_Transmitter";
	_mrkfin setMarkerColor "ColorBlack";
	_mrkfin setMarkerText "Radio Tower";
	mrkAntenas pushBack _mrkfin;
	_antenna addEventHandler ["Killed", {
		params ["_object"];
		_object = _this select 0;
		private _mrk = [mrkAntenas, _object] call BIS_fnc_nearestPosition;
		antenas = antenas - [_object];
		antenasmuertas pushBack (getPos _object);
		deleteMarker _mrk;
		[["TaskSucceeded", ["", localize "STR_TSK_RADIO_DESTROYED"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	}];
};

_resourcesAAF = server getVariable ["resourcesAAF",0];
_resourcesAAF = _resourcesAAF - 10000;
server setVariable ["resourcesAAF",_resourcesAAF,true];
[60,_task] spawn borrarTask;

waitUntil {sleep 1; !(spawner getVariable _marker)};

if (typeName _group == "GROUP") then {
	{deleteVehicle _x} forEach units _group;
	deleteGroup _group;
	if !([distanciaSPWN,1,_vehicle,"BLUFORSpawn"] call distanceUnits) then {deleteVehicle _vehicle};
};