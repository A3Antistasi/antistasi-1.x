params ["_marker", "_threshold"];

_city = [[ciudades, _marker] call BIS_fnc_nearestPosition, _marker] select (typeName _marker == typeName "");
_data = server getVariable _city;
if !(_data isEqualType []) exitWith {diag_log format ["Error in getHighSupplies. Passed %1 as reference.", _location]};

_result = [];
_supplyLevels = _data select 4;
_tiers = ["CRITICAL", "LOW", "GOOD"];

_indexThreshold = _tiers find _threshold;
diag_log format ["_indexThreshold = %1",_indexThreshold];
if(_indexThreshold == -1) exitWith {diag_log format ["Error in getHighSupplies. Could not find threshold %1.", _threshold]};

for "_i" from 0 to 2 do
{
	_level = _supplyLevels select _i;
	_indexLevel = _tiers find _level;
	if(_indexLevel >= _indexThreshold) then {_result pushBackUnique (["FOOD", "WATER", "FUEL"] select _i)};
};

diag_log format ["_result = %1",_result];
_result
