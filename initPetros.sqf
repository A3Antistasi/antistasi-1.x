removeHeadgear petros;
removeGoggles petros;
petros setSkill 1;
petros setVariable ["inconsciente",false,true];
petros setVariable ["respawning",false];
petros allowDamage true;

//[] remoteExec ["petrosAnimation", 2];
[] remoteExec ["AS_fnc_rearmPetros", 2];

petros addEventHandler ["HandleDamage", {
    params ["_unit","_part","_dam","_injurer"];

    if (isPlayer _injurer) then {
        [_injurer,60] remoteExec ["AS_fnc_punishPlayer", _injurer];
        _dam = 0;
    };

    if ((isNull _injurer) OR (_injurer == petros)) then {_dam = 0};
    if (_part == "") then {
        if (_dam > 0.95) then {
            if !(petros getVariable "inconsciente") then {
                _dam = 0.9;
                [petros] spawn inconsciente;
            } else {
                petros removeAllEventHandlers "HandleDamage";
            };
        };
    };
    _dam
}];

petros addMPEventHandler ["mpkilled", {
    params ["_unit","_killer"];

    removeAllActions petros;
    if (isServer) then {
        diag_log format ["MAINTENANCE: Petros died. Killer: %1; type: %2", _killer, typeOf _killer];
        diag_log format ["Info: players online at time of Petros' death: %1", allPlayers - entities "HeadlessClient_F"];

        if ((side _killer == side_red) OR (side _killer == side_green)) then {
            [] spawn {
                garrison setVariable ["FIA_HQ",[],true];

                if (activeJNA) then {
                    [50] spawn AS_fnc_JNA_dropPercentage;
                } else {
                    for "_i" from 0 to round random 3 do {
                        if (count unlockedWeapons > 4) then {
                            _cosa = selectRandom unlockedWeapons;
                            diag_log format ["weapon: %1", _cosa];
                            unlockedWeapons = unlockedWeapons - [_cosa];
                            lockedWeapons = lockedWeapons + [_cosa];
                            if (_cosa in unlockedRifles) then {unlockedRifles = unlockedRifles - [_cosa]};
                            _mag = (getArray (configFile / "CfgWeapons" / _cosa / "magazines") select 0);
                            if !(isNil "_mag") then {unlockedMagazines = unlockedMagazines - [_mag]; diag_log format ["weapon/mag: %1", _mag];};
                        };
                     };
                    publicVariable "unlockedWeapons";

                    if (count unlockedMagazines > 6) then {
                        for "_i" from 0 to round random 2 do {
                            _cosa = selectRandom unlockedMagazines;
                            if !(isNil "_cosa") then {
                                diag_log format ["mag: %1", _cosa];
                                unlockedMagazines = unlockedMagazines - [_cosa];
                            };
                        };
                    };
                    publicVariable "unlockedMagazines";

                    for "_i" from 0 to round random 5 do {
                        _cosa = selectRandom (unlockedItems - ["ItemMap","ItemWatch","ItemCompass","FirstAidKit","Medikit","ToolKit","ItemRadio"] - aceItems - aceAdvMedItems);
                        diag_log format ["item: %1", _cosa];
                        unlockedItems = unlockedItems - [_cosa];
                        if (_cosa in unlockedOptics) then {unlockedOptics = unlockedOptics - [_cosa]; publicVariable "unlockedOptics"};
                    };
                    publicVariable "unlockedItems";

                    clearMagazineCargoGlobal caja;
                    clearWeaponCargoGlobal caja;
                    clearItemCargoGlobal caja;
                    clearBackpackCargoGlobal caja;

                    [] remoteExec ["AS_fnc_MAINT_arsenal", 2];
                };

                waitUntil {sleep 6; isPlayer Slowhand};
                waitUntil {sleep 3; alive Slowhand};
                if (activeACE) then {
                    Slowhand setVariable ["ACE_isUnconscious",false,true];
                    [Slowhand, Slowhand] call ace_medical_fnc_treatmentAdvanced_fullHeal;
                };
                [] remoteExec ["placementSelection",Slowhand];
            };
        } else {
            AS_flag_resetDone = false;
            [position petros] remoteExec ["AS_fnc_resetHQ",2];
            //waitUntil {AS_flag_resetDone}; Suspention not allowed here! Sparker.
            AS_flag_resetDone = false;
        };
    };
}];