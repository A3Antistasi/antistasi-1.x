private ["_tipo","_coste","_posicionTel","_cantidad","_cantidadMax"];

if ("Mines" in misiones) exitWith {hint "We can only deploy one minefield at a time."};

if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

_tipo = _this select 0;

_coste = (2*(server getVariable guer_sol_EXP)) + ([guer_veh_truck] call vehiclePrice);
_hr = 2;
if (_tipo == "delete") then
	{
	_coste = _coste - (server getVariable guer_sol_EXP);
	_hr = 1;
	};
if ((server getVariable "resourcesFIA" < _coste) or (server getVariable "hr" < _hr)) exitWith {hint format ["Not enought resources to recruit a mine deploying team (%1 € and %2 HR needed)",_coste,_hr]};

if (_tipo == "delete") exitWith
	{
	hint "Sapper/engineer is available on your High Command bar.\n\nSend him anywhere on the map and he will deactivate and load in his truck any mine he may find.\n\nReturning back to HQ will unload the mines he stored in his vehicle";
	[[], "AI\mineSweep.sqf"] remoteExec ["execVM", HCattack];
	};

openMap true;
posicionTel = [];
hint "Click on the position you wish to build the minefield.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;

_cantidadMax = 40;
_cantidad = 0;

if (_tipo == "ATMine") then {
	_cantidadMax = 20;
	if (atMine in unlockedMagazines) then {
		_cantidad = 20;
	} else {
		_cantidad = {_x == atMine} count (magazineCargo caja);
	};
	diag_log format ["AT mines: %1", _cantidad];
};


if (_tipo == "APERSMine") then {
	if (apMine in unlockedMagazines) then {
		_cantidad = 40;
	} else {
		_cantidad = {_x == apMine} count (magazineCargo caja);
	};
	diag_log format ["AP mines: %1", _cantidad];
};

if (_cantidad < 5) exitWith {hint "You need at least 5 mines of this type to build a Minefield"};

if (_cantidad > _cantidadMax) then
	{
	_cantidad = _cantidadMax;
	};

[[_tipo,_posicionTel,_cantidad], "REINF\buildMinefield.sqf"] remoteExec ["execVM",HCattack];