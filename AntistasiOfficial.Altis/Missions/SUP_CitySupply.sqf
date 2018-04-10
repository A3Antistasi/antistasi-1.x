if (!isServer and hasInterface) exitWith {};

params ["_marker", "_type"];
//[3,[],[],[],[],[]] params ["_countBuildings","_targetBuildings","_allGroups","_allSoldiers","_allVehicles","_leafletCrates"];
private ["_targetPosition","_targetName","_duration","_endTime","_task","_spawnPosition","_missionVehicle","_crate","_range","_allBuildings","_usableBuildings","_index","_perimeterBuildings","_currentBuilding","_lastBuilding","_bPositions","_groupType","_params","_group","_dog","_leaflets","_drop"];


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

_task = ["SUP",[side_blue,civilian],[[_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetPosition,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _task;
publicVariable "misiones";

_spawnPosition = (getMarkerPos guer_respawn) findEmptyPosition [5,50,"C_Van_01_transport_F"];
sleep 1;

_missionVehicle = "C_Van_01_transport_F" createVehicle _spawnPosition;
_missionVehicle allowDamage false;
[_missionVehicle] spawn {sleep 1; (_this select 0) allowDamage true;};

_lockedseats = [2,3,4,5,6,7,8,9,10,11];
{_missionVehicle lockcargo [_x, true]} foreach _lockedseats;

//@Stef insert the name of the crates you want to use
if(_type == "FOOD") then 
{
	_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
};
if(_type == "WATER") then 
{
	_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
};
if(_type == "FUEL") then
{
	_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
};
//Needs correct positioning
_crate attachTo [_missionVehicle,[0,-2.5,-0.25]];
_crate setDir (getDir _missionVehicle);

[_missionVehicle] spawn VEHinit;
{_x reveal _missionVehicle} forEach (allPlayers - entities "HeadlessClient_F");
_missionVehicle setVariable ["tmp_targetName",_targetName,true];
_missionVehicle addEventHandler ["GetIn", {
	if (_this select 1 == "driver") then {
		format ["This truck carries supplies for %1.",(_this select 0) getVariable ["tmp_targetName","Llandudno"]] remoteExec ["hint",_this select 2];
	};
}];

_allVehicles pushBack _missionVehicle;

[_missionVehicle,"Supply Vehicle"] spawn inmuneConvoy;


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

// wait until the vehicle enters the target area
waitUntil {sleep 1; !(alive _missionVehicle) OR (dateToNumber date > _endTime) OR (_missionVehicle distance _targetPosition < 500)};


// vehicle destroyed or timer ran out
if !(_missionVehicle distance _targetPosition < 550) exitWith {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_fail, _targetName],_tskTitle,_marker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	//@Stef penalities for failing the mission?
    [5,-5,_targetPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;

    [1200,_task] spawn borrarTask;
	waitUntil {sleep 1; !([distanciaSPWN,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) OR ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) AND (speed _missionVehicle < 1))};
	if ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) AND (speed _missionVehicle < 1)) then {
		[_missionVehicle,true] call vaciar;
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
[false,false,90,0,""] params ["_timerRunning","_canUnload","_deploymentTime","_counter","_currentDrop"];

server setVariable ["sup_unloading_supplies", false, true];

// truck alive, mission running, sites to go
while {(alive _missionVehicle) AND (dateToNumber date < _endTime)} do {

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
		
	
	// truck close enough to unload
	while {(alive _missionVehicle) AND (dateToNumber date < _endTime) AND (_targetBuilding distance _missionVehicle < 20)} do {

		// add unload action if truck is stationary
		if (!(_canUnload) AND (speed _missionVehicle < 1)) then {
			_canUnload = true;
			[_missionVehicle,"unload_supplies"] remoteExec ["AS_fnc_addActionMP"];
		};

		// stop unloading when enemies get too close
		while {(_counter < _deploymentTime) AND (alive _missionVehicle) AND !({[_x] call AS_fnc_isUnconscious} count ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits)) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits == 0) AND (dateToNumber date < _endTime) AND (server getVariable "sup_unloading_supplies")} do {

			// start a progress bar, remove crew from truck, lock the truck
			if !(_timerRunning) then {
				{if (isPlayer _x) then {[(_deploymentTime - _counter),false] remoteExec ["pBarMP",_x]; [_missionVehicle,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);
				_timerRunning = true;
				[petros,"globalChat","Guard the truck!"] remoteExec ["commsMP"];
				{
					_x action ["eject", _missionVehicle];
				} forEach (crew (_missionVehicle));
				[_missionVehicle, true] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
				_missionVehicle lock 2;
				_missionVehicle engineOn false;
				_missionVehicle lockCargo false;
			};

			_counter = _counter + 1;
  			sleep 1;
		};

		// if unloading wasn't finished, reset
		if ((_counter < _deploymentTime) AND (server getVariable "sup_unloading_supplies")) then {
			_counter = 0;
			_timerRunning = false;
			_missionVehicle lock 0;
			[_missionVehicle, false] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);

			if ((!([80,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) OR ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits != 0)) AND (alive _missionVehicle)) then {
				{if (isPlayer _x) then {[petros,"hint","Stay near the truck, keep the perimeter clear of hostiles."] remoteExec ["commsMP",_x]}} forEach ([150,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);
			};

			waitUntil {sleep 1; (!alive _missionVehicle) OR (([80,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits == 0)) OR (dateToNumber date > _endTime)};
		};

		// if unloading was finished, reset all respective flags, escape to the outer loop
		if ((alive _missionVehicle) AND !(_counter < _deploymentTime)) exitWith {
			_info = "";
			server setVariable ["sup_unloading_supplies", false, true];
			_canUnload = false;
			[[_missionVehicle,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			_counter = 0;
			[_missionVehicle, false] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
			_missionVehicle lock 0;
			_timerRunning = false;

		};
		sleep 1;
	};

	// remove unload action if truck isn't close enough to current site
	if (_canUnload) then {
		_canUnload = false;
		[_missionVehicle,"remove"] remoteExec ["AS_fnc_addActionMP"];
	};
	sleep 1;
};

// fail if the truck is destroyed or the timer runs out
if (!(alive _missionVehicle) OR (dateToNumber date > _endTime)) then {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_fail, _targetName],_tskTitle,_marker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[0,-2,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_success,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetPosition,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[-15,5,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _targetPosition < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

[1200,_task] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits)) or ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) && (speed _missionVehicle < 1))};
if ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) && (speed _missionVehicle < 1)) then {
	[_missionVehicle,true] call vaciar;
};
{deleteVehicle _x} forEach _leafletCrates;
sleep 1;
deleteVehicle _missionVehicle;

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;