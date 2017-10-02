params ["_vehicle", "_group", "_unitArray", "_position"];
private ["_emptySeats", "_unit", "_unitType"];

_emptySeats = _vehicle emptyPositions "cargo";

for "_i" from 1 to _emptySeats do {
	_unitType = (infList_sniper + infList_special + infList_auto + infList_regular + infList_regular) call BIS_fnc_selectRandom;
	_unit = ([_position, 0, _unitType, _group] call bis_fnc_spawnvehicle) select 0;
	_unit assignAsCargo _vehicle;
	_unit moveInCargo _vehicle;
	_unitArray pushBack _unit;
};
_group selectLeader (units _group select 1);

[_vehicle, _group, _unitArray]