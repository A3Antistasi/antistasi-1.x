params ["_group"];
private ["_defSize", "_newSize"];

_defSize = count (units _group);
_newSize = ceil (_defSize / 2);

if (_newSize < 3) exitWith {diag_log format ["Adjust group size - group too small - group: %1; def: %2; new: %3", _group, _defSize, _newSize]};

for "_i" from 1 to (_defSize - _newSize) do {
	deleteVehicle selectRandom ((units _group) - [leader _group]);
};

_group