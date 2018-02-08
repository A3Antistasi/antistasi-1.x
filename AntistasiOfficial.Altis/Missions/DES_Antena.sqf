if (!isServer and hasInterface) exitWith{};

_tskTitle = "STR_TSK_TD_DesAntenna";
_tskDesc = "STR_TSK_TD_DESC_DesAntenna";

private ["_antena","_posicion","_tiempolim","_marcador","_nombredest","_mrkfin","_tsk"];

_antena = _this select 0;
_posicion = getPos _antena;

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_marcador = [markers,_posicion] call BIS_fnc_nearestPosition;
_nombredest = [_marcador] call AS_fnc_localizar;

_mrkfin = createMarker [format ["DES%1", random 100], _posicion];
_mrkfin setMarkerShape "ICON";

_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_INDEP],_tskTitle,_mrkfin],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _antena) or (not(_marcador in mrkAAF))};

if (dateToNumber date > _fechalimnum) then
	{
	_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_INDEP],_tskTitle,_mrkfin],_posicion,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[-10,Slowhand] call playerScoreAdd;
	};
if ((not alive _antena) or (not(_marcador in mrkAAF))) then
	{
	sleep 15;
	_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_INDEP],_tskTitle,_mrkfin],_posicion,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[0,0] remoteExec ["prestige",2];
	[600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
	};

deleteMarker _mrkfin;

[1200,_tsk] spawn borrarTask;