//if (!isServer) exitWith {};

private ["_crate","_NATOSupp"];

_crate = _this select 0;
_NATOSupp = _this select 1;

[_crate] call emptyCrate;

//Standard Equipment (good for 5 people)
			//										Weapon
			_crate addWeaponCargoGlobal 		[bluSmallWpn 		select 0,	5	];
			_crate addMagazineCargoGlobal 		[bluSmallAmmo 		select 0,	25	];
			_crate addWeaponCargoGlobal 		[bluSmallWpn 		select 1,	5	];
			_crate addMagazineCargoGlobal 		[bluSmallAmmo 		select 1,	25	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 0,	5	];	//AT tube
			_crate addItemCargoGlobal 			[bluATMissile		select 0,	5	];
			_crate addItemCargoGlobal			["SmokeShellRed"			,	25	];
			_crate addItemCargoGlobal			["SmokeShellGreen"			,	25	];
			_crate addItemCargoGlobal			[bluAttachments 	select 0,	6	];	//flashlight
				{_crate addItemCargoGlobal 		[_x							,	20	];	//Shells: Smoke and Flares Green and Red
				} foreach bluGLsmoke;

			_crate addWeaponCargoGlobal 		[selectrandom bluGL			,	1	];
			_crate addMagazineCargoGlobal 		[selectrandom bluRifleAmmo	,	5	];

			//										Medical
			if !(activeACEMedical) then{
				_crate addItemCargoGlobal		["FirstAidKit"				,	25	];
				_crate addItemCargoGlobal 		["Medikit"					,	1	];
				}
				else{
				_crate addItemCargoGlobal		["ACE_epinephrine"			,	10	];
				_crate addItemCargoGlobal		["ACE_morphine"				,	25	];
				_crate addItemCargoGlobal		["ACE_fieldDressing"		,	25	];
				_crate addItemCargoGlobal		["ACE_bloodIV"				,	40	];
				};
			//										Generic

			_crate addItemCargoGlobal 			["ToolKit"					,	1	];
			_crate addItemCargoGlobal 			["MineDetector"				,	1	];
			if (activeTFAR) then {
			_crate addBackpackCargoGlobal 		[lrRadio					, 	3	];
			};

			//										From Tier 1
			if(BE_currentStage > 0) then {
						_crate addWeaponCargoGlobal 		[selectrandom bluGL			,	4	];
						_crate addMagazineCargoGlobal 		[selectrandom bluRifleAmmo	,	35	];
						_crate addItemCargoGlobal			[bluScopes			select 0,	4	];
						//_crate addItemCargoGlobal			[bluSuppressor		select 0,	5	];  still missing in templates
						if (activeACE) then {
						_crate addMagazineCargoGlobal 		["ACE_HuntIR_M203"			, 	3	];
						_crate addItemCargoGlobal 			["ACE_HuntIR_monitor"		, 	1	];
						_crate addItemCargoGlobal 			["ACE_Vector"				, 	5	];
						_crate addItemCargoGlobal 			["ACE_microDAGR"			, 	5	];
						_crate addItemCargoGlobal 			["ACE_ATragMX"				, 	5	];
						_crate addItemCargoGlobal 			["ACE_Kestrel4500"			, 	5	];
						};
			};

// Additional equipment depending on ArmyLevel
	if (BE_currentStage == 3) then {
			_crate addItemCargoGlobal 			[bluHelmet			select 2,	5	]; //Helmet T3
			_crate addWeaponCargoGlobal 		[bluSNPR 			select 1,	5	]; //Sniper
			_crate addItemCargoGlobal			[bluScopes			select 2,	5	];
			_crate addMagazineCargoGlobal 		[bluSNPRAmmo 		select 1,	50	];
			_crate addWeaponCargoGlobal 		[bluAA 				select 0,	5	]; //AA
			_crate addMagazineCargoGlobal 		[bluAAMissile 		select 0,	10	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 2,	2	]; //AT Guided
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 2,	4	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 1,	5	]; //AT Non guided + rockets
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 1,	10	];
			_crate addWeaponCargoGlobal 		[bluLMG		 		select 0,	5	]; // LMG
			_crate addItemCargoGlobal			[bluScopes			select 1,	5	];
			_crate addMagazineCargoGlobal 		[bluLMGAmmo 		select 0,	40	];
			_crate addMagazineCargoGlobal 		[selectrandom bluRifleAmmo	,	50	]; // Extra ammo bonus
			if (activeACE) then {
			_crate addItemCargoGlobal 			[blunvg				select 0,	5	];};
	}
	else {
	if (BE_currentStage == 2) then {
			_crate addItemCargoGlobal 			[bluHelmet			select 1,	5	]; //Helmet T2
			_crate addWeaponCargoGlobal 		[bluSNPR 			select 0,	5	]; //Sniper
			_crate addItemCargoGlobal			[bluScopes			select 2,	5	];
			_crate addMagazineCargoGlobal 		[bluSNPRAmmo 		select 0,	50	];
			_crate addWeaponCargoGlobal 		[bluAA 				select 0,	3	]; //AA
			_crate addMagazineCargoGlobal 		[bluAAMissile 		select 0,	6	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 2,	1	]; //AT Guided
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 2,	2	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 1,	2	]; //AT Non guided + rockets
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 1,	6	];
			_crate addWeaponCargoGlobal 		[bluLMG		 		select 0,	5	]; // LMG
			_crate addItemCargoGlobal			[bluScopes			select 1,	5	];
			_crate addMagazineCargoGlobal 		[bluLMGAmmo 		select 0,	20	];
			_crate addMagazineCargoGlobal 		[selectrandom bluRifleAmmo	,	25	]; // Extra ammo
			if (activeACE) then {
			_crate addItemCargoGlobal 			[blunvg				select 0,	2	];};
	}
	else {
		if (BE_currentStage == 1) then {
			_crate addItemCargoGlobal 			[bluHelmet			select 0,	5	]; //Helmet T1
			_crate addWeaponCargoGlobal 		[bluSNPR 			select 0,	2	]; //Sniper
			_crate addMagazineCargoGlobal 		[bluSNPRAmmo 		select 0,	25	];
			_crate addWeaponCargoGlobal 		[bluAA 				select 0,	1	]; //AA
			_crate addMagazineCargoGlobal 		[bluAAMissile 		select 0,	2	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 2,	1	]; //AT Guided
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 2,	2	];
			_crate addWeaponCargoGlobal 		[bluAT		 		select 1,	2	]; //AT Non guided + rockets
			_crate addMagazineCargoGlobal 		[bluATMissile 		select 1,	2	];
			_crate addWeaponCargoGlobal 		[bluLMG		 		select 0,	2	]; // LMG
			_crate addItemCargoGlobal			[bluScopes			select 1,	2	];
			_crate addMagazineCargoGlobal 		[bluLMGAmmo 		select 0,	8	];
			if (activeACE) then {
			_crate addItemCargoGlobal 			[blunvg				select 0,	1	];};
		};
	};
};

if (activeAFRF) then {
	_crate addItemCargoGlobal ["Laserdesignator",1];
	_crate addItemCargoGlobal ["Laserbatteries",1];
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

//add jnl load action
	_crate call jn_fnc_logistics_addAction;