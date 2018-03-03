if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_logSupply";
_tskDesc = "STR_TSK_TD_DESC_logSupply";

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call AS_fnc_localizar;

_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_pos = (getMarkerPos guer_respawn) findEmptyPosition [1,50,AS_misSupplyBox];

_sbox = AS_misSupplyBox createVehicle _pos;
_sbox call jn_fnc_logistics_addAction;
//{_x reveal _sbox} forEach (allPlayers - (entities "HeadlessClient_F")); No sense to reveal an object to players
_sbox setVariable ["destino",_nombredest,true];
_sbox addAction ["Delivery infos",
	{
		_text = format ["Deliver this box to %1, unload it to start distributing to people",(_this select 0) getVariable "destino"];
		_text remoteExecCall ["hint",_this select 2];
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];


[_sbox,"Supply Crate"] spawn inmuneConvoy;

waitUntil {sleep 1; (not alive _sbox) or (dateToNumber date > _fechalimnum) or (_sbox distance _posicion < 40) and (isNull attachedTo _sbox)};

if (dateToNumber date > _fechalimnum) then {
	_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_cuenta = 120;
	_counter = 0;
	_active = false;
	[_posicion] remoteExec ["patrolCA", call AS_fnc_getNextWorker]; //In future this will be small ca from outpost
	{_amigo = _x;
		if (captive _amigo) then {[_amigo,false] remoteExec ["setCaptive",_amigo];};
		{
			if ((side _x == side_green) and (_x distance _posicion < distanciaSPWN)) then {
				if (_x distance _posicion < 300) then {_x doMove _posicion} else {_x reveal [_amigo,4]};
			};
			if ((side _x == civilian) and (_x distance _posicion < 300)) then {_x doMove position _sbox};
		} forEach allUnits;
	} forEach ([300,0,position _sbox,"BLUFORSpawn"] call distanceUnits);

	while {(_counter < _cuenta) and (dateToNumber date < _fechalimnum)} do {
		while {
			(_counter < _cuenta) and
			(_sbox distance _posicion < 40) && (speed _sbox < 1) and
			(alive _sbox) and
			(isNull attachedTo _sbox) and
			!(
			  	{[_x] call AS_fnc_isUnconscious} count ([40,0,_sbox,"BLUFORSpawn"] call distanceUnits) ==
			  	count ([40,0,_sbox,"BLUFORSpawn"] call distanceUnits)) and
				({(side _x == side_green) and (_x distance _sbox < 50)} count allUnits == 0) and (dateToNumber date < _fechalimnum)} do {
					if !(_active) then {   //this is not going to have any use since it is a crate.
						{
							_x action ["eject", _sbox];
						} forEach (crew (_sbox));
						_sbox lock 2;
						_sbox engineOn false;
						{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]; [_sbox,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([80,0,_sbox,"BLUFORSpawn"] call distanceUnits);
						_active = true;
						[[petros,"globalChat","Guard the truck!"],"commsMP"] call BIS_fnc_MP;
					};

			_counter = _counter + 1;
  			sleep 1;
		};

		if (_counter < _cuenta) then {
			_counter = 0;
			_active = false;

			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,_sbox,"BLUFORSpawn"] call distanceUnits);

			if (
				((_sbox distance _posicion > 40) or (not([40,1,_sbox,"BLUFORSpawn"] call distanceUnits)) or
			    ({(side _x == side_green) and (_x distance _sbox < 50)} count allUnits != 0)) and (alive _sbox))
			then {[[petros,"hint","Don't get the truck far from the city center, and stay close to it, and clean all AAF presence in the surroundings or count will restart"],"commsMP"] call BIS_fnc_MP};

			waitUntil {sleep 1; (
				(_sbox distance _posicion < 40) and ([40,1,_sbox,"BLUFORSpawn"] call distanceUnits) and
				({(side _x == side_green) and (_x distance _sbox < 50)} count allUnits == 0))
				or (dateToNumber date > _fechalimnum)};
			};

				if !(_counter < _cuenta) exitWith {};
	};

	if (dateToNumber date < _fechalimnum) then {
		[[petros,"hint","Supplies Delivered"],"commsMP"] call BIS_fnc_MP;
		_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
		[0,15,_marcador] remoteExec ["AS_fnc_changeCitySupport",2];
		[5,0] remoteExec ["prestige",2];
		{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
		[5,Slowhand] call playerScoreAdd;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	}
	else {
		_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
		[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		[-10,Slowhand] call playerScoreAdd;
	};
};
{if (isPlayer _x) then {[_sbox,false] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([100,0,_sbox,"BLUFORSpawn"] call distanceUnits);

_ecpos = getpos _sbox;
deleteVehicle _sbox;
_empty = AS_misSupplyBoxEmpty createVehicle _ecpos;

//sleep (600 + random 1200);

//[_tsk,true] call BIS_fnc_deleteTask;
[600,_tsk] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_empty,"BLUFORSpawn"] call distanceUnits)) or ((_empty distance (getMarkerPos guer_respawn) < 60))};
deleteVehicle _empty;

