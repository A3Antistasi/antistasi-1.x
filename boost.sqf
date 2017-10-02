if !(isServer) exitWith {};

private ["_weapons", "_magazines", "_items", "_optics"];
scriptName "boost";

server setVariable ["hr",20,true];
server setVariable ["resourcesFIA",10000,true];
server setVariable ["prestigeNATO",30,true];

if (activeAFRF) then {
	if (activeGREF) then {
		_weapons = ["rhs_weap_m92", "rhs_weap_rpg26"];
		_magazines = ["rhs_30Rnd_762x39mm", "rhs_rpg26_mag", "rhs_mag_rgd5"];
		_items = ["ItemGPS", "ItemRadio", "rhs_acc_1p29", "rhs_6b5_khaki", "rhsgref_helmet_pasgt_un"];
		_optics = ["rhs_acc_1p29"];
	} else {
		_weapons = ["rhs_weap_aks74un", "rhs_weap_rpg26"];
		_magazines = ["rhs_30Rnd_545x39_AK", "rhs_rpg26_mag", "rhs_mag_rgd5"];
		_items = ["ItemGPS", "ItemRadio", "rhs_acc_1p29", "rhs_6b23", "rhs_ssh68"];
		_optics = ["rhs_acc_1p29"];
	};
} else {
	_weapons = ["arifle_TRG21_F", "launch_NLAW_F"];
	_magazines = ["30Rnd_556x45_Stanag", "NLAW_F", "HandGrenade"];
	_items = ["ItemGPS", "ItemRadio", "optic_Arco", "V_TacVest_oli", "H_HelmetCrew_I"];
	_optics = ["optic_Arco"];
};

unlockedWeapons = unlockedWeapons + _weapons;
unlockedMagazines = unlockedMagazines + _magazines;
unlockedItems = unlockedItems + _items;
unlockedOptics = unlockedOptics + _optics;

publicVariable "unlockedWeapons";
publicVariable "unlockedMagazines";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";

if (activeJNA) exitWith {[(unlockedWeapons + unlockedMagazines + unlockedItems + unlockedBackpacks) arrayIntersect (unlockedWeapons + unlockedMagazines + unlockedItems + unlockedBackpacks)] call AS_fnc_JNA_setupGear};

/*if (activeBE) then {[] call fnc_BE_gearUpdate; [] call fnc_BE_refresh};
[unlockedWeapons, "unlockedMagazines"] call AS_fnc_MAINT_missingAmmo;
[false] call AS_fnc_MAINT_arsenal; */
