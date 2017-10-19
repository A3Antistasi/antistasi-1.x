activeACE = false;
activeACEhearing = false;
activeACEMedical = false;
if !(isNil "ace_common_settingFeedbackIcons") then {
	activeACE = true;
	unlockedItems = unlockedItems + ["ACE_EarPlugs","ACE_RangeCard","ACE_Clacker","ACE_M26_Clacker","ACE_DeadManSwitch","ACE_DefusalKit","ACE_MapTools","ACE_Flashlight_MX991","ACE_Sandbag_empty","ACE_wirecutter","ACE_RangeTable_82mm","ACE_SpareBarrel","ACE_EntrenchingTool","ACE_Cellphone","ACE_ConcertinaWireCoil","ACE_CableTie","ACE_SpottingScope","ACE_Tripod","ACE_Chemlight_HiWhite","ACE_Chemlight_HiRed"];
	unlockedBackpacks pushBackUnique "ACE_TacticalLadder_Pack";
	unlockedWeapons pushBackUnique "ACE_VMH3";
	unlockedMagazines = unlockedMagazines + ["ACE_HandFlare_White","ACE_HandFlare_Red"];
	genItems = genItems + ["ACE_Kestrel4500","ACE_ATragMX"];

	if (isClass (configFile >> "CfgSounds" >> "ACE_EarRinging_Weak")) then {
		activeACEhearing = true;
	};
	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3")) then {
		activeACEMedical = true;

		if (ace_medical_level == 1) then //ACE Basic medical system
		{
			unlockedItems = unlockedItems + ["ACE_fieldDressing","ACE_bloodIV_500","ACE_bloodIV","ACE_epinephrine","ACE_morphine","ACE_bodyBag"];
		};
		if(ace_medical_level == 2) then  //ACE Advanced medical system
		{

			unlockedItems = unlockedItems + ["ACE_bloodIV_500","ACE_bloodIV","ACE_epinephrine","ACE_morphine","ACE_bodyBag","ACE_elasticBandage","ACE_bloodIV_250","ACE_packingBandage","ACE_personalAidKit","ACE_plasmaIV","ACE_plasmaIV_500","ACE_plasmaIV_250","ACE_salineIV","ACE_salineIV_500","ACE_salineIV_250","ACE_surgicalKit","ACE_tourniquet","ACE_adenosine"];
		};
	};
};

diag_log "Init: ACE detection done.";