if (activeAFRF) then {
    private _mag = currentMagazine petros;
    petros removeMagazines _mag;
    petros removeWeaponGlobal (primaryWeapon petros);
    [petros, "rhs_weap_ak74m", 5, 0] call BIS_fnc_addWeapon;
    petros selectweapon primaryWeapon petros;
} else {
	private _mag = currentMagazine petros;
    petros removeMagazines _mag;
    petros removeWeaponGlobal (primaryWeapon petros);
    [petros, "arifle_TRG21_F", 5, 0] call BIS_fnc_addWeapon;
    petros selectweapon primaryWeapon petros;
};