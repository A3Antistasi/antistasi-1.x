if (isDedicated) exitWith {};

params ["_newUnit","_oldUnit"];
private ["_owner","_score","_rapSheet","_cash","_rank","_elegible"];

if (isNull _oldUnit) exitWith {};

waitUntil {alive player};

[_oldUnit] spawn postmortem;

_owner = _oldUnit getVariable ["owner",_oldUnit];

if (_owner != _oldUnit) exitWith {
	hint localize "STR_HINTS_GEN_OPR_TEMP";
	selectPlayer _owner;
	disableUserInput false;
	deleteVehicle _newUnit;
};

[0,-1,getPos _oldUnit] remoteExec ["AS_fnc_changeCitySupport",2];

_score = _oldUnit getVariable ["score",0];
_rapSheet = _oldUnit getVariable ["punish",0];
_cash = _oldUnit getVariable ["dinero",0];
_cash = (round (_cash - (_cash * 0.15))) max 0;
_elegible = _oldUnit getVariable ["elegible",true];
_rank = _oldUnit getVariable ["ASrank","PRIVATE"];

_newUnit setVariable ["score",_score -1,true];
_newUnit setVariable ["owner",_newUnit,true];
_newUnit setVariable ["punish",_rapSheet,true];
_newUnit setVariable ["ASrespawning",false];
_newUnit setVariable ["dinero",_cash,true];
_newUnit setVariable ["compromised",0];
_newUnit setVariable ["elegible",_elegible,true];
_newUnit setVariable ["BLUFORSpawn",true,true];
_newUnit setCaptive false;
_newUnit setRank (_rank);
_newUnit setVariable ["ASrank",_rank,true];

_oldUnit setVariable ["BLUFORSpawn",nil,true];

disableUserInput false;

if (_oldUnit == Slowhand) then {
	[_newUnit] call stavrosInit;
};

removeAllItemsWithMagazines _newUnit;
{_newUnit removeWeaponGlobal _x} forEach weapons _newUnit;
removeBackpackGlobal _newUnit;
removeVest _newUnit;
//if (!("ItemGPS" in unlockedItems) AND ("ItemGPS" in (assignedItems _newUnit))) then {_newUnit unlinkItem "ItemGPS"};  Stef disabled because no unlock and giving an annoying error message clientside sometime
if ((!activeTFAR) AND ("ItemRadio" in (assignedItems player)) AND !("ItemRadio" in unlockedItems)) then {player unlinkItem "ItemRadio"};
if (!isPlayer (leader group player)) then {(group player) selectLeader player};

call AS_fnc_initPlayerEH;

if (!(isMultiplayer) AND (activeACEMedical)) then {
	[player, false] call AS_fnc_setUnconscious;
	player setVariable ["ASrespawning",false];
	player addEventHandler ["HandleDamage", {
		if ([player] call AS_fnc_isUnconscious) then {
			0 = [player] spawn ACErespawn;
		};
	}
	];
};

[0,true] remoteExec ["pBarMP",player];
[true] execVM "reinitY.sqf";
statistics= [] execVM "statistics.sqf";

[player] execVM "OrgPlayers\unitTraits.sqf";
[player] spawn rankCheck;