/*
    Description:
        - Sends selected units scavenging.
        - They will loot corpses/surrender-boxes within a set distance and deposit all gear within the specified vehicle/container.

    Parameters:
        0: Container to use for storage (default: vehicle of first selected unit)

    Returns:
        Nothing

    Example:
        [vehicle player] call AS_fnc_startScavenging
*/

params [["_specificContainer", objNull]];
private ["_units", "_break", "_unit", "_vehicle", "_container", "_looting", "_driver", "_commander", "_gunner"];

_units = groupSelectedUnits player;

if !(count _units > 0) exitWith {hintSilent "Please select the units who should start scavenging."};

_break = false;
{
	if (_x getVariable ["AS_lootingCorpses", false]) exitWith {
		_break = true;
		_x groupChat "I am already looking for gear.";
	};
};

if (_break) exitWith {hintSilent "Some of your selected units are occupied."};

_rtv = {
	params ["_crew", "_vehicle", "_role"];
	_crew doMove (getPosATL _vehicle);
	[_crew] allowGetIn true;
	[_crew] orderGetIn true;
	waitUntil {sleep 0.5; (_crew distance2D _vehicle) < 6};

	switch (_role) do {
		case "driver": {
			_crew assignAsDriver _vehicle;
			diag_log format ["Driver: %1; vehicle: %2", _crew, _vehicle];
			_crew action ["getInDriver", _vehicle];
		};
		case "commander": {
			_crew assignAsCommander _vehicle;
			diag_log format ["Commander: %1", _crew];
			_crew action ["getInCommander", _vehicle];
		};
		case "gunner": {
			_crew assignAsGunner _vehicle;
			diag_log format ["Gunner: %1", _crew];
			_crew action ["getInGunner", _vehicle];
		};

		default {
		};
	};
};

_container = objNull;
_vehicle = objNull;
_driver = "";
_gunner = "";
_unit = _units select 0;
if !(vehicle _unit == _unit) then {
	_vehicle = vehicle _unit;
	if ((_vehicle isKindOf "Car") || (_vehicle isKindOf "Tank")) then {
		_driver = ["", driver _vehicle] select !(isNull (driver _vehicle));
		_container = _vehicle;
		_commander = ["", commander _vehicle] select !(isNull (commander _vehicle));
		_gunner = ["", gunner _vehicle] select !(isNull (gunner _vehicle));
	};
};

if !(isNull (_specificContainer)) then {
	if (_specificContainer isKindOf "LandVehicle") then {
		_container = _specificContainer;
	};
};

if (isNull (_container)) exitWith {hintSilent "Please specify a container."};
if (([_container] call AS_fnc_getSpareCapacity) < 100) exitWith {_unit groupChat "If we add more load to it, it'll break..."};

{
	if !(vehicle _x == _x) then {
		_x setVariable ["vehicle", vehicle _x, true];
		doGetOut _x;
		sleep 1;
	};
	[_x, _container] spawn AS_fnc_lootCorpses;
	sleep 1;
} forEach _units;

sleep 5;

_looting = true;
while {_looting} do {
	_looting = false;
	{
		if (_x getVariable ["AS_lootingCorpses", false]) exitWith {_looting = true};
	} forEach _units;
	sleep 3;
};

{
	_x doFollow player;
	if !(isNull (_x getVariable ["vehicle", objNull])) then {
		_x doMove (getPosATL (_x getVariable "vehicle"));
	};
} forEach _units;

if !(isNull _vehicle) then {
	if (alive _vehicle) then {
		if !(typeName _driver == "STRING") then {
			if ((isNull (driver _vehicle)) && (alive _driver)) then {
				[_driver, _vehicle, "driver"] spawn _rtv;
			};
		};
		if !(typeName _commander == "STRING") then {
			if ((isNull (commander _vehicle)) && (alive _commander)) then {
				[_commander, _vehicle, "commander"] spawn _rtv;
			};
		};
		if !(typeName _gunner == "STRING") then {
			if ((isNull (gunner _vehicle)) && (alive _gunner)) then {
				[_gunner, _vehicle, "gunner"] spawn _rtv;
			};
		};
	};
} else {
	{
		if !(isNull (_x getVariable ["vehicle", objNull])) then {
			if ((alive (_x getVariable "vehicle")) && (alive _x) && (vehicle _x == _x)) then {
				_vehicle = _x getVariable "vehicle";
				_x action ["getInCargo", _vehicle];
			};
		};
	} forEach _units;
};

[_units, true] call AS_fnc_resetAIStatus;

_unit groupChat "We are done here. Ready to move out.";