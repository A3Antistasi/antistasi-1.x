/*
 	Description:
		Get the JNA category of an item

	Parameters:
		0: STRING - Class name of item

 	Returns:
		STRING - Name of category as listed in fn_JNA_getLists

 	Example:
		_cat = ["arifle_TRG21_F"] call AS_fnc_JNA_classifyItem;
*/

params ["_item"];
[[],""] params ["_data","_category"];

_data = _x call bis_fnc_itemtype;

call {
	if ((_data select 0) isEqualTo "Weapon") exitWith {
		if ((_data select 1) in ["AssaultRifle","MachineGun","Shotgun","Rifle","SubmachineGun","SniperRifle"]) exitWith {
			_category = "primary";
		};
		if ((_data select 1) in ["Launcher","MissileLauncher","RocketLauncher"]) exitWith {
			_category = "secondary";
		};
		if ((_data select 1) in ["Handgun"]) exitWith {
			_category = "handgun";
		};
		if ((_data select 1) in ["UnknownWeapon"]) exitWith {
			_category = "misc";
		};
	};

	if ((_data select 0) isEqualTo "Item") exitWith {
		if ((_data select 1) in ["FirstAidKit","Medikit","MineDetector","Toolkit"]) exitWith {
			_category = "misc";
		};
		if ((_data select 1) in ["Binocular","LaserDesignator"]) exitWith {
			_category = "binos";
		};
		if ((_data select 1) in ["AccessoryPointer"]) exitWith {
			_category = "accessory";
		};
		if ((_data select 1) in ["AccessoryMuzzle"]) exitWith {
			_category = "muzzle";
		};
		if ((_data select 1) in ["AccessorySights"]) exitWith {
			_category = "optic";
		};
		if ((_data select 1) in ["AccessoryBipod"]) exitWith {
			_category = "bipod";
		};
		if ((_data select 1) in ["NVGoggles"]) exitWith {
			_category = "nvg";
		};
		if ((_data select 1) in ["Compass"]) exitWith {
			_category = "compass";
		};
		if ((_data select 1) in ["GPS"]) exitWith {
			_category = "gps";
		};
		if ((_data select 1) in ["Map"]) exitWith {
			_category = "map";
		};
		if ((_data select 1) in ["Radio"]) exitWith {
			_category = "radio";
		};
		if ((_data select 1) in ["Watch"]) exitWith {
			_category = "watch";
		};
	};

	if ((_data select 0) isEqualTo "Equipment") exitWith {
		if ((_data select 1) in ["Uniform"]) exitWith {
			_category = "uniform";
		};
		if ((_data select 1) in ["Vest"]) exitWith {
			_category = "vest";
		};
		if ((_data select 1) in ["Backpack"]) exitWith {
			_category = "backpack";
		};
		if ((_data select 1) in ["Headgear"]) exitWith {
			_category = "helmet";
		};
		if ((_data select 1) in ["Glasses"]) exitWith {
			_category = "goggle";
		};
	};

	if ((_data select 0) isEqualTo "Magazine") exitWith {
		if ((_data select 1) in ["Bullet","Missile","Rocket","Shell","ShotgunShell","SmokeShell","Laser"]) exitWith {
			_category = "ammo";
		};
		if ((_data select 1) in ["Flare","Grenade"]) exitWith {
			_category = "grenade";
		};
		if ((_data select 1) in ["UnknownMagazine"]) exitWith {
			_category = "misc";
		};
	};

	if ((_data select 0) isEqualTo "Mine") exitWith {
		_category = "mine";
	};

	if ((_data select 0) isEqualTo "") exitWith {
		_category = "misc";
	};
};

_category