params ["_groupType", "_position", "_side"];
private ["_group", "_ranks"];

_groupType = [_groupType, _side] call AS_fnc_pickGroup;
if (typeName _groupType isEqualTo "ARRAY") then {
	_ranks = [count _groupType] call AS_fnc_getRanks;
	_group = [_position, _side, _groupType, [], _ranks] call BIS_Fnc_spawnGroup;
} else {
	_group = [_position, _side, _groupType] call BIS_Fnc_spawnGroup;
};
_group