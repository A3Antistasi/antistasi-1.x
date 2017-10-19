if (!isServer and hasInterface) exitWith {};

if(true)exitWith{};//disabled because its to slow

private ["_marcador","_destino","_origen","_grupos","_soldados","_vehiculos","_size","_grupo","_camion","_tam","_roads","_road","_pos"];

_marcador = _this select 0;
if (not(_marcador in smallCAmrk)) exitWith {};
if (debug) then {Slowhand globalChat format ["AutoGarrison en marcha, destino %1",_marcador]};
_destino = getMarkerPos _marcador;
_origen = getMarkerPos guer_respawn;

if ((worldName == "Tanoa") AND !([_origen, _destino] call AS_fnc_IslandCheck)) exitWith {};

_grupos = [];
_soldados = [];
_vehiculos = [];

_size = [_marcador] call sizeMarker;

_divisor = 50;

if (_marcador in aeropuertos) then {_divisor = 100};
if (_marcador in bases) then {_divisor = 30};

_size = round (_size / _divisor);

if (_size == 0) then {_size = 1};

while {(_size > 0)} do
	{
	if (diag_fps > minimoFPS) then
		{
		_tam = 10;
		while {true} do
			{
			_roads = _origen nearRoads _tam;
			if (count _roads < 1) then {_tam = _tam + 10};
			if (count _roads > 0) exitWith {};
			};
		_road = _roads select 0;
		_tipoVeh = [guer_veh_truck,guer_veh_offroad,guer_veh_quad,guer_veh_technical] call BIS_fnc_selectRandom;
		_pos = position _road findEmptyPosition [1,30,_tipoVeh];
		_vehicle=[_pos, random 360,_tipoVeh, side_blue] call bis_fnc_spawnvehicle;
		_veh = _vehicle select 0;
		_vehCrew = _vehicle select 1;
		{[_x] spawn AS_fnc_initialiseFIAUnit} forEach _vehCrew;
		[_veh] spawn VEHinit;
		[_veh,"Reinf"] spawn inmuneConvoy;
		_grupoVeh = _vehicle select 2;
		_grupoVeh setVariable ["esNATO",true,true];
		_soldados = _soldados + _vehCrew;
		_grupos pushBack _grupoVeh;
		_vehiculos = _vehiculos + [_veh];
		if (_tipoVeh != guer_veh_technical) then
			{
			if (_tipoVeh == guer_veh_quad) then
				{
				_soldado = _grupoVeh createUnit [guer_sol_SN, _pos, [], 0, "NONE"];
				[_soldado] spawn AS_fnc_initialiseFIAUnit;
				_soldados pushBack _soldado;
				_soldado moveInCargo _veh;
				}
			else
				{
				_tipoGrupo = guer_grp_squad;
				if (_tipoVeh == guer_veh_offroad) then {_tipoGrupo = [guer_grp_team,guer_grp_AT] call BIS_fnc_selectRandom};
				_grupo = [_origen, side_blue, ([_tipoGrupo, "guer"] call AS_fnc_pickGroup)] call BIS_Fnc_spawnGroup;
				{[_x] call AS_fnc_initialiseFIAUnit; [_x] join _grupoVeh; _x moveInCargo _veh; _soldados pushBack _x} forEach units _grupo;
				deleteGroup _grupo;
				};
			//[_marcador,_grupoVeh] spawn attackDrill;
			_Vwp0 = _grupoVeh addWaypoint [_destino, 0];
			_Vwp0 setWaypointBehaviour "SAFE";
			_Vwp0 setWaypointType "GETOUT";
			_Vwp1 = _grupoVeh addWaypoint [_destino, 1];
			_Vwp1 setWaypointType "SAD";
			_Vwp1 setWaypointBehaviour "AWARE";
			}
		else
			{
			_Vwp1 = _grupoVeh addWaypoint [_destino, 0];
			_Vwp1 setWaypointType "SAD";
			_Vwp1 setWaypointBehaviour "AWARE";
			};
		};
	sleep 30;
	_size = _size - 1;
	hint "Supreme Commander Petros sent in the cavalry.";
	};

{
	_x setVariable ["generated",true,true];
} forEach _soldados;

waitUntil {sleep 1;((not(_marcador in smallCAmrk)) or (_marcador in mrkAAF))};

{_vehiculo = _x;
waitUntil {sleep 1; {_x distance _vehiculo < distanciaSPWN} count (allPlayers - hcArray) == 0};
deleteVehicle _vehiculo;
} forEach _vehiculos;
{_soldado = _x;
waitUntil {sleep 1; {_x distance _soldado < distanciaSPWN} count (allPlayers - hcArray) == 0};
deleteVehicle _soldado;
} forEach _soldados;
{deleteGroup _x} forEach _grupos;