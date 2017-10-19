/*
Testing advanced roadblock spawning script. Sparker.
*/
if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_markerPos","_size","_distance","_roads","_connectedRoads","_bunker","_static","_group","_unit","_groupType","_tempGroup","_dog","_normalPos"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

//Delete trees
private _no = nearestTerrainObjects [_markerPos, ["TREE", "SMALL TREE", "BUSH"], 20, false, true];
{hideObjectGlobal _x;} forEach _no;

//Get the composition data
private _rbData = roadblocksEnemy getVariable [_marker, nil];
if(isNil "_rbData") exitWith {diag_log format ["createRoadblock2.sqf: Error: no _rbData found for %1", _marker];};

private _objects = [_markerPos, _rbData select 1, _rbData select 0] call BIS_fnc_ObjectsMapper;


private _vehicleArray = [];
private _turretArray = [];

//Initialize arrays
{
	call {
		//_normalPos = surfaceNormal (position _x);
		//_x setVectorUp _normalPos;
		if ((typeOf _x) in var_AAF_groundForces) exitWith {_vehicleArray pushBack _x;};
		if ((typeOf _x) isEqualTo statMG) exitWith {_turretArray pushBack _x;};
	};
} forEach _objects;

private _veh = objNull;
private _group = objNull;
//Fill the vehicle
{
	_group = createGroup side_green;
	_veh = _x;
	_group addVehicle _veh;
	_allGroups pushback _group;
	//Driver, gunner
	_driver = ([getPos _veh, 0, infCrew, _group] call bis_fnc_spawnvehicle) select 0;
	_gunner = ([getPos _veh, 0, infCrew, _group] call bis_fnc_spawnvehicle) select 0;
	_allSoldiers pushback _driver;
	_allSoldiers pushback _gunner;
	_group selectLeader _gunner;
	//_driver assignAsDriver _veh;
	//_gunner assignAsDriver _veh;
	//[_driver, _gunner] orderGetIn true;
	_driver moveInDriver _veh;
	_gunner moveInGunner _veh;
	_allGroups pushBack _group;
} forEach _vehicleArray;

//Create infantry
_groupType = [infAT, side_green] call AS_fnc_pickGroup;
_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
_allGroups pushBack _group;
_soldier = ([_markerPos, 0, sol_MED, _group] call bis_fnc_spawnvehicle) select 0;
_soldier = ([_markerPos, 0, sol_LAT, _group] call bis_fnc_spawnvehicle) select 0;

//Fill statics
{
	_static = _x;
	_unit = ([_markerPos, 0, infGunner, _group] call bis_fnc_spawnvehicle) select 0;
	_unit assignAsGunner _static;
	_unit moveInGunner _static;
	//Make static more bottom-heavy
	_static setCenterOfMass [(getCenterOfMass _static) vectorAdd [0, 0, -1], 0];
} forEach _turretArray;


[leader _group, _marker, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _group;

//_allVehicles = _vehicleArray + _turretArray;
//_allVehicles pushBack _objects;
_allVehicles = _objects;
//diag_log _allVehicles;
{[_x] spawn genVEHinit} forEach _allVehicles;


waitUntil {sleep 1; !(spawner getVariable _marker) or (count (allUnits select {((side _x == side_green) or (side _x == side_red)) and (_x distance _markerPos <= _size) AND !(captive _x)}) < 1)};

private _removeMarker = false;

if (count (allUnits select {((side _x == side_green) or (side _x == side_red)) and (_x distance _markerPos <= _size)}) < 1) then { //Did everyone die?
	_removeMarker = true;
	[-5,0,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	[["TaskSucceeded", ["", localize "STR_TSK_RB_DESTROYED"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	[_markerPos] remoteExec ["patrolCA",HCattack];
};

waitUntil {sleep 1; !(spawner getVariable _marker)};
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;

if(_removeMarker) then //Remove the roadblock completely
{
	mrkAAF = mrkAAF - [_marker];
	markers = markers - [_marker];
	controles = controles - [_marker];
	publicVariable "mrkAAF";
	publicVariable "markers";
	publicVariable "controles";
	spawner setVariable [_marker, nil, true];
	//publicVariable "mrkFIA";
	if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
	deleteMarker _marker;
	roadblocksEnemy setVariable [_marker, nil];
};