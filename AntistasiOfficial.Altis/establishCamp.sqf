if (!isServer) exitWith {};

private ["_tipo","_coste","_grupo","_unit","_tam","_roads","_road","_pos","_camion","_texto","_mrk","_hr","_unidades","_formato"];

_tipo = _this select 0;
_posicionTel = _this select 1;

if (_tipo == "delete") exitWith {
	_mrk = [campsFIA,_posicionTel] call BIS_fnc_nearestPosition;
	_pos = getMarkerPos _mrk;
	_txt = markerText _mrk;
	hint format ["Deleting %1", _txt];
	_coste = 0;
	_hr = 0;
	_formato = ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _hr = _hr +1} forEach _tipogrupo;
	[_hr,_coste] remoteExec ["resourcesFIA",2];
	deleteMarker _mrk;
	campsFIA = campsFIA - [_mrk]; publicVariable "campsFIA";
	campList = campList - [[_mrk, _txt]]; publicVariable "campList";
	usedCN = usedCN - [_txt]; publicVariable "usedCN";
	diag_log format ["deleting: %1", [_txt]];
	markers = markers - [_mrk]; publicVariable "markers";
};

_nameOptions = campNames - usedCN;
_texto = selectRandom _nameOptions;
_tipoVeh = guer_veh_truck;

_mrk = createMarker [format ["FIACamp%1", random 1000], _posicionTel];
_mrk setMarkerShape "ICON";

_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + 60];
_fechalimnum = dateToNumber _fechalim;

_tsk = ["campsFIA",[side_blue,civilian],["We are sending a team to establish a camp. Send and cover the team until reaches it's destination.","Camp Setup",_mrk],_posicionTel,"CREATED",5,true,true,"Move"] call BIS_fnc_setTask;
misiones pushBackUnique _tsk; publicVariable "misiones";

_tam = 10;
while {true} do {
	_roads = getMarkerPos guer_respawn nearRoads _tam;
	if (count _roads < 1) then {_tam = _tam + 10};
	if (count _roads > 0) exitWith {};
};
_road = _roads select 0;
_pos = position _road findEmptyPosition [1,30,guer_veh_truck];

_vehicle=[_pos, 0,guer_veh_truck, side_blue] call bis_fnc_spawnvehicle;
_camion = _vehicle select 0;
_grupo = _vehicle select 2;

_grupoTemp = [getMarkerPos guer_respawn, side_blue, ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup)] call BIS_Fnc_spawnGroup;
_grupoTemp setGroupId ["Watch"];
{
	_x moveInCargo _camion;
	[_x] joinSilent _grupo;
} forEach units _grupoTemp;
{[_x] call AS_fnc_initialiseFIAUnit;} forEach units _grupo;

[_grupo] spawn dismountFIA;

leader _grupo setBehaviour "SAFE";
Slowhand hcSetGroup [_grupo];
_grupo setVariable ["isHCgroup", true, true];

driver _camion action ["engineOn", vehicle driver _camion];
_grupo selectLeader (driver _camion);

_crate = "Box_FIA_Support_F" createVehicle _pos;
_crate attachTo [_camion,[0.0,-1.2,0.5]];

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
	campsFIA = campsFIA + [_mrk]; publicVariable "campsFIA";
	campList = campList + [[_mrk, _texto]]; publicVariable "campList";
	markers = markers + [_mrk];
	publicVariable "markers";
	spawner setVariable [_mrk,false,true];
	_tsk = ["campsFIA",[side_blue,civilian],["We are sending a team to establish a camp. Send and cover the team until reaches it's destination.","Camp Setup",_mrk],_posicionTel,"SUCCEEDED",5,true,true,"Move"] call BIS_fnc_setTask;
	_mrk setMarkerType "loc_bunker";
	_mrk setMarkerColor "ColorOrange";
	_mrk setMarkerText _texto;
	usedCN pushBack _texto;
}
else {
	_tsk = ["campsFIA",[side_blue,civilian],["We are sending a team to establish a camp. Send and cover the team until reaches it's destination.","Camp Setup",_mrk],_posicionTel,"FAILED",5,true,true,"Move"] call BIS_fnc_setTask;
	sleep 3;
	deleteMarker _mrk;
};

Slowhand hcRemoveGroup _grupo;
{deleteVehicle _x} forEach units _grupo;
deleteVehicle _camion;
deleteGroup _grupo;
_crate enableSimulationGlobal false;
_crate hideObjectGlobal true;
sleep 15;

[0,_tsk] spawn borrarTask;