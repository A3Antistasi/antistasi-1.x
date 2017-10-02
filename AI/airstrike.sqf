// usage: Activate via radio trigger, on act: [] execVM "airstrike.sqf";
if (!isServer) exitWith{};

private ["_marcador","_posicion","_ang","_angorig","_pos1","_origpos","_pos2","_finpos","_plane","_wp1","_wp2","_wp3","_tipoavion","_lado"];

_marcador = _this select 0;
_tipoavion = _this select 1;
_posicion = getMarkerPos _marcador;

if (_tipoavion in opCASFW) then {_lado = side_red};
if (_tipoAvion in bluCASFW) then {_lado = side_blue};

_ang = random 360;
_angorig = _ang + 180;

_pos1 = [_posicion, 400, _angorig] call BIS_Fnc_relPos;
_origpos = [_posicion, 4500, _angorig] call BIS_fnc_relPos;
_pos2 = [_posicion, 200, _ang] call BIS_Fnc_relPos;
_finpos = [_posicion, 4500, _ang] call BIS_fnc_relPos;

_planefn = [_origpos, _ang, _tipoavion, _lado] call bis_fnc_spawnvehicle;
_plane = _planefn select 0;
_plane setVariable ["OPFORSpawn",false]; //Vehicle not defined? Sparker.
_planeCrew = _planefn select 1;
_grupoplane = _planefn select 2;
_plane setPosATL [getPosATL _plane select 0, getPosATL _plane select 1, 1000];
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane flyInHeight 100;


_wp1 = _grupoplane addWaypoint [_pos1, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "LIMITED";
_wp1 setWaypointBehaviour "CARELESS";
if (_tipoavion in opCASFW) then
	{
	if ((_marcador in bases) or (_marcador in aeropuertos)) then
		{
		_wp1 setWaypointStatements ["true", "[this] execVM 'AI\airbomb.sqf'"];
		}
	else
		{
		if (_marcador in ciudades) then
			{
			_wp1 setWaypointStatements ["true", "[this,""NAPALM""] execVM 'AI\airbomb.sqf'"];
			}
		else
			{
			_wp1 setWaypointStatements ["true", "[this,""CLUSTER""] execVM 'AI\airbomb.sqf'"];
			};
		};
	}
else
	{
	_wp1 setWaypointStatements ["true", "[this] execVM 'AI\airbomb.sqf'"];
	};

_wp2 = _grupoplane addWaypoint [_pos2, 1];
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointType "MOVE";

_wp3 = _grupoplane addWaypoint [_finpos, 2];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "FULL";
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];

waitUntil {sleep 2; (currentWaypoint _grupoplane == 4) or (!canMove _plane)};

{deleteVehicle _x} forEach _planeCrew;
deleteVehicle _plane;
deleteGroup _grupoplane;




