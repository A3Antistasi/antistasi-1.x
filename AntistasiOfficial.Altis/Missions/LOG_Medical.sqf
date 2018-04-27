if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_logMedical";
_tskDesc = "STR_TSK_TD_DESC_logMedical";

private ["_poscrash","_posbase","_mrkfin","_mrkTarget","_tipoveh","_heli","_vehiculos","_soldados","_grupos","_unit","_roads","_road","_vehicle","_veh","_tipogrupo","_tsk","_humo","_emitterArray"];

/*
_posicion -> location of the destination, town
_posCrash -> location of the vehicle
_posCrashMrk -> marker for the vehicle
_posBase -> location of the base sending reinforcements
*/

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;
_nombredest = [_marcador] call AS_fnc_localizar;

_posHQ = getMarkerPos guer_respawn;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_fMarkers = mrkFIA + campsFIA;
_hMarkers = bases + aeropuertos + puestos - mrkFIA;

_basesAAF = bases - mrkFIA;
_bases = [];
_base = "";
{
	_base = _x;
	_posbase = getMarkerPos _base;
	if ((_posicion distance _posbase < 7500) and (_posicion distance _posbase > 1500) and (not (spawner getVariable _base))) then {_bases = _bases + [_base]}
} forEach _basesAAF;
if (count _bases > 0) then {_base = [_bases,_posicion] call BIS_fnc_nearestPosition;} else {_base = ""};

_posbase = getMarkerPos _base;

_nombreOrig = [_base] call AS_fnc_localizar;

while {true} do {
	sleep 0.1;
	_poscrash = [_posicion,2000,random 360] call BIS_fnc_relPos;
	_nfMarker = [_fMarkers,_poscrash] call BIS_fnc_nearestPosition;
	_nhMarker = [_hMarkers,_poscrash] call BIS_fnc_nearestPosition;
	if ((!surfaceIsWater _poscrash) && (_poscrash distance _posHQ < 4000) && (getMarkerPos _nfMarker distance _poscrash > 500) && (getMarkerPos _nhMarker distance _poscrash > 800)) exitWith {};
};

_tipoVeh = AS_misSupplyBoxEmpty;

_posCrashMrk = [_poscrash,random 200,random 360] call BIS_fnc_relPos;
_posCrash = _posCrash findEmptyPosition [0,100,_tipoVeh];
_mrkfin = createMarker [format ["REC%1", random 100], _posCrashMrk];
_mrkfin setMarkerShape "ICON";

_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;

misiones pushBack _tsk; publicVariable "misiones";

_vehiculos = [];
_soldados = [];
_grupos = [];

_sboxempty = createVehicle [_tipoVeh, _poscrash, [], 0, "CAN_COLLIDE"];
[_sboxempty,"Supply Crate"] spawn inmuneConvoy; //necessary for marker icon

// number of crate offsets = number of spawned crates
_crateOffsets = [
	[ 6, 185],
	[ 4, 167],
	[ 8, 105],
	[ 5, 215],
	[ 6, 125],
	[ 4, 147],
	[ 8, 82 ],
	[ 5, 222]
];

_crates = [];
{
	_x params ["_distance","_heading"];

	_currentCrate =  "Land_PaperBox_01_small_closed_white_med_F" createVehicle _poscrash;
	_currentCrate setPos ([getPos _sboxempty, _distance, _heading] call BIS_Fnc_relPos);
	_currentCrate setDir (getDir _sboxempty + (floor random 180));
	if(activeACE && {["ace_dragging"] call ace_common_fnc_isModLoaded}) then { // check if ace dragging module is active
		[_currentCrate, false] call ace_dragging_fnc_setCarryable; //disable carrying
		[_currentCrate, false] call ace_dragging_fnc_setDraggable; // disable dragging
	};
	if(activeACE && {["ace_cargo"] call ace_common_fnc_isModLoaded}) then { // check if ace cargo module is active
		[_currentCrate, -1] call ace_cargo_fnc_setSize; // disable loading as cargo with ace
	};

	_crates pushBack _currentCrate;
} forEach _crateOffsets;

_tipoGrupo = [infGarrisonSmall, side_green] call AS_fnc_pickGroup;
_grupo = [_poscrash, side_green, _tipogrupo] call BIS_Fnc_spawnGroup;
_grupos = _grupos + [_grupo];

{[_x] spawn genInit; _soldados = _soldados + [_x]} forEach units _grupo;


sleep 30;

_tam = 100;

while {true} do
	{
	_roads = _posbase nearRoads _tam;
	if (count _roads > 0) exitWith {};
	_tam = _tam + 50;
	};

_road = _roads select 0;

_vehicle= [position _road, 0,selectRandom vehTrucks, side_green] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] spawn genVEHinit;
[_veh,"AAF Escort"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] spawn genInit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_veh];

sleep 1;

_tipoGrupo = [infSquad, side_green] call AS_fnc_pickGroup;
_grupo = [_posbase, side_green, _tipogrupo] call BIS_Fnc_spawnGroup;

{_x assignAsCargo _veh; _x moveInCargo _veh; _soldados = _soldados + [_x]; [_x] spawn genInit} forEach units _grupo;
_grupos = _grupos + [_grupo];

//[_veh] spawn smokeCover;

_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "TR UNLOAD";
_Vwp0 setWaypointBehaviour "SAFE";
_Gwp0 = _grupo addWaypoint [_poscrash, 0];
_Gwp0 setWaypointType "GETOUT";
_Vwp0 synchronizeWaypoint [_Gwp0];

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ({(side _x == side_blue) and (_x distance _sboxempty < 500)} count allUnits > 0)};

_mrkfin = createMarker [format ["REC%1", random 100], _poscrash];
_mrkfin setMarkerShape "ICON";

if (dateToNumber date > _fechalimnum) then {
	_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_tsk = ["LOG",[side_blue,civilian],[["Secure the vehicle, load the cargo, and deliver the supplies to the people in %1 before %2:%3. AAF command has probably dispatched a patrol from %4 to retrieve the goods, so you better hurry. Note: no cargo left behind!",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_poscrash,"AUTOASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;

	_cuenta = 120;
	_counter = 0;

	_active = false;

	{_amigo = _x;
		if (captive _amigo) then {
			[_amigo,false] remoteExec ["setCaptive",_amigo];
		};
		{
			if ((side _x == side_green) and (_x distance _posCrash < distanciaSPWN)) then {
			if (_x distance _posCrash < 300) then {_x doMove _posCrash} else {_x reveal [_amigo,4]};
			};
			if ((side _x == civilian) and (_x distance _posCrash < 300)) then {_x doMove position _sboxempty};
		} forEach allUnits;
	} forEach ([300,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits);


	while {(_counter < _cuenta) and (dateToNumber date < _fechalimnum)} do {

		while {
			(_counter < _cuenta) and
			(_sboxempty distance _posCrash < 40) and
			!({[_x] call AS_fnc_isUnconscious} count
			  	([80,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits)
			  	==
			  	count (
			  	    [80,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits)) and
					({(side _x == side_green) and (_x distance _sboxempty < 50) and (lifeState _x != "INCAPACITATED")} count allUnits == 0) and
					(dateToNumber date < _fechalimnum)}
		do {
			if !(_active) then {
				{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]}} forEach ([80,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits);
				_active = true;
				[[petros,"globalChat","Keep area clear while repacking"],"commsMP"] call BIS_fnc_MP;
			};
			_counter = _counter + 1;
  			sleep 1;
		};

		if (_counter < _cuenta) then {
			_counter = 0;
			_active = false;
			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits);

			if (
				((_sboxempty distance _posCrash > 40) or (not([80,1,position _sboxempty,"BLUFORSpawn"] call distanceUnits)) or
				({(side _x == side_green) and (_x distance _sboxempty < 50) and (lifeState _x != "INCAPACITATED")} count allUnits != 0))
			) then {
				[[petros,"hint","Hold this position while loading the supplies into the crate."],"commsMP"] call BIS_fnc_MP};
				waitUntil {sleep 1;
					((_sboxempty distance _posCrash < 40) and ([80,1,_sboxempty,"BLUFORSpawn"] call distanceUnits) and
					({(side _x == side_green) and (_x distance _sboxempty < 50) and (lifeState _x != "INCAPACITATED")} count allUnits == 0)) or
					(dateToNumber date > _fechalimnum)};
		};
		if !(_counter < _cuenta) exitWith {
			_formato = format ["Good to go. Deliver these supplies to %1.",_nombredest];
			{if (isPlayer _x) then {[petros,"hint",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,position _sboxempty,"BLUFORSpawn"] call distanceUnits);
		};
	};

// delete boxes
{deleteVehicle _x;} forEach _crates ;
_pos1 = position _sboxempty;
deleteVehicle _sboxempty;

// Create the repacked box add delivery info
	_sbox = AS_misSupplyBox createVehicle _pos1;
	_sbox call jn_fnc_logistics_addAction;
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
	_mrkTarget = createMarker [format ["REC%1", random 100], _posicion];
	_mrkTarget setMarkerShape "ICON";
	_active = false;

	_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkTarget],_posicion,"AUTOASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;
	hint format ["%1 is the box, %2 is posicion",_sbox,_posicion];
	waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ( (_sbox distance _posicion < 40) and (isNull attachedTo _sbox) ) };

	if (dateToNumber date < _fechalimnum) then {
		_counter = 0;
		_cuenta = 10;
		while {(_counter < _cuenta) and (isNull attachedTo _sbox) and !({[_x] call AS_fnc_isUnconscious} count ([80,0,_sbox,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_sbox,"BLUFORSpawn"] call distanceUnits)) and (dateToNumber date < _fechalimnum)} do {

			if !(_active) then {
				{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]}} forEach ([80,0,_sbox,"BLUFORSpawn"] call distanceUnits);
				_active = true;
				[[petros,"globalChat","Leave the vehicle here, they'll come pick it up."],"commsMP"] call BIS_fnc_MP;
			};

			_counter = _counter + 1;
  			sleep 1;

			};
			{if (isPlayer _x) then {[_sbox,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([100,0,_sbox,"BLUFORSpawn"] call distanceUnits);

			if (alive _sbox) then {
				[[petros,"hint","Supplies Delivered"],"commsMP"] call BIS_fnc_MP;
				_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
				[0,15,_marcador] remoteExec ["AS_fnc_changeCitySupport",2];
				[5,0] remoteExec ["prestige",2];
				{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
				[5,Slowhand] call playerScoreAdd;
				// BE module
				if (activeBE) then {
					["mis"] remoteExec ["fnc_BE_XP", 2];
				};
				// BE module

				if (random 10 < 5) then {
					if (random 10 < 5) then {
						for [{_i=1},{_i<=(1 + round random 2)},{_i=_i+1}] do {
							_cosa = genMines call BIS_Fnc_selectRandom;
							_num = 1 + (floor random 5);
							if (not(_cosa in unlockedMagazines)) then {cajaVeh addMagazineCargoGlobal [_cosa, _num]};
						};
					}
					else {
						for [{_i=1},{_i<=(1 + round random 2)},{_i=_i+1}] do {
							_cosa = genOptics call BIS_Fnc_selectRandom;
							_num = 1 + (floor random 5);
							if (not(_cosa in unlockedOptics)) then {cajaVeh addItemCargoGlobal [_cosa, _num]};
						};
					};
					[[petros,"globalChat","Someone dropped off a crate near HQ while you were gone. Check the vehicle ammo box."],"commsMP"] call BIS_fnc_MP;
				};

			}
			else {
				_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
				[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
				[-10,Slowhand] call playerScoreAdd;
			};
	}
	else {
			_tsk = ["LOG",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
			[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
			[-10,Slowhand] call playerScoreAdd;
	};
};

[1200,_tsk] spawn borrarTask;
deleteMarker _mrkfin;
{waitUntil {sleep 1;(!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
deleteVehicle _x} forEach _vehiculos;
{deleteVehicle _x} forEach _soldados;
{deleteGroup _x} forEach _grupos;
