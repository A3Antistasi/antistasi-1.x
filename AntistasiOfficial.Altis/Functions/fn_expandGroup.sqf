params ["_group", "_position", ["_soldiers", []]];
private ["_unit"];

if (count _soldiers == 0) then {
	_unit = _group createUnit [sol_MK, _position, [],0, "NONE"];
	_unit = _group createUnit [sol_MED, _position, [],0, "NONE"];
	_unit = _group createUnit [sol_ENG, _position, [],0, "NONE"];
	_unit = _group createUnit [sol_LAT2, _position, [],0, "NONE"];
} else {
	{
		_unit = _group createUnit [_x, _position, [],0, "NONE"];
	} forEach _soldiers;
};

_group
