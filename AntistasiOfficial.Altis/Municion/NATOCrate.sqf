//if (!isServer) exitWith {};

private ["_crate","_NATOSupp","_weapons", "_lmgs", "_lmgAmmo", "_smAmmo", "_int"];

_crate = _this select 0;
_NATOSupp = _this select 1;

_weapons = bluRifle + bluSNPR + bluLMG + bluSmallWpn;
_lmgs = [bluLMG select 1];
_lmgs pushBack (bluLMG select 2);

_lmgAmmo = [bluLMGAmmo select 0];
_lmgAmmo pushBack (bluLMGAmmo select 1);

_smAmmo = [bluSmallAmmo select 0];
_smAmmo pushBack (bluSmallAmmo select 1);

clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

//add jnl load action
_crate call jn_fnc_logistics_addAction;

//Standard Equipment (good for 5 people)
	//										Weapon						
	_crate addWeaponCargoGlobal 		[bluSmallWpn 	select 0,	5	];	
	_crate addMagazineCargoGlobal 		[bluSmallAmmo 	select 0,	25	];
	_crate addWeaponCargoGlobal 		[bluSmallWpn 	select 1,	5	];
	_crate addMagazineCargoGlobal 		[bluSmallAmmo 	select 1,	25	];
	_crate addItemCargoGlobal			["SmokeShellRed"		,	25	];
	_crate addItemCargoGlobal			["SmokeShellGreen"		,	25	];
	_crate addItemCargoGlobal				
	_crate addItemCargoGlobal			[bluAttachments select 0,	5	];	//flashlight

	//										Medical
	if !(activeACEMedical) then( 
		_crate addItemCargoGlobal		["FirstAidKit"			,	25	];
		)
		else( 
		_crate addItemCargoGlobal		["ACE_epinephrine"		,	10	];		
		_crate addItemCargoGlobal		["ACE_morphine"			,	25	];
		_crate addItemCargoGlobal		["ACE_fieldDressing"	,	25	];
		_crate addItemCargoGlobal		["ACE_bloodIV"			,	40	];
		)
	// 										AT
	_crate addWeaponCargoGlobal			[bluAT 			select 0,	5	];

// Additional equipment depending on ArmyLevel
	if (BE_currentStage == 3) then {
		
		
	}
	else {
	if (BE_currentStage == 2) then {
		
	}
	else {
		if (BE_currentStage == 1) then {
			
			
		};
	};
};


if (activeAFRF) then {
	_crate addItemCargoGlobal ["Laserdesignator",1];
	_crate addItemCargoGlobal ["Laserbatteries",1];
};

_int = round (_NATOSupp/10);
if (activeTFAR) then {
	if (lrRadio in unlockedBackpacks) then {
		_crate addBackpackCargoGlobal [lrRadio, 2];
	}
	else {
		_crate addBackpackCargoGlobal [lrRadio, 1 + _int];
	};
};

if (activeACE) then {
	_crate addMagazineCargoGlobal ["ACE_HuntIR_M203", 3];
	_crate addItemCargoGlobal ["ACE_HuntIR_monitor", 1];

// This should be added only from the tier you get the sniper rifle.
	if (_NATOSupp > 60) then {
		_crate addItemCargoGlobal ["ACE_Vector", 5];
		_crate addItemCargoGlobal ["ACE_microDAGR", 5];
		_crate addItemCargoGlobal ["ACE_ATragMX", 5];
		_crate addItemCargoGlobal ["ACE_Kestrel4500", 5];
	}
	else {
		_crate addItemCargoGlobal ["ACE_Vector", 3];
		_crate addItemCargoGlobal ["ACE_microDAGR", 3];
		_crate addItemCargoGlobal ["ACE_ATragMX", 3];
		_crate addItemCargoGlobal ["ACE_Kestrel4500", 3];
	};
};


if (_NATOSupp < 50) then {
	_crate addBackpackCargoGlobal ["B_Static_Designator_01_weapon_F",1];
	_crate addItemCargoGlobal ["B_UavTerminal",1];
} else {
	if (replaceFIA) then {
		_crate addBackpackCargoGlobal ["I_UAV_01_backpack_F",1];
		_crate addItemCargoGlobal ["I_UavTerminal",1];
	} else {
		_crate addBackpackCargoGlobal ["B_UAV_01_backpack_F",1];
		_crate addItemCargoGlobal ["B_UavTerminal",1];
	};
};

//Add the raven UAV from RHS
if (activeUSAF) then
{
	_crate addBackpackCargoGlobal ["B_rhsusf_B_BACKPACK", 2];
};
