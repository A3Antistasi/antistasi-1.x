if (!isServer and hasInterface) exitWith {};


//Stef 31-08 disabled capture hilltop and garaged vehicles
#define BE_XP_KILL 0.5
#define BE_XP_MIS 10
#define BE_XP_DES_VEH 5
#define BE_XP_DES_ARM 10
#define BE_XP_CAP_VEH 8
#define BE_XP_CAP_ARM 12
#define BE_XP_CON_TER 10
#define BE_XP_CON_BAS 20
#define BE_XP_CON_CIT 15
#define BE_XP_CL_LOC 5
#define BE_XP_UNL_WPN 15

#define BE_REQ_XP [150, 200, 250, 350]

#define BE_FIA_SKILL_CAP [4, 8, 12, 20]
#define BE_FIA_OUTFIT [0, 25, 50, 75]
#define BE_FIA_GARAGE_CAPACITY [6, 10, 15, 20]
#define BE_PERS_GARAGE_CAPACITY [2, 4, 6, 8]
#define BE_VEHICLE_RESTRICTION [["MBT", "APC", "Heli"], ["MBT", "Heli"], ["Heli"], ["none"]]
#define BE_FIA_HR_CAP [30, 60, 90, 120]
#define BE_FIA_CAMP_CAP [2, 3, 4, 5]
#define BE_FIA_RB_CAP [2, 4, 6, 10]
#define BE_FIA_WP_CAP [2, 3, 4, 6]
#define BE_FIA_RB_STYLE [0, 0, 1, 1]
#define BE_FIA_WP_STYLE [0, 0, 1, 1]

#define BE_UPGRADE_PRICES [14000, 40000, 60000]
#define BE_UPGRADE_DISCOUNT [0, 0, 0]

#define BE_COLOR_DONE "#1DA81D"
#define BE_COLOR_LOCK "#D8480A"
#define BE_COLOR_DEF "#C1C0BB"

#define BE_DISC_ONE 1000
#define BE_DISC_TWO 1500
#define BE_DISC_THREE 2000

fnc_BE_initialize = {
	if !(isNil "BE_INIT") exitWith {};

	BE_INIT = true;

	BE_currentStage = 0;
	BE_currentXP = 0;
	BE_currentPrice = 0;
	BE_progressLock = false;
	BE_current_vehicles = [];

	BE_class_Heli = heli_unarmed + heli_armed + opAir - opCASFW;
	BE_class_MBT = vehTank + ["DGC_FIAVEH_MBT_03_cannon_F"];
	BE_class_APC = vehAPC + vehIFV + ["DGC_FIAVEH_APC_Wheeled_03_cannon_F", "DGC_FIAVEH_APC_Tracked_03_cannon_F"];
	BE_class_MRAP = vehLead + standardMRAP + [opMRAPu] + ["DGC_FIAVEH_MRAP03_F", "DGC_FIAVEH_MRAP03_GMG_F", "DGC_FIAVEH_MRAP03_HMG_F"];

	BE_mil_vehicles = BE_class_Heli + BE_class_MBT + BE_class_APC + BE_class_MRAP;

	[] call fnc_BE_gearUpdate;
	[true] call fnc_BE_refresh;
};

fnc_BE_gearUpdate = {
	BE_defWeap = unlockedWeapons arrayIntersect (gear_assaultRifles + gear_machineGuns + gear_sniperRifles);
	BE_defVests = unlockedItems select {(getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type")) == 701};
	BE_defHelmets = unlockedItems select {(getNumber (configfile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type")) == 605};
	BE_defOptics = unlockedOptics;
};

fnc_BE_captureVehicle = {
	params ["_vehicle"];
	BE_vehiclesCaptured pushBack _vehicle;
};

fnc_BE_refresh = {
	params [["_init", false]];

	BE_current_FIA_Skill_Cap = BE_FIA_SKILL_CAP select BE_currentStage;
	BE_current_FIA_Outfit = BE_FIA_OUTFIT select BE_currentStage;
	BE_current_FIA_GarageCap = BE_FIA_GARAGE_CAPACITY select BE_currentStage;
	BE_current_Pers_GarageCap = BE_PERS_GARAGE_CAPACITY select BE_currentStage;
	BE_current_Vehicle_Restriction = BE_VEHICLE_RESTRICTION select BE_currentStage;
	BE_current_FIA_HR_Cap = BE_FIA_HR_CAP select BE_currentStage;
	BE_current_FIA_Camp_Cap = BE_FIA_CAMP_CAP select BE_currentStage;
	BE_current_FIA_RB_Cap = BE_FIA_RB_CAP select BE_currentStage;
	BE_current_FIA_WP_Cap = BE_FIA_WP_CAP select BE_currentStage;
	BE_current_FIA_RB_Style = BE_FIA_RB_STYLE select BE_currentStage;
	BE_current_FIA_WP_Style = BE_FIA_WP_STYLE select BE_currentStage;

	[] call fnc_BE_pushVariables;
	[] call fnc_BE_updateProgressBar;
	if !(_init) then {[] call fnc_BE_calcPrice};

	BE_currentRestrictions = [
		BE_current_FIA_Skill_Cap,
		BE_current_FIA_Outfit,
		BE_current_FIA_GarageCap,
		BE_current_Pers_GarageCap,
		BE_current_Vehicle_Restriction,
		BE_current_FIA_HR_Cap,
		BE_current_FIA_Camp_Cap,
		BE_current_FIA_RB_Cap,
		BE_current_FIA_WP_Cap,
		BE_current_FIA_RB_Style,
		BE_current_FIA_WP_Style];
};

fnc_BE_pushVariables = {
	publicVariable "BE_current_FIA_Skill_Cap";
	publicVariable "BE_current_FIA_Outfit";
	publicVariable "BE_current_FIA_GarageCap";
	publicVariable "BE_current_Pers_GarageCap";
	publicVariable "BE_current_Vehicle_Restriction";
	publicVariable "BE_current_FIA_HR_Cap";
	publicVariable "BE_current_FIA_Camp_Cap";
	publicVariable "BE_current_FIA_RB_Cap";
	publicVariable "BE_current_FIA_WP_Cap";
	publicVariable "BE_current_FIA_RB_Style";
	publicVariable "BE_current_FIA_WP_Style";

	publicVariable "BE_class_Heli";
	publicVariable "BE_class_MBT";
	publicVariable "BE_class_APC";
	publicVariable "BE_class_MRAP";
	publicVariable "BE_mil_vehicles";

	publicVariable "activeBE";
	publicVariable "BE_currentStage";
	publicVariable "BE_currentPrice";
};

fnc_BE_XP = {
	params ["_category", ["_amount", 1]];
	private _delta = 0;

	if ((BE_currentStage > 3) || (BE_progressLock)) exitWith {};

	switch (_category) do {
		case "kill": {
			_delta = BE_XP_KILL;
		};
		case "mis": {
			_delta = BE_XP_MIS;
		};
		case "des_veh": {
			_delta = BE_XP_DES_VEH;
		};
		case "des_arm": {
			_delta = BE_XP_DES_ARM;
		};
		case "cap_veh": {
			_delta = BE_XP_CAP_VEH;
		};
		case "cap_arm": {
			_delta = BE_XP_CAP_ARM;
		};
		case "con_ter": {
			_delta = BE_XP_CON_TER;
		};
		case "con_bas": {
			_delta = BE_XP_CON_BAS;
		};
		case "con_cit": {
			_delta = BE_XP_CON_CIT;
		};
		case "cl_loc": {
			_delta = BE_XP_CL_LOC;
		};
		case "unl_wpn": {
			_delta = _amount * BE_XP_UNL_WPN;
		};
		default {
			diag_log format ["Error in BE module XP - param 1: %1", _category];
		};
	};

	BE_currentXP = BE_currentXP + _delta;
	[] call fnc_BE_updateProgressBar;

	diag_log format ["BE - module XP -- cat: %1; delta: %2; progress: %3", _category, _delta, BE_currentXP];
};

fnc_BE_updateProgressBar = {
	private ["_req", "_cV", "_pV", "_v"];

	_req = BE_REQ_XP select BE_currentStage;
	_cV = BE_currentXP / _req;
	_v = server getVariable ["skillFIA", 0];

	if (BE_progressLock) exitWith {
		_pV = [BE_COLOR_LOCK, BE_COLOR_LOCK, BE_current_FIA_Skill_Cap, BE_current_FIA_Skill_Cap+1, "Army XP"];
		BE_currentXP = 0;
		["Army XP", [_pV, _cV, "BE_PBar"]] call AS_fnc_updateProgressBar;
	};

	_pV = [BE_COLOR_DONE, BE_COLOR_DEF, _v, _v+1, "Army XP"];

	if (_cV > 1) then {
		server setVariable ["skillFIA", _v+1, true];
		BE_currentXP = BE_currentXP - _req;
		if ((_v+1) >= BE_current_FIA_Skill_Cap) then {
			_pV = [BE_COLOR_LOCK, BE_COLOR_LOCK, BE_current_FIA_Skill_Cap, BE_current_FIA_Skill_Cap+1, "Army XP"];
			BE_progressLock = true;
			BE_currentXP = 0;
		};
		[format ["<t color='#1DA81D'>New FIA Skill Level: %1</t>", _v+1],0,0,4,0,0,4] remoteExec ["bis_fnc_dynamicText", Slowhand];
		[] spawn {sleep 2; [] call fnc_BE_updateProgressBar};
	};

	["Army XP", [_pV, _cV, "BE_PBar"]] call AS_fnc_updateProgressBar;
};

fnc_BE_REQs = {
	private ["_reqs", "_result", "_multi"];

	_result = 0;
	_multi = 0;

	call {
		if (BE_currentStage == 0) exitWith {
			_reqs = BE_reqs_0;
			_multi = BE_DISC_ONE;
		};
		if (BE_currentStage == 1) exitWith {
			_reqs = BE_reqs_1;
			_multi = BE_DISC_TWO;
		};
		if (BE_currentStage == 2) exitWith {
			_reqs = BE_reqs_2;
			_multi = BE_DISC_THREE;
		};
	};

	{
		if ((call _x) select 0) then {_result = _result +1 };
	} forEach _reqs;

	_result * _multi
};

fnc_BE_calcPrice = {
	if (BE_currentStage >= 3) exitWith {
		BE_currentPrice = "No further training available.";
		publicVariable "BE_currentPrice";
	};
	private _price = BE_UPGRADE_PRICES select BE_currentStage;

	_price = _price - ((call fnc_BE_REQs) min (BE_UPGRADE_DISCOUNT select BE_currentStage));
	BE_currentPrice = _price;
	publicVariable "BE_currentPrice";

	_price
};

fnc_BE_buyUpgrade = {
	if (BE_currentStage == 3) exitWith {
		[petros,"hint","No further training available."] remoteExec ["commsMP",Slowhand];
	};
	private _price = call fnc_BE_calcPrice;

	if ((server getVariable "resourcesFIA") > BE_currentPrice) then {
		[_price] call fnc_BE_upgrade;
		diag_log format ["Maintenance: upgrade acquired. New stage: %1; price paid: %2", BE_currentStage, BE_currentPrice];
	} else {
		[petros,"hint","We don't have the resources."] remoteExec ["commsMP",Slowhand];
	};
};

fnc_BE_upgrade = {
	params [["_price", 10000]];

	private _tempFunds = server getVariable "resourcesFIA";
	server setVariable ["skillFIA", BE_current_FIA_Skill_Cap, true];
	server setVariable ["resourcesFIA", _tempFunds - _price, true];
	BE_currentStage = BE_currentStage + 1;
	[] call fnc_BE_refresh;
	BE_progressLock = false;

	switch (BE_currentStage) do {
		case 1: {
			[10,0] remoteExec ["prestige",2];
		};
		case 2: {
			[20,0] remoteExec ["prestige",2];
		};
		case 3: {
			[30,0] remoteExec ["prestige",2];
		};
		default {
		};
	};

	[] call fnc_BE_updateProgressBar;
};

fnc_BE_save = {
	private _result = [];
	private _current_vehicles = [];

	_result pushBack BE_currentStage;
	_result pushBack "legacy";
	_result pushBack BE_currentXP;
	_result pushBack _current_vehicles;
	_result pushBack [BE_defWeap, BE_defVests, BE_defHelmets, BE_defOptics];
	_result pushBack BE_progressLock;

	_result
};

fnc_BE_load = {
	params ["_save"];

	BE_currentStage = _save select 0;
	BE_currentXP = _save select 2;
	BE_current_vehicles = _save select 3;
	if (count _save > 4) then {
		BE_defWeap = (_save select 4) select 0;
		BE_defVests = (_save select 4) select 1;
		BE_defHelmets = (_save select 4) select 2;
		BE_defOptics = (_save select 4) select 3;
		BE_progressLock = _save select 5;
	};

	if (BE_current_FIA_WP_Style > 0) then {
		private ["_posDes", "_remDes", "_normalPos"];
		{
			_posDes = [getMarkerPos _x, 5, round (random 359)] call BIS_Fnc_relPos;
			_remDes = ([_posDes, 0,guer_rem_des, side_blue] call bis_fnc_spawnvehicle) select 0;
			_normalPos = surfaceNormal (position _remDes);
			_remDes setVectorUp _normalPos;
		} forEach FIA_WP_list;
	};

	[] call fnc_BE_refresh;
};

fnc_BE_permission = {
	params ["_category", ["_value", 1], ["_vehicle", ""]];

	private _result = false;
	private _return = -1;

	switch (_category) do {
		case "skill": {
			if (BE_current_FIA_Skill_Cap > (server getVariable "skillFIA")) then {
				_result = true;
			};
		};
		case "FIA_garage": {
			if (BE_current_FIA_GarageCap > (count vehInGarage)) then {
				_result = true;
			};
		};
		case "pers_garage": {
			if (BE_current_Pers_GarageCap > (count personalGarage)) then {
				_result = true;
			};
		};
		case "vehicle": {
			_result = true;

			if ((_value in BE_class_MBT) && ("MBT" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};
			if ((_value in BE_class_APC) && ("APC" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};
			if ((_value in BE_class_Heli) && ("Heli" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};

			_vehClass = getText (configFile >> "CfgVehicles" >> _value >> "vehicleClass");
			if (((toLower _vehClass find "heli" >= 0) || (_vehClass == "Air")) && ("Heli" in BE_current_Vehicle_Restriction)) exitWith {_result = false};

			if (!(_vehicle getVariable ["BE_mil_veh", false]) && (_value in BE_mil_vehicles)) then {
				call {
					if (_vehicle in BE_class_MBT) exitWith {["cap_arm"] remoteExec ["fnc_BE_XP", 2]};
					if (_vehicle in BE_class_APC) exitWith {["cap_arm"] remoteExec ["fnc_BE_XP", 2]};
					if (_vehicle in BE_class_MRAP) exitWith {["cap_veh"] remoteExec ["fnc_BE_XP", 2]};
				};
			};
		};
		case "HR": {
			if (BE_current_FIA_HR_Cap > (server getVariable "hr")) then {
				_result = true;
				_return = BE_current_FIA_HR_Cap - (server getVariable "hr");
			} else {
				_return = 0;
			};
		};
		case "camp": {
			if (BE_current_FIA_Camp_Cap > (count campsFIA)) then {
				_result = true;
			};
		};
		case "RB": {
			if (BE_current_FIA_RB_Cap > (count FIA_RB_list)) then {
				_result = true;
			};
		};
		case "WP": {
			if (BE_current_FIA_WP_Cap > (count FIA_WP_list)) then {
				_result = true;
			};
		};

		default {
			diag_log format ["Error in BE module permission - param 1:%1; param 2: %2", _category, _delta];
		};
	};

	[_result, _return] select (_return > -1);
};

publicVariable "fnc_BE_permission";


fnc_BE_getCurrentValue = {
	params ["_category"];

	private _result = 0;

	switch (_category) do {
		case "HR": {
			_result = BE_current_FIA_HR_Cap - (server getVariable "hr");
		};
		case "outfit": {
			_result = BE_current_FIA_Outfit;
		};
		case "RB_type": {
			_result = BE_current_FIA_RB_Style;
		};
		case "WP_type": {
			_result = BE_current_FIA_WP_Style;
		};

		default {
			diag_log format ["Error in BE module permission - param 1:%1; param 2: %2", _category, _delta];
		};
	};

	_result
};

publicVariable "fnc_BE_getCurrentValue";

fnc_BE_broadcast = {
	params ["_type", "_reqs", "_data", "_bool", "_str", "_boolStr"];
	private _pI = [];

	[] call fnc_BE_refresh;

	if (_type == "progress") then {

		call {
			if (BE_currentStage == 0) exitWith {
				_reqs = BE_reqs_0;
			};
			if (BE_currentStage == 1) exitWith {
				_reqs = BE_reqs_1;
			};
			if (BE_currentStage == 2) exitWith {
				_reqs = BE_reqs_2;
			};
		};

		{
			_data = call _x;
			_bool = _data select 0;
			_str = _data select 1;

			_boolStr = ["not satisfied", "satisfied"] select _bool, true;
			_pI pushBack (format ["Requirement: %1 \nStatus: %2", _str, _boolStr]);
		} forEach _reqs;
	};

	if (_type == "restrictions") then {
		_pI pushBackUnique (format ["Current FIA skill cap: %1", BE_current_FIA_Skill_Cap]);
		_pI pushBackUnique (format ["Current FIA outfit percentage: %1", BE_current_FIA_Outfit]);
		//_pI pushBackUnique (format ["Current FIA garage size: %1", BE_current_FIA_GarageCap]);
		//_pI pushBackUnique (format ["Current personal garage size: %1", BE_current_Pers_GarageCap]);
		//_pI pushBackUnique (format ["Currently restricted vehicles: %1", BE_current_Vehicle_Restriction]);
		_pI pushBackUnique (format ["Current FIA manpower cap: %1", BE_current_FIA_HR_Cap]);
		_pI pushBackUnique (format ["Current FIA camp cap: %1", BE_current_FIA_Camp_Cap]);
		_pI pushBackUnique (format ["Current FIA roadblock cap: %1", BE_current_FIA_RB_Cap]);
		_pI pushBackUnique (format ["Current FIA watchpost cap: %1", BE_current_FIA_WP_Cap]);
		_pI pushBackUnique (format ["Current FIA roadblock type: %1", ["simple", "advanced"] select (BE_current_FIA_RB_Style > 0)]);
		_pI pushBackUnique (format ["Current FIA watchpost type: %1", ["simple", "advanced"] select (BE_current_FIA_WP_Style > 0)]);
	};

	[petros,"BE",_pI] remoteExec ["commsMP",Slowhand];
};

#define BE_STR_CTER1 "At least 1 outpost/base/airport under your control"
#define BE_STR_CTER2 "At least 1 base/airport under your control"
#define BE_STR_CTER3 "At least 1 airport under your control"
fnc_BE_C_TER = {
	private _base = aeropuertos;
	BE_STR_CTER = BE_STR_CTER3;
	call {
		if (BE_currentStage == 1) exitWith {
			_base = _base + bases;
			BE_STR_CTER = BE_STR_CTER2;
		};
		if (BE_currentStage == 0) exitWith {
			_base = _base + puestos + puestosAA;
			BE_STR_CTER = BE_STR_CTER1;
		};
	};

	[(count (mrkFIA arrayIntersect _base) > 0), BE_STR_CTER]
};

#define BE_STR_CWPN1 "At least 2 primary weapons unlocked in the arsenal"
#define BE_STR_CWPN2 "At least 4 primary weapons unlocked in the arsenal"
#define BE_STR_CWPN3 "At least 6 primary weapons unlocked in the arsenal"
fnc_BE_C_WPN = {
	private _base = gear_assaultRifles + gear_machineGuns + gear_sniperRifles - BE_defWeap;
	private _minVal = 6;
	BE_STR_CWPN = BE_STR_CWPN3;
	call {
		if (BE_currentStage == 1) exitWith {
			_minVal = 4;
			BE_STR_CWPN = BE_STR_CWPN2;
		};
		if (BE_currentStage == 0) exitWith {
			_minVal = 2;
			BE_STR_CWPN = BE_STR_CWPN1;
		};
	};

	[(count (_base arrayIntersect unlockedWeapons) >= _minVal), BE_STR_CWPN]
};

#define BE_STR_CHEL1 ""
#define BE_STR_CHEL2 "At least 1 helmet unlocked in the arsenal"
#define BE_STR_CHEL3 "At least 1 helmet unlocked in the arsenal"
fnc_BE_C_HEL = {
	private _base = genHelmets - BE_defHelmets;
	BE_STR_CHEL = BE_STR_CHEL3;

	[(count (_base arrayIntersect unlockedItems) > 0), BE_STR_CHEL]
};

#define BE_STR_CVES1 "At least 1 vest unlocked in the arsenal"
#define BE_STR_CVES2 "At least 1 vest unlocked in the arsenal"
#define BE_STR_CVES3 "At least 1 vest unlocked in the arsenal"
fnc_BE_C_VES = {
	private _base = genVests - BE_defVests;
	BE_STR_CVES = BE_STR_CVES3;

	[(count (_base arrayIntersect unlockedItems) > 0), BE_STR_CVES]
};

#define BE_STR_COPT1 "At least 1 optic unlocked in the arsenal"
#define BE_STR_COPT2 ""
#define BE_STR_COPT3 ""
fnc_BE_C_OPT = {
	BE_STR_COPT = BE_STR_COPT1;
	[(count (unlockedOptics - BE_defOptics) > 0), BE_STR_COPT]
};

#define BE_STR_CNVG1 ""
#define BE_STR_CNVG2 ""
#define BE_STR_CNVG3 "NVGs unlocked in the arsenal"
fnc_BE_C_NVG = {
	BE_STR_CNVG = BE_STR_CNVG3;
	[(indNVG in unlockedItems), BE_STR_CNVG]
};

#define BE_STR_CAT1 "At least 1 type of AT unlocked in the arsenal"
#define BE_STR_CAT2 "At least 1 type of AT unlocked in the arsenal"
#define BE_STR_CAT3 "At least 1 type of AT unlocked in the arsenal"
fnc_BE_C_AT = {
	BE_STR_CAT = BE_STR_CAT3;
	[!(server getVariable ["genATlocked", false]), BE_STR_CAT]
};

#define BE_STR_CAA1 ""
#define BE_STR_CAA2 "At least 1 type of AA unlocked in the arsenal"
#define BE_STR_CAA3 "At least 1 type of AA unlocked in the arsenal"
fnc_BE_C_AA = {
	BE_STR_CAA = BE_STR_CAA3;
	[!(server getVariable ["genAAlocked", false]), BE_STR_CAA]
};
/*
#define BE_STR_CMTN1 ""
#define BE_STR_CMTN2 "Have cleared at least 1 CSAT hilltop"
#define BE_STR_CMTN3 ""
fnc_BE_C_MTN = {
	BE_STR_CMTN = BE_STR_CMTN2;
	[(count (colinasAA arrayIntersect mrkFIA) > 0), BE_STR_CMTN]
};*/ // Stef 31-08

#define BE_STR_CATM1 ""
#define BE_STR_CATM2 ""
#define BE_STR_CATM3 "AT mines unlocked in the arsenal"
fnc_BE_C_ATM = {
	BE_STR_CATM = BE_STR_CATM3;
	[(atMine in unlockedMagazines), BE_STR_CATM]
};

#define BE_STR_CHR1 "Have at least 20 HR"
#define BE_STR_CHR2 "Have at least 40 HR"
#define BE_STR_CHR3 "Have at least 60 HR"
fnc_BE_C_HR = {
	private _minVal = 60;
	BE_STR_CHR = BE_STR_CHR3;
	call {
		if (BE_currentStage == 1) exitWith {
			_minVal = 40;
			BE_STR_CHR = BE_STR_CHR2;
		};
		if (BE_currentStage == 0) exitWith {
			_minVal = 20;
			BE_STR_CHR = BE_STR_CHR1;
		};
	};

	[((server getVariable ["hr", 0]) >= _minVal), BE_STR_CHR]
};

/*
fnc_BE_C_VEH = {
	private _type = BE_class_MBT;
	private _minVal = 1;
	private _result = 0;
	BE_STR_CVEH = BE_STR_CVEH3;

	call {
		if (BE_currentStage == 1) exitWith {
			_type = BE_class_APC;
			_minVal = 2;
			BE_STR_CVEH = BE_STR_CVEH2;
		};
		if (BE_currentStage == 0) exitWith {
			_type = BE_class_MRAP;
			_minVal = 2;
			BE_STR_CVEH = BE_STR_CVEH1;
		};
	};

	{
		if (_x in _type) then {_result = _result + 1};
	//} forEach BE_vehiclesCaptured;
	} forEach vehInGarage;

	[(_result >= _minVal), BE_STR_CVEH]
};*/ //Stef 31-08 can't get them from JAGS

BE_reqs_0 = [fnc_BE_C_TER, fnc_BE_C_HR]; //Stef 31-08 removed impossible requirements for current version
BE_reqs_1 = [fnc_BE_C_TER, fnc_BE_C_HR];
BE_reqs_2 = [fnc_BE_C_TER, fnc_BE_C_HR];