if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_posMarker","_size","_cmpInfo","_posCmp","_cmp","_objs","_allGroups","_allSoldiers","_allVehicles","_statics","_SPAA","_hasSPAA","_truck","_crate","_unit","_groupCrew","_groupGunners","_markerPatrol","_UAV","_groupUAV","_groupType","_groupPatrol","_garrisonSize","_mrk"];

_posMarker = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_allGroups = [];
_allSoldiers = [];
_allVehicles = [];
_statics = [];
_hasSPAA = false;
_groupGunners = createGroup side_red;

_cmpInfo = [_marker] call AS_fnc_selectCMPData;
_posCmp = _cmpInfo select 0;
_cmp = _cmpInfo select 1;

_objs = [_posCmp, 0, _cmp] call BIS_fnc_ObjectsMapper;

{
	call {
		if (typeOf _x == opSPAA) exitWith {_SPAA = _x; _allVehicles pushBack _x; _hasSPAA = true};
		if (typeOf _x == opTruck) exitWith {_truck = _x; _allVehicles pushBack _truck};
		if (typeOf _x in [statMG, statAT, statAA, statAA2, statMGlow, statMGtower]) exitWith {_statics pushBack _x};
		//if (typeOf _x == statMortar) exitWith {_statics pushBack _x; [_x] execVM "scripts\UPSMON\MON_artillery_add.sqf"}; Stef removed mortar from Hilltop
		if (typeOf _x == opCrate) exitWith {_crate = _x; _allVehicles pushBack _x};
		if (typeOf _x == opFlag) exitWith {_allVehicles pushBack _x};
	};
} forEach _objs;

_objs = _objs - [_truck];

if (_hasSPAA) then {
	_groupCrew = createGroup side_red;
	_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
	_unit moveInGunner _SPAA;
	_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
	_unit moveInCommander _SPAA;
	_SPAA lock 2;
	_allGroups pushBack _groupCrew;
	{[_x] spawn CSATinit; _allSoldiers pushBack _x} forEach units _groupCrew;
};

{
	_unit = ([_posMarker, 0, opI_CREW, _groupGunners] call bis_fnc_spawnvehicle) select 0;
	_unit moveInGunner _x;
	if (str typeof _x find statAA > -1) then {
		_unit = ([_posMarker, 0, opI_CREW, _groupGunners] call bis_fnc_spawnvehicle) select 0;
		_unit moveInCommander _x;
	};
} forEach _statics;

{[_x] spawn CSATinit; _allSoldiers pushBack _x} forEach units _groupGunners;
_allGroups pushBack _groupGunners;

_markerPatrol = createMarkerLocal [format ["specops%1", random 100],_posCmp];
_markerPatrol setMarkerShapeLocal "RECTANGLE";
_markerPatrol setMarkerSizeLocal [200,200];
_markerPatrol setMarkerTypeLocal "hd_warning";
_markerPatrol setMarkerColorLocal "ColorRed";
_markerPatrol setMarkerBrushLocal "DiagGrid";

[_groupGunners, _markerPatrol, "AWARE", "SPAWNED","NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";

_UAV = createVehicle [opUAVsmall, _posCmp, [], 0, "FLY"];
_allVehicles pushBack _UAV;
createVehicleCrew _UAV;
_groupUAV = group (crew _UAV select 1);
[_groupUAV, _markerPatrol, "SAFE", "SPAWNED","NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupUAV;
_allGroups pushBack _groupUAV;

_spawnGroup = {
	params ["_type"];

	_groupType = [_type, side_green] call AS_fnc_pickGroup;
	_groupPatrol = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
	sleep 1;
	[_groupPatrol, _marker, "SAFE","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
	{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupPatrol;
	_allGroups pushBack _groupPatrol;
};

{
	[_x] call _spawnGroup;
} forEach [infTeamATAA, infAA, infTeam];

{[_x] spawn genVEHinit} forEach _allVehicles;

_garrisonSize = count _allSoldiers;

if (_hasSPAA) then {
	waitUntil {sleep 1; !(spawner getVariable _marker) OR ((({alive _x} count _allSoldiers < (_garrisonSize / 3)) OR ({fleeing _x} count _allSoldiers == {alive _x} count _allSoldiers)) AND !(alive _SPAA) AND ({alive _x} count units _groupGunners == 0))};

	if ((({alive _x} count _allSoldiers < (_garrisonSize / 3)) OR ({fleeing _x} count _allSoldiers == {alive _x} count _allSoldiers)) AND !(alive _SPAA) AND ({alive _x} count units _groupGunners == 0)) then {
		[-5,0,_posMarker] remoteExec ["AS_fnc_changeCitySupport",2];
		[0,5] remoteExec ["prestige",2];
		{["TaskSucceeded", ["", format [localize "STR_TSK_TD_AAWP_DESTROYED", A3_Str_RED]]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		_mrk = format ["Dum%1",_marker];
		deleteMarker _mrk;
		mrkAAF = mrkAAF - [_marker];
		mrkFIA = mrkFIA + [_marker];
		publicVariable "mrkAAF";
		publicVariable "mrkFIA";
		[_posMarker] remoteExec ["patrolCA", call AS_fnc_getNextWorker];
		if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
	};
} else {
	waitUntil {sleep 1; !(spawner getVariable _marker) OR ((count (allUnits select {((side _x == side_green) OR (side _x == side_red)) AND (_x distance _posMarker <= (_size max 100)) AND !(captive _x)}) == 0) AND ({alive _x} count units _groupGunners == 0))};

	if (({alive _x} count _allSoldiers < (_garrisonSize / 3)) OR ({fleeing _x} count _allSoldiers == {alive _x} count _allSoldiers)) then {
		[-5,0,_posMarker] remoteExec ["AS_fnc_changeCitySupport",2];
		[0,5] remoteExec ["prestige",2];
		{["TaskSucceeded", ["", format [localize "STR_TSK_TD_AAWP_DESTROYED", A3_Str_RED]]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		_mrk = format ["Dum%1",_marker];
		deleteMarker _mrk;
		mrkAAF = mrkAAF - [_marker];
		mrkFIA = mrkFIA + [_marker];
		publicVariable "mrkAAF";
		publicVariable "mrkFIA";
		[_posMarker] remoteExec ["patrolCA", call AS_fnc_getNextWorker];
		if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
	};
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
{deleteVehicle _x} forEach _objs;
