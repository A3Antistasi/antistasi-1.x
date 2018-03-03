//This script is executed only after a "Create" is completed and spawner check return true
//The effect is enemy capture the territory.
if (!isServer) exitWith {};

private ["_marcador","_posicion","_mrk","_powerpl","_bandera"];

_marcador = _this select 0;
if (_marcador in mrkAAF) exitWith {};
_posicion = getMarkerPos _marcador;

mrkAAF = mrkAAF + [_marcador];
mrkFIA = mrkFIA - [_marcador];
publicVariable "mrkAAF";
publicVariable "mrkFIA";

// BE module
	if (activeBE) then {
		["territory", -1] remoteExec ["fnc_BE_update", 2];
	};

//remove FIA garrison variable
	garrison setVariable [_marcador,[],true];

_bandera = objNull;
_dist = 10;
while {isNull _bandera} do {
	_dist = _dist + 10;
	_banderas = nearestObjects [_posicion, ["FlagCarrier"], _dist];
	_bandera = _banderas select 0;
};

[[_bandera,"take"],"AS_fnc_addActionMP"] call BIS_fnc_MP;

_mrk = format ["Dum%1",_marcador];
_mrk setMarkerColor IND_marker_colour;

//Effects depending on marker type
	if ((not (_marcador in bases)) and (not (_marcador in aeropuertos))) then {
		[10,-10,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		if (_marcador in puestos) then {
			_mrk setMarkerText localize "STR_GL_AAFOP";
			{["TaskFailed", ["", localize "STR_NTS_OPLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		};
		if (_marcador in puertos) then {
			_mrk setMarkerText localize "STR_GL_MAP_SP";
			{["TaskFailed", ["", localize "STR_NTS_SPLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		};
	};
	if (_marcador in power) then {
		[0,0] remoteExec ["prestige",2];
		_mrk setMarkerText localize "STR_GL_MAP_PP";
		{["TaskFailed", ["", localize "STR_NTS_POWLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		[_marcador] spawn AS_fnc_powerReorg;
	};

	if ((_marcador in recursos) or (_marcador in fabricas)) then {
		[0,-8,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		[0,0] remoteExec ["prestige",2];
		if (_marcador in recursos) then {
			_mrk setMarkerText localize "STR_GL_MAP_RS";
			{["TaskFailed", ["", localize "STR_NTS_RESLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		} else {
			_mrk setMarkerText localize "STR_GL_MAP_FAC";
			{["TaskFailed", ["", localize "STR_NTS_FACLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		};
	};

	if ((_marcador in bases) or (_marcador in aeropuertos)) then {
		[20,-20,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		_mrk setMarkerType IND_marker_type;
		[0,-8] remoteExec ["prestige",2];
		server setVariable [_marcador,dateToNumber date,true];
		[_marcador,60] spawn AS_fnc_addTimeForIdle;
		if (_marcador in bases) then {
			{["TaskFailed", ["", localize "STR_NTS_BASELOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
			_mrk setMarkerText localize "STR_GL_AAFBS";
			APCAAFmax = APCAAFmax + 2;
	        tanksAAFmax = tanksAAFmax + 1;
		} else {
			{["TaskFailed", ["", localize "STR_NTS_ABLOST"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
			_mrk setMarkerText localize "STR_GL_AAFAB";
			server setVariable [_marcador,dateToNumber date,true];
			planesAAFmax = planesAAFmax + 1;
	        helisAAFmax = helisAAFmax + 2;
	    };
	};

_size = [_marcador] call sizeMarker;

//Remove static guns, enemies have already their own.
	_staticsToSave = staticsToSave;
	{
		if ((position _x) distance _posicion < _size) then {
			_staticsToSave = _staticsToSave - [_x];
			deleteVehicle _x;
		};
	} forEach staticsToSave;

	if (not(_staticsToSave isEqualTo staticsToSave)) then {
		staticsToSave = _staticsToSave;
		publicVariable "staticsToSave";
	};

//Reverting the owership in case of player manage to capture back.
	waitUntil {sleep 1;
		(not (spawner getVariable _marcador)) or
		(({	(not(vehicle _x isKindOf "Air")) and
		 	(alive _x) and
		 	(lifeState _x != "INCAPACITATED")}
		 	count ([_size,0,_posicion,"BLUFORSpawn"] call distanceUnits)) > 3*(
		  {	(alive _x) and
			(lifeState _x != "INCAPACITATED") and
			(!fleeing _x)}
			count ([_size,0,_posicion,"OPFORSpawn"] call distanceUnits))
		)
	};

	if (spawner getVariable _marcador) then{[_bandera] spawn mrkWIN;};