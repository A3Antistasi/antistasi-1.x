
_resourcesFIA = server getVariable "resourcesFIA";

if (_resourcesFIA < 5000) exitWith {hint localize "STR_HINTS_RA_YDNHEMTRAA"};

_destroyedCities = destroyedCities - ciudades;

openMap true;
posicionTel = [];
hint localize "STR_HINTS_RA_COTZYWTR";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;

_sitio = [markers,_posicionTel] call BIS_fnc_nearestPosition;

if (getMarkerPos _sitio distance _posicionTel > 50) exitWith {hint localize "STR_HINTS_RA_YMCNAMM"};

if (not(_sitio in _destroyedCities)) exitWith {hint localize "STR_HINTS_RA_YCRT"};

_nombre = [_sitio] call AS_fnc_localizar;

hint format [localize "STR_HINTS_RA_1REBUILT"];

[0,10,_posicionTel] remoteExec ["AS_fnc_changeCitySupport",2];
[5,0] remoteExec ["prestige",2];
destroyedCities = destroyedCities - [_sitio];
publicVariable "destroyedCities";
if (_sitio in power) then {[_sitio] call AS_fnc_powerReorg};
[0,-5000] remoteExec ["resourcesFIA",2];