params ["_spawnPosition", "_crateType", "_marker"];
private ["_crateType","_cratedisplay"]; //Stef, should i add other variables here?

_crate = _crateType createVehicle _spawnPosition;
_crate allowDamage false;
[_crate] spawn {sleep 1; (_this select 0) allowDamage true;};
_crate call jn_fnc_logistics_addAction;
switch (_crateType) do {
	case "Land_PaperBox_01_open_water_F": 	{_cratedisplay = "Water Supplies"	};
	case "CargoNet_01_barrels_F": 			{_cratedisplay = "Fuel Supplies"	};
	case "Land_PaperBox_01_open_boxes_F": 	{_cratedisplay = "Food Supplies"	};
};
[_crate,_cratedisplay] spawn inmuneConvoy;


/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
*/

[false,150,0] params ["_timerRunning","_deploymentTime","_counter"];

while {alive _crate AND (_marker in mrkSupplyCrates)} do {

	// wait until the player loads the crate or have the loaded crate in a city
	waitUntil {sleep 5; !(isNull attachedTo _crate) OR !({_crate distance (getmarkerpos _x) < 400} count ciudades == 0) OR !(_marker in mrkSupplyCrates)};
	//wait until the player has the crate unloaded in a city
	waitUntil {sleep 1; (isNull attachedTo _crate) AND !({_crate distance (getmarkerpos _x) < 400} count ciudades == 0) OR !(_marker in mrkSupplyCrates)};
	if(!(_marker in mrkSupplyCrates)) exitWith {}; //Crate not longer active!
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


	while {(alive _crate) AND (isNull attachedTo _crate)} do {

		// stop supplying when enemies get too close (100m)
		while {(_counter < _deploymentTime) AND (alive _crate) AND (isNull attachedTo _crate) AND !({[_x] call AS_fnc_isUnconscious} count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_crate,"BLUFORSpawn"] call distanceUnits)) AND !([100, 1,_crate, "OPFORspawn"] call distanceUnits)} do {

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

			if ((!([80,1,_crate,"BLUFORSpawn"] call distanceUnits) OR ([100, 1, _crate, "OPFORspawn"] call distanceUnits)) AND (alive _crate)) then {
				{
					if (isPlayer _x) then
					{
						[petros,"hint","Stay near the crate, keep the perimeter clear of hostiles."] remoteExec ["commsMP",_x]
					}
				} forEach ([150,0,_crate,"BLUFORSpawn"] call distanceUnits);
			};

			waitUntil {sleep 1; (!alive _crate) OR (([80,1,_crate,"BLUFORSpawn"] call distanceUnits) AND !([100, 1, _crate, "OPFORspawn"] call distanceUnits))};
		};

		// if unloading was finished,  escape to the outer loop
		if (!(_counter < _deploymentTime)) exitWith {
			//You won this mission
		};
		sleep 1;
	};
	sleep 1;
};

if ((alive _crate) AND (_marker in mrkSupplyCrates)) then {
	[_type, 1, _currentCity] remoteExec ["AS_fnc_changeCitySupply", 2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _crate < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

waitUntil {sleep 1; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
deleteVehicle _crate;