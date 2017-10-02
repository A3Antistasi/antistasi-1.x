//////////////////////////////////////////////////////////////////////////////////////////////////////////
//caja
caja allowDamage false;
caja addAction [localize "STR_ACT_UNLOADCARGO","[] call vaciar"];


// Stef adding class selection in singleplayer
if(!isMultiplayer) then{
caja addAction [localize "STR_ACT_CHANGEROLE",
	{CreateDialog "ROLECHANGE";},
	nil,
	0,
	false,
	true,
	"",
	"(_this == Slowhand)"
];};


caja addAction [localize "STR_ACT_MOVEASSET",
	{[_this select 0,_this select 1,_this select 2] spawn AS_fnc_moveObject},
	nil,
	0,
	false,
	true,
	"",
	"(_this == Slowhand)"
];
//caja addAction [localize "STR_ACT_SELLMENU", "UI\sellMenu.sqf",nil,0,false,true,"","(_this == Slowhand)", 5];

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//mapa----------
mapa allowDamage false;
mapa addAction [localize "str_act_gameOptions",
	{
		hint format ["Arma 3 - Antistasi\n\nVersion: %1",antistasiVersion];
		nul=CreateDialog "game_options_commander";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == Slowhand) and (_this == _this getVariable ['owner',objNull])"
];
mapa addAction [localize "str_act_gameOptions",
	{
		hint format ["Arma 3 - Antistasi\n\nVersion: %1",antistasiVersion];
		nul=CreateDialog "game_options_player";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and !(_this == Slowhand) and (_this == _this getVariable ['owner',objNull])"
];
mapa addAction [localize "str_act_mapInfo",
	{
		nul = [] execVM "cityinfo.sqf";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];
mapa addAction [localize "str_act_tfar",
	{
		nul=CreateDialog "tfar_menu";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isClass (configFile >> ""CfgPatches"" >> ""task_force_radio""))",
	5
];
mapa addAction [localize "str_act_moveAsset",
	"moveObject.sqf",
	nil,
	0,
	false,
	true,
	"",
	"(_this == Slowhand)",
	5
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//bandera
bandera allowDamage false;
bandera addAction [localize "str_act_hqOptions",
	{
		nul=[] execVM "Dialogs\dialogHQ.sqf";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (player == Slowhand) and (_this == _this getVariable ['owner',objNull]) and (petros == leader group petros)"
];
bandera addAction [localize "str_act_recruitUnit",
	{
		nul=[] execVM "Dialogs\unit_recruit.sqf";
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];
bandera addAction [localize "str_act_moveAsset",
	"moveObject.sqf",
	nil,
	0,
	false,
	true,
	"",
	"(_this == Slowhand)",
	5
];


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//cajaVeh
cajaVeh allowDamage false;
cajaVeh addAction [localize "str_act_healRepair", "healandrepair.sqf",nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
cajaVeh addAction [localize "str_act_moveAsset", "moveObject.sqf",nil,0,false,true,"","(_this == Slowhand)",5];
cajaVeh addAction [localize "str_act_buyVehicle",
	{
		nul = createDialog "vehicle_option"
	},
	nil,
	0,
	false,
	true,
	"",
	"(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"
];
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//campFire
fuego allowDamage false;
fuego addAction [localize "str_act_rest", "skiptime.sqf",nil,0,false,true,"","isPlayer _this"];
fuego addAction [localize "str_act_moveAsset",
	"moveObject.sqf",
	nil,
	0,
	false,
	true,
	"",
	"(_this == Slowhand)",
	5
];

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//petros
grupoPetros = group petros;
grupoPetros setGroupId ["Petros","GroupColor4"];
petros setIdentity "amiguete";
petros setName "Petros";
petros forceSpeed 0;
petros setCombatMode "GREEN";
//petros addAction [localize "str_act_missionRequest", {nul=CreateDialog "mission_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"]; mnarijnm 16/08: not needed, gives double mission_menu