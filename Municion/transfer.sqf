private ["_camion","_objetos","_todo","_proceder","_caja","_armas","_municion","_items","_mochis","_contenedores","_cuenta","_exists"];
/*
spanish to english dictionary:
camion = truck
caja = box
cuenta = count
jugador = player
*/
_jugador = _this select 0;
_camion = vehicle _jugador;
_id = _this select 2;

if (_jugador getVariable ["loadingCrate", false]) exitWith {[petros,"hint", "Already loading a crate..."] remoteExec ["commsMP",_jugador]};

_objetos = [];
_todo = [];
_proceder = false;
_active = false;
_counter = 0;

_objetos = nearestObjects [_camion, ["ReammoBox_F","Land_PlasticCase_01_medium_F"], 20];

if (count _objetos == 0) exitWith {[petros,"hint", "No crates nearby."] remoteExec ["commsMP",_jugador]};
_caja = _objetos select 0;

if ((_caja == caja) and (player!=Slowhand)) exitWith {[petros,"hint", "Only the Commander can transfer this ammobox content to any truck"] remoteExec ["commsMP",_jugador]};


_armas = weaponCargo _caja;
_municion = magazineCargo _caja;
_items = itemCargo _caja;
_mochis = [];

_todo = _armas + _municion + _items + _mochis;
_cuenta = count _todo;
_breakText = "";

if (_cuenta < 1) then
	{
	[petros,"hint", "Closest Ammobox is empty"] remoteExec ["commsMP",_jugador];
	_proceder = true;
	};

if (_cuenta > 0) then
	{
	if (_caja == caja) then
		{
		if ("DEF_HQ" in misiones) then {_cuenta = round (_cuenta / 10)} else {_cuenta = round (_cuenta / 100)};
		}
	else
		{
		_cuenta = round (_cuenta / 5);
		};
	if (_cuenta < 1) then {_cuenta = 1};
	_cuenta = _cuenta * 10;
	_jugador setVariable ["loadingCrate", true];
	while {(_camion == vehicle player) and (speed _camion == 0) and (_cuenta > _counter)} do
		{
		if !(_active) then {
			[round ((_cuenta - _counter) / 10),false] remoteExec ["pBarMP",player];
			_active = true;
		};

			_counter = _counter + 1;
  			sleep 0.1;
		if !(_cuenta > _counter) then
			{
			[_caja,_camion] remoteExec ["AS_fnc_transferGear",2];
			_proceder = true;
			};
		if ((_camion != vehicle player) or (speed _camion != 0)) then
				{
				_proceder = true;
				};
		};

		if ((_camion != vehicle _jugador) or (speed _camion > 2)) then {
			_proceder = true;
			_breakText = "Transfer cancelled due to movement of Truck or Player";
		};
	};
	[0,true] remoteExec ["pBarMP",player];
	_jugador setVariable ["loadingCrate", false];

if !(_breakText == "") then {[petros,"hint", _breakText] remoteExec ["commsMP",_jugador]};