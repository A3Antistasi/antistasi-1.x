if (!isServer and hasInterface) exitWith {};

params ["_spawnPosition", "_crateType"];
private ["_marker", "_crateType","_cratedisplay", "_abort", "_allSheds", "_posHQ", "_houseType"]; //Stef, should i add other variables here?

//TODO Get away from hard coding the number of maximum crates!
if(countSupplyCrates > 6) exitWith {diag_log format ["Could not create supply crate, max (%1) are already active", 6] ;};

countSupplyCrates ++;
publicVariable "countSupplyCrates";
systemchat format ["countSupplyCrates = %1",countSupplyCrates];

diag_log format ["ANTISTASI - Supplycrate, _type = %1, now creating",_crateType];

//Create abort condition if init is wrong
_abort = false;

//HQ position for supply deadzone around HQ
_posHQ = getMarkerPos guer_respawn;

//Deciding which type of crate is used
_houseType = "Land_i_Shed_Ind_F"; //<-- perhaps define this somewhere else
switch (_crateType) do {
	case "WATER": 	{_crateTypeBox = "Land_PaperBox_01_open_boxes_F";		};
	case "FUEL": 	{_crateTypeBox = "CargoNet_01_barrels_F";				};
	case "FOOD": 	{_crateTypeBox = "Land_PaperBox_01_open_boxes_F";		};
	default
	{
		diag_log format ["BAD REFERENCE AT SUPPLYBOX, passed %1, expected WATER, FUEL or FOOD", _crateType];
		_abort = true;
	};
};
if(_abort) exitWith
{
	countSupplyCrates --;
	publicVariable "countSupplyCrates";
};

//Checking if given position is [], if yes search for new position
if(count _spawnPosition == 0)
{
	//Searching for all available warehouses in AO
	_allSheds = nearestObjects [_posHQ, [_houseType], 4000, true];
	sleep 1;
	if (count _allSheds == 0) exitWith
	{
		//No suitable warehouses found, exiting
		diag_log format ["Supply crate not created, could not find %1", _houseType];
		_abort = true;
	};

	//Select random to start with
	_selectedShed = selectRandom _allSheds;
	_spawnPosition = position _selectedShed;

//Search for a suitable postition
	while {
		(count (
			nearestObjects [_spawnPosition, ["Land_PaperBox_01_open_boxes_F", "Land_PaperBox_01_open_water_F", "CargoNet_01_barrels_F"], 300, true]
		) != 0) OR (_spawnPosition distance2D _posHQ < 1000) OR (count ([200, 0, _spawnPosition, "BLUFORSpawn"] call distanceUnits) != 0)
	} do
	{
		_allSheds = _allSheds - [_selectedShed];
		if((count _allSheds)  == 0) exitWith {_abort = true};
		_spawnPosition = position _selectedShed;
	};
};

//Abort if no position found
if(_abort) exitWith
{
	diag_log "ANTISTASI - DynamicSupplies: No suitable position found around HQ for a supply crate";
	countSupplyCrates --;
	publicVariable "countSupplyCrates";
};

//Creating the crate with the needed data
_crate = _crateTypeBox createVehicle _spawnPosition;
_crate allowDamage false;
[_crate] spawn {sleep 1; (_this select 0) allowDamage true;};
_crate call jn_fnc_logistics_addAction;
_cratedisplay = "";
switch (_crateTypeBox) do {
	case "Land_PaperBox_01_open_water_F": 	{_cratedisplay = "Water Supplies"	};
	case "CargoNet_01_barrels_F": 			{_cratedisplay = "Fuel Supplies"	};
	case "Land_PaperBox_01_open_boxes_F": 	{_cratedisplay = "Food Supplies"	};
};

_marker = createMarker [format ["SUP%1", random 100], _spawnPosition];
_marker setMarkerText _cratedisplay;
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_warning";
//Hide the marker until found by units
_marker setMarkerAlpha 0;

//Add to needed global variables
markerSupplyCrates pushBackUnique _marker;
publicVariable "markerSupplyCrates";
supplySaveArray pushBackUnique [_spawnPosition, _crateType];
publicVariable "supplySaveArray";

//Add spawning mechanics to the position
//spawner setVariable [_marker, 0, true]; //Activate when merged with new spawn system
spawner setVariable [_marker, false, true];



/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
*/

waitUntil{sleep 1; ([300,1 ,_crate,"BLUFORSpawn"] call distanceUnits) OR ({_x distance2D _crate < 1000} count puestosFIA != 0)};
//Reveal marker
_marker setMarkerAlpha 1;
if([300,1,_crate, "BLUFORSpawn"] call distanceUnits) then
{
	//Crate detected by player
	{
			["You detected an AAF supply crate near you!"] remoteExec ["hint",_x];
	} forEach ([300,0,_crate,"BLUFORSpawn"] call distanceUnits);
}
else
{
	//Crate detected by watchpost
	[[petros,"globalChat","Our watchposts have detected an AAF supply crate. Check your maps!"],"commsMP"] call BIS_fnc_MP;
};

[false,150,0] params ["_timerRunning","_deploymentTime","_counter"];
//TODO rework marker
while {alive _crate AND (_marker in markerSupplyCrates)} do {

	// wait until the player loads the crate or have the loaded crate in a city
	waitUntil {sleep 5; !(isNull attachedTo _crate) OR !({(_crate distance (getmarkerpos _x) < 200)} count ciudades == 0) OR !(_marker in markerSupplyCrates)};
	//wait until the player has the crate unloaded in a city
	waitUntil {sleep 1; (isNull attachedTo _crate) AND !({(_crate distance (getmarkerpos _x) < 200) AND (isOnRoad (position _crate))} count ciudades == 0) OR !(_marker in markerSupplyCrates)};
	if(!(_marker in markerSupplyCrates)) exitWith {}; //Crate not longer active!
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

if ((alive _crate) AND (_marker in markerSupplyCrates)) then {
	[_crateType, 1, _currentCity] remoteExec ["AS_fnc_changeCitySupply", 2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _crate < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};
//Delete position from arrays
markerSupplyCrates = markerSupplyCrates - [_marker];
publicVariable "markerSupplyCrates";
supplySaveArray = supplySaveArray - [[_spawnPosition, _crateType]];
publicVariable "supplySaveArray";


waitUntil {sleep 5; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
deleteVehicle _crate;
