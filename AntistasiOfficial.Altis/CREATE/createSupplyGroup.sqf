if (!isServer and hasInterface) exitWith {};

params ["_marker"];

private ["_groupType","_group", "_allGroups"];

diag_log format ["Supply crate at %1 spawning in troups", _marker];


_allGroups = [];
_allSoldiers = [];
_allVehicles = [];

_spawnPosition = getmarkerpos _marker;
_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_spawnPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;

_allGroups pushBack _group;

{
	_group = _x;
	{
		[_x] spawn genInit;
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups;

//waitUntil {sleep 1; spawner getVariable _marker > 1}; //Activate when merged with new spawn system
waitUntil {sleep 1; !(spawner getVariable _marker)};

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
