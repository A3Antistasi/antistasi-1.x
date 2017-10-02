/*
List of infantry classes. These will have individual skills and equipment mapped to them.
If you wish to add more soldiers beyond the available variables, you also need to add any new variables to genInit.sqf and genInitBASES.sqf.

Note: all classes marked as "extra" do not have a unique class in this template. They are, however, part of other templates and are therfore included in all templates.
*/
sol_A_AA = 	"BWA3_RiflemanAA_Fliegerfaust_Fleck"; // Assistant AA (extra)
sol_A_AR = 	"BWA3_Autorifleman_Fleck"; // Assistant autorifle
sol_A_AT = 	"BWA3_RiflemanAT_Pzf3_Fleck"; // Assistant AT
sol_AA = 	"BWA3_RiflemanAA_Fliegerfaust_Fleck"; // AA
sol_AR = 	"BWA3_AutoriflemanMG5_Fleck"; // Autorifle
sol_AT = 	"BWA3_RiflemanAT_Pzf3_Fleck"; // AT
sol_AMMO = 	"BWA3_RiflemanAT_CG_Fleck"; // Ammo bearer (extra)
sol_GL = 	"BWA3_Grenadier_Fleck"; // Grenade launcher
sol_GL2 = 	"BWA3_GrenadierG27_Fleck"; // Grenade launcher
sol_LAT = 	"BWA3_RiflemanAT_RGW90_Fleck"; // Light AT
sol_LAT2 = 	"BWA3_RiflemanAT_RGW90_Fleck"; // Light AT
sol_MG = 	"BWA3_Autorifleman_Fleck"; // Machinegunner
sol_MK = 	"BWA3_Marksman_Fleck"; // Marksman
sol_SL = 	"BWA3_SL_Fleck"; // Squad leader
sol_TL = 	"BWA3_TL_Fleck"; // Team leader
sol_TL2 = 	"BWA3_TL_Fleck"; // Team leader
sol_EXP = 	"BWA3_Engineer_Fleck"; // Explosives (extra)
sol_R_L = 	"BWA3_Rifleman_lite_Fleck"; // Rifleman, light
sol_REP = 	"BWA3_Engineer_Fleck"; // Repair (extra)
sol_UN = 	"BWA3_Rifleman_unarmed_Fleck"; // Unarmed (extra)
sol_RFL = 	"BWA3_Rifleman_Fleck"; // Rifleman
sol_SN = 	"BWA3_Marksman_Fleck"; // Sniper
sol_SP = 	"BWA3_Rifleman_lite_Fleck"; // Spotter
sol_MED = 	"BWA3_CombatLifeSaver_Fleck"; // Medic
sol_ENG = 	"BWA3_Engineer_Fleck"; // Engineer
sol_OFF = 	"BWA3_Officer_Fleck"; // Officer
sol_OFF2 = 	"BWA3_Officer_Fleck"; // Officer

sol_CREW = 	"BWA3_Crew_Fleck"; // Crew
sol_CREW2 = "BWA3_Rifleman_lite_Fleck"; // Crew
sol_CREW3 = "BWA3_Tank_Commander_Fleck"; // Crew
sol_CREW4 = "BWA3_Rifleman_lite_Fleck"; // Crew
sol_DRV = 	"BWA3_Crew_Fleck"; // Driver
sol_DRV2 = 	"BWA3_Crew_Fleck"; // Driver
sol_HCREW = "BWA3_Rifleman_unarmed_Fleck"; // Helicopter crew (extra)
sol_HPIL = 	"BWA3_Helipilot"; // helicopter pilot
sol_HPIL2 = "BWA3_Helipilot"; // helicopter pilot
sol_PIL = 	"BWA3_Helipilot"; // Pilot
sol_UAV = 	"BWA3_Rifleman_lite_Fleck"; // UAV controller (extra)

sol_SUP_AMG = 	"BWA3_Rifleman_Fleck"; // Assistant HMG gunner (extra)
sol_SUP_AMTR = 	"BWA3_Rifleman_Fleck"; // Assistant mortar gunner (extra)
sol_SUP_GMG = 	"BWA3_Rifleman_Fleck"; // GMG gunner (extra)
sol_SUP_MG = 	"BWA3_Rifleman_Fleck"; // HMG gunner (extra)
sol_SUP_MTR = 	"BWA3_Rifleman_Fleck"; // mortar gunner (extra)

// Standard roles for static gunner, crew, and unarmed helicopter pilot
infGunner =	sol_SUP_MG;
infCrew = 	sol_CREW;
infPilot = 	sol_HPIL;

// All classes sorted by role, used for pricing, etc
infList_officers = 	[sol_OFF, sol_OFF2];
infList_sniper = 	[sol_MK, sol_SN, sol_SP];
infList_NCO = 		[sol_SL, sol_TL, sol_TL2];
infList_special = 	[sol_A_AA, sol_A_AT, sol_AA, sol_AT, sol_EXP, sol_REP, sol_ENG, sol_MED];
infList_auto = 		[sol_A_AR, sol_MG];
infList_regular = 	[sol_AMMO, sol_GL, sol_GL2, sol_LAT, sol_LAT2, sol_R_L, sol_RFL];
infList_crew = 		[sol_UN, sol_CREW, sol_CREW2, sol_CREW3, sol_CREW4, sol_DRV, sol_DRV2, sol_HCREW, sol_UAV, sol_SUP_AMG, sol_SUP_AMTR, sol_SUP_GMG, sol_SUP_MG, sol_SUP_MTR];
infList_pilots = 	[sol_HPIL, sol_HPIL2, sol_PIL];

// Vehicles
vehTrucks = 		["BW_LKW_Transport_Fleck","BW_LKW_Transport_offen_fleck"]; // trucks that spawn at outposts, etc
vehPatrol =			["BWA3_Eagle_FLW100_Fleck","AW159_BW_Fleck","KGB_B_MRAP_03_hmg_F","KGB_B_MRAP_03_gmg_F","BWA3_Eagle_Fleck"]; // vehicles used for road patrols;
vehAPC = 			["BW_LKW_Transport_Fleck","BW_LKW_Transport_Fleck"]; // APCs
vehIFV = 			["BWA3_Puma_Fleck"]; // IFVs
vehTank = 			["BWA3_Leopard2A6M_Fleck"]; // MBTs
vehSupply = 		["BW_LKW_Munition_Fleck","BW_LKW_Medic_Fleck","BW_LKW_Reparatur_Fleck","BW_LKW_Treibstoff_Fleck"]; // supply vehicles (ammo, fuel, med)
vehAmmo = 			"BW_LKW_Munition_Fleck"; // ammo truck, for special missions
vehFuel = 			["BW_LKW_Treibstoff_Fleck"];
vehLead = 			["KGB_B_MRAP_03_hmg_F"]; // lead vehicle for convoys, preferably armed MRAP/car
standardMRAP = 		["BWA3_Eagle_FLW100_Fleck","KGB_B_MRAP_03_hmg_F","BWA3_Eagle_Fleck"]; // default transport MRAP/car
vehTruckBox = 		["BW_LKW_Reparatur_Fleck"]; // repair truck or at least a prop
vehPatrolBoat = 	["B_Boat_Armed_01_minigun_F"];

vehTruckAA = 		"BWA3_Puma_Fleck";
guer_vehicleArray pushBackUnique vehTruckAA;

var_AAF_groundForces = vehTrucks + vehPatrol + vehAPC + vehIFV + vehTank + vehLead + standardMRAP;
var_AAF_groundForces = var_AAF_groundForces arrayIntersect var_AAF_groundForces;

// Airforce
heli_unarmed = 		["NH_90_Fleck","AW159_BW_Fleck_Unbewaffnet"]; // (un-)armed transport helicopters
heli_armed = 		["AH6_Littlebird_BW_Fleck","BWA3_Tiger_RMK_Heavy","BWA3_Tiger_RMK_PARS", "AW159_BW_Fleck"]; // // armed helicopters
heli_escort = 		"AW159_BW_Fleck";
planes = 			["heeresflieger_1"]; // attack planes
heli_default = 		"AW159_BW_Fleck_Unbewaffnet";
heli_transport = 	"NH_90_Fleck";
indUAV_large = 		"BW_Euro_Hawk"; // large UAV, unarmed

// Initial motorpool/airforce
enemyMotorpoolDef = "BW_LKW_Transport_Fleck"; // fallback vehicle in case of an empty motorpool -- NOT AN ARRAY!
enemyMotorpool = 	["BW_LKW_Transport_Fleck","BWA3_Eagle_FLW100_Fleck"]; // starting/current motorpool
indAirForce = 		["AW159_BW_Fleck_Unbewaffnet","NH_90_Fleck"]; // starting/current airforce

// Config paths for pre-defined groups -- required if group names are used
cfgInf = (configfile >> "CfgGroups" >> "West" >> "Bundeswehr" >> "Infantry_Fleck");

// Standard group arrays, used for spawning groups -- can use full config paths, config group names, arrays of individual soldiers

// standard group arrays of individuals
BWGroup_Team = 		[sol_TL, sol_A_AR, sol_MED, sol_LAT]; // sniper team
BWGroup_AA = 		[sol_SL, sol_A_AA, sol_MED, sol_A_AA, sol_R_L, sol_A_AA]; // spec opcs
BWGroup_WeapSquad = 		[sol_SL, sol_AR, sol_A_AR, sol_MK, sol_SP, sol_MED, sol_GL, sol_LAT]; // squad
BWGroup_SniperTeam = 	[sol_SL, sol_MK, sol_MK, sol_MED];


infPatrol = 		[BWGroup_Team,BWGroup_SniperTeam,"Panzerabwehrtrupp"]; // 2-3 guys, incl sniper teams
infGarrisonSmall = 	["Panzerabwehrtrupp",BWGroup_Team]; // 2-3 guys, to guard towns
infTeamATAA =		["Panzerabwehrtrupp", BWGroup_AA]; // missile teams, 4+ guys, for roadblocks and watchposts
infTeam = 			["Jaegertrupp",BWGroup_WeapSquad,"Jaegertrupp","Jaegertrupp",
					"Jaegertrupp"]; // teams, 4+ guys
infSquad = 			[BWGroup_WeapSquad,"Jaegertrupp","Jaegertrupp"]; // squads, 8+ guys, for outposts, etc
infAA =				[BWGroup_AA];
infAT =				["Panzerabwehrtrupp"];

if (AS_customGroups) then {
	IND_cfgPath = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");
	infAT =	[IND_cfgPath >> "rhs_group_nato_usmc_wd_infantry_team_heavy_AT"];
};

// Statics to be used
statMG = 			"B_HMG_01_high_F";
statAT = 			"RHS_TOW_TriPod_WD"; // alternatives: rhs_Kornet_9M133_2_vdv, rhs_SPG9M_VDV, rhs_Metis_9k115_2_vdv
statAA = 			"RHS_Stinger_AA_pod_WD"; // alternatively: "rhs_Igla_AA_pod_vdv"
statAA2 = 			"RHS_Stinger_AA_pod_WD";
statMortar = 		"RHS_M252_WD";

statMGlow = 		"RHS_M2StaticMG_MiniTripod_WD";
statMGtower = 		"B_HMG_01_high_F";

// Lists of statics to determine the defensive capabilities at locations
statics_allMGs = 		statics_allMGs + [statMG];
statics_allATs = 		statics_allATs + [statAT];
statics_allAAs = 		statics_allAAs + [statAA];
statics_allMortars = 	statics_allMortars + [statMortar];

// Backpacks of dismantled statics -- 0: weapon, 1: tripod/support
statMGBackpacks = 		["B_HMG_01_high_weapon_F","B_HMG_01_support_high_F"];
statATBackpacks = 		["rhs_Tow_Gun_Bag","rhs_TOW_Tripod_Bag"]; // alt: ["RHS_Kornet_Gun_Bag","RHS_Kornet_Tripod_Bag"], ["RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag"], ["RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"]
statAABackpacks = 		[]; // Neither Igla nor ZSU can be dismantled. Any alternatives?
statMortarBackpacks = 	["rhs_M252_Gun_Bag","rhs_M252_Bipod_Bag"];
statMGlowBackpacks = 	["B_HMG_01_F","B_HMG_01_support_F"];
statMGtowerBackpacks = 	["B_HMG_01_high_weapon_F","B_HMG_01_support_high_F"];

/*
================ Gear ================
Weapons, ammo, launchers, missiles, mines, items and optics will spawn in ammo crates, the rest will not. These lists, together with the corresponding lists in the NATO/USAF template, determine what can be unlocked. Weapons of all kinds and ammo are the exception: they can all be unlocked.
*/
genWeapons = [
	"BWA3_G36",
	"BWA3_G36K",
	"BWA3_G36_AG",
	"BWA3_G38",
	"BWA3_G27",
	"BWA3_MG4",
	"BWA3_MG5",
	"BWA3_P8",
	"BWA3_G36_LMG"

];

genAmmo = [
	"BWA3_30Rnd_556x45_G36",
	"BWA3_30Rnd_556x45_G36",
	"BWA3_20Rnd_762x51_G28",
	"BWA3_200Rnd_556x45",
	"BWA3_120Rnd_762x51",
	"BWA3_20Rnd_762x51_G28",
	"1Rnd_HE_Grenade_shell",
	"BWA3_15Rnd_9x19_P8",
	"HandGrenade",
	"MiniGrenade"
];

genLaunchers = [
	"BWA3_Pzf3",
	"BWA3_Fliegerfaust",
	"BWA3_RGW90"
];

genMissiles = [

	"BWA3_Fliegerfaust_Mag"
];

genMines = [
	"rhs_mine_M19_mag",
	"APERSTripMine_Wire_Mag",
	"rhsusf_m112_mag"
];

genItems = [
	"FirstAidKit",
	"MineDetector",
	"rhs_1PN138",
	"ItemGPS",
	"rhs_scarf",
	"rhs_pdu4",
	"rhsusf_acc_anpeq15side",
	"BWA3_muzzle_snds_G36",
	"muzzle_snds_B",
	"BWA3_acc_VarioRay_irlaser",
	"BWA3_muzzle_snds_G28"
];

genOptics = [
	"BWA3_optic_ZO4x30",
	"BWA3_optic_20x50",
	"BWA3_optic_ZO4x30_Single",
	"BWA3_optic_EOTech_Mag_Off"
];

genBackpacks = [
	"rhs_assault_umbts",
	"rhs_assault_umbts_engineer",
	"rhs_assault_umbts_engineer_empty",
	"rhs_assault_umbts_medic",
	"rhsusf_assault_eagleaiii_coy",
	"rhsusf_assault_eagleaiii_coy_engineer",
	"rhsusf_assault_eagleaiii_coy_ar",
	"rhsusf_assault_eagleaiii_coy_demo",
	"rhsusf_assault_eagleaiii_coy_m27",
	"rhsusf_assault_eagleaiii_coy_ar",
	"rhsusf_assault_eagleaiii_coy_assaultman",
	"tf_anprc155_coyote",
	"B_Carryall_oli"
];

genVests = [
	"rhsusf_spc",
	"rhsusf_spc_rifleman",
	"rhsusf_spc_iar",
	"rhsusf_spc_corpsman",
	"rhsusf_spc_crewman",
	"rhsusf_spc_light",
	"rhsusf_spc_marksman",
	"rhsusf_spc_mg",
	"rhsusf_spc_squadleader",
	"rhsusf_spc_teamleader"
];

genHelmets = [
	"rhsusf_patrolcap_ucp",
	"rhs_Booniehat_ucp",
	"rhsusf_mich_helmet_marpatwd",
	"rhsusf_mich_helmet_marpatwd_headset",
	"rhsusf_mich_helmet_marpatd",
	"rhsusf_mich_helmet_marpatd_headset",
	"rhsusf_mich_helmet_marpatwd_alt",
	"rhsusf_mich_helmet_marpatwd_alt_headset",
	"rhsusf_mich_helmet_marpatd_alt",
	"rhsusf_mich_helmet_marpatd_alt_headset",
	"rhsusf_mich_helmet_marpatwd_norotos",
	"rhsusf_mich_helmet_marpatwd_norotos_headset",
	"rhsusf_mich_helmet_marpatd_norotos",
	"rhsusf_mich_helmet_marpatd_norotos_headset",
	"rhsusf_mich_helmet_marpatwd_norotos_arc",
	"rhsusf_mich_helmet_marpatwd_norotos_arc_headset",
	"rhsusf_mich_helmet_marpatd_norotos_arc",
	"rhsusf_mich_helmet_marpatd_norotos_arc_headset",
	"rhsusf_lwh_helmet_marpatd",
	"rhsusf_lwh_helmet_marpatd_ess",
	"rhsusf_lwh_helmet_marpatd_headset",
	"rhsusf_lwh_helmet_marpatwd",
	"rhsusf_lwh_helmet_marpatwd_ess",
	"rhsusf_lwh_helmet_marpatwd_headset",
	"rhs_Booniehat_marpatwd"
];

// Equipment unlocked by default

if (activeGREF) then {
	unlockedWeapons = [
	"rhs_weap_makarov_pm",
	"rhs_weap_savz61",
	"rhs_weap_kar98k",
	"rhs_weap_m38"
	];

	unlockedRifles = [
	"rhs_weap_savz61",
	"rhs_weap_kar98k",
	"rhs_weap_m38"
	];

	unlockedMagazines = [
	"rhs_mag_9x18_8_57N181S",
	"rhsgref_5Rnd_762x54_m38",
	"rhsgref_5Rnd_792x57_kar98k",
	"rhsgref_20rnd_765x17_vz61"

	];
} else {
	unlockedWeapons = [
	"rhs_weap_makarov_pm",
	"rhs_weap_savz61",
	"rhs_weap_kar98k",
	"rhs_weap_m38"
];

};

// Standard rifles for AI are picked from this array. Add only rifles.
unlockedRifles = [
	"rhs_weap_savz61",
	"rhs_weap_kar98k",
	"rhs_weap_m38"
];

unlockedMagazines = [
	"rhs_mag_9x18_8_57N181S",
	"rhsgref_5Rnd_762x54_m38",
	"rhsgref_5Rnd_792x57_kar98k",
	"rhsgref_20rnd_765x17_vz61"
];

unlockedItems = [
	"Binocular",
	"ItemMap",
	"ItemWatch",
	"ItemCompass",
	"FirstAidKit",
	"Medikit",
	"ToolKit",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_2",
	"U_BG_Guerilla2_3",
	"U_BG_Guerilla3_1",
	"U_BG_leader",
	"H_Booniehat_khk",
	"H_Booniehat_oli",
	"H_Cap_oli",
	"H_Cap_blk",
	"H_MilCap_rucamo",
	"H_MilCap_gry",
	"H_Bandanna_khk",
	"H_Bandanna_gry",
	"H_Bandanna_camo",
	"H_ShemagOpen_khk",
	"H_ShemagOpen_tan",
	"H_Shemag_olive",
	"H_Watchcap_camo",
	"H_Hat_camo",
	"H_Hat_tan",
	"H_Beret_blk",
	"H_Beret_02",
	"H_Watchcap_khk",
	"G_Balaclava_blk",
	"G_Balaclava_combat",
	"G_Balaclava_lowprofile",
	"G_Balaclava_oli",
	"G_Bandanna_beast",
	"G_Tactical_Black",
	"G_Aviator",
	"G_Bandanna_aviator",
	"G_Shades_Black",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_tricolour",
	"U_C_Poor_1",
	"U_Rangemaster",
	"U_NikosBody",
	"U_I_G_Story_Protagonist_F",
	"U_I_G_resistanceLeader_F",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_redwhite",
	"U_Rangemaster",
	"U_NikosBody",
	"U_C_Poor_1",
	"U_C_WorkerCoveralls",
	"U_BG_Guerrilla_6_1",
	"U_B_survival_uniform",
	"U_OrestesBody",
	"G_Bandanna_khk",
	"V_BandollierB_khk",
	"rhsgref_uniform_para_ttsko_oxblood",
	"rhsgref_uniform_flecktarn",
	"rhsgref_uniform_tigerstripe"
];

unlockedBackpacks = [
	"rhs_assault_umbts"
];

unlockedOptics = [];

// Default rifle types, required to unlock specific unit types. Unfortunatly, not all mods classify their weapons the same way, so automatic detection doesn't work reliably enough.
gear_machineGuns = gear_machineGuns + ["rhs_weap_m240G","rhs_weap_m249_pip_L_para", "rhs_weap_m249_pip_S_vfg"];
gear_machineGuns = gear_machineGuns arrayIntersect gear_machineGuns;
gear_sniperRifles = gear_sniperRifles + ["rhs_weap_M107_d","rhs_weap_m24sws","rhs_weap_sr25"];
gear_sniperRifles = gear_sniperRifles arrayIntersect gear_sniperRifles;
genGL = ["rhs_weap_m16a4_carryhandle_M203","rhs_weap_m4a1_carryhandle_m203S","rhs_weap_m4a1_m203s_d"];

// Standard rifles for your troops to be equipped with
baseRifles =+ unlockedRifles;

basicGear = unlockedWeapons + unlockedMagazines + unlockedItems + unlockedBackpacks;

startingWeapons =+ unlockedWeapons;

// Default launchers
genAALaunchers = ["BWA3_Fliegerfaust"];
genATLaunchers = ["BWA3_RGW90","BWA3_Pzf3"];

IND_gear_heavyAT = "BWA3_Pzf3";
IND_gear_lightAT = "BWA3_RGW90";

AAmissile = 	"BWA3_Fliegerfaust_Mag";

// NVG, flashlight, laser, mine types
indNVG = 		"rhsusf_ANPVS_14";
indRF = 		"lerca_1200_black";
indFL = 		"rhsusf_acc_anpeq15side";
indLaser = 		"rhsusf_acc_anpeq15side";
atMine = 		"rhs_mine_M19_mag";
atMine_placed = "rhsusf_mine_M19";
atMine_type = 	"rhsusf_mine_m19_ammo";
apMine = 		"rhs_mine_pmn2_mag";
apMine_placed = "rhs_mine_pmn2";
apMine_type = 	"rhs_mine_pmn2_ammo";

// The flag
cFlag = "BWA3_Flag_Ger_F";

// Affiliation
side_green = 	west;

// Long-range radio
lrRadio = "tf_anprc155_coyote";

// Define the civilian helicopter that allows you to go undercover
civHeli = "RHS_Mi8amt_civilian";

// Define the ammo crate to be spawned at camps
campCrate = "Box_NATO_Equip_F";

// Colour of this faction's markers
IND_marker_colour = "ColorWEST";

// Type of this faction's markers
IND_marker_type = "flag_Germany";

// Name of the faction
A3_Str_INDEP = localize "STR_GENIDENT_BW";

if (worldname == "Tanoa") then {
    unlockedItems = unlockedItems + [
    "U_I_C_Soldier_Para_5_F",
    "U_I_C_Soldier_Para_4_F",
    "U_I_C_Soldier_Para_3_F",
    "U_I_C_Soldier_Para_2_F",
    "U_I_C_Soldier_Para_1_F",
    "U_I_C_Soldier_Para_1_F",
    "U_I_C_Soldier_Bandit_1_F",
    "U_I_C_Soldier_Bandit_2_F",
    "U_I_C_Soldier_Bandit_3_F",
    "U_I_C_Soldier_Bandit_4_F",
    "U_I_C_Soldier_Bandit_5_F"
    ];

	// infPatrol = infPatrol + [(configfile >> "CfgGroups" >> "West" >> "Gendarmerie" >> "Infantry" >> "GENDARME_Inf_Patrol")]

	// vehPatrol = vehPatrol + ["B_GEN_Offroad_01_gen_F"]

};