params ["_unit", "_class"];

switch (_class) do {
	case sol_AT: {
		{
			_unit removeMagazines _x;
		} forEach (getArray (configFile / "CfgWeapons" / (secondaryWeapon _unit) / "magazines")) +
			(getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines"));
		for "_i" from 1 to 2 do {_unit addItemToVest ((getArray (configFile / "CfgWeapons" / (primaryWeapon _unit) / "magazines")) select 0)};
		removeBackpackGlobal _unit;
		_unit addBackPack "rhsusf_assault_eagleaiii_coy";
		_unit removeWeaponGlobal (secondaryWeapon _unit);
		_unit addItemToBackpack (getArray (configFile / "CfgWeapons" / "launch_I_Titan_short_F" / "magazines") select 0);
		_unit addWeapon "launch_I_Titan_short_F";
		_unit addSecondaryWeaponItem "rhs_weap_optic_smaw";
		_unit addItemToBackpack (getArray (configFile / "CfgWeapons" / "launch_I_Titan_short_F" / "magazines") select 0);
	};
	default {
	};
};