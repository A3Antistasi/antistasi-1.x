if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_DesVehicle";
_tskDesc = "STR_TSK_TD_DESC_DesVehicle";

private ["_marcador","_posicion","_fechalim","_fechalimnum","_nombredest","_tipoVeh","_texto","_camionCreado","_size","_pos","_veh","_grupo","_unit"];

_marcador = _this select 0;
_source = _this select 1;

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val + 1, true];
};

_posicion = getMarkerPos _marcador;

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call AS_fnc_localizar;

_tipoVeh = "";
_texto = "";

//experimental
if (count (enemyMotorpool - vehTank) < count enemyMotorpool) then {_tipoVeh = selectRandom vehTank; _texto = "Enemy Tank"} else {_tipoVeh = selectRandom vehIFV; _texto = "Enemy IFV"};

// if ("I_MBT_03_cannon_F" in enemyMotorpool) then {_tipoVeh = "I_MBT_03_cannon_F"; _texto = "AAF Tank"} else {_tipoVeh = opSPAA; _texto = "CSAT Artillery"};

_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],_tskTitle,_marcador],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_camionCreado = false;

waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (spawner getVariable _marcador)};

if (spawner getVariable _marcador) then
	{
	_camionCreado = true;
	_size = [_marcador] call sizeMarker;
	_pos = [];
	if (_size > 40) then {_pos = [_posicion, 10, _size, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos} else {_pos = _posicion findEmptyPosition [10,60,_tipoVeh]};
	_veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
	_veh allowdamage false;
	_veh setDir random 360;
	//if (_tipoVeh == "I_MBT_03_cannon_F") then {[_veh] spawn genVEHinit} else {[_veh] spawn CSATVEHinit};
	[_veh] spawn genVEHinit;

	_grupo = createGroup side_green;

	sleep 5;
	_veh allowDamage true;

	for "_i" from 1 to 3 do
		{
		_unit = ([_pos, 0, sol_CREW, _grupo] call bis_fnc_spawnvehicle) select 0;
		[_unit] spawn genInit;
		sleep 2;
		};
	waitUntil {sleep 1;({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"BLUFORSpawn"] call distanceUnits) > 0) or (dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)};

	if ({leader _grupo knowsAbout _x > 1.4} count ([distanciaSPWN,0,leader _grupo,"BLUFORSpawn"] call distanceUnits) > 0) then {_grupo addVehicle _veh;};

	waitUntil {sleep 1;(dateToNumber date > _fechalimnum) or (not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)};

	if ((not alive _veh) or ({_x getVariable ["BLUFORSpawn",false]} count crew _veh > 0)) then
		{
		_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],_tskTitle,_marcador],_posicion,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		[0,300] remoteExec ["resourcesFIA",2];
		[2,0] remoteExec ["prestige",2];
		if (_tipoVeh == opSPAA) then {[0,0] remoteExec ["prestige",2]; [0,10,_posicion] remoteExec ["AS_fnc_changeCitySupport",2]} else {[0,5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2]};
		[1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (_x distance _veh < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5,Slowhand] call playerScoreAdd;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
		};
	};
if (dateToNumber date > _fechalimnum) then
	{
	_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_texto],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[-5,-100] remoteExec ["resourcesFIA",2];
	[5,0,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	if (_tipoVeh == opSPAA) then {[0,0] remoteExec ["prestige",2]};
	[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	[-10,Slowhand] call playerScoreAdd;
	};

[1200,_tsk] spawn borrarTask;

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};

waitUntil {sleep 1; not (spawner getVariable _marcador)};

if (_camionCreado) then
	{
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	if (!([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};
	};
