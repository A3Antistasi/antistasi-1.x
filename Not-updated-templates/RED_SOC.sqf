// (un-)armed transport helicopters
opHeliTrans = 		["RHS_UH60M","RHS_CH_47F"];

// helicopter that dismounts troops
opHeliDismount = 	"RHS_CH_47F"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"RHS_MELB_MH6M"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"RHS_UH60M"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"RHS_AH64D_wd"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["rhsusf_f22"]; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"B_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["RHS_UH60M","RHS_CH_47F","RHS_AH64D_wd","RHS_MELB_MH6M","rhsusf_f22"];

// self-propelled anti air
opSPAA = 			"RHS_M6_wd";

opTruck = 			"rhsusf_M1083A1P2_B_wd_fmtv_usarmy";

opMRAPu = 			"rhsusf_rg33_usmc_wd";

opIFV = 			["RHS_M2A2_wd","RHS_M2A2_BUSKI_WD"];

opArtillery = 		"rhsusf_m109_usarmy";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"rhsusf_usmc_marpat_wd_officer"; // officer/official
opI_PIL = 	"rhsusf_socom_swcc_officer"; // pilot
opI_OFF2 = 	"B_G_Soldier_unarmed_F"; // officer/traitor
opI_CREW = 	"rhsusf_socom_swcc_crewman"; // crew
opI_MK = 	"rhsusf_socom_marsoc_sniper";
opI_MED =	"rhsusf_socom_marsoc_sarc";
opI_RFL1 = 	"rhsusf_socom_marsoc_cso";
opI_RFL2 = 	"rhsusf_socom_marsoc_cso_light";
opI_AR = 	"rhsusf_socom_marsoc_spotter";
opI_AR2 = 	"rhsusf_socom_marsoc_cso_light";
opI_SL = 	"rhsusf_socom_marsoc_teamleader";
opI_MK2 = 	"rhsusf_socom_marsoc_sniper_m107";
opI_AAR = 	"rhsusf_socom_marsoc_jtac";
opI_SP = 	"rhsusf_socom_marsoc_cso_mechanic";
opI_GL =	"rhsusf_socom_marsoc_cso_grenadier";
opI_LAT = 	"rhsusf_socom_marsoc_cso_breacher";

// config path for infantry groups (not used)
opCfgInf = 			(configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_recon_wd_infantry");

// standard group arrays, used for spawning groups
opGroup_Sniper = 		[opI_MK, opI_MK2]; // sniper team
opGroup_SpecOps = 		[opI_SL, opI_MK, opI_MED, opI_RFL1, opI_RFL2, opI_GL, opI_LAT]; // spec opcs
opGroup_Squad = 		[opI_SL, opI_AR, opI_AAR, opI_MK, opI_SP, opI_MED, opI_GL, opI_LAT]; // squad
opGroup_Recon_Team = 	[opI_SL, opI_MK, opI_LAT, opI_MED];
opGroup_Security = 		[opI_SL, opI_AR2, opI_RFL2, opI_MED]; // security detail

// the affiliation
side_red = 			west;

opFlag = 			"Flag_NATO_F";

opIR = "rhsusf_acc_anpeq15side";

opCrate = "Box_NATO_WpsLaunch_F";

// Colour of this faction's markers
OPFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
OPFOR_marker_type = "flag_USA";

// Name of the faction
A3_Str_RED = localize "STR_GENIDENT_SOC";