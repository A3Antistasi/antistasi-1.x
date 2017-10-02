if (!isServer and hasInterface) exitWith {};

_tskTitle = localize "Str_tsk_logMedical";
_tskDesc = localize "Str_tskDesc_logMedical";

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

_tipoVeh = "C_Van_01_transport_F";

_posCrashMrk = [_poscrash,random 200,random 360] call BIS_fnc_relPos;
_posCrash = _posCrash findEmptyPosition [0,100,_tipoVeh];
_mrkfin = createMarker [format ["REC%1", random 100], _posCrashMrk];
_mrkfin setMarkerShape "ICON";

_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;

misiones pushBack _tsk; publicVariable "misiones";

_vehiculos = [];
_soldados = [];
_grupos = [];

_sTruck = createVehicle [_tipoVeh, _poscrash, [], 0, "CAN_COLLIDE"];
[_sTruck,"Mission Vehicle"] spawn inmuneConvoy;
reportedVehs pushBack _sTruck; publicVariable "reportedVehs";
_sTruck lockCargo true;
{_sTruck lockCargo [_x, false];} forEach [0 ,1];
//_sTruck setFuel 0;

_crate1 = "Box_IND_Support_F" createVehicle _poscrash;
_crate2 = "Box_IND_Support_F" createVehicle _poscrash;
_crate3 = "Box_NATO_WpsSpecial_F" createVehicle _poscrash;
_crate4 = "Box_NATO_WpsSpecial_F" createVehicle _poscrash;
_crate1 setPos ([getPos _sTruck, 6, 185] call BIS_Fnc_relPos);
_crate2 setPos ([getPos _sTruck, 4, 167] call BIS_Fnc_relPos);
_crate3 setPos ([getPos _sTruck, 8, 105] call BIS_Fnc_relPos);
_crate4 setPos ([getPos _sTruck, 5, 215] call BIS_Fnc_relPos);
_crate1 setDir (getDir _sTruck + (floor random 180));
_crate2 setDir (getDir _sTruck + (floor random 180));
_crate3 setDir (getDir _sTruck + (floor random 180));
_crate4 setDir (getDir _sTruck + (floor random 180));

[_crate1] call emptyCrate;
[_crate2] call emptyCrate;
[_crate3] call emptyCrate;
[_crate4] call emptyCrate;

_crate1 addItemCargoGlobal ["FirstAidKit", 40];
_crate2 addItemCargoGlobal ["FirstAidKit", 40];
_crate3 addItemCargoGlobal ["Medikit", 10];
_crate4 addItemCargoGlobal ["Medikit", 10];

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

[_veh] spawn smokeCover;

_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "TR UNLOAD";
_Vwp0 setWaypointBehaviour "SAFE";
_Gwp0 = _grupo addWaypoint [_poscrash, 0];
_Gwp0 setWaypointType "GETOUT";
_Vwp0 synchronizeWaypoint [_Gwp0];

waitUntil {sleep 1; (not alive _sTruck) or (dateToNumber date > _fechalimnum) or ({(side _x == side_blue) and (_x distance _sTruck < 500)} count allUnits > 0)};

waitUntil {sleep 1; (not alive _sTruck) or (dateToNumber date > _fechalimnum) or ({(side _x == side_blue) and (_x distance _sTruck < 50)} count allUnits > 0)};

_mrkfin = createMarker [format ["REC%1", random 100], _poscrash];
_mrkfin setMarkerShape "ICON";

if ((not alive _sTruck) or (dateToNumber date > _fechalimnum)) then {
	_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
}
else {
	_tsk = ["LOG",[side_blue,civilian],[format ["Secure the vehicle, load the cargo, and deliver the supplies to the people in %1 before %2:%3. AAF command has probably dispatched a patrol from %4 to retrieve the goods, so you better hurry. Note: no cargo left behind!",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_poscrash,"AUTOASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;

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
			if ((side _x == civilian) and (_x distance _posCrash < 300)) then {_x doMove position _sTruck};
		} forEach allUnits;
	} forEach ([300,0,_sTruck,"BLUFORSpawn"] call distanceUnits);


	while {(_counter < _cuenta) and (alive _sTruck) and (dateToNumber date < _fechalimnum)} do {

		while {(_counter < _cuenta) and (_sTruck distance _posCrash < 40) and (alive _sTruck) and !({_x getVariable ["inconsciente",false]} count ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits)) and ({(side _x == side_green) and (_x distance _sTruck < 50)} count allUnits == 0) and (dateToNumber date < _fechalimnum)} do {

			if !(_active) then {
				{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]}} forEach ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits);
				_active = true;
				[[petros,"globalChat","Guard the truck!"],"commsMP"] call BIS_fnc_MP;
			};

			_counter = _counter + 1;
  			sleep 1;

			};

		if (_counter < _cuenta) then {
			_counter = 0;
			_active = false;
			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,_sTruck,"BLUFORSpawn"] call distanceUnits);

			if (((_sTruck distance _posCrash > 40) or (not([80,1,_sTruck,"BLUFORSpawn"] call distanceUnits)) or ({(side _x == side_green) and (_x distance _sTruck < 50)} count allUnits != 0)) and (alive _sTruck)) then {[[petros,"hint","Hold this position and keep the truck near the supplies while they are being loaded."],"commsMP"] call BIS_fnc_MP};
			waitUntil {sleep 1; (!alive _sTruck) or ((_sTruck distance _posCrash < 40) and ([80,1,_sTruck,"BLUFORSpawn"] call distanceUnits) and ({(side _x == side_green) and (_x distance _sTruck < 50)} count allUnits == 0)) or (dateToNumber date > _fechalimnum)};
		};
		if ((alive _sTruck) and !(_counter < _cuenta)) exitWith {
			_formato = format ["Good to go. Deliver these supplies to %1 on the double.",_nombredest];
			{if (isPlayer _x) then {[petros,"hint",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits);
			_crate1 attachTo [_sTruck,[0.3,-1.0,-0.4]];
			_crate2 attachTo [_sTruck,[-0.3,-1.0,-0.4]];
			_crate3 attachTo [_sTruck,[0,-1.6,-0.4]];
			_crate4 attachTo [_sTruck,[0,-2.0,-0.4]];
		};
	};
	_mrkTarget = createMarker [format ["REC%1", random 100], _posicion];
	_mrkTarget setMarkerShape "ICON";
	_active = false;

	_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkTarget],_posicion,"AUTOASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;

	waitUntil {sleep 1; (not alive _sTruck) or (dateToNumber date > _fechalimnum) or (_sTruck distance _posicion < 40)};

	if ((alive _sTruck) and (dateToNumber date < _fechalimnum)) then {
		_sTruck setFuel 0;
		_counter = 0;
		_cuenta = 10;
		while {(_counter < _cuenta) and (alive _sTruck) and !({_x getVariable ["inconsciente",false]} count ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits)) and (dateToNumber date < _fechalimnum)} do {

			if !(_active) then {
				{if (isPlayer _x) then {[(_cuenta - _counter),false] remoteExec ["pBarMP",_x]}} forEach ([80,0,_sTruck,"BLUFORSpawn"] call distanceUnits);
				_active = true;
				[[petros,"globalChat","Leave the vehicle here, they'll come pick it up."],"commsMP"] call BIS_fnc_MP;
			};

			_counter = _counter + 1;
  			sleep 1;

			};
			{
				_x action ["eject", _sTruck];
			} forEach (crew (_sTruck));
			sleep 1;
			_sTruck lock 2;
			{if (isPlayer _x) then {[_sTruck,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([100,0,_sTruck,"BLUFORSpawn"] call distanceUnits);

			if (alive _sTruck) then {
				[[petros,"hint","Supplies Delivered"],"commsMP"] call BIS_fnc_MP;
				_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
				[0,15,_marcador] remoteExec ["AS_fnc_changeCitySupport",2];
				[5,0] remoteExec ["prestige",2];
				{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
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
				_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
				[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
				[-10,Slowhand] call playerScoreAdd;
			};
	}
	else {
			_tsk = ["LOG",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, _nombreOrig, A3_Str_INDEP],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
			[5,-5,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
			[-10,Slowhand] call playerScoreAdd;
	};
};

deleteVehicle _crate1;
deleteVehicle _crate2;
deleteVehicle _crate3;
deleteVehicle _crate4;

[1200,_tsk] spawn borrarTask;
deleteMarker _mrkfin;
{
waitUntil {sleep 1;(!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
deleteVehicle _x} forEach _vehiculos;
{deleteVehicle _x} forEach _soldados;
{deleteGroup _x} forEach _grupos;