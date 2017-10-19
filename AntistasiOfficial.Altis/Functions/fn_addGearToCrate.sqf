params [["_crate",caja],["_weaponArray",[]],["_magazineArray",[]],["_itemArray",[]],["_backpackArray",[]]];

if (count _weaponArray > 0) then {
	{
		_crate addWeaponCargoGlobal [_x select 0, _x select 1];
	} forEach _weaponArray;
};

if (count _magazineArray > 0) then {
	{
		_crate addMagazineCargoGlobal [_x select 0, _x select 1];
	} forEach _magazineArray;
};

if (count _itemArray > 0) then {
	{
		_crate addItemCargoGlobal [_x select 0, _x select 1];
	} forEach _itemArray;
};

if (count _backpackArray > 0) then {
	{
		_crate addBackpackCargoGlobal [_x select 0, _x select 1];
	} forEach _backpackArray;
};