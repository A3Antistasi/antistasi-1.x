//This script is triggered only when a player capture the flag. Passive winning conditions are somewhere else.
private ["_bandera","_pos","_marcador","_posicion","_size","_powerpl","_arevelar"];

_bandera = _this select 0;
_jugador = objNull;
if (count _this > 1) then {_jugador = _this select 1};

if ((player != _jugador) and (!isServer)) exitWith {};

_pos = getPos _bandera;
_marcador = [markers,_pos] call BIS_fnc_nearestPosition;
if (_marcador in mrkFIA) exitWith {};
_posicion = getMarkerPos _marcador;
_size = [_marcador] call sizeMarker;

if ((!isNull _jugador) and (captive _jugador)) exitWith {hint localize "STR_HINTS_MRKW_YCCTFWIUM"};

//Reveal enemy units to player within a range
	if (!isNull _jugador) then {
		if (_size > 300) then {_size = 300};
		_arevelar = [];
		{ if (((side _x == side_green) or (side _x == side_red)) and (alive _x) and (not(fleeing _x)) and (_x distance _posicion < _size)) then {_arevelar pushBack _x};} forEach allUnits;
		if (player == _jugador) then {
			_jugador playMove "MountSide";
			sleep 8;
			_jugador playMove "";
			{player reveal _x} forEach _arevelar;
		};
	};

if (!isServer) exitWith {};

{ //add score and give info to player
	if (isPlayer _x) then {
		[5,_x] remoteExec ["playerScoreAdd",_x];
		[[_marcador], "intelFound.sqf"] remoteExec ["execVM",_x];
		if (captive _x) then {[_x,false] remoteExec ["setCaptive",_x]};
	}
} forEach ([_size,0,_posicion,"BLUFORSpawn"] call distanceUnits);

//if (!isNull _jugador) then {[5,_jugador] call playerScoreAdd};
[[_bandera,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
_bandera setFlagTexture guer_flag_texture;

sleep 5;
[[_bandera,"unit"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
[[_bandera,"vehicle"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
_bandera addAction [localize "str_act_mapInfo",
		{
			nul = [] execVM "cityinfo.sqf";
		},
		nil,
		0,
		false,
		true,
		"",
		"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
	];
// [[_bandera,"garage"],"AS_fnc_addActionMP"] call BIS_fnc_MP; Stef 27/10 disabled old garage

_antenna = [antenas,_posicion] call BIS_fnc_nearestPosition;
if (getPos _antenna distance _posicion < 100) then {
	[_bandera,"jam"] remoteExec ["AS_fnc_addActionMP"];
};

mrkAAF = mrkAAF - [_marcador];
mrkFIA = mrkFIA + [_marcador];
publicVariable "mrkAAF";
publicVariable "mrkFIA";

reducedGarrisons = reducedGarrisons - [_marcador];
publicVariable "reducedGarrisons";

[_marcador] call AS_fnc_markerUpdate;

[_marcador] remoteExec ["patrolCA", call AS_fnc_getNextWorker];

//Depending on marker type
	if (_marcador in aeropuertos) then {
		[0,10,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		{["TaskSucceeded", ["", localize "STR_NTS_AIRPORT_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		[5,8] remoteExec ["prestige",2];
		planesAAFmax = planesAAFmax - 1;
	    helisAAFmax = helisAAFmax - 2;
	   	if (activeBE) then {["con_bas"] remoteExec ["fnc_BE_XP", 2]};
	    };
	if (_marcador in bases) then {
		[0,10,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		{["TaskSucceeded", ["", localize "STR_NTS_BASE_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		[5,8] remoteExec ["prestige",2];
		APCAAFmax = APCAAFmax - 2;
		tanksAAFmax = tanksAAFmax - 1;
		_minasAAF = allmines - (detectedMines side_blue);
		if (count _minasAAF > 0) then {
			{if (_x distance _pos < 1000) then {side_blue revealMine _x}} forEach _minasAAF;
		};
		if (activeBE) then {["con_bas"] remoteExec ["fnc_BE_XP", 2]};
	};

	if (_marcador in power) then {
		{["TaskSucceeded", ["", localize "STR_NTS_POWER_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		[0,0] remoteExec ["prestige",2];
		if (activeBE) then {["con_ter"] remoteExec ["fnc_BE_XP", 2]};
		[_marcador] call AS_fnc_powerReorg;
	};
	if (_marcador in puestos) then{
		{["TaskSucceeded", ["", localize "STR_NTS_OP_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		if (activeBE) then {["con_ter"] remoteExec ["fnc_BE_XP", 2]};
	};
	if (_marcador in puertos) then {
		{["TaskSucceeded", ["", localize "STR_NTS_SEA_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		[0,0] remoteExec ["prestige",2];
		if (activeBE) then {["con_ter"] remoteExec ["fnc_BE_XP", 2]};
		[[_bandera,"seaport"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
	};
	if ((_marcador in fabricas) or (_marcador in recursos)) then {
		if (_marcador in fabricas) then {{["TaskSucceeded", ["", localize "STR_NTS_FACT_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];};
		if (_marcador in recursos) then {{["TaskSucceeded", ["", localize "STR_NTS_RES_TKN"]] call BIS_fnc_showNotification} remoteExec ["call", 0];};
		if (activeBE) then {["con_ter"] remoteExec ["fnc_BE_XP", 2]};
		[0,0] remoteExec ["prestige",2];
		_powerpl = [power, _posicion] call BIS_fnc_nearestPosition;
		if (_powerpl in mrkAAF) then {
			sleep 5;
			{["TaskFailed", ["", localize "STR_NTS_RES_OUT_POWER"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
			[_marcador, false] call AS_fnc_adjustLamps;
		} else {
			[_marcador, true] call AS_fnc_adjustLamps;
		};
	};

//Old roadblock removal, no longer working and autogarrison is disabled to save units.
{[_marcador,_x] spawn AS_fnc_deleteRoadblock} forEach controles;
//sleep 15;
[_marcador] remoteExec ["autoGarrison", call AS_fnc_getNextWorker];

waitUntil {sleep 1;
	(not (spawner getVariable _marcador)) or
	(
	({(not(vehicle _x isKindOf "Air")) and (alive _x) and (lifeState _x != "INCAPACITATED") and (!fleeing _x)}
	count ([_size,0,_posicion,"OPFORSpawn"] call distanceUnits)) > 3* ({(alive _x) and (lifeState _x != "INCAPACITATED")}
	count ([_size,0,_posicion,"BLUFORSpawn"] call distanceUnits))
	)
}; //need to add check for unconscious

if (spawner getVariable _marcador) then {
	[_marcador] spawn mrkLOOSE;
};