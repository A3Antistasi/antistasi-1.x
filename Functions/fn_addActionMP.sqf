if (isDedicated) exitWith {};

params ["_object", "_type"];

switch _type do {
	case "take": {removeAllActions _object; _object addAction [localize "STR_ACT_TAKEFLAG", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "unit": {_object addAction [localize "STR_ACT_RECRUITUNIT", {nul=[] execVM "Dialogs\unit_recruit.sqf";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "vehicle": {_object addAction [localize "STR_ACT_BUYVEHICLE", {createDialog "vehicle_option";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "mission": {petros addAction [localize "STR_ACT_MISSIONREQUEST", {nul=CreateDialog "mission_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "misCiv": {_object addAction [localize "STR_ACT_MISSIONREQUEST", {nul=CreateDialog "misCiv_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "misMil": {_object addAction [localize "STR_ACT_MISSIONREQUEST", {nul=CreateDialog "misMil_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "camion": {_object addAction [localize "STR_ACT_LOADAMMOBOX", "Municion\transfer.sqf",nil,0,false,true]};
	case "remove": {
		for "_i" from 0 to (_object addAction ["",""]) do {
			_object removeAction _i;
		};
	};
	case "refugiado": {_object addAction [localize "STR_ACT_ORDERREFUGEE", "AI\liberaterefugee.sqf",nil,0,false,true]};
	case "prisionero": {_object addAction [localize "STR_ACT_LIBERATE", "AI\liberatePOW.sqf",nil,0,false,true]};
	case "interrogar": {_object addAction [localize "STR_ACT_INTERROGATE", "AI\interrogar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "capturar": {_object addAction [localize "STR_ACT_OFFERTOJOIN", "AI\capturar.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "buildHQ": {_object addAction [localize "STR_ACT_BUILDHQ", {[] spawn buildHQ},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]};
	case "seaport": {_object addAction ["Buy Boat", "REINF\buyBoat.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "steal": {_object addAction ["Steal Static", "REINF\stealStatic.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "garage": {
		if (isMultiplayer) then {
			_object addAction [localize "STR_ACT_PERSGARAGE", {[true] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]
		} else {
			_object addAction ["FIA Garage", {[false] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]
		};
	};
	case "heal_camp": {_object addAction [localize "STR_ACT_USEMED", {[position (_this select 0)] spawn AS_fnc_healCamp},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "refuel": {_object addAction [localize "STR_ACT_REFUEL", {[] spawn AS_fnc_refuelVehicles},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "conversation": {_object addAction [localize "STR_ACT_TALK", "AI\conversation.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "buy_exp": {_object addAction [localize "STR_ACT_BUY", {nul=CreateDialog "exp_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "jam": {_object addAction [localize "STR_ACT_JAMCSAT", "jamLRRAdio.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "toggle_device": {_object addAction [localize "STR_ACT_TOGGLEDEVICE", "Scripts\toggleDevice.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "unload_pamphlets": {_object addAction [localize "STR_ACT_PAMPHLETS", {server setVariable ["pr_unloading_pamphlets", true, true]; [[_this select 0,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];};
	case "moveObject" : {_object addAction [localize "STR_ACT_MOVEASSET", {[_this select 0,_this select 1,_this select 2] spawn AS_fnc_moveObject},nil,0,false,true,"","(_this == Slowhand)"]};
	case "deploy" : {_object addAction [localize "STR_ACT_BUILDPAD", {[_this select 0, _this select 1] remoteExec ["AS_fnc_deployPad", 2]},nil,0,false,true,"","(_this == Slowhand)"]};
	case "heal": {if (player != _object) then {_object addAction ["Revive", "Revive\actionRevive.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]}};
	case "removeObj" : {_object addAction [localize "STR_ACT_REMOVEASSET", {deleteVehicle (_this select 0)},nil,0,false,true,"","(_this == Slowhand)"]};
	case "Capture_HVT": {_object addAction [localize "STR_ACT_CAPTURE_HVT", "AI\CaptureHVT.sqf",nil,0,false,true]};
};