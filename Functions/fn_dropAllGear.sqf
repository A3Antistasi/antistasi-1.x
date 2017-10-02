params ["_unit", "_container"];

{
	_container addMagazineCargoGlobal [_x, 1];
} forEach magazines _unit;

{
	_container addWeaponCargoGlobal [_x, 1];
} forEach weapons _unit;

{
	_container addItemCargoGlobal [_x, 1];
} forEach [vest _unit, headgear _unit, backpack _unit];

{_unit removeMagazine _x} forEach magazines _unit;
removeAllWeapons _unit;
removeVest _unit;
removeHeadgear _unit;
removeBackpack _unit;