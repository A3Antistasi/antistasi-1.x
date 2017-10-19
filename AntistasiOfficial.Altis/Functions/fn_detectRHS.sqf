private ["_hostilesMain", "_hostilesSupport", "_friendlySupport"];

// Indicators for the presence of each RHS module
activeAFRF = false;
activeUSAF = false;
activeGREF = false;
activeBW = false;

// Initial side definitions, which might be overwritten by the templates
side_blue = west;
side_green = independent;
side_red = east;

// RHS detection, using the previously created list of all weapons
if ("rhs_weap_akms" in gear_allWeapons) then {
	activeAFRF = true;
};
if ("rhs_weap_m4a1_d" in gear_allWeapons) then {
	activeUSAF = true;
};
if ("rhs_weap_m92" in gear_allWeapons) then {
	activeGREF = true;
};
if ("BWA3_P8" in gear_allWeapons) then {
	activeBW = true;
};

// Check if a GUER FIA is being used instead of a BLUFOR FIA
replaceFIA = false;
if (((side petros) == independent) OR ("respawn_guer" in allMapMarkers)) then {
	replaceFIA = true;
	static_playerSide = "G";
};

// Setup civilians, with Altis civilians as the default
call {
	if (worldName == "Altis") exitWith {
		call compile preprocessFileLineNumbers "Templates\CIV_ALTIS.sqf";
	};
	if (worldName == "Tanoa") exitWith {
 		call compile preprocessFileLineNumbers "Templates\CIV_TANOA.sqf";
	};

	call compile preprocessFileLineNumbers "Templates\CIV_ALTIS.sqf";
};

call {
	// GUER FIA
	if (replaceFIA) exitWith {
		call compile preprocessFileLineNumbers "Templates\PLAYER_IND_FIA.sqf";

		call {
			if (activeBW) exitWith {
				// Hostiles: Heer supported by KSK
				call compile preprocessFileLineNumbers "Templates\IND_BW.sqf";
				call compile preprocessFileLineNumbers "Templates\RED_KSK.sqf";
				_hostilesMain = "Heer"; _hostilesSupport = "KSK";

				// Friendly support: VMF
				call compile preprocessFileLineNumbers "Templates\BLUE_VMF.sqf";
				_friendlySupport = "VMF";
			};
			if (activeUSAF) then {
				// Hostiles: USMC supported by SOCOM
				call compile preprocessFileLineNumbers "Templates\IND_USMC.sqf";
				call compile preprocessFileLineNumbers "Templates\RED_SOC.sqf";
				_hostilesMain = "USMC"; _hostilesSupport = "SOCOM";
			} else {
				// Hostiles: NATO supported by NATO Special Forces
				call compile preprocessFileLineNumbers "Templates\IND_NATO.sqf";
				call compile preprocessFileLineNumbers "Templates\RED_NATO_SF.sqf";
				_hostilesMain = "NATO"; _hostilesSupport = "NATO SF";
			};

			if (activeAFRF) then {
				// Friendly support: VMF
				call compile preprocessFileLineNumbers "Templates\BLUE_VMF.sqf";
				_friendlySupport = "VMF";
			} else {
				// Friendly support: CSAT
				call compile preprocessFileLineNumbers "Templates\BLUE_CSAT.sqf";
				_friendlySupport = "CSAT";
			};
		};
	};

	// BLUFOR FIA
	call compile preprocessFileLineNumbers "Templates\PLAYER_FIA.sqf";

	if (activeAFRF) then {
		// Hostiles: VDV supported by VMF
		call compile preprocessFileLineNumbers "Templates\IND_AFRF.sqf";
		call compile preprocessFileLineNumbers "Templates\RED_VMF.sqf";
		_hostilesMain = "VDV"; _hostilesSupport = "VMF";
	} else {
		// Hostiles: AAF supported by CSAT
		call compile preprocessFileLineNumbers "Templates\IND_AAF.sqf";
		call compile preprocessFileLineNumbers "Templates\RED_CSAT.sqf";
		_hostilesMain = "AAF"; _hostilesSupport = "CSAT";
	};

	if (activeUSAF) then {
		// Friendly support: USAF
		call compile preprocessFileLineNumbers "Templates\BLUE_USAF.sqf";
		_friendlySupport = "USAF";
	} else {
		// Friendly support: NATO
		call compile preprocessFileLineNumbers "Templates\BLUE_NATO.sqf";
		_friendlySupport = "NATO";
	};
};

diag_log "Init: RHS detection done.";
diag_log format ["%1 FIA supported by %2 will be fighting against %3 supported by %4", ["BLUFOR", "GUER"] select replaceFIA, _friendlySupport, _hostilesMain, _hostilesSupport];

// Add rangefinder, missing ammo types, and create a list of all enemy enemy soldiers
gear_allWeapons pushBackUnique indRF;
[genWeapons, "genAmmo"] call AS_fnc_MAINT_missingAmmo;
units_enemySoldiers = infList_sniper + infList_NCO + infList_special + infList_auto + infList_regular + infList_crew + infList_pilots;

status_templatesLoaded = true;