if (!isServer and hasInterface) exitWith {};

_prestigio = server getVariable "prestigeNATO";
_aeropuertos = aeropuertos - mrkAAF + ["spawnNATO"];

_origen = [_aeropuertos,Slowhand] call BIS_fnc_nearestPosition;
_orig = getMarkerPos _origen;

[-10,0] remoteExec ["prestige",2];

_tiempolim = _prestigio;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombreorig = format ["the %1 Carrier", A3_Str_BLUE];
if (_origen!= "spawnNATO") then {_nombreorig = [_origen] call AS_fnc_localizar};

_tsk = ["NATOCAS",[side_blue,civilian],[format ["%4 is providing Air support from %1. They will be under our command until %2:%3.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_BLUE],format ["%1 CAS", A3_Str_BLUE],_origen],_orig,"CREATED",5,true,true,"Attack"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_tipoVeh = bluHeliArmed;

if (_prestigio > 70) then{
	_tipoVeh = bluCASFW;
}else{
	if (_prestigio > 30) then{
		_tipoVeh = bluHeliGunship;
	};
};

_soldados = [];
_vehiculos = [];

_grupoHeli = createGroup side_blue;
_grupoHeli setVariable ["esNATO",true,true];
_grupoHeli setGroupId ["CAS"];
hint format ["%1 CAS will be available on HC module in 35 seconds.", A3_Str_BLUE];

for "_i" from 1 to 3 do{
	_helifn = [_orig, 0, selectRandom _tipoVeh, side_blue] call bis_fnc_spawnvehicle;
	_heli = _helifn select 0;
	_heli setVariable ["BLUFORSpawn",false];
	_vehiculos pushBack _heli;
	_heliCrew = _helifn select 1;
	_grupoheliTmp = _helifn select 2;
	{[_x] spawn NATOinitCA; _soldados pushBack _x; [_x] join _grupoHeli} forEach _heliCrew;
	deleteGroup _grupoheliTmp;
	//[_heli] spawn NATOVEHinit; //This despawns the CAS vehicles as soon as they appear so i removed this. Sparker.
	_heli setPosATL [getPosATL _heli select 0, getPosATL _heli select 1, 1000];
	_heli flyInHeight 300;
	//[_heli] spawn unlimitedAmmo;
	//[_heli,"NATO CAS"] spawn inmuneConvoy;
	sleep 10;
};

Slowhand hcSetGroup [_grupoHeli];
_grupoHeli setVariable ["isHCgroup", true, true];

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ({alive _x} count _vehiculos == 0) or ({canMove _x} count _vehiculos == 0)};

if (dateToNumber date > _fechalimnum) then
	{
	[["TaskSucceeded", ["", format ["%1 CAS finished", A3_Str_BLUE]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	}
else
	{
	_tsk = ["NATOCAS",[side_blue,civilian],[format ["%4 is providing Air support from %1. They will be under our command until %2:%3.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_BLUE],format ["%1 CAS", A3_Str_BLUE],_origen],_orig,"FAILED",5,true,true,"Attack"] call BIS_fnc_setTask;
	[-5,0] remoteExec ["prestige",2];
	};

[0,_tsk] spawn borrarTask;

{deleteVehicle _x} forEach _soldados;
{deleteVehicle _x} forEach _vehiculos;
deleteGroup _grupoheli;