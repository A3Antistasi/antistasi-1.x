//if (!isServer) exitWith{};

if (player != leader group player) exitWith {hint "You cannot dismiss anyone if you are not the squad leader"};

private ["_units","_hr","_resourcesFIA","_unit","_nuevogrp"];

_units = _this select 0;

player globalChat "Get out of my sight you useless scum!";

_ai = false;

if ({isPlayer _x} count units group player == 1) then {_ai = true; _nuevogrp = createGroup side_blue};

{if (!isPlayer _x) then
	{
	if (typeOf _x != guer_POW) then
		{
		[_x] join _nuevogrp;
		arrayids = arrayids + [name _x];
		};
	}
else
	{
	_otroGrupo = createGroup side_blue;
	[_x] join _otroGrupo;
	};
} forEach _units;

if (recruitCooldown < time) then {recruitCooldown = time + 60} else {recruitCooldown = recruitCooldown + 60};

if (_ai) then
	{
	_lider = leader _nuevogrp;

	{_x domove getMarkerPos guer_respawn} forEach units _nuevogrp;

	_tiempo = time + 120;

	waitUntil {sleep 1; (time > _tiempo) or ({(_x distance getMarkerPos guer_respawn < 50) and (alive _x)} count units _nuevogrp == {alive _x} count units _nuevogrp)};

	_hr = 0;
	_resourcesFIA = 0;
	_items = [];
	_municion = [];
	_armas = [];

	{_unit = _x;
	if ((alive _unit) and (not(_x getVariable "inconsciente"))) then
		{
		_resourcesFIA = _resourcesFIA + (server getVariable (typeOf _unit));
		_hr = _hr +1;
		{if (not(([_x] call BIS_fnc_baseWeapon) in unlockedWeapons)) then {_armas pushBack ([_x] call BIS_fnc_baseWeapon)}} forEach weapons _unit;
		{if (not(_x in unlockedMagazines)) then {_municion pushBack _x}} forEach magazines _unit;
		_items = _items + (items _unit) + (primaryWeaponItems _unit) + (assignedItems _unit) + (secondaryWeaponItems _unit);
		};
	deleteVehicle _x;
	} forEach units _nuevogrp;
	if (!isMultiplayer) then {[_hr,_resourcesFIA/2] remoteExec ["resourcesFIA",2];} else {[_hr,0] remoteExec ["resourcesFIA",2]; [_resourcesFIA/2] call resourcesPlayer};
	{caja addWeaponCargoGlobal [_x,1]} forEach _armas;
	{caja addMagazineCargoGlobal [_x,1]} forEach _municion;
	{caja addItemCargoGlobal [_x,1]} forEach _items;
	deleteGroup _nuevogrp;
	};

