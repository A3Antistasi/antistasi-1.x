if (isDedicated) exitWith {};
if !(server getVariable ["enableWpnProf", false]) exitWith {};

/*
 	Description:
		- MP only.
		- Adjust a player's skills (aim coefficient, recoil coefficient) based on chosen class and used weapon.
		- Display warning if primary weapon causes skill malus.
		- To be used in event handlers or continuous checks.

	Parameters:
		None

 	Returns:
		Nothing

 	Example:
		player addEventHandler ["Take",{[] spawn fn_skillAdjustments}];
*/

//	Values for each class
//	0: default; 1: LMG; 2: Sniper Rifle
#define OFF_AIM [1.5, 2.5, 2.5]
#define RIF_AIM [1, 3, 3]
#define LAT_AIM [1, 3, 3]
#define AR_AIM [1.5, 1, 3]
#define ENG_AIM [2.5, 3.3, 3.3]
#define MED_AIM [2.5, 3.3, 3.3]
#define AMM_AIM [1, 3, 3]
#define MRK_AIM [1, 2, 1]
#define TL_AIM [1.5, 2.5, 2.5]

#define OFF_REC [1.5, 2, 2]
#define RIF_REC [1, 2.5, 2.5]
#define LAT_REC [1, 2.5, 2.5]
#define AR_REC [1, 1, 2]
#define ENG_REC [1.8, 3, 3]
#define MED_REC [1.8, 3, 3]
#define AMM_REC [1, 2.5, 2.5]
#define MRK_REC [1.5, 2.5, 1]
#define TL_REC [1.5, 2, 2]

private _class = player getVariable ["class","it_doesnt_exist"];

_fnc_text = {
	params ["_text"];
	[_text,[0.2 * safeZoneW + safeZoneX, 1 * safezoneH + safezoneY],[0.03 * safezoneH + safezoneY, 1 * safezoneH + safezoneY],3,0,0,16] spawn BIS_fnc_dynamicText;
};

_fnc_adjust = {
	params ["_aim", "_recoil"];

	if (([primaryWeapon player] call BIS_fnc_baseWeapon) in AS_specialWeapons) exitWith {
		player setCustomAimCoef 1.0;
		player setUnitRecoilCoefficient 1.0;
	};

	if (([primaryWeapon player] call BIS_fnc_baseWeapon) in gear_machineGuns) exitWith {
		player setCustomAimCoef (_aim select 1);
		player setUnitRecoilCoefficient (_recoil select 1);
		if ((_aim select 1) > (_aim select 0)) then {[localize "STR_info_skillAdj"] call _fnc_text};
	};
	if (([primaryWeapon player] call BIS_fnc_baseWeapon) in gear_sniperRifles) exitWith {
		player setCustomAimCoef (_aim select 2);
		player setUnitRecoilCoefficient (_recoil select 2);
		if ((_aim select 2) > (_aim select 0)) then {[localize "STR_info_skillAdj"] call _fnc_text};
	};

	player setCustomAimCoef (_aim select 0);
	player setUnitRecoilCoefficient (_recoil select 0);
};

switch (_class) do {
	case "officer": {[OFF_AIM, OFF_REC] call _fnc_adjust};
	case "rifleman":  {[RIF_AIM, RIF_REC] call _fnc_adjust};
	case "antitank": {[LAT_AIM, LAT_REC] call _fnc_adjust};
	case "autorifleman": {[AR_AIM, AR_REC] call _fnc_adjust};
	case "engineer":  {[ENG_AIM, ENG_REC] call _fnc_adjust};
	case "medic":  {[MED_AIM, MED_REC] call _fnc_adjust};
	case "ammobearer":  {[AMM_AIM, AMM_REC] call _fnc_adjust};
	case "marksman":  {[MRK_AIM, MRK_REC] call _fnc_adjust};
	case "teamleader": {[TL_AIM, TL_REC] call _fnc_adjust};
};