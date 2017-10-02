if (!isServer and hasInterface) exitWith {};

_tskTitle = localize "Str_tsk_logSupply";
_tskDesc = localize "Str_tskDesc_logSupply";

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call AS_fnc_localizar;

_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_pos = (getMarkerPos guer_respawn) findEmptyPosition [1,50,AS_misVehicleBox];

_camion = AS_misVehicleBox createVehicle _pos;
[_camion] spawn VEHinit;
{_x reveal _camion} forEach (allPlayers - hcArray);
_camion setVariable ["destino",_nombredest,true];
_camion addEventHandler ["GetIn",
	{
	if (_this select 1 == "driver") then
		{
		_texto = format ["Bring this truck to %1 and deliver it's supplies to the population",(_this select 0) getVariable "destino"];
		_texto remoteExecCall ["hint",_this select 2];
		};
	}];

[_camion,"Mission Vehicle"] spawn inmuneConvoy;

waitUntil {sleep 1; (not alive _camion) or (dateToNumber date > _fechalimnum) or (_camion distance _posicion < 40)};

if ((not alive _camion) or (dateToNumber date > _fechalimnum)) then
	{
	_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
	}
else
	{
	_cuenta = 120;
	_counter = 0;
	_active = false;
	[_posicion] remoteExec ["patrolCA",HCattack];
	{_amigo = _x;
	if (captive _amigo) then
		{
		[_amigo,false] remoteExec ["setCaptive",_amigo];
		};
	{
	if ((side _x == side_green) and (_x distance _posicion < distanciaSPWN)) then
		{
		if (_x distance _posicion < 300) then {_x doMove _posicion} else {_x reveal [_amigo,4]};
		};
	if ((side _x == civilian) and (_x distance _posicion < 300)) then {_x doMove position _camion};
	} forEach allUnits;
	} forEach ([300,0,_camion,"BLUFORSpawn"] call distanceUnits);
	while {(_counter < _cuenta) and (alive _camion) and (dateToNumber date < _fechalimnum)} do
		{
		while {(_counter < _cuenta) and (_camion distance _posicion < 40) && (speed _camion < 1) and (alive _camion) and !({_x getVariable ["inconsciente",false]} count ([40,0,_camion,"BLUFORSpawn"] call distanceUnits) == count ([40,0,_camion,"BLUFORSpawn"] call distanceUnits)) and ({(side _x == side_green) and (_x distance _camion < 50)} count allUnits == 0) and (dateToNumber date < _fechalimnum)} do
			{
			if !(_active) then {
				{
					_x action ["eject", _camion];
				} forEach (crew (_camion));
				_camion lock 2;
				_camion engineOn false;
				{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]; [_camion,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([80,0,_camion,"BLUFORSpawn"] call distanceUnits);
				_active = true;
				[[petros,"globalChat","Guard the truck!"],"commsMP"] call BIS_fnc_MP;
			};

			_counter = _counter + 1;
  			sleep 1;
			};
		if (_counter < _cuenta) then
			{
			_counter = 0;
			_active = false;

			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,_camion,"BLUFORSpawn"] call distanceUnits);

			if (((_camion distance _posicion > 40) or (not([40,1,_camion,"BLUFORSpawn"] call distanceUnits)) or ({(side _x == side_green) and (_x distance _camion < 50)} count allUnits != 0)) and (alive _camion)) then {[[petros,"hint","Don't get the truck far from the city center, and stay close to it, and clean all AAF presence in the surroundings or count will restart"],"commsMP"] call BIS_fnc_MP};
			waitUntil {sleep 1; (!alive _camion) or ((_camion distance _posicion < 40) and ([40,1,_camion,"BLUFORSpawn"] call distanceUnits) and ({(side _x == side_green) and (_x distance _camion < 50)} count allUnits == 0)) or (dateToNumber date > _fechalimnum)};
			};
		if ((alive _camion) and !(_counter < _cuenta)) exitWith {};
	};
	if ((alive _camion) and (dateToNumber date < _fechalimnum)) then {
		[[petros,"hint","Supplies Delivered"],"commsMP"] call BIS_fnc_MP;
		_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
		[0,15,_marcador] remoteExec ["AS_fnc_changeCitySupport",2];
		[5,0] remoteExec ["prestige",2];
		{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
		[5,Slowhand] call playerScoreAdd;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	}
	else {
		_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
		[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		[-10,Slowhand] call playerScoreAdd;
	};
};
{if (isPlayer _x) then {[_camion,false] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([100,0,_camion,"BLUFORSpawn"] call distanceUnits);

//sleep (600 + random 1200);

//[_tsk,true] call BIS_fnc_deleteTask;
[1200,_tsk] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_camion,"BLUFORSpawn"] call distanceUnits)) or ((_camion distance (getMarkerPos guer_respawn) < 60) && (speed _camion < 1))};
[_camion,true] call vaciar;
deleteVehicle _camion;

