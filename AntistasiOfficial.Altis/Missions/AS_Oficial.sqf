if (!isServer and hasInterface) exitWith {};

_tskTitle = localize "Str_tsk_ASOfficer";
_tskDesc = localize "Str_tskDesc_ASOfficer";

_marcador = _this select 0;
_source = _this select 1;

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val + 1, true];
};

_posicion = getMarkerPos _marcador;

_tiempolim = 30;//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call AS_fnc_localizar;
_tsk = ["AS",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_grp = createGroup side_red;

_oficial = ([_posicion, 0, opI_OFF, _grp] call bis_fnc_spawnvehicle) select 0;
_piloto = ([_posicion, 0, opI_PIL, _grp] call bis_fnc_spawnvehicle) select 0;

_grp selectLeader _oficial;
sleep 1;
[leader _grp, _marcador, "SAFE", "SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";

{[_x] spawn CSATinit; _x allowFleeing 0} forEach units _grp;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _oficial)};

if (not alive _oficial) then {
	_tsk = ["AS",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"SUCCEEDED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[0,300] remoteExec ["resourcesFIA",2];
	[1800] remoteExec ["AS_fnc_increaseAttackTimer",2];
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"BLUFORSpawn"] call distanceUnits);
	[5,Slowhand] call playerScoreAdd;
	[_marcador,30] spawn AS_fnc_addTimeForIdle;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
} else {
	_tsk = ["AS",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	[-10,Slowhand] call playerScoreAdd;
	[_marcador,-30] spawn AS_fnc_addTimeForIdle;
};

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};

{deleteVehicle _x} forEach units _grp;
deleteGroup _grp;

[1200,_tsk] spawn borrarTask;