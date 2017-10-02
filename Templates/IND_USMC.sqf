/*
List of infantry classes. These will have individual skills and equipment mapped to them.
If you wish to add more soldiers beyond the available variables, you also need to add any new variables to genInit.sqf and genInitBASES.sqf.

Note: all classes marked as "extra" do not have a unique class in this template. They are, however, part of other templates and are therfore included in all templates.
*/
sol_A_AA = 	"rhsusf_usmc_marpat_wd_stinger"; // Assistant AA (extra)
sol_A_AR = 	"rhsusf_usmc_marpat_wd_machinegunner_ass"; // Assistant autorifle
sol_A_AT = 	"rhsusf_usmc_marpat_wd_javelin_assistant"; // Assistant AT
sol_AA = 	"rhsusf_usmc_marpat_wd_stinger"; // AA
sol_AR = 	"rhsusf_usmc_marpat_wd_autorifleman_m249"; // Autorifle
sol_AT = 	"rhsusf_usmc_marpat_wd_javelin"; // AT
sol_AMMO = 	"rhsusf_usmc_marpat_wd_machinegunner_ass"; // Ammo bearer (extra)
sol_GL = 	"rhsusf_usmc_marpat_wd_grenadier"; // Grenade launcher
sol_GL2 = 	"rhsusf_usmc_marpat_wd_grenadier_m32"; // Grenade launcher
sol_LAT = 	"rhsusf_usmc_marpat_wd_smaw"; // Light AT
sol_LAT2 = 	"rhsusf_usmc_marpat_wd_riflemanat"; // Light AT
sol_MG = 	"rhsusf_usmc_marpat_wd_machinegunner"; // Machinegunner
sol_MK = 	"rhsusf_usmc_marpat_wd_marksman"; // Marksman
sol_SL = 	"rhsusf_usmc_marpat_wd_squadleader"; // Squad leader
sol_TL = 	"rhsusf_usmc_marpat_wd_teamleader"; // Team leader
sol_TL2 = 	"rhsusf_usmc_marpat_wd_rifleman_m590"; // Team leader
sol_EXP = 	"rhsusf_usmc_marpat_wd_explosives"; // Explosives (extra)
sol_R_L = 	"rhsusf_usmc_marpat_wd_rifleman_light"; // Rifleman, light
sol_REP = 	"rhsusf_usmc_marpat_wd_engineer"; // Repair (extra)
sol_UN = 	"rhsusf_usmc_marpat_wd_helicrew"; // Unarmed (extra)
sol_RFL = 	"rhsusf_usmc_marpat_wd_rifleman"; // Rifleman
sol_SN = 	"rhsusf_usmc_marpat_wd_sniper"; // Sniper
sol_SP = 	"rhsusf_usmc_marpat_wd_spotter"; // Spotter
sol_MED = 	"rhsusf_navy_marpat_wd_medic"; // Medic
sol_ENG = 	"rhsusf_usmc_marpat_wd_engineer"; // Engineer
sol_OFF = 	"rhsusf_usmc_marpat_wd_officer"; // Officer
sol_OFF2 = 	"rhsusf_usmc_marpat_wd_officer"; // Officer

sol_CREW = 	"rhsusf_usmc_marpat_wd_crewman"; // Crew
sol_CREW2 = "rhsusf_usmc_marpat_wd_combatcrewman"; // Crew
sol_CREW3 = "rhsusf_usmc_marpat_wd_crewman"; // Crew
sol_CREW4 = "rhsusf_usmc_marpat_wd_combatcrewman"; // Crew
sol_DRV = 	"rhsusf_usmc_marpat_wd_driver"; // Driver
sol_DRV2 = 	"rhsusf_usmc_marpat_wd_driver"; // Driver
sol_HCREW = "rhsusf_usmc_marpat_wd_helicrew"; // Helicopter crew (extra)
sol_HPIL = 	"rhsusf_usmc_marpat_wd_helipilot"; // helicopter pilot
sol_HPIL2 = "rhsusf_usmc_marpat_wd_helipilot"; // helicopter pilot
sol_PIL = 	"rhsusf_usmc_marpat_wd_helipilot"; // Pilot
sol_UAV = 	"rhsusf_usmc_marpat_wd_uav"; // UAV controller (extra)

sol_SUP_AMG = 	"rhsusf_usmc_marpat_wd_gunner"; // Assistant HMG gunner (extra)
sol_SUP_AMTR = 	"rhsusf_usmc_marpat_wd_gunner"; // Assistant mortar gunner (extra)
sol_SUP_GMG = 	"rhsusf_usmc_marpat_wd_gunner"; // GMG gunner (extra)
sol_SUP_MG = 	"rhsusf_usmc_marpat_wd_gunner"; // HMG gunner (extra)
sol_SUP_MTR = 	"rhsusf_usmc_marpat_wd_gunner"; // mortar gunner (extra)

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
vehTrucks = 		["rhsusf_M1078A1P2_B_wd_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_open_fmtv_usarmy","rhsusf_M1078A1P2_B_wd_fmtv_usarmy"]; // trucks that spawn at outposts, etc
vehPatrol =			["rhsusf_rg33_m2_usmc_wd","RHS_UH1Y_GS","rhsusf_m1025_w_s_Mk19"]; // vehicles used for road patrols;
vehAPC = 			["rhsusf_M1232_MK19_usarmy_wd","rhsusf_M1232_M2_usarmy_wd"]; // APCs
vehIFV = 			["RHS_M2A2_wd","RHS_M2A2_wd","RHS_M2A3_BUSKI_wd","RHS_M2A2_wd"]; // IFVs
vehTank = 			["rhsusf_m1a1fep_wd","rhsusf_m1a1fep_od"]; // MBTs
vehSupply = 		["rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd","rhsusf_M977A4_BKIT_M2_usarmy_wd","rhsusf_M978A4_BKIT_usarmy_wd","rhsusf_M977A4_REPAIR_BKIT_usarmy_wd","rhsusf_M1083A1P2_B_M2_d_Medical_fmtv_usarmy"]; // supply vehicles (ammo, fuel, med)
vehAmmo = 			"rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd"; // ammo truck, for special missions
vehFuel = 			["rhsusf_M978A4_BKIT_usarmy_d","rhsusf_M978A4_usarmy_d"];
vehLead = 			["rhsusf_M1117_W"]; // lead vehicle for convoys, preferably armed MRAP/car
standardMRAP = 		["rhsusf_rg33_usmc_wd","rhsusf_m1025_w_s"]; // default transport MRAP/car
vehTruckBox = 		["rhsusf_M977A4_REPAIR_BKIT_usarmy_wd"]; // repair truck or at least a prop
vehPatrolBoat = 	["I_Boat_Armed_01_minigun_F"];

vehTruckAA = 		"rhs_gaz66_zu23_msv";
guer_vehicleArray pushBackUnique vehTruckAA;

var_AAF_groundForces = vehTrucks + vehPatrol + vehAPC + vehIFV + vehTank + vehLead + standardMRAP;
var_AAF_groundForces = var_AAF_groundForces arrayIntersect var_AAF_groundForces;

// Airforce
heli_unarmed = 		["RHS_CH_47F","RHS_UH1Y_UNARMED"]; // (un-)armed transport helicopters
heli_armed = 		["RHS_AH1Z_wd","RHS_AH1Z_wd_CS","RHS_UH1Y"]; // // armed helicopters
heli_escort = 		"RHS_UH1Y";
planes = 			["RHS_A10"]; // attack planes
heli_default = 		"RHS_UH1Y";
heli_transport = 	"RHS_CH_47F";
indUAV_large = 		"B_UAV_02_F"; // large UAV, unarmed

// Initial motorpool/airforce
enemyMotorpoolDef = "rhsusf_M1078A1P2_B_wd_fmtv_usarmy"; // fallback vehicle in case of an empty motorpool -- NOT AN ARRAY!
enemyMotorpool = 	["rhsusf_M1078A1P2_B_wd_fmtv_usarmy","rhsusf_M1237_M2_usarmy_wd"]; // starting/current motorpool
indAirForce = 		["RHS_CH_47F","RHS_UH1Y_UNARMED"]; // starting/current airforce

// Config paths for pre-defined groups -- required if group names are used
cfgInf = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");

// Standard group arrays, used for spawning groups -- can use full config paths, config group names, arrays of individual soldiers
infPatrol = 		["rhs_group_nato_usmc_wd_infantry_team","rhs_group_nato_usmc_wd_infantry_team_MG","rhs_group_nato_usmc_wd_infantry_team_support"]; // 2-3 guys, incl sniper teams
infGarrisonSmall = 	["rhs_group_nato_usmc_wd_infantry_team","rhs_group_nato_usmc_wd_infantry_team_heavy_AT","rhs_group_nato_usmc_wd_infantry_team_MG"]; // 2-3 guys, to guard towns
infTeamATAA =		["rhs_group_nato_usmc_wd_infantry_team_heavy_AT","rhs_group_nato_usmc_wd_infantry_team_AA"]; // missile teams, 4+ guys, for roadblocks and watchposts
infTeam = 			["rhs_group_nato_usmc_wd_infantry_team_MG","rhs_group_nato_usmc_wd_infantry_team","rhs_group_nato_usmc_wd_infantry_team_heavy_AT","rhs_group_nato_usmc_wd_infantry_team_AA",
					"rhs_group_nato_usmc_wd_infantry_team_support"]; // teams, 4+ guys
infSquad = 			["rhs_group_nato_usmc_wd_infantry_squad","rhs_group_nato_usmc_wd_infantry_weaponsquad","rhs_group_nato_usmc_wd_infantry_squad_sniper"]; // squads, 8+ guys, for outposts, etc
infAA =				["rhs_group_nato_usmc_wd_infantry_team_AA"];
infAT =				["rhs_group_nato_usmc_wd_infantry_team_heavy_AT"];

if (AS_customGroups) then {
	IND_cfgPath = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");
	infAT =	[IND_cfgPath >> "rhs_group_nato_usmc_wd_infantry_team_heavy_AT"];
};

// Statics to be used
statMG = 			"RHS_M2StaticMG_WD";
statAT = 			"RHS_TOW_TriPod_WD"; // alternatives: rhs_Kornet_9M133_2_vdv, rhs_SPG9M_VDV, rhs_Metis_9k115_2_vdv
statAA = 			"RHS_Stinger_AA_pod_WD"; // alternatively: "rhs_Igla_AA_pod_vdv"
statAA2 = 			"RHS_Stinger_AA_pod_WD";
statMortar = 		"RHS_M252_WD";

statMGlow = 		"RHS_M2StaticMG_MiniTripod_WD";
statMGtower = 		"RHS_M2StaticMG_WD";

// Lists of statics to determine the defensive capabilities at locations
statics_allMGs = 		statics_allMGs + [statMG];
statics_allATs = 		statics_allATs + [statAT];
statics_allAAs = 		statics_allAAs + [statAA];
statics_allMortars = 	statics_allMortars + [statMortar];

// Backpacks of dismantled statics -- 0: weapon, 1: tripod/support
statMGBackpacks = 		["RHS_M2_Gun_Bag","RHS_M2_Tripod_Bag"];
statATBackpacks = 		["rhs_Tow_Gun_Bag","rhs_TOW_Tripod_Bag"]; // alt: ["RHS_Kornet_Gun_Bag","RHS_Kornet_Tripod_Bag"], ["RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag"], ["RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"]
statAABackpacks = 		[]; // Neither Igla nor ZSU can be dismantled. Any alternatives?
statMortarBackpacks = 	["rhs_M252_Gun_Bag","rhs_M252_Bipod_Bag"];
statMGlowBackpacks = 	["RHS_M2_Gun_Bag","RHS_M2_MiniTripod_Bag"];
statMGtowerBackpacks = 	["RHS_M2_Gun_Bag","RHS_M2_Tripod_Bag"];

/*
================ Gear ================
Weapons, ammo, launchers, missiles, mines, items and optics will spawn in ammo crates, the rest will not. These lists, together with the corresponding lists in the NATO/USAF template, determine what can be unlocked. Weapons of all kinds and ammo are the exception: they can all be unlocked.
*/
genWeapons = [
	"rhs_weap_m16a4_carryhandle",
	"rhs_weap_m4a1_carryhandle",
	"rhs_weap_m16a4_carryhandle_M203",
	"rhs_weap_m4a1_carryhandle_m203S",
	"rhs_weap_m40a5_wd",
	"rhs_weap_sr25",
	"rhs_weap_m240G",
	"rhs_weap_m249_pip_L_para",
	"rhs_weap_m249_pip_S_vfg",
	"rhs_weap_M590_5RD",
	"rhsusf_weap_m1911a1",
	"rhs_weap_m27iar"

];

genAmmo = [
	"rhsusf_mag_10Rnd_STD_50BMG_M33",
	"rhsusf_50Rnd_762x51",
	"rhs_mag_30Rnd_556x45_Mk318_Stanag",
	"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",
	"rhsusf_20Rnd_762x51_m118_special_Mag",
	"rhsusf_5Rnd_762x51_m118_special_Mag",
	"rhs_200rnd_556x45_M_SAW",
	"rhsusf_5Rnd_00Buck",
	"rhs_mag_smaw_SR",
	"20Rnd_762x51_Mag",
	"rhsusf_100Rnd_762x51_m61_ap",
	"rhsusf_100Rnd_762x51_m62_tracer",
	"rhsusf_mag_7x45acp_MHP",
	"HandGrenade",
	"MiniGrenade"
];

genLaunchers = [
	"rhs_weap_M136_hedp",
	"rhs_weap_fim92",
	"rhs_weap_smaw_gr_optic"
];

genMissiles = [
	"rhs_m136_hedp_mag",
	"rhs_mag_smaw_HEAA",
	"rhs_mag_smaw_SR",
	"rhs_fim92_mag"
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
	"rhsusf_acc_harris_bipod",
	"muzzle_snds_B",
	"rhsusf_acc_anpeq15A",
	"rhsusf_acc_nt4_black"
];

genOptics = [
	"rhsusf_acc_LEUPOLDMK4",
	"rhsusf_acc_ACOG3_USMC",
	"rhsusf_acc_ACOG_MDO",
	"rhsusf_acc_compm4"
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
};

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
genAALaunchers = ["rhs_weap_fim92"];
genATLaunchers = ["rhs_weap_M136_hedp","rhs_weap_smaw_green"];

IND_gear_heavyAT = "rhs_weap_fgm148";
IND_gear_lightAT = "rhs_weap_smaw_optic";

AAmissile = 	"rhs_fim92_mag";

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
cFlag = "Flag_US_F";

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
IND_marker_type = "rhs_flag_USA";

// Name of the faction
A3_Str_INDEP = localize "STR_GENIDENT_USMC";

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