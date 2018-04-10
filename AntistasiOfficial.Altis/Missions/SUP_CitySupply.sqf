if (!isServer and hasInterface) exitWith {};

params ["_marker", "_type"];
//[3,[],[],[],[],[]] params ["_countBuildings","_targetBuildings","_allGroups","_allSoldiers","_allVehicles","_leafletCrates"];
private ["_targetPosition","_targetName","_duration","_endTime","_task","_spawnPosition","_crate","_range","_allBuildings","_usableBuildings","_index","_perimeterBuildings","_currentBuilding","_lastBuilding","_bPositions","_groupType","_params","_group","_dog","_leaflets","_drop"];


_tskTitle = "City Supplies";
_tskDesc = "City Supplies Description";
_tskDesc_fail = "You failed delivering a paket, very impressive";
_tskDesc_success = "You crazy little postman";

_targetPosition = getMarkerPos _marker;
_targetName = [_marker] call AS_fnc_localizar;
_range = [_marker] call sizeMarker;

_allBuildings = nearestObjects [_targetPosition, ["Building"], _range];
if (count _allBuildings == 0) then {
	while {(_range < 1000) AND (count _allBuildings == 0)} do {
		_range = _range + 100;
		_allBuildings = nearestObjects [_targetPosition, ["Building"], _range];
	};
};

if (count _allBuildings == 0) exitWith {};

//@Stef using a random buidling or perhaps a special building?
_targetBuilding = selectRandom _allBuildings;

_duration = 30;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;

_task = ["SUP",[side_blue,civilian],[[_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetBuilding,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _task;
publicVariable "misiones";


_crateType = "Land_PaperBox_01_open_boxes_F";
if(_type == "WATER") then 
{
	_crateType = "Land_PaperBox_01_open_water_F";
};
if(_type == "FUEL") then
{
	_crateType = "CargoNet_01_barrels_F";
};

_spawnPosition = (getMarkerPos guer_respawn) findEmptyPosition [5,50, _crateType];
sleep 1;
_crate = _crateType createVehicle _spawnPosition;


_crate allowDamage false;
[_crate] spawn {sleep 1; (_this select 0) allowDamage true;};
//Spawned the crate in

_crate call jn_fnc_logistics_addAction;

_groupType = [infGarrisonSmall, side_green] call AS_fnc_pickGroup;
_params = [_targetPosition, side_green, _groupType];

for "_i" from 0 to 1 do {
	_group = _params call BIS_Fnc_spawnGroup;
	sleep 1;
	_dog = _group createUnit ["Fin_random_F",_targetPosition,[],0,"FORM"];
	[_dog] spawn guardDog;
	[_group, _marker, "SAFE", "RANDOM", "SPAWNED","NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBack _group;
};

{
	_group = _x;
	{
		[_x] spawn genInitBASES;
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups;

// wait until the crate arrives at the target building
waitUntil {sleep 1; !(alive _crate) OR (dateToNumber date > _endTime) OR (_crate distance _targetBuilding < 25)};


// vehicle destroyed or timer ran out
if !(_crate distance _targetBuilding < 30) exitWith {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_fail, _targetName],_tskTitle,_marker],_targetBuilding,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	//@Stef penalities for failing the mission?
    [5,-5,_targetPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;

    [1200,_task] spawn borrarTask;
	waitUntil {sleep 1; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
	if (_crate distance (getMarkerPos guer_respawn) < 60) then 
	{
		[_crate,true] call vaciar;
	};
	[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
};

/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
	_currentDrop: current site
	_canUnload: flag to control unloading action

	sup_unloading_supplies: active process
*/
[false,false,150,0,""] params ["_timerRunning","_canUnload","_deploymentTime","_counter","_currentDrop"];


// crate alive and on place, defend it
while {(alive _crate) AND (dateToNumber date < _endTime)} do {

	// advance site, refresh task
	_task = ["SUP",[side_blue,civilian],[[_tskDesc_drop,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker], position _targetBuilding,"ASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;
	_patGroup = _allGroups select 0;
	if (((leader _patGroup) distance2D (position _currentDrop)) > ((leader (_allGroups select 1)) distance2D (position _currentDrop))) then {
		_patGroup = _allGroups select 1;
	};
	//And i thought this would be random bad luck ...
	if (alive leader _patGroup) then {
		_wp101 = _patGroup addWaypoint [position _currentDrop, 20];
		_wp101 setWaypointType "SAD";
		_wp101 setWaypointBehaviour "AWARE";
		_patGroup setCombatMode "RED";
		_patGroup setCurrentWaypoint _wp101;
		};
		
	
	while {(alive _crate) AND (dateToNumber date < _endTime) AND (_targetBuilding distance _crate < 25)} do {

		// stop supplying when enemies get too close (100m)
		while {(_counter < _deploymentTime) AND (alive _crate) AND !({[_x] call AS_fnc_isUnconscious} count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits)) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _crate < 100)} count allUnits == 0) AND (dateToNumber date < _endTime)} do {

			// start a progress bar
			if !(_timerRunning) then {
				{
					if (isPlayer _x) then 
					{
						[(_deploymentTime - _counter),false] remoteExec ["pBarMP",_x];
						}
				}forEach ([80,0,_crate,"BLUFORSpawn"] call distanceUnits);
				_timerRunning = true;
				[petros,"globalChat","Guard the crate!"] remoteExec ["commsMP"];
			};
			_counter = _counter + 1;
  			sleep 1;
		};

		// if unloading wasn't finished, reset
		if (_counter < _deploymentTime) then {
			_counter = 0;
			_timerRunning = false;
			{
				if (isPlayer _x) then 
				{
					[0,true] remoteExec ["pBarMP",_x]
				}
			} forEach ([100,0,_crate,"BLUFORSpawn"] call distanceUnits);

			if ((!([80,1,_crate,"BLUFORSpawn"] call distanceUnits) OR ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _crate < 100)} count allUnits != 0)) AND (alive _crate)) then {
				{
					if (isPlayer _x) then 
					{
						[petros,"hint","Stay near the crate, keep the perimeter clear of hostiles."] remoteExec ["commsMP",_x]
					}
				} forEach ([150,0,_crate,"BLUFORSpawn"] call distanceUnits);
			};

			waitUntil {sleep 1; (!alive _crate) OR (([80,1,_crate,"BLUFORSpawn"] call distanceUnits) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _crate < 100)} count allUnits == 0)) OR (dateToNumber date > _endTime)};
		};

		// if unloading was finished, reset all respective flags, escape to the outer loop
		if (!(_counter < _deploymentTime)) exitWith {
			//You won this mission
		};
		sleep 1;
	};
	sleep 1;
};

// fail if the truck is destroyed or the timer runs out
if (!(alive _crate) OR (dateToNumber date > _endTime)) then {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_fail, _targetName],_tskTitle,_marker],_targetBuilding,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[0,-2,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_success,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetBuilding,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[_type, 1, _marker] remoteExec ["AS_fnc_changeCitySupply", 2];
	//[-15,5,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _targetBuilding < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

[1200,_task] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits)) or (_crate distance (getMarkerPos guer_respawn) < 60)};
if (_crate distance (getMarkerPos guer_respawn) < 60) then 
	{
		[_crate,true] call vaciar;
	};
sleep 1;
deleteVehicle _crate;

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;