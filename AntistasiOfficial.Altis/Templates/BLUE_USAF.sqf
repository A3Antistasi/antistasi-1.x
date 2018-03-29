//Blu USAF vehicles
	bluHeliTrans = 		["RHS_CH_47F_light"]; //Chinhook
	bluHeliTS = 		["RHS_MELB_MH6M"]; //small heli
	bluHeliDis = 		["RHS_UH60M"]; //Black hawk
	bluHeliRope = 		["RHS_CH_47F_light"];
	bluHeliArmed = 		["RHS_MELB_AH6M_H","RHS_MELB_AH6M_M"];
	bluHeliGunship = 	["RHS_AH64D_AA","RHS_AH64D_GS","RHS_AH64D"];
	bluCASFW = 			["RHS_A10"];
	bluTSairdrop =		["B_T_VTOL_01_vehicle_F"];

	bluAS = 			["rhsusf_f22"];
	bluC130 = 			["RHS_C130J"];

	bluUAV = 			["B_UAV_02_F"];

	planesNATO = bluHeliTrans + bluHeliArmed + bluHeliGunship + bluCASFW;
	planesNATOTrans = bluHeliTrans;


	bluMBT = 		["rhsusf_m1a2sep1wd_usarmy","rhsusf_m1a2sep1tuskiwd_usarmy"];
	bluAPC = 		["RHS_M2A3_wd","RHS_M2A3_BUSKI_wd"];
	bluIFV = 		["rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy_supply"];
	bluIFVAA = 		["RHS_M6_wd"];
	bluArty = 		["RHS_M119_W"]; bluArtyAmmoHE = "RHS_mag_m1_he_12"; bluArtyAmmoLaser = nil; bluArtyAmmoSmoke = "rhs_mag_m60a2_smoke_4";
	bluMLRS = 		["B_MBT_01_mlrs_F"];
	bluMRAP = 		["rhsusf_m1025_W","rhsusf_m998_w_4dr_halftop","rhsusf_m998_w_4dr_fulltop"];
	bluMRAPHMG = 	["rhsusf_m1025_W_m2","rhsusf_rg33_m2_W"];
	bluTruckTP = 	["rhsusf_M1083A1P2_B_M2_wd_fmtv_usarmy"];
	bluTruckMed = 	["rhsusf_M1083A1P2_B_M2_d_Medical_fmtv_usarmy"];
	bluTruckFuel = 	["rhsusf_M978A4_BKIT_usarmy_wd"];

	vehNATO = bluMBT + bluAPC + bluIFV + bluIFVAA + bluArty + bluMLRS + bluMRAP + bluMRAPHMG + bluTruckTP + bluTruckMed + bluTruckFuel;


	bluStatAA = 	["RHS_Stinger_AA_pod_WD"];
	bluStatAT = 	["RHS_TOW_TriPod_WD"];
	bluStatHMG = 	["RHS_M2StaticMG_WD"];
	bluStatMortar = ["RHS_M252_WD"];

//Blu USAF units
	bluCfgInf = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");

	bluPilot = 	"rhsusf_army_ocp_helipilot";
	bluCrew = 	"rhsusf_usmc_marpat_wd_combatcrewman";
	bluGunner = "rhsusf_usmc_marpat_wd_rifleman_light";

	bluMRAPHMGgroup = 	["rhsusf_usmc_fr_marpat_wd_riflemanat","rhsusf_usmc_fr_marpat_wd_rifleman","rhsusf_usmc_fr_marpat_wd_autorifleman_m249"];
	bluMRAPgroup = 		["rhsusf_usmc_fr_marpat_wd_teamleader","rhsusf_usmc_fr_marpat_wd_marksman","rhsusf_usmc_fr_marpat_wd_autorifleman"];


	bluAirCav = 	["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_marksman","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_riflemanat","rhsusf_usmc_marpat_wd_rifleman","rhsusf_usmc_marpat_wd_autorifleman_m249"];

	bluSquad = 			["rhs_group_nato_usmc_wd_infantry_squad"]; // 12
	bluSquadWeapons = 	["rhs_group_nato_usmc_wd_infantry_weaponsquad"]; // 7
	bluTeam = 			["rhs_group_nato_usmc_wd_infantry_team"]; // 4
	bluATTeam = 		["rhs_group_nato_usmc_wd_infantry_team_heavy_AT"]; // 4

	bluIR = 	"rhsusf_acc_anpeq15";

	bluFlag = 	"Flag_NATO_F";

//Vehicles to buy
	blubuyTruck =			"rhsusf_M1078A1P2_B_M2_D_fmtv_usarmy";
	blubuyAPC = 			"rhsusf_m113d_usarmy";
	blubuyMRAP = 			"rhsusf_rg33_m2_usmc_d";

//Airfield vehicle (max1)
	blubuyHeli = 			"RHS_MELB_MH6M";
//Seaport vehicle
	blubuyBoat = 			"rhsusf_mkvsoc";
//Special vehicle to buy (max 1)
	blubuyHumvee = 			"rhsusf_m1025_d_m2";

	blubuylist = [blubuyBoat,blubuyHeli,blubuyMRAP,blubuyAPC,blubuyTruck,blubuyHumvee];

//bluEquipment
	bluSmallWpn = 	[					// select reference
		"rhsusf_weap_MP7A2",      		// 0 SMG
		"rhs_weap_M590_5RD"     		// 1 SecondarySMG or Shotgun short
	];

	bluSmallAmmo = [					// select reference
		"rhsusf_mag_40Rnd_46x30_FMJ",  	// 0 SMG ammo
		"rhsusf_5Rnd_Slug"				// 1 SecondarySMG ammo
	];

	bluRifle = 	[ 						// select random
		"rhs_weap_hk416d10_m320",
		"rhs_weap_m4_m320",
		"rhs_weap_mk18_m320"
	];

	bluRifleAmmo = [					// select random (this might require a tweak if blurifle have rifle with different ammo, try to keep the same)
		"rhs_mag_30Rnd_556x45_M855_Stanag",
		"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red"
	];

	bluGL = [
		"rhs_weap_hk416d10_m320",
		"rhs_weap_m4_m320",
		"rhs_weap_mk18_m320"
	];

	bluGLsmoke = [
		"rhs_mag_m662_red",
		"rhs_mag_m661_green",
		"rhs_mag_m713_Red",
		"rhs_mag_m715_Green"
	];

	bluSNPR = 	[
		"rhs_weap_m24sws",		//Tier 1
		"rhs_weap_XM2010"		//Tier 2
	];

	bluSNPRAmmo = [
		"rhsusf_5Rnd_762x51_m118_special_Mag",	//Tier1
		"rhsusf_5Rnd_300winmag_xm2010"			//Tier2
	];

	bluLMG = 	[
		"rhs_weap_m249_pip_S_vfg",	//Tier1
		"rhs_weap_m249_pip_S_vfg"	//Tier2
	];

	bluLMGAmmo = [
		"rhsusf_100Rnd_556x45_soft_pouch",	//Tier1
		"rhsusf_100Rnd_556x45_soft_pouch"	//Tier 2
	];

	bluAT = [
		"rhs_weap_M136_hedp",	//Tier 1 Standard, single use
		"rhs_weap_smaw_optic",	//Tier 2
		"rhs_weap_fgm148"		//Tier 3

	];

	bluATMissile = [
		"",								//Tier 1
		"rhs_mag_smaw_HEAA",			//Only high tier
		"rhs_fgm148_magazine_AT"		//Locking
	];

	bluAA = [
		"rhs_weap_fim92"		//Higher tier
	];

	bluAAMissile = [
		"rhs_fim92_mag"		//Higher tier
	];

	bluVest = [				//Need to check stats
		"rhsusf_spc_rifleman",
		"rhsusf_spc_crewman"
	];

	bluScopes = [					// Preferibly only PIP compatible = more realisitc
		"rhsusf_acc_SpecterDR_3d",	//Rifle scope
		"rhsusf_acc_ACOG_MDO",		//LMG scope
		"rhsusf_acc_LEUPOLDMK4_2_d"	//Snipe scope
	];

	bluAttachments = [
		"rhsusf_acc_anpeq15_light", //anpeq with laser + flashlight
		"rhsusf_acc_nt4_black"		//Higer tier only
	];

	blunvg = [
	"rhsusf_ANPVS_15"
	];

	bluHelmet = [
	"rhsusf_opscore_bk_pelt",					// Tier 1
	"rhsusf_ach_bare_des_headset",				// Tier 2
	"rhsusf_mich_bare_norotos_semi_headset"		// Tier 3
	];


genGL = genGL + bluGL;
genATLaunchers = genATLaunchers + bluAT;
genAALaunchers = genAALaunchers + bluAA;

// Colour of this faction's markers
BLUFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
BLUFOR_marker_type = "flag_USA";

// Name of the faction
A3_Str_BLUE = localize "STR_GENIDENT_USMC";