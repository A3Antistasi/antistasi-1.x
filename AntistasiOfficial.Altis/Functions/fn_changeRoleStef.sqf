params ["_text"];

switch (_text) do {

	case "officer":{
		player setVariable ["class", "officer"];
		player setUnitTrait ["medic",false];
		player setUnitTrait ["engineer",false];
		player setUnitTrait ["camouflagecoef",0.8];
		player setUnitTrait ["audiblecoef",0.8];
		player setUnitTrait ["loadcoef",1.4];
		hint "Officer role.\n\nOfficers have bonuses on both silent sneaking and camouflage, but cannot carry too much items";
	};
	case "ammobearer":{
		player setVariable ["class", "ammobearer"];
		player setUnitTrait ["medic",false];
		player setUnitTrait ["engineer",false];
		player setUnitTrait ["camouflagecoef",1.2];
		player setUnitTrait ["audiblecoef",1.2];
		player setUnitTrait ["loadcoef",0.6];
		hint "Ammo bearer role.\n\nAmmo bearers have a great strenght but are easy to spot and easy to hear.";
	};

	case "autorifleman":{
		player setVariable ["class", "autorifleman"];
		player setUnitTrait ["medic",false];
		player setUnitTrait ["engineer",false];
		player setUnitTrait ["camouflagecoef",1];
		player setUnitTrait ["audiblecoef",1.2];
		player setUnitTrait ["loadcoef",0.8];
		hint "Autorifleman role.\n\nAutoriflemen have a slight bonus on carry capacity, but make too much noise when they move";
	};
	case "marksman":{
		player setVariable ["class", "marksman"];
		player setUnitTrait ["medic",false];
		player setUnitTrait ["engineer",false];
		player setUnitTrait ["camouflagecoef",0.8];
		player setUnitTrait ["audiblecoef",1];
		player setUnitTrait ["loadcoef",1.2];
		hint "Marksman role.\n\nMarksmen know well how to hide, but have less carry capacity.";
	};
	case "engineer":{
		player setVariable ["class", "engineer"];
		player setUnitTrait ["engineer",true];
		player setUnitTrait ["medic",false];
		player setUnitTrait ["camouflagecoef",1];
		player setUnitTrait ["audiblecoef",1];
		player setUnitTrait ["loadcoef",1];
		hint "Engineer role.\n\nEngineers do not have any bonus or penalties, but have the ability to use Repair Kits for vehicle repair";
	};

	case "medic":{
		player setVariable ["class", "medic"];
		player setUnitTrait ["medic",true];
		player setUnitTrait ["engineer",false];
		player setUnitTrait ["camouflagecoef",1];
		player setUnitTrait ["audiblecoef",1];
		player setUnitTrait ["loadcoef",1];
		hint "Medic role.\n\nMedics do not have any bonus or penalties, but have the ability to use Medikits for full health restoration";
	};
};