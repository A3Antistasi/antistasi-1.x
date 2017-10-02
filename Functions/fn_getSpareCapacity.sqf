/*
    Description:
        - Calculate the spare cargo capacity of a vehicle

    Parameters:
        0: Vehicle

    Returns:
        Spare capacity (float), negative value indicates overloaded vehicle

    Example:
        _cap = [vehicle player] call AS_fnc_getSpareCapacity
*/

params ["_vehicle"];
private ["_capacity", "_load", "_mass", "_count", "_weaponData", "_magazineData", "_itemData", "_backpackData", "_classNames"];

_maxLoad = getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "maximumLoad");
_load = 0;

_weaponData = getWeaponCargo _vehicle;
_magazineData = getMagazineCargo _vehicle;
_itemData = getItemCargo _vehicle;
_backpackData = getBackpackCargo _vehicle;

if (count (_weaponData select 0) > 0) then {
    _classNames = _weaponData select 0;
    _count = _weaponData select 1;
    for "_i" from 0 to (count _classNames - 1) do {
        _mass = getNumber (configFile >> "CfgWeapons" >> (_classNames select _i) >> "WeaponSlotsInfo" >> "mass");
        _load = _load + (_mass * (_count select _i));
    };
};

if (count (_magazineData select 0) > 0) then {
    _classNames = _magazineData select 0;
    _count = _magazineData select 1;
    for "_i" from 0 to (count _classNames - 1) do {
        _mass = getNumber (configFile >> "CfgMagazines" >> (_classNames select _i) >> "mass");
        _load = _load + (_mass * (_count select _i));
    };
};

if (count (_itemData select 0) > 0) then {
    _classNames = _itemData select 0;
    _count = _itemData select 1;
    for "_i" from 0 to (count _classNames - 1) do {
        _mass = getNumber (configFile >> "CfgWeapons" >> (_classNames select _i) >> "ItemInfo" >> "mass");
        _load = _load + (_mass * (_count select _i));
    };
};

if (count (_backpackData select 0) > 0) then {
    _classNames = _backpackData select 0;
    _count = _backpackData select 1;
    for "_i" from 0 to (count _classNames - 1) do {
        _mass = getNumber (configFile >> "CfgVehicles" >> (_classNames select _i) >> "mass");
        _load = _load + (_mass * (_count select _i));
    };
};

_maxLoad - _load