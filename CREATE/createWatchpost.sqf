if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_markerPos","_size","_position","_bunker","_vehicle","_normalPos","_group","_unit","_groupType","_tempGroup","_patrolMarker"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_group = createGroup side_green;

_vehicle = createVehicle ["Land_BagBunker_Tower_F", _markerPos, [],0, "NONE"];
_vehicle setVectorUp (surfacenormal (getPosATL _vehicle));
_allVehicles pushBack _vehicle;
_vehicle setDir (markerDir _marker);
_normalPos = surfaceNormal (position _vehicle);
_vehicle setVectorUp _normalPos;

_vehicle = createVehicle [cFlag, _markerPos, [],0, "NONE"];
_allVehicles pushBack _vehicle;

_vehicle = createVehicle ["I_supplyCrate_F", _markerPos, [],0, "NONE"];
_allVehicles pushBack _vehicle;
[_vehicle] call cajaAAF;

_position = _markerPos findEmptyPosition [5,50,enemyMotorpoolDef];
if !(count _position == 0) then {
	_vehicle = createVehicle [selectRandom vehTrucks, _position, [], 0, "NONE"];
	_vehicle setDir random 360;
	_allVehicles pushBack _vehicle;
};

sleep 1;

if !(worldName == "Tanoa") then {
	_position = [_markerPos] call mortarPos;
	_vehicle = statMortar createVehicle _position;
	//_vehicle enableDynamicSimulation true;
	_unit = ([_markerPos, 0, infGunner, _group] call bis_fnc_spawnvehicle) select 0;
	_unit moveInGunner _vehicle;
	[_vehicle] execVM "scripts\UPSMON\MON_artillery_add.sqf";
	_allVehicles pushBack _vehicle;
	_allGroups pushBack _group;
	_group allowFleeing 0;
	sleep 1;
};

_patrolMarker = [_marker, [50, 50]] call AS_fnc_createPatrolMarker;
_position = [_markerPos findEmptyPosition [15,50,enemyMotorpoolDef],_markerPos] select (worldName == "Tanoa");
_groupType = [infTeamATAA, side_green] call AS_fnc_pickGroup;
_group = [_position, side_green, _groupType] call BIS_Fnc_spawnGroup;
[leader _group, _patrolMarker, "SAFE","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
_allGroups pushBack _group;
_group allowFleeing 0;

{
	_tempGroup = _x;
	{
		[_x] spawn genInitBASES; _allSoldiers pushBack _x
	} forEach units _tempGroup;
	//_tempGroup enableDynamicSimulation true;
} forEach _allGroups;

{
	[_x] spawn genVEHinit;
} forEach _allVehicles;

//Wait until there is no enemy units nearby
waitUntil {
	sleep 1;
	!(spawner getVariable _marker) or
	(count (allUnits select {
		((side _x == side_green) or (side _x == side_red)) and (_x distance _markerPos <= (_size max 200)) AND
		!(captive _x)
	}) < 1)
};

//check if all enemies where killed
if (count(allUnits select {
		((side _x == side_green) or (side _x == side_red)) and
		(_x distance _markerPos <= (_size max 100))
	}) < 1)
then {
	[-5,0,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	[["TaskSucceeded", ["", localize "STR_TSK_WP_DESTROYED"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	_mrk = format ["Dum%1",_marker];
	deleteMarker _mrk;
	mrkAAF = mrkAAF - [_marker];
	mrkFIA = mrkFIA + [_marker];
	publicVariable "mrkAAF";
	publicVariable "mrkFIA";
	[_markerPos] remoteExec ["patrolCA",HCattack];
	if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
};

waitUntil {sleep 1; !(spawner getVariable _marker)};
deleteMarker _patrolMarker;
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
