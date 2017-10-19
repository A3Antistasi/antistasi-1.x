/*
 	Description:
		- Spawns crates in pre-defined houses
		- Marks houses with pre-placed graffiti

	Parameters:
		0: Marker of the city
		1: Number of crates to spawn

 	Returns:
		Nothing

 	Example:
		["Panochori", 3] spawn AS_fnc_createLootCrates
*/

params ["_marker", ["_number", 0]];
private ["_allLocations", "_tempLoc", "_house", "_cratePosition", "_crate"];

if (_number == 0) exitWith {};

_allLocations = [];
for "_i" from 1 to 10 do {
	if !(typeName (missionNamespace getVariable [format ["%1_%2", _marker, _i], ""]) == "STRING") then {
		_allLocations pushBackUnique (missionNamespace getVariable (format ["%1_%2", _marker, _i]));
	};
};

if (count _allLocations == 0) exitWith {diag_log "CLC: no locations"};

_locations = [];
if (count _allLocations > _number) then {
	for "_i" from 0 to (_number - 1) do {
		_tempLoc = selectRandom _allLocations;
		_locations pushBackUnique _tempLoc;
		_allLocations set [(_allLocations find _tempLoc), -1];
		_allLocations = _allLocations - [-1];
	};
} else {
	_locations = _allLocations;
};

diag_log _locations;

{
	_x hideObjectGlobal false;
	_house = (nearestObjects [position _x, ["house"], 10]) select 0;
	_house allowDamage false;
	_cratePosition = selectRandom ([_house] call BIS_fnc_buildingPositions);
	_crate = (selectRandom AS_lootCrateTypes) createVehicle _cratePosition;
	_crate setDir (random 360);
	[_crate] call emptyCrate;
	diag_log format ["house: %1; crate: %3; cratePos: %2", position _house, _cratePosition, _crate];
} forEach _locations;