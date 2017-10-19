// (un-)armed transport helicopters
opHeliTrans = 		["AW159_BW_Black_Unbewaffnet","NH_90_Black"];

// helicopter that dismounts troops
opHeliDismount = 	"NH_90_Black"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"AW159_BW_Black_Unbewaffnet"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"AW159_BW_Black"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"BWA3_Tiger_RMK_Heavy"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["heeresflieger_1"]; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"B_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["AW159_BW_Black_Unbewaffnet","NH_90_Black","BWA3_Tiger_RMK_Heavy","heeresflieger_1"];

// self-propelled anti air
opSPAA = 			"BWA3_Puma_Fleck";

opTruck = 			"BW_LKW_Transport_offen_fleck";

opMRAPu = 			"BWA3_Eagle_Fleck";

opIFV = 			["BWA3_Puma_Fleck","BWA3_Puma_Fleck"];

opArtillery = 		"rhsusf_m109_usarmy";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"BWA3_Officer_Fleck"; // officer/official
opI_PIL = 	"BWA3_Helipilot"; // pilot
opI_OFF2 = 	"B_G_Soldier_unarmed_F"; // officer/traitor
opI_CREW = 	"BWA3_Crew_Fleck"; // crew
opI_MK = 	"BWA3_recon_Marksman_Fleck";
opI_MED =	"BWA3_recon_Medic_Fleck";
opI_RFL1 = 	"BWA3_recon_Pioneer_Fleck";
opI_RFL2 = 	"BWA3_recon_Fleck";
opI_AR = 	"BWA3_recon_Pioneer_Fleck";
opI_AR2 = 	"BWA3_recon_Pioneer_Fleck";
opI_SL = 	"BWA3_recon_TL_Fleck";
opI_MK2 = 	"BWA3_Spotter_Fleck";
opI_AAR = 	"BWA3_recon_Pioneer_Fleck";
opI_SP = 	"BWA3_SniperG82_Fleck";
opI_GL =	"BWA3_recon_Pioneer_Fleck";
opI_LAT = 	"BWA3_recon_LAT_Fleck";

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

opFlag = 			"BWA3_Flag_Ger_F";

opIR = "rhsusf_acc_anpeq15side";

opCrate = "Box_NATO_WpsLaunch_F";

// Colour of this faction's markers
OPFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
OPFOR_marker_type = "flag_Germany";

// Name of the faction
A3_Str_RED = localize "STR_GENIDENT_KSK";