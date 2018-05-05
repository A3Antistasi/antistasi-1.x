if (!isServer and hasInterface) exitWith {};

params ["_spawnPosition", "_crateType"];
private ["_marker", "_crateType","_crateTypeBox","_cratedisplay", "_abort", "_allSheds","_selectedShed", "_posHQ", "_houseType", "_currentCity", "_fnDeleteMissionIn"];

_fnDeleteMissionIn = {
    params ["_marker", "_spawnPosition", "_crateType", "_crate", "_timer"];
    if (_timer > 0) then {sleep _timer;};

    // this all we need to revert mission creation
    deleteMarker _marker;
    //Disable respawn mechanics
    spawner setVariable [_marker, nil, true];
    countSupplyCrates = countSupplyCrates - 1;
    publicVariable "countSupplyCrates";
    supplySaveArray = supplySaveArray - [[_spawnPosition, _crateType]];
    publicVariable "supplySaveArray";
    markerSupplyCrates = markerSupplyCrates - [_marker];
    publicVariable "markerSupplyCrates";
    waitUntil {sleep 5; !([distanciaSPWN,1,_crate,"BLUFORSpawn"] call distanceUnits) OR (_crate distance (getMarkerPos guer_respawn) < 60)};
    if (alive _crate OR (_marker in markerSupplyCrates)) exitWith{};
};

//TODO Get away from hard coding the number of maximum crates!
//zalexki: yes use the Factory Design Pattern and this will be a parameter of createSupplyBoxMissionFactory
if (countSupplyCrates > 6) exitWith {
    diag_log format ["Could not create supply crate, max (%1) are already active", 6];
};

countSupplyCrates = countSupplyCrates + 1;
diag_log format ["ANTISTASI - Supplycrate, _type = %1, now creating", _crateType];

//Create abort condition if init is wrong
_abort = false;

//HQ position for supply deadzone around HQ
_posHQ = getMarkerPos guer_respawn;

//Deciding which type of crate is used
//wurzel: perhaps define this somewhere else
//zalexki: yes same as countSupplyCrates
_houseType = "Land_i_Shed_Ind_F";
switch (_crateType) do {
	case "WATER": {_crateTypeBox = "Land_PaperBox_01_open_boxes_F";};
	case "FUEL": {_crateTypeBox = "CargoNet_01_barrels_F";};
	case "FOOD": {_crateTypeBox = "Land_PaperBox_01_open_boxes_F";};
	default {
		diag_log format ["BAD REFERENCE AT SUPPLYBOX, passed %1, expected WATER, FUEL or FOOD", _crateType];
		_abort = true;
	};
};

if (_abort) exitWith {
    countSupplyCrates = countSupplyCrates - 1;
	publicVariable "countSupplyCrates";
};

//Checking if given position is [], if yes search for new position
if (count _spawnPosition == 0) then {
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
	diag_log format ["Createsupplybox _allSheds = %1,",_allSheds];
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
if (_abort) exitWith
{
    // this need to be translatable with stringtable
    diag_log format ["ANTISTASI - Mission DynamicSupplies: No suitable position found around HQ for a supply crate"];
	systemChat format ["ANTISTASI - Mission DynamicSupplies: No suitable position found around HQ for a supply crate"];
    countSupplyCrates = countSupplyCrates - 1;
	publicVariable "countSupplyCrates";
};

//Creating the crate with the needed data
diag_log format ["Createsupplybox _crateTypeBox = %1,  _spawnposition = %2",_crateTypeBox,_spawnPosition];
_crate = _crateTypeBox createVehicle _spawnPosition;
_crate allowDamage false;
if(activeACE && {["ace_cargo"] call ace_common_fnc_isModLoaded}) then { // check if ace cargo module is active
    [_crate, -1] call ace_cargo_fnc_setSize; // disable loading as cargo with ace
};
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
//Activate when merged with new spawn system (tight to supply system or air control PRs)
spawner setVariable [_marker, 0, true];
//spawner setVariable [_marker, false, true];

// delete mission in 30min=1800s
[_marker, _spawnPosition, _crateType, _crate, 1800] spawn _fnDeleteMissionIn;


/*
	_timerRunning: timer running
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
*/

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

[false, false, 150, 0] params ["_isCrateUnloaded", "_timerRunning", "_deploymentTime", "_counter"];

while {alive _crate OR (_marker in markerSupplyCrates)} do {
    sleep 1;

	// wait until the player loads the crate
	waitUntil {
        sleep 1;
		!(isNull attachedTo _crate)
	};

	// wait until the player have the unloaded crate in a city
	waitUntil {
        sleep 1;
		(isNull attachedTo _crate) AND
		!({(_crate distance (getmarkerpos _x) < 200) AND
		(isOnRoad (position _crate))} count ciudades == 0) OR
		!(_marker in markerSupplyCrates)
	};

    _crate call jn_fnc_logistics_removeAction;
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

	[position _crate] spawn AS_fnc_SpawnCiviGetSupplies;

	//Send nearby civis to the crate
	{ if ((side _x == civilian) and (_x distance _crate < 700)) then { _x doMove position _crate }; } forEach allUnits;

	while {(alive _crate) AND (isNull attachedTo _crate)} do {
        sleep 1;
		// stop supplying when enemies get too close (100m)
		while {
            sleep 1;
			(_counter < _deploymentTime) AND
			(alive _crate) AND
			(isNull attachedTo _crate) AND
			!({[_x] call AS_fnc_isUnconscious} count
                ([80,0,_crate,"BLUFORSpawn"] call distanceUnits) == count
                ([80,0,_crate,"BLUFORSpawn"] call distanceUnits)) AND
			!([100, 1,_crate, "OPFORspawn"] call distanceUnits)
        }
        do
		{
			// start progress bar
			if !(_timerRunning) then {
				{
					if (isPlayer _x) then
					{
						[(_deploymentTime - _counter),false] remoteExec ["pBarMP",_x];
						}
				} forEach ([80,0,_crate,"BLUFORSpawn"] call distanceUnits);
				_timerRunning = true;
				[petros,"globalChat","Guard the crate!"] remoteExec ["commsMP"];
			};
			_counter = _counter + 1;

		};

		// if unloading wasnt finished, reset
		if (_counter < _deploymentTime) then {
			_counter = 0;
			_timerRunning = false;
			{
				if (isPlayer _x) then {
					[0,true] remoteExec ["pBarMP",_x]
				}
			} forEach ([100,0,_crate,"BLUFORSpawn"] call distanceUnits);

			if ((!([80,1,_crate,"BLUFORSpawn"] call distanceUnits) OR ([100, 1, _crate, "OPFORspawn"] call distanceUnits)) AND (alive _crate)) then {
				{
					if (isPlayer _x) then {
						[petros,"hint","Stay near the crate, keep the perimeter clear of hostiles."] remoteExec ["commsMP",_x]
					}
				} forEach ([150,0,_crate,"BLUFORSpawn"] call distanceUnits);
			};

			waitUntil {sleep 1; (!alive _crate) OR (([80,1,_crate,"BLUFORSpawn"] call distanceUnits) AND !([100, 1, _crate, "OPFORspawn"] call distanceUnits))};
		};

		// if unloading was finished
		if (!(_counter < _deploymentTime)) exitWith {
			// delete the map marker
			deleteMarker _marker;
			_currentCity = [ciudades, getPos _crate] call BIS_fnc_nearestPosition;
			_isCrateUnloaded = true;
		};
	};
	if (_isCrateUnloaded) exitWith {};
};

if ((alive _crate) AND (_marker in markerSupplyCrates) AND _isCrateUnloaded) then {
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _crate < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - entities "HeadlessClient_F");
	[5,Slowhand] call playerScoreAdd;
    [_crateType, 1, _currentCity] remoteExec ["AS_fnc_changeCitySupply", 2];
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
    systemChat format ["%1 received %2", _currentCity, _crateType];
};

[_marker, _spawnPosition, _crateType, _crate, 0] call _fnDeleteMissionIn;
