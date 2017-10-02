if (!isServer and hasInterface) exitWith {};

private ["_roads"];

_posicionTel = _this select 0;

_prestigio = server getVariable "prestigeNATO";
_base = bases - mrkAAF + ["spawnNATO"];

_origen = [_base,Slowhand] call BIS_fnc_nearestPosition;
_orig = getMarkerPos _origen;

[-10,0] remoteExec ["prestige",2];


_tiempolim = 30 max _prestigio;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombreorig = [_origen] call AS_fnc_localizar;


_texto = "NATO Roadblock";
_tipoGrupo = [bluATTeam, side_blue] call AS_fnc_pickGroup;
_tipoVeh = bluAPC select 0;


_mrk = createMarker [format ["NATOPost%1", random 1000], _posicionTel];
_mrk setMarkerShape "ICON";


_tsk = ["NATORoadblock",[side_blue,civilian],[format ["%1 is dispatching a team to establish a Roadblock. Send and cover the team until reaches its destination.", A3_Str_BLUE],format ["%1 Roadblock Deployment", A3_Str_BLUE],_mrk],_posicionTel,"CREATED",5,true,true,"Move"] call BIS_fnc_setTask;
misiones pushBackUnique _tsk; publicVariable "misiones";
_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
_grupo setGroupId ["Watch"];

_tam = 10;
while {true} do
	{
	_roads = _orig nearRoads _tam;
	if (count _roads < 1) then {_tam = _tam + 10};
	if (count _roads > 0) exitWith {};
	};
_road = _roads select 0;
_pos = position _road findEmptyPosition [1,30,"B_APC_Wheeled_01_cannon_F"];
_camion = _tipoVeh createVehicle _pos;
_grupo addVehicle _camion;

{
	_x assignAsCargo _camion;
	_x moveInCargo _camion;
} forEach units _grupo;

{[_x] call NATOinitCA} forEach units _grupo;
leader _grupo setBehaviour "SAFE";

Slowhand hcSetGroup [_grupo];
_grupo setVariable ["isHCgroup", true, true];

waitUntil {sleep 1; ({alive _x} count units _grupo == 0) or ({(alive _x) and (_x distance _posicionTel < 10)} count units _grupo > 0) or (dateToNumber date > _fechalimnum)};

if ({(alive _x) and (_x distance _posicionTel < 10)} count units _grupo > 0) then {
	if (isPlayer leader _grupo) then {
		_owner = (leader _grupo) getVariable ["owner",leader _grupo];
		(leader _grupo) remoteExec ["removeAllActions",leader _grupo];
		_owner remoteExec ["selectPlayer",leader _grupo];
		(leader _grupo) setVariable ["owner",_owner,true];
		{[_x] joinsilent group _owner} forEach units group _owner;
		[group _owner, _owner] remoteExec ["selectLeader", _owner];
		"" remoteExec ["hint",_owner];
		waitUntil {!(isPlayer leader _grupo)};
	};

	Slowhand hcRemoveGroup _grupo;
	{deleteVehicle _x} forEach units _grupo;
	deleteVehicle _camion;
	deleteGroup _grupo;
	sleep 1;

	puestosNATO = puestosNATO + [_mrk]; publicVariable "puestosNATO";
	markers = markers + [_mrk]; publicVariable "markers";
	spawner setVariable [_mrk,false,true];
	_tsk = ["NATORoadblock",[side_blue,civilian],[format ["%3 successfully deployed a roadblock, They will hold their position until %1:%2.",numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_BLUE],format ["%1 Roadblock Deployment", A3_Str_BLUE],_mrk],_posicionTel,"SUCCEEDED",5,true,true,"Move"] call BIS_fnc_setTask;

	_mrk setMarkerType "flag_Spain";
	//_mrk setMarkerColor "ColorBlue";
	_mrk setMarkerText _texto;


	waitUntil {sleep 60; (dateToNumber date > _fechalimnum)};

	puestosNATO = puestosNATO - [_mrk]; publicVariable "puestosNATO";
	markers = markers - [_mrk]; publicVariable "markers";
	deleteMarker _mrk;
	sleep 15;
	[0,_tsk] spawn borrarTask;
}
else {
	_tsk = ["NATORoadblock",[side_blue,civilian],[format ["%1 is dispatching a team to establish an Observation Post or Roadblock. Send and cover the team until reaches it's destination.", A3_Str_BLUE],format ["%1 Roadblock Deployment", A3_Str_BLUE],_mrk],_posicionTel,"FAILED",5,true,true,"Move"] call BIS_fnc_setTask;
	sleep 3;
	deleteMarker _mrk;

	Slowhand hcRemoveGroup _grupo;
	{deleteVehicle _x} forEach units _grupo;
	deleteVehicle _camion;
	deleteGroup _grupo;

	sleep 15;

	[0,_tsk] spawn borrarTask;
};
