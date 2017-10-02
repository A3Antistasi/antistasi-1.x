params ["_weaponList", "_list"];

call {
	if (_list == "unlockedMagazines") exitWith {
		{
			unlockedMagazines pushBackUnique (getArray (configFile / "CfgWeapons" / _x / "magazines") select 0);
		} forEach _weaponList;
		publicVariable "unlockedMagazines";
	};

	if (_list == "genAmmo") exitWith {
		{
			genAmmo pushBackUnique (getArray (configFile / "CfgWeapons" / _x / "magazines") select 0);
		} forEach _weaponList;
		publicVariable "genAmmo";
	};
};