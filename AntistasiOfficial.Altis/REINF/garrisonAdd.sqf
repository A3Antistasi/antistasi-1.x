private ["_hr","_resourcesFIA","_tipo","_coste","_marcador","_garrison","_posicion","_unit","_grupo","_veh","_pos","_salir"];

_hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "You lack of HR to make a new recruitment"};

_resourcesFIA = server getVariable "resourcesFIA";

_tipo = _this select 0;

_coste = server getVariable _tipo;
_salir = false;

if (_tipo == guer_sol_UN) then
	{
	_coste = _coste + ([guer_stat_mortar] call vehiclePrice);
	};

if (_coste > _resourcesFIA) exitWith {hint format ["You do not have enough money for this kind of unit (%1 € needed)",_coste]};

_marcador = [markers,posicionGarr] call BIS_fnc_nearestPosition;
_posicion = getMarkerPos _marcador;
_chequeo = false;
{
	if (((side _x == side_red) or (side _x == side_green)) and (_x distance _posicion < safeDistance_garrison) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot Recruit Garrison Units with enemies near the zone"};
if (closeMarkersUpdating > 0) exitWith {hint format ["We are currently adding garrison units to this zone. HQ nearby zones require more time to add garrisons.\n\nPlease try again in %1 seconds.",closeMarkersUpdating]};
[-1,-_coste] remoteExec ["resourcesFIA",2];
_garrison = garrison getVariable [_marcador,[]];
_garrison = _garrison + [_tipo];
garrison setVariable [_marcador,_garrison,true];
[_marcador] call AS_fnc_markerUpdate;
hint format ["Soldier recruited.%1",[_marcador] call AS_fnc_getGarrisonInfo];

if (spawner getVariable _marcador) then
	{
	closeMarkersUpdating = 10;
	_forzado = false;
	if (_marcador in forcedSpawn) then {forcedSpawn = forcedSpawn - [_marcador]; publicVariable "forcedSpawn"; _forzado = true};
	[_marcador] remoteExec ["tempMoveMrk",2];
	[_marcador,_forzado] spawn
		{
		private ["_marcador","_forzado"];
		_marcador = _this select 0;
		_forzado = _this select 1;
		while {closeMarkersUpdating > 1} do
			{
			sleep 1;
			closeMarkersUpdating = closeMarkersUpdating - 1;
			};
		waitUntil {getMarkerPos _marcador distance [0,0,0] > 10};
		closeMarkersUpdating = 0;
		};
	if (_forzado) then {forcedSpawn pushBackUnique _marcador; publicVariable "forcedSpawn"};
	};