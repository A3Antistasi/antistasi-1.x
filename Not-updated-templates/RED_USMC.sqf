// (un-)armed transport helicopters
opHeliTrans = 		["RHS_UH1Y_UNARMED","rhsusf_CH53E_USMC_D"];

// helicopter that dismounts troops
opHeliDismount = 	"rhsusf_CH53E_USMC_D"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"RHS_UH1Y_UNARMED"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"RHS_UH1Y_GS"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"RHS_AH1Z_wd"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["RHS_A10"]; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"B_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["RHS_UH1Y_UNARMED","rhsusf_CH53E_USMC_D","RHS_AH1Z_wd","RHS_A10","RHS_UH1Y_GS","rhsusf_f22"];

// self-propelled anti air
opSPAA = 			"RHS_M6_wd";

opTruck = 			"rhsusf_M1083A1P2_B_wd_fmtv_usarmy";

opMRAPu = 			"rhsusf_rg33_d";

opIFV = 			["RHS_M2A2_wd","RHS_M2A2_BUSKI_WD"];	 //Using bradleys as RHS doesn't inlclude marine IFVs

opArtillery = 		"rhsusf_m109d_usarmy";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"rhsusf_usmc_marpat_wd_officer"; // officer/official
opI_PIL = 	"rhsusf_usmc_marpat_wd_helipilot"; // pilot
opI_OFF2 = 	"B_G_Soldier_unarmed_F"; // officer/traitor
opI_CREW = 	"rhsusf_usmc_marpat_wd_crewman"; // crew
opI_MK = 	"rhsusf_usmc_recon_marpat_wd_marksman_lite";
opI_MED =	"rhsusf_usmc_recon_marpat_wd_rifleman_lite";
opI_RFL1 = 	"rhsusf_usmc_marpat_wd_rifleman_m4";
opI_RFL2 = 	"rhsusf_usmc_recon_marpat_wd_rifleman_lite";
opI_AR = 	"rhsusf_usmc_marpat_wd_machinegunner";
opI_AR2 = 	"rhsusf_usmc_recon_marpat_wd_autorifleman_lite";
opI_SL = 	"rhsusf_usmc_recon_marpat_wd_teamleader_lite";
opI_MK2 = 	"rhsusf_usmc_recon_marpat_wd_sniper_M107";
opI_AAR = 	"rhsusf_usmc_marpat_wd_machinegunner_ass";
opI_SP = 	"rhsusf_usmc_recon_marpat_wd_machinegunner_m249_lite";
opI_GL =	"rhsusf_usmc_marpat_wd_grenadier";
opI_LAT = 	"rhsusf_usmc_recon_marpat_wd_rifleman_at_lite";

// config path for infantry groups
opCfgInf = 			(configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_recon_wd_infantry");

// standard group arrays, used for spawning groups
opGroup_Sniper = 		[opI_AR2, opI_MK2]; // sniper team
opGroup_SpecOps = 		[opI_SL, opI_MK, opI_MED, opI_RFL1, opI_RFL2, opI_AR2, opI_LAT]; // spec opcs
opGroup_Squad = 		[opI_RFL1, opI_AR, opI_AAR, opI_MK, opI_SP, opI_MED, opI_GL, opI_LAT]; // squad
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
A3_Str_RED = localize "STR_GENIDENT_USMC";