params ["_text"];

switch (_text) do {

case "officer":{
	player setVariable ["class", "officer"];
player setUnitTrait ["medic",false];
player setUnitTrait ["engineer",false];
player setUnitTrait ["camouflagecoef",0.8];
player setUnitTrait ["audiblecoef",0.8];
player setUnitTrait ["loadcoef",1.4];};


case "ammobearer":{
	player setVariable ["class", "ammobearer"];
player setUnitTrait ["medic",false];
player setUnitTrait ["engineer",false];
player setUnitTrait ["camouflagecoef",1.2];
player setUnitTrait ["audiblecoef",1.2];
player setUnitTrait ["loadcoef",0.6];};

case "autorifleman":{
player setVariable ["class", "autorifleman"];
player setUnitTrait ["medic",false];
player setUnitTrait ["engineer",false];
player setUnitTrait ["camouflagecoef",1];
player setUnitTrait ["audiblecoef",1.2];
player setUnitTrait ["loadcoef",0.8];};

case "marksman":{
	player setVariable ["class", "marksman"];
player setUnitTrait ["medic",false];
player setUnitTrait ["engineer",false];
player setUnitTrait ["camouflagecoef",0.8];
player setUnitTrait ["audiblecoef",1];
player setUnitTrait ["loadcoef",1.2];};

case "engineer":{
	player setVariable ["class", "engineer"];
player setUnitTrait ["engineer",true];
player setUnitTrait ["medic",false];
player setUnitTrait ["camouflagecoef",1];
player setUnitTrait ["audiblecoef",1];
player setUnitTrait ["loadcoef",1];};

case "medic":{
	player setVariable ["class", "medic"];
player setUnitTrait ["medic",true];
player setUnitTrait ["engineer",false];
player setUnitTrait ["camouflagecoef",1];
player setUnitTrait ["audiblecoef",1];
player setUnitTrait ["loadcoef",1];};
};