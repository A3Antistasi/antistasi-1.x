activeACRE = false;

if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
    activeACRE = true;
	unlockedItems pushBackUnique "ItemRadio";
	unlockedItems pushBackUnique "ACRE_PRC343";
	unlockedItems pushBackUnique "ACRE_PRC148";
	unlockedItems pushBackUnique "ACRE_PRC152";
	unlockedItems pushBackUnique "ACRE_PRC77";
	unlockedItems pushBackUnique "ACRE_PRC117F";
};