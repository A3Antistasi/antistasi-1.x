params ["_location"];
private ["_position","_city","_text"];

_position = getMarkerPos _location;
_text = "";

call {
	if (_location in colinas) exitWith {_text = format ["Observation Post at Mount %1", [_location, false] call AS_fnc_location]};
	if (_location in ciudades) exitWith {_text = format ["%1", [_location, false] call AS_fnc_location]};

	_city = [ciudades, _position] call BIS_fnc_nearestPosition;
	_city = [_city, false] call AS_fnc_location;

	if (_location in controles) exitWith {_text = format ["Roadblock near %1",_city]};
	if (_location in puestos) exitWith {_text = format ["Outpost near %1",_city]};
	if (_location in power) exitWith {_text = format ["Powerplant near %1",_city]};
	if (_location in bases) exitWith {_text = format ["%1 Base",_city]};
	if (_location in recursos) exitWith {_text = format ["Resource near %1",_city]};
	if (_location in aeropuertos) exitWith {_text = format ["%1 Airport",_city]};
	if (_location in fabricas) exitWith {_text = format ["Factory near %1",_city]};
	if (_location in puertos) exitWith {_text = format ["Seaport near %1",_city]};
};

_text