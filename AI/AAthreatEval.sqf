private ["_marcador","_threat","_esMarcador","_posicion","_esFIA","_analizado","_size"];

_threat = 0;

{if (_x in unlockedWeapons) then {_threat = 5};} forEach genAALaunchers;


_marcador = _this select 0;
_esMarcador = true;
if (_marcador isEqualType []) then {_esMarcador = false; _posicion = _marcador} else {_posicion = getMarkerPos _marcador};

_esFIA = false;
if (_esMarcador) then
	{
	if (_marcador in mrkAAF) then
		{
		{
		if (getMarkerPos _x distance _posicion < (distanciaSPWN*1.5)) then
			{
			if ((_x in bases) or (_x in aeropuertos)) then {_threat = _threat + 3} else {_threat = _threat + 1};
			};
		} forEach (controles + puestos + colinas + bases + aeropuertos - mrkFIA);
		}
	else
		{
		_esFIA = true;
		};
	}
else
	{
	_esFIA = true;
	};

if (_esFIA) then {
	{
	if (getMarkerPos _x distance _posicion < distanciaSPWN) then {
		_analizado = _x;
		_garrison = garrison getVariable [_analizado,[]];
		_threat = _threat + (floor((count _garrison)/4));
		_size = [_analizado] call sizeMarker;
		_estaticas = staticsToSave select {_x distance (getMarkerPos _analizado) < _size};
		if (count _estaticas > 0) then {
			_threat = _threat + ({typeOf _x in statics_allMGs} count _estaticas) + (5*({typeOf _x in statics_allAAs} count _estaticas));
		};
	};
	} forEach (mrkFIA - ciudades - controles - colinas - puestosFIA);
};

_threat