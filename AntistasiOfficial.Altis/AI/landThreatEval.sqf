private ["_marcador","_threat","_posicion","_analizado","_size"];

_threat = 0;

{if (_x in unlockedWeapons) then {_threat = 3};} forEach genATLaunchers;

if (activeAFRF) then {{if (_x in unlockedWeapons) then {_threat = 2};} forEach genATLaunchers;};

_marcador = _this select 0;

if (_marcador isEqualType []) then {_posicion = _marcador} else {_posicion = getMarkerPos _marcador};
_threat = _threat + 2 * ({(isOnRoad getMarkerPos _x) and (getMarkerPos _x distance _posicion < distanciaSPWN)} count puestosFIA);

{
if (getMarkerPos _x distance _posicion < distanciaSPWN) then {
	_analizado = _x;
	_garrison = garrison getVariable [_analizado,[]];
	_threat = _threat + (2*({(_x == guer_sol_LAT)} count _garrison)) + (floor((count _garrison)/8));
	_size = [_analizado] call sizeMarker;
	_estaticas = staticsToSave select {_x distance (getMarkerPos _analizado) < _size};
	if (count _estaticas > 0) then {
		_threat = _threat + ({typeOf _x in statics_allMortars} count _estaticas) + (2*({typeOf _x in statics_allATs} count _estaticas));
	};
};
} forEach (mrkFIA - ciudades - controles - colinas - puestosFIA);

_threat