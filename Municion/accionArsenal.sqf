private ["_box","_unit"];

_box = _this select 0;
_unit = _this select 1;

if (([_unit] call isMember) && ((server getVariable "enableMemAcc"))) exitWith {
	["Open",[nil,_box,_unit]] call BIS_fnc_arsenal;
};

_switch = false;
_bpitems = [];
_backpack = backpack _unit;
if (_backpack != "") then {
	_bpitems = backpackItems _unit;

	removeBackpack _unit;
	_unit addBackpack (_backpack call BIS_fnc_basicBackpack);
	_switch = true;

	if ((count _bpitems > 0) && (_switch)) then {
		for "_i" from 0 to (count _bpitems - 1) do {
			_unit addItemToBackpack  (_bpitems select _i);
		};
	};
};

_armas = [];
_items = [];
_mags = [];
_destino = cajaVeh;

if ([_unit] call isMember) then {_destino = caja} else {"Your locked items will be placed in the vehicle ammo box." remoteExec ["hint", player];};

_casco = headgear _unit;

if ((!(_casco in unlockedItems)) and (_casco in genHelmets)) then {_items pushBack _casco; removeHeadgear _unit};

if (activeTFAR) then {
	{
	if (!(_x in unlockedItems)) then {
		if !(toLower _x find "tf_anprc" >= 0) then {
			_items pushBack _x;
		};
	};
	} forEach ((items _unit) + (assignedItems _unit) - (weapons _unit));
}
else {
	{
	if (!(_x in unlockedItems)) then {
		_items pushBack _x;
		};
	} forEach ((items _unit) + (assignedItems _unit) - (weapons _unit));
	};

{
_ameter = false;
_arma = _x select 0;
_armaTrad = [_arma] call BIS_fnc_baseWeapon;
if (!(_armaTrad in unlockedWeapons)) then
	{
	_armas pushBack _armaTrad;
	_ameter = true;
	};
for "_i" from 1 to (count _x) - 1 do
	{
	_cosa = _x select _i;
	if (_cosa isEqualType "") then
		{
		if (_cosa != "") then
			{
			if (!(_cosa in unlockedItems)) then
				{
				_items pushBack _cosa;
				_ameter = true;
				};
			};
		}
	else
		{
		if (_cosa isEqualType []) then
			{
			if (!((_cosa select 0) in unlockedMagazines)) then
				{
				_mags pushBack (_cosa select 0);
				_ameter = true;
				};
			};
		};
	};


if (_ameter) then
	{
	if ((_arma == primaryWeapon _unit) or (_arma == secondaryWeapon _unit) or (_arma == handgunWeapon _unit)) then
		{
		_unit removeWeapon _arma;
		}
	else
		{
		_unit removeItem _arma;
		};
	};
} forEach weaponsItems _unit;


if (count _armas > 0) then
	{
	_armasDef = [];
	_armasDefCount = [];
	{
	_arma = _x;
	if (!(_arma in _armasDef)) then
		{
		_armasDef pushBack _arma;
		_armasDefCount pushBack ({_x == _arma} count _armas);
		};
	} forEach _armas;
	_texto = "";
	if (_destino == cajaVeh) then {_texto = "The following weapons have been added to the Vehicle Ammobox:"} else {_texto = "The following weapons have been added to the Main Ammobox:"};
	for "_i" from 0 to (count _armasDef - 1) do
		{
		_destino addWeaponCargoGlobal [_armasDef select _i,_armasDefCount select _i];
		if (_i == 0) then {_texto = format ["%1 %2",_texto, getText (configfile >> "CfgWeapons" >> (_armasDef select _i) >> "displayName")]} else {_texto = format ["%1, %2",_texto, getText (configfile >> "CfgWeapons" >> (_armasDef select _i) >> "displayName")]};
		};
	player globalChat _texto;
	};

if (count _items > 0) then
	{
	_itemsDef = [];
	_itemsDefCount = [];
	{
	_item = _x;
	if (_item in assignedItems _unit) then {_unit unassignItem _item};
	_unit removeItem _item;
	if (!(_item in _itemsDef)) then
		{
		_itemsDef pushBack _item;
		_itemsDefCount pushBack ({_x == _item} count _items);
		};
	} forEach _items;
	_texto = "";
	if (_destino == cajaVeh) then {_texto = "The following items have been added to the Vehicle Ammobox:"} else {_texto = "The following items have been added to the Main Ammobox:"};
	for "_i" from 0 to (count _itemsDef) - 1 do
		{
		if (_i == 0) then {_texto = format ["%1 %2",_texto, getText (configfile >> "CfgWeapons" >> (_itemsDef select _i) >> "displayName")]} else {_texto = format ["%1, %2",_texto, getText (configfile >> "CfgWeapons" >> (_itemsDef select _i) >> "displayName")]};
		_destino addItemCargoGlobal [_itemsDef select _i,_itemsDefCount select _i];
		};
	player globalChat _texto;
	};

{
if (!(_x in unlockedMagazines)) then
	{
	_mags pushBack _x;
	};
} forEach magazines _unit;

// experimental
{
if (!(_x in unlockedMagazines)) then
	{
	_mags pushBack _x;
	};
} forEach primaryWeaponMagazine _unit;

{
if (!(_x in unlockedMagazines)) then
	{
	_mags pushBack _x;
	};
} forEach secondaryWeaponMagazine _unit;
// experimental

if (count _mags > 0) then
	{
	_magsDef = [];
	_magsDefCount = [];
	{
	_mag = _x;
	_unit removeMagazine _mag;
	if(!(_mag in _magsDef)) then
		{
		_magsDef pushBack _mag;
		_magsDefCount pushBack ({_x == _mag} count _mags);
		};
	} forEach _mags;
	_texto = "";
	if (_destino == cajaVeh) then {_texto = "The following magazines have been added to the Vehicle Ammobox:"} else {_texto = "The following magazines have been added to the Main Ammobox:"};
	for "_i" from 0 to (count _magsDef) - 1 do
		{
		if (_i == 0) then {_texto = format ["%1 %2",_texto, getText (configfile >> "CfgMagazines" >> (_magsDef select _i) >> "displayName")]} else {_texto = format ["%1, %2",_texto, getText (configfile >> "CfgMagazines" >> (_magsDef select _i) >> "displayName")]};
		_destino addMagazineCargoGlobal [_magsDef select _i,_magsDefCount select _i];
		};
	player globalChat _texto;
	};


_backpack = backpack _unit;
if ( _backpack != "" ) then
	{
	if (not (_backpack in unlockedBackpacks)) then
		{
		_inScope = false;
		{
		if ( isNumber( configFile >> "CfgVehicles" >> _backpack >> _x ) && { getNumber( configFile >> "CfgVehicles" >> _backpack >> _x ) isEqualTo 2 } ) exitWith { true };
		}forEach [ "scope", "scopearsenal" ];
		if !( _inScope ) then
			{
			_tmpWhitelistBackpacks = [];
			// XLA fixed arsenal
			missionNamespace setVariable [ "BIS_fnc_arsenal_data", nil ];
			["Preload"] call BIS_fnc_arsenal;
			_tmpWhitelistBackpacks = ( missionNamespace getVariable "BIS_fnc_arsenal_data" ) select 5;
			_tmpWhitelistBackpacks pushBack _backpack;

			};
		};
	};

if ([_unit] call isMember) then {player globalChat "Your locked items will be placed in the vehicle ammo box."};


["Open",[nil,_box,_unit,false]] call BIS_fnc_arsenal;