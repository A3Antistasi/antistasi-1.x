params ["_position"];

{
	if (_x distance _position < 30) then {
		_x setFuel 0.8;
	};
} forEach vehicles;