/*
List of infantry classes. These will have individual skills and equipment mapped to them.
If you wish to add more soldiers beyond the available variables, you also need to add any new variables to genInit.sqf and genInitBASES.sqf.

Note: all classes marked as "extra" do not have a unique class in this template. They are, however, part of other templates and are therfore included in all templates.
*/
sol_A_AA = 	"CUP_B_BAF_Soldier_AAA_MTP"; // Assistant AA (extra)
sol_A_AR = 	"UK3CB_BAF_FT_762_MTP"; // Assistant autorifle
sol_A_AT = 	"UK3CB_BAF_MATC_MTP"; // Assistant AT
sol_AA = 	"CUP_B_BAF_Soldier_AA_MTP"; // AA
sol_AR = 	"UK3CB_BAF_MGGPMG_MTP"; // Autorifle
sol_AT = 	"UK3CB_BAF_MAT_MTP"; // AT
sol_AMMO = 	"UK3CB_BAF_LAT_ILAW_762_MTP"; // Ammo bearer (extra)
sol_GL = 	"UK3CB_BAF_FAC_MTP"; // Grenade launcher
sol_GL2 = 	"UK3CB_BAF_Grenadier_MTP"; // Grenade launcher
sol_LAT = 	"UK3CB_BAF_LAT_ILAW_MTP"; // Light AT
sol_LAT2 = 	"UK3CB_BAF_LAT_MTP"; // Light AT
sol_MG = 	"UK3CB_BAF_MGLMG_MTP"; // Machinegunner
sol_MK = 	"UK3CB_BAF_Sharpshooter_MTP"; // Marksman
sol_SL = 	"UK3CB_BAF_SC_MTP"; // Squad leader
sol_TL = 	"UK3CB_BAF_FT_MTP"; // Team leader
sol_TL2 = 	"UK3CB_BAF_RO_MTP"; // Team leader
sol_EXP = 	"UK3CB_BAF_Explosive_MTP"; // Explosives (extra)
sol_R_L = 	"UK3CB_BAF_Pointman_MTP"; // Rifleman, light
sol_REP = 	"UK3CB_BAF_Repair_MTP"; // Repair (extra)
sol_UN = 	"UK3CB_BAF_Recruit_MTP"; // Unarmed (extra)
sol_RFL = 	"UK3CB_BAF_Rifleman_MTP"; // Rifleman
sol_SN = 	"UK3CB_BAF_Marksman_MTP"; // Sniper
sol_SP = 	"UK3CB_BAF_Sharpshooter_MTP_H"; // Spotter
sol_MED = 	"UK3CB_BAF_Medic_MTP"; // Medic
sol_ENG = 	"UK3CB_BAF_Engineer_MTP"; // Engineer
sol_OFF = 	"UK3CB_BAF_Officer_MTP"; // Officer
sol_OFF2 = 	"UK3CB_BAF_Officer_MTP_H"; // Officer

sol_CREW = 	"UK3CB_BAF_Crewman_MTP"; // Crew
sol_CREW2 = "UK3CB_BAF_Crewman_MTP"; // Crew
sol_CREW3 = "UK3CB_BAF_Crewman_RTR_MTP"; // Crew
sol_CREW4 = "UK3CB_BAF_Crewman_RTR_MTP"; // Crew
sol_DRV = 	"UK3CB_BAF_Crewman_MTP"; // Driver
sol_DRV2 = 	"UK3CB_BAF_Crewman_MTP"; // Driver
sol_HCREW = "UK3CB_BAF_HeliCrew_MTP"; // Helicopter crew (extra)
sol_HPIL = 	"UK3CB_BAF_HeliPilot_Army_MTP"; // helicopter pilot
sol_HPIL2 = "UK3CB_BAF_HeliPilot_Army_MTP"; // helicopter pilot
sol_PIL = 	"UK3CB_BAF_HeliPilot_Army_MTP"; // Pilot
sol_UAV = 	"UK3CB_BAF_UAV_MTP_RM"; // UAV controller (extra)

sol_SUP_AMG = 	"UK3CB_BAF_GunnerStatic_MTP"; // Assistant HMG gunner (extra)
sol_SUP_AMTR = 	"UK3CB_BAF_GunnerM6_MTP"; // Assistant mortar gunner (extra)
sol_SUP_GMG = 	"UK3CB_BAF_GunnerM6_MTP"; // GMG gunner (extra)
sol_SUP_MG = 	"UK3CB_BAF_GunnerStatic_MTP"; // HMG gunner (extra)
sol_SUP_MTR = 	"UK3CB_BAF_GunnerM6_MTP"; // mortar gunner (extra)

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
vehTrucks = 		["B_Truck_01_transport_F","B_Truck_01_covered_F"]; // trucks that spawn at outposts, etc
vehPatrol =			["UK3CB_BAF_LandRover_WMIK_HMG_FFR_Green_A_MTP","UK3CB_BAF_LandRover_WMIK_HMG_FFR_Green_A_MTP","UK3CB_BAF_Jackal2_L2A1_W_MTP"]; // vehicles used for road patrols;
vehAPC = 			["CUP_B_FV432_Bulldog_GB_W","CUP_B_FV432_Bulldog_GB_W_RWS"]; // APCs
vehIFV = 			["CUP_B_FV510_GB_W_SLAT","CUP_B_FV510_GB_W"]; // IFVs
vehTank = 			["CUP_B_Challenger2_2CW_BAF","CUP_B_Challenger2_Woodland_BAF"]; // MBTs
vehSupply = 		["B_Truck_01_ammo_F","B_Truck_01_fuel_F","UK3CB_BAF_Coyote_Logistics_L111A1_W_MTP","UK3CB_BAF_LandRover_Amb_FFR_Green_A_MTP"]; // supply vehicles (ammo, fuel, med)
vehAmmo = 			"B_Truck_01_ammo_F"; // ammo truck, for special missions
vehFuel = 			["B_Truck_01_fuel_F"];
vehLead = 			["UK3CB_BAF_LandRover_WMIK_Milan_FFR_Green_A_MTP"]; // lead vehicle for convoys, preferably armed MRAP/car
standardMRAP = 		["UK3CB_BAF_LandRover_WMIK_HMG_FFR_Green_A_MTP","UK3CB_BAF_Jackal2_L2A1_W_MTP","UK3CB_BAF_LandRover_WMIK_HMG_FFR_Green_A_MTP"]; // default transport MRAP/car
vehTruckBox = 		["UK3CB_BAF_Coyote_Logistics_L111A1_W_MTP"]; // repair truck or at least a prop
vehPatrolBoat = 	["B_Boat_Armed_01_minigun_F"];

vehTruckAA = 		"CUP_B_FV510_GB_W_SLAT";
guer_vehicleArray pushBackUnique vehTruckAA;

var_AAF_groundForces = vehTrucks + vehPatrol + vehAPC + vehIFV + vehTank + vehLead + standardMRAP;
var_AAF_groundForces = var_AAF_groundForces arrayIntersect var_AAF_groundForces;

// Airforce
heli_unarmed = 		["UK3CB_BAF_Merlin_HC3_32_MTP_RM","UK3CB_BAF_Merlin_HC3_CSAR_MTP_RM"]; // (un-)armed transport helicopters
heli_armed = 		["UK3CB_BAF_Wildcat_AH1_CAS_6C_MTP_RM","UK3CB_BAF_Wildcat_AH1_HEL_8A_MTP_RM","UK3CB_BAF_Apache_AH1_JS_MTP_RM"]; // // armed helicopters
heli_escort = 		"UK3CB_BAF_Wildcat_AH1_CAS_6C_MTP_RM";
planes = 			["CUP_B_GR9_AGM_GB","CUP_B_GR9_AGM_GB"]; // attack planes
heli_default = 		"UK3CB_BAF_Merlin_HC3_CSAR_MTP_RM";
heli_transport = 	"UK3CB_BAF_Merlin_HC3_CSAR_MTP_RM";
indUAV_large = 		"B_UAV_02_F"; // large UAV, unarmed

// Initial motorpool/airforce
enemyMotorpoolDef = "B_Truck_01_transport_F"; // fallback vehicle in case of an empty motorpool -- NOT AN ARRAY!
enemyMotorpool = 	["B_Truck_01_transport_F","UK3CB_BAF_LandRover_WMIK_HMG_FFR_Green_A_MTP"]; // starting/current motorpool
indAirForce = 		["UK3CB_BAF_Wildcat_AH1_CAS_6C_MTP_RM","UK3CB_BAF_Merlin_HC3_CSAR_MTP_RM"]; // starting/current airforce

// Config paths for pre-defined groups -- required if group names are used
cfgInf = (configfile >> "CfgGroups" >> "West" >> "UK3CB_BAF_Faction_Army_MTP" >> "Infantry");

// Standard group arrays, used for spawning groups -- can use full config paths, config group names, arrays of individual soldiers

// standard group arrays of individuals
BWGroup_Team = 		[sol_TL, sol_A_AR, sol_MED, sol_LAT]; // sniper team
BWGroup_AA = 		[sol_SL, sol_AA, sol_MED, sol_AA, sol_R_L, sol_AA]; // spec opcs
BWGroup_WeapSquad = 		[sol_SL, sol_AR, sol_A_AR, sol_MK, sol_SP, sol_MED, sol_GL, sol_LAT]; // squad
BWGroup_SniperTeam = 	[sol_SL, sol_MK, sol_MK, sol_MED];


infPatrol = 		["UK3CB_BAF_Army_MTP_Sentry_Day","UK3CB_BAF_Army_MTP_Sentry_Day","UK3CB_BAF_Army_MTP_FireTeam_C_Day"]; // 2-3 guys, incl sniper teams
infGarrisonSmall = 	["UK3CB_BAF_Army_MTP_FireTeam_B_Day","UK3CB_BAF_Army_MTP_FireTeam_C_Day"]; // 2-3 guys, to guard towns
infTeamATAA =		["UK3CB_BAF_Army_MTP_FireTeam_A_Day", BWGroup_AA]; // missile teams, 4+ guys, for roadblocks and watchposts
infTeam = 			["UK3CB_BAF_Army_MTP_FireTeam_A_Day","UK3CB_BAF_Army_MTP_FireTeam_B_Day","UK3CB_BAF_Army_MTP_FireTeam_C_Day"]; // teams, 4+ guys
infSquad = 			["UK3CB_BAF_Army_MTP_Section_A_Day","UK3CB_BAF_Army_MTP_Section_B_Day","UK3CB_BAF_Army_MTP_Section_C_Day"]; // squads, 8+ guys, for outposts, etc
infAA =				[BWGroup_AA];
infAT =				["UK3CB_BAF_Army_MTP_HWAT_Day","UK3CB_BAF_Army_MTP_FireTeam_A_Day"];

if (AS_customGroups) then {
	IND_cfgPath = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");
	infAT =	[IND_cfgPath >> "rhs_group_nato_usmc_wd_infantry_team_heavy_AT"];
};

// Statics to be used
statMG = 			"UK3CB_BAF_Static_L111A1_Deployed_High_MTP";
statAT = 			"CUP_B_TOW_TriPod_US"; // alternatives: rhs_Kornet_9M133_2_vdv, rhs_SPG9M_VDV, rhs_Metis_9k115_2_vdv
statAA = 			"B_static_AA_F"; // alternatively: "rhs_Igla_AA_pod_vdv"
statAA2 = 			"UK3CB_BAF_Static_L111A1_Deployed_High_MTP";
statMortar = 		"UK3CB_BAF_Static_L16_Deployed_DPMT";

statMGlow = 		"UK3CB_BAF_Static_L7A2_Deployed_Low_MTP";
statMGtower = 		"UK3CB_BAF_Static_L7A2_Deployed_High_MTP";

// Lists of statics to determine the defensive capabilities at locations
statics_allMGs = 		statics_allMGs + [statMG];
statics_allATs = 		statics_allATs + [statAT];
statics_allAAs = 		statics_allAAs + [statAA];
statics_allMortars = 	statics_allMortars + [statMortar];

// Backpacks of dismantled statics -- 0: weapon, 1: tripod/support
statMGBackpacks = 		["UK3CB_BAF_L111A1","UK3CB_BAF_Tripod"];
statATBackpacks = 		["CUP_B_Tow_Gun_Bag","CUP_B_TOW_Tripod_Bag"]; // alt: ["RHS_Kornet_Gun_Bag","RHS_Kornet_Tripod_Bag"], ["RHS_Metis_Gun_Bag","RHS_Metis_Tripod_Bag"], ["RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"]
statAABackpacks = 		[]; // Neither Igla nor ZSU can be dismantled. Any alternatives?
statMortarBackpacks = 	["UK3CB_BAF_L16","UK3CB_BAF_L16_Tripod"];
statMGlowBackpacks = 	["UK3CB_BAF_L131A1","UK3CB_BAF_Tripod"];
statMGtowerBackpacks = 	["UK3CB_BAF_L131A1","UK3CB_BAF_Tripod"];

/*
================ Gear ================
Weapons, ammo, launchers, missiles, mines, items and optics will spawn in ammo crates, the rest will not. These lists, together with the corresponding lists in the NATO/USAF template, determine what can be unlocked. Weapons of all kinds and ammo are the exception: they can all be unlocked.
*/
genWeapons = [
	"UK3CB_BAF_L110A2RIS",
	"UK3CB_BAF_L110A2",
	"UK3CB_BAF_L115A3",
	"UK3CB_BAF_L128A1",
	"UK3CB_BAF_L129A1",
	"UK3CB_BAF_L7A2",
	"UK3CB_BAF_L85A2_EMAG",
	"UK3CB_BAF_L85A2_RIS",
	"UK3CB_BAF_L85A2_UGL",
	"UK3CB_BAF_L86A2",
	"UK3CB_BAF_L91A1",
	"UK3CB_BAF_L22"

];

genAmmo = [
	"HandGrenade",
	"MiniGrenade",
	"UK3CB_BAF_556_100Rnd",
	"UK3CB_BAF_556_200Rnd_T",
	"UK3CB_BAF_338_5Rnd",
	"UK3CB_BAF_12G_Slugs",
	"UK3CB_BAF_12G_Pellets",
	"UK3CB_BAF_762_L42A1_20Rnd",
	"UK3CB_BAF_762_20Rnd",
	"UK3CB_BAF_762_100Rnd",
	"UK3CB_BAF_556_30Rnd",
	"UK3CB_BAF_556_30Rnd_T",
	"UK3CB_BAF_1Rnd_HE_Grenade_Shell",
	"UK3CB_BAF_1Rnd_HEDP_Grenade_Shell",
	"UK3CB_BAF_UGL_FlareWhite_F",
	"UK3CB_BAF_1Rnd_SmokeRed_Grenade_shell",
	"UK3CB_BAF_9_30Rnd",
	"UK3CB_BAF_556_30Rnd",
	"UK3CB_BAF_556_30Rnd"

];

genLaunchers = [
	"UK3CB_BAF_Javelin_Slung_Tube",
	"UK3CB_BAF_NLAW_Launcher",
	"UK3CB_BAF_AT4_CS_AP_Launcher"
];

genMissiles = [

	"CUP_Stinger_M"
];

genMines = [
	"rhs_mine_M19_mag",
	"APERSTripMine_Wire_Mag",
	"rhsusf_m112_mag"
];

genItems = [
	"FirstAidKit",
	"MineDetector",
	"UK3CB_BAF_HMNVS",
	"ItemGPS",
	"Rangefinder",
	"UK3CB_BAF_LLM_Flashlight_Black"

];

genOptics = [
	"RKSL_optic_LDS",
	"UK3CB_BAF_MaxiKite",
	"RKSL_optic_PMII_525_wdl",
	"UK3CB_BAF_SUSAT",
	"UK3CB_BAF_TA648_308"
];

genBackpacks = [
"UK3CB_BAF_B_Bergen_MTP_Rifleman_H_A",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_H_B",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_H_C",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_L_A",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_L_B",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_L_C",
"UK3CB_BAF_B_Bergen_MTP_Rifleman_L_D",
"UK3CB_BAF_B_Bergen_MTP_Radio_H_A",
"UK3CB_BAF_B_Bergen_MTP_Radio_H_B",
"UK3CB_BAF_B_Bergen_MTP_Radio_L_A",
"UK3CB_BAF_B_Bergen_MTP_Radio_L_B",
"UK3CB_BAF_B_Bergen_MTP_JTAC_H_A",
"UK3CB_BAF_B_Bergen_MTP_JTAC_L_A",
"UK3CB_BAF_B_Bergen_MTP_SL_H_A",
"UK3CB_BAF_B_Bergen_MTP_SL_L_A",
"UK3CB_BAF_B_Bergen_MTP_Medic_H_A",
"UK3CB_BAF_B_Bergen_MTP_Medic_H_B",
"UK3CB_BAF_B_Bergen_MTP_Medic_L_A",
"UK3CB_BAF_B_Bergen_MTP_Medic_L_B",
"UK3CB_BAF_B_Bergen_MTP_Engineer_H_A",
"UK3CB_BAF_B_Bergen_MTP_Engineer_L_A",
"UK3CB_BAF_B_Bergen_MTP_Sapper_H_A",
"UK3CB_BAF_B_Bergen_MTP_Sapper_L_A",
"UK3CB_BAF_B_Bergen_MTP_PointMan_H_A",
"UK3CB_BAF_B_Bergen_MTP_PointMan_L_A",
"UK3CB_BAF_B_Carryall_MTP",
"UK3CB_BAF_B_Kitbag_MTP",
	"tf_anprc155_coyote",
	"B_Carryall_oli"
];

genVests = [
"UK3CB_BAF_V_Osprey",
"UK3CB_BAF_V_Osprey_Belt_A",
"UK3CB_BAF_V_Osprey_Holster",
"UK3CB_BAF_V_Osprey_Grenadier_A",
"UK3CB_BAF_V_Osprey_Grenadier_B",
"UK3CB_BAF_V_Osprey_Marksman_A",
"UK3CB_BAF_V_Osprey_Medic_A",
"UK3CB_BAF_V_Osprey_Medic_B",
"UK3CB_BAF_V_Osprey_Medic_C",
"UK3CB_BAF_V_Osprey_Medic_D",
"UK3CB_BAF_V_Osprey_MG_A",
"UK3CB_BAF_V_Osprey_MG_B",
"UK3CB_BAF_V_Osprey_Rifleman_A",
"UK3CB_BAF_V_Osprey_Rifleman_B",
"UK3CB_BAF_V_Osprey_Rifleman_C",
"UK3CB_BAF_V_Osprey_Rifleman_D",
"UK3CB_BAF_V_Osprey_Rifleman_E",
"UK3CB_BAF_V_Osprey_Rifleman_F",
"UK3CB_BAF_V_Osprey_SL_A",
"UK3CB_BAF_V_Osprey_SL_B",
"UK3CB_BAF_V_Osprey_SL_C",
"UK3CB_BAF_V_Osprey_SL_D",
"UK3CB_BAF_V_Osprey_Lite",
"UK3CB_BAF_V_Pilot_A"
];

genHelmets = [
"UK3CB_BAF_H_Mk7_Camo_A",
"UK3CB_BAF_H_Mk7_Camo_B",
"UK3CB_BAF_H_Mk7_Camo_C",
"UK3CB_BAF_H_Mk7_Camo_D",
"UK3CB_BAF_H_Mk7_Camo_E",
"UK3CB_BAF_H_Mk7_Camo_F",
"UK3CB_BAF_H_Mk7_Camo_ESS_A",
"UK3CB_BAF_H_Mk7_Camo_ESS_B",
"UK3CB_BAF_H_Mk7_Camo_ESS_C",
"UK3CB_BAF_H_Mk7_Camo_ESS_D",
"UK3CB_BAF_H_Mk7_Camo_CESS_A",
"UK3CB_BAF_H_Mk7_Camo_CESS_B",
"UK3CB_BAF_H_Mk7_Camo_CESS_C",
"UK3CB_BAF_H_Mk7_Camo_CESS_D",
"UK3CB_BAF_H_Mk7_HiVis",
"UK3CB_BAF_H_Mk7_Net_A",
"UK3CB_BAF_H_Mk7_Net_B",
"UK3CB_BAF_H_Mk7_Net_C",
"UK3CB_BAF_H_Mk7_Net_D",
"UK3CB_BAF_H_Mk7_Net_ESS_A",
"UK3CB_BAF_H_Mk7_Net_ESS_B",
"UK3CB_BAF_H_Mk7_Net_ESS_C",
"UK3CB_BAF_H_Mk7_Net_ESS_D",
"UK3CB_BAF_H_Mk7_Net_CESS_A",
"UK3CB_BAF_H_Mk7_Net_CESS_B",
"UK3CB_BAF_H_Mk7_Net_CESS_C",
"UK3CB_BAF_H_Mk7_Net_CESS_D",
"UK3CB_BAF_H_Mk7_Scrim_A",
"UK3CB_BAF_H_Mk7_Scrim_B",
"UK3CB_BAF_H_Mk7_Scrim_C",
"UK3CB_BAF_H_Mk7_Scrim_D",
"UK3CB_BAF_H_Mk7_Scrim_E",
"UK3CB_BAF_H_Mk7_Scrim_F",
"UK3CB_BAF_H_Mk7_Scrim_ESS_A",
"UK3CB_BAF_H_Mk7_Scrim_ESS_B",
"UK3CB_BAF_H_Mk7_Scrim_ESS_C",
"UK3CB_BAF_H_Mk7_Win_A",
"UK3CB_BAF_H_Mk7_Win_ESS_A",
"UK3CB_BAF_H_Boonie_MTP_PRR"

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
	"hgun_Pistol_heavy_02_F",
	"UK3CB_BAF_L91A1"

];

// Standard rifles for AI are picked from this array. Add only rifles.
unlockedRifles = [
	"UK3CB_BAF_L91A1"

];

unlockedMagazines = [
	"6Rnd_45ACP_Cylinder",
	"UK3CB_BAF_9_30Rnd"


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
	"V_BandollierB_khk"

];

unlockedBackpacks = [
	"UK3CB_BAF_B_Kitbag_OLI"
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
genAALaunchers = ["CUP_launch_FIM92Stinger"];
genATLaunchers = ["UK3CB_BAF_NLAW_Launcher","UK3CB_BAF_Javelin_Slung_Tube"];

IND_gear_heavyAT = "UK3CB_BAF_Javelin_Slung_Tube";
IND_gear_lightAT = "UK3CB_BAF_AT4_CS_AP_Launcher";

AAmissile = 	"CUP_Stinger_M";

// NVG, flashlight, laser, mine types
indNVG = 		"rhsusf_ANPVS_14";
indRF = 		"Rangefinder";
indFL = 		"UK3CB_BAF_LLM_IR_Black";
indLaser = 		"UK3CB_BAF_LLM_IR_Black";
atMine = 		"rhs_mine_M19_mag";
atMine_placed = "rhsusf_mine_M19";
atMine_type = 	"rhsusf_mine_m19_ammo";
apMine = 		"rhs_mine_pmn2_mag";
apMine_placed = "rhs_mine_pmn2";
apMine_type = 	"rhs_mine_pmn2_ammo";

// The flag
cFlag = "Flag_UK_F";

// Affiliation
side_green = 	west;

// Long-range radio
lrRadio = "tf_anprc155_coyote";

// Define the civilian helicopter that allows you to go undercover
civHeli = "C_Heli_Light_01_civil_F";

// Define the ammo crate to be spawned at camps
campCrate = "Box_NATO_Equip_F";

// Colour of this faction's markers
IND_marker_colour = "ColorWEST";

// Type of this faction's markers
IND_marker_type = "flag_UK";

// Name of the faction
A3_Str_INDEP = localize "STR_GENIDENT_BritArm";

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