if (!isServer and hasInterface) exitWith {};

params ["_type"];
diag_log format ["SUP_CitySupply, _type = %1, now creating",_type];
private ["_duration","_endTime", "_spawnPosition","_crate", "_house","_groupType","_group"];


_posHQ = getMarkerPos guer_respawn;

_duration = 30;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;


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
_allSheds = nearestObjects [_posHQ, [_houseType], 4000, true];
sleep 1;

if (count _allSheds == 0) exitWith
{
	diag_log format ["Supply mission not created, could not find %1", _houseType];
};


_spawnPosition = position (selectRandom _allSheds);
_spawnPosition = _spawnPosition findEmptyPosition [5,50, _crateType];
sleep 1;
_crate = _crateType createVehicle _spawnPosition;
_crate allowDamage false;
[_crate] spawn {sleep 1; (_this select 0) allowDamage true;};
_crate call jn_fnc_logistics_addAction;
//Spawned the crate in


_allGroups = [];
_allSoldiers = [];

_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_spawnPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
_allGroups pushBack _group;

{
	_group = _x;
	{
		[_x] spawn genInit; //Or genInitBASES ?? Where is the difference between them?
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups; //Should be only one by now so ok

diag_log "SUP_CitySupply successful created";




/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
*/
[false,150,0] params ["_timerRunning","_deploymentTime","_counter"];


// crate alive and loaded
while {(alive _crate) AND (dateToNumber date < _endTime)} do {

	// wait until the player loads the crate or have the loaded crate in a city
	waitUntil {sleep 1; (dateToNumber date > _endTime) OR !(isNull attachedTo _crate) OR !({_crate distance (getmarkerpos _x) < 400} count ciudades == 0)};
	//wait until the player has the crate unloaded in a city
	waitUntil {sleep 1; (dateToNumber date > _endTime) OR (isNull attachedTo _crate) AND !({_crate distance (getmarkerpos _x) < 400} count ciudades == 0)};
	_currentCity = [ciudades, getPos _crate] call BIS_fnc_nearestPosition;
	//Reveal all players in the surrounding of the crate to the enemies
	{
		_player = _x;
		{
			if ((side _x == side_green) and (_x distance _crate < distanciaSPWN)) then{
				if (_x distance _crate < 600) then
				{
					_x doMove position _crate
				}
				else
				{
					_x reveal [_player,4]
				};
			};
		} forEach allUnits;
	} forEach ([300,0,_crate,"BLUFORSpawn"] call distanceUnits);

	{

	//Send nearby civis to the crate
    if ((side _x == civilian) and (_x distance _crate < 700)) then {_x doMove position _crate};
	} forEach allUnits;


	while {(alive _crate) AND (dateToNumber date < _endTime) AND (isNull attachedTo _crate)} do {

		// stop supplying when enemies get too close (100m)
		while {(_counter < _deploymentTime) AND (alive _crate) AND (isNull attachedTo _crate) AND !({[_x] call AS_fnc_isUnconscious} count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits)) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _crate < 100)} count allUnits == 0) AND (dateToNumber date < _endTime)} do {

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

if ((alive _crate) AND (dateToNumber date < _endTime)) then {
	[_type, 1, _currentCity] remoteExec ["AS_fnc_changeCitySupply", 2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _currentCity < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

waitUntil {sleep 1; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
if (_crate distance (getMarkerPos guer_respawn) < 60) then
{
	[_crate,true] call vaciar;
};
{deleteVehicle _x} forEach _allSoldiers;
{deleteGroup _x} forEach _allGroups;
