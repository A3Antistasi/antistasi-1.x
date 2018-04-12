if (!isServer and hasInterface) exitWith {};

params ["_marker", "_type"];
diag_log format ["SUP_CitySupply _marker = %1, _type = %2 called off",_marker,_type];
//[3,[],[],[],[],[]] params ["_countBuildings","_targetBuildings","_allGroups","_allSoldiers","_allVehicles","_leafletCrates"];
private ["_targetPosition","_targetName","_duration","_endTime","_task", "_posSupply", "_FIAMarkers", "_nFIAMarker","_spawnPosition","_crate", "_house", "_range","_allBuildings","_groupType","_params","_group","_dog","_leaflets","_drop"];


_tskTitle = "City Supplies";
_tskDesc = "Get it from the AAF and deliver it to %1 before %2:%3";
_tskDesc_drop = "Now bring this supplies to %1 before %2:%3";
_tskDesc_fail = "You failed delivering a paket to %1, very impressive";
_tskDesc_success = "You crazy little postman";

_targetPosition = getMarkerPos _marker;
_targetName = [_marker] call AS_fnc_localizar;
_range = [_marker] call sizeMarker;
_posHQ = getMarkerPos guer_respawn;

/*
_allBuildings = nearestObjects [_targetPosition, ["Building"], _range];
if (count _allBuildings == 0) exitWith {};
_targetBuilding = selectRandom _allBuildings; <= if house as dropoff point wanted use this
*/

_targetBuilding = _targetPosition;

_duration = 30;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;
/*
_FIAMarkers = mrkFIA + campsFIA;

while {true} do {
	sleep 0.1;
	_posSupply = [_targetPosition,2000,random 360] call BIS_fnc_relPos;
	_nFIAMarker = [_FIAMarkers,_posSupply] call BIS_fnc_nearestPosition;
	if ((!surfaceIsWater _posSupply) && (_posSupply distance _posHQ < 4000) && (getMarkerPos _nFIAMarker distance _posSupply > 500)) exitWith {};
};
*/
_houseType = "Land_i_Shed_Ind_F";
_crateType = "Land_PaperBox_01_open_boxes_F";
if(_type == "WATER") then
{
	_crateType = "Land_PaperBox_01_open_water_F";
};
if(_type == "FUEL") then
{
	_crateType = "CargoNet_01_barrels_F";
};
_allSheds = nearestObjects [_targetPosition, [_houseType], 2000, true];
if (count _allSheds == 0) exitWith
{
	diag_log format ["Supply mission not created, could not find %1 around %2", _houseType, _targetPosition];
};

_spawnPosition = _allSheds selectRandom;
_spawnPosition = _spawnPosition findEmptyPosition [5,50, _crateType];
sleep 1;
_crate = _crateType createVehicle _spawnPosition;
_crate allowDamage false;
[_crate] spawn {sleep 1; (_this select 0) allowDamage true;};
_crate call jn_fnc_logistics_addAction;
//Spawned the crate in

/*
_marker = createMarker [format ["REC%1", random 100], _posSupply];
_marker setMarkerShape "ICON";

_task = ["SUP",[side_blue,civilian],[[_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_posSupply,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;

*/

_allGroups = [];
_allSoldiers = [];

_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_posSupply, side_green, _groupType] call BIS_Fnc_spawnGroup;
_allGroups pushBack _group;

{
	_group = _x;
	{
		[_x] spawn genInit; //Or genInitBASES ?? Where is the difference between them?
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups; //Should be only one by now so ok

diag_log "SUP_CitySupply successful created";

// wait until the player loads the crate
waitUntil {sleep 1; (dateToNumber date > _endTime) OR !(isNull attachedTo _crate)};


//if timer ran out
if (dateToNumber date > _endTime) exitWith
{
	diag_log "SUP_CitySupply ended without the player even touching the crate";
};

if("SUP" in misiones) then
{
	{
		if (isPlayer _x) then{
			["You already have a mission of that kind, complete this first"] remoteExec ["hint",_this select 2];
		}
	} forEach ([100,0,_crate,"BLUFORSpawn"] call distanceUnits);
	waitUntil{sleep 1;!("SUP" in misiones) OR (dateToNumber date > _endTime)};
}

_targetMarker = createMarker [format ["REC%1", random 100], _targetBuilding];
_targetMarker setMarkerShape "ICON";

_task = ["SUP",[side_blue,civilian], [[_tskDesc_drop, _targetName, numberToDate [2035,_endTime] select 3, numberToDate [2035,_endTime] select 4],_tskTitle,_targetMarker],_targetBuilding,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _task;
publicVariable "misiones";
/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
	_currentDrop: current site
	_canUnload: flag to control unloading action

	sup_unloading_supplies: active process
*/
[false,false,150,0,""] params ["_timerRunning","_canUnload","_deploymentTime","_counter","_currentDrop"];


// crate alive and loaded
while {(alive _crate) AND (dateToNumber date < _endTime)} do {

	waitUntil {sleep 1; (dateToNumber date > _endTime) OR (isNull attachedTo _crate) AND (_crate distance _targetBuilding > 25)};

	//Reveal all players in the surrounding of the crate to the enemies
	{
		_player = _x;
		{
			if ((side _x == side_green) and (_x distance _crate < distanciaSPWN)) then{
				if (_x distance _crate < 300) then
				{
					_x doMove position _crate
				} 	
				else
				{
					_x reveal [_player,4]
				};
			};
		} forEach allUnits;
	} forEach ([300,0,_crate,"BLUFORSpawn"] call distanceUnits)

	
	while {(alive _crate) AND (dateToNumber date < _endTime) AND (_targetBuilding distance _crate < 25) AND (isNull attachedTo _crate)} do {

		// stop supplying when enemies get too close (100m)
		while {(_counter < _deploymentTime) AND (isNull attachedTo _crate) AND (alive _crate) AND !({[_x] call AS_fnc_isUnconscious} count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits)) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _crate < 100)} count allUnits == 0) AND (dateToNumber date < _endTime)} do {

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

		// if unloading wasnt finished, reset
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
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_fail, _targetName],_tskTitle,_targetMarker],_targetBuilding,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[0,-2,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_task = ["SUP",[side_blue,civilian], [[_tskDesc_success,_targetName],_tskTitle,_targetMarker],_targetBuilding,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[_type, 1, _marker] remoteExec ["AS_fnc_changeCitySupply", 2];
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
	waitUntil {sleep 1; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
	if (_crate distance (getMarkerPos guer_respawn) < 60) then
	{
		[_crate,true] call vaciar;
	};
	{deleteVehicle _x} forEach _allSoldiers;
	{deleteGroup _x} forEach _allGroups;
	deleteVehicle _house;