private ["_cfgmagazines","_magazine","_allPrimaryWeapons","_allHandGuns","_allLaunchers","_allAccessories","_name","_type","_magazines","_weapon","_weaponType"];

gear_assaultRifles = [];
gear_sniperRifles = [];
gear_machineGuns = [];
gear_sidearms = [];
gear_missileLaunchers = [];
gear_rocketLaunchers = [];
gear_allWeapons = [];
gear_allMagazines = [];
gear_allAccessories = [];

lockedWeapons = ["Laserdesignator"];

_allPrimaryWeapons = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 1 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allHandGuns = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 2 } } )
" configClasses ( configFile >> "cfgWeapons" );

_allLaunchers = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 4 } } )
" configClasses ( configFile >> "cfgWeapons" );


_allAccessories = "
    ( getNumber ( _x >> ""scope"" ) isEqualTo 2
    &&
    { getText ( _x >> ""simulation"" ) isEqualTo ""Weapon""
    &&
    { getNumber ( _x >> ""type"" ) isEqualTo 131072 } } )
" configClasses ( configFile >> "cfgWeapons" );

{
	_name = configName _x;
	_type = [_name] call BIS_fnc_itemType;
	_type = _type select 1;
	if ((_type == "AccessoryMuzzle") OR (_type == "AccessoryPointer") OR (_type == "AccessorySights")) then {
		gear_allAccessories pushBackUnique _name;
	};
} forEach _allAccessories;

{
	_name = configName _x;
	_name = [_name] call BIS_fnc_baseWeapon;
	if !(_name in lockedWeapons) then {
		lockedWeapons pushBackUnique _name;
		gear_allWeapons pushBackUnique _name;
		_weapon = [_name] call BIS_fnc_itemType;
		_weaponType = _weapon select 1;
		switch (_weaponType) do {
			case "AssaultRifle": {gear_assaultRifles pushBack _name};
			case "MachineGun": {gear_machineGuns pushBack _name};
			case "SniperRifle": {gear_sniperRifles pushBack _name};
			case "Handgun": {gear_sidearms pushBack _name};
			case "MissileLauncher": {gear_missileLaunchers pushBack _name};
			case "RocketLauncher": {gear_rocketLaunchers pushBack _name};
		};
	};
} forEach _allPrimaryWeapons + _allHandGuns + _allLaunchers;

gear_allWeapons pushBackUnique "Rangefinder";
gear_allWeapons pushBackUnique "Binocular";
gear_allWeapons pushBackUnique "Laserdesignator";
gear_allWeapons pushBackUnique "Laserdesignator_02";
gear_allWeapons pushBackUnique "Laserdesignator_03";

_magazines = configFile >> "cfgmagazines";
for "_i" from 0 to (count _magazines) -1 do {
	_magazine = _magazines select _i;
	if (isClass _magazine) then {
		gear_allMagazines pushBackUnique configName (_magazine);
	};
};

if (isServer) then {
	{
		_magazines = getArray (configFile / "CfgWeapons" / _x / "magazines");
		server setVariable [format ["%1_mags", _x], _magazines, true];
	} forEach lockedWeapons;
};

diag_log "Init: Gear Done";