params ["_unit", "_medic"];
private ["_timeOut","_healed"];

_healed = false;

if (_medic != _unit) then {
    _unit setVariable ["ASmedHelped",true];
    _medic setVariable ["ASmedHelping",true];
	if !([_unit] call AS_fnc_isUnconscious) then {
		_unit groupChat format ["Comrades, this is %1. I'm hurt",name _unit];
		playSound3D [(injuredSounds call BIS_fnc_selectRandom),_unit,false, getPosASL _unit, 1, 1, 50];
		sleep 2;
		_medic groupChat format ["Wait a minute comrade %1, I will patch you up",name _unit];
	};
	if (player == _unit) then {hint format ["%1 is on the way to help you",name _medic]};
	[_medic,_unit] call coverWithSmoke;
	_medic stop false;
	_timeOut = time + 60;
	_medic disableAI "AUTOCOMBAT";
	while {true} do {
		_medic doMove getPosATL _unit;
		if ((!alive _medic) or (!alive _unit) or (_medic distance _unit < 3) or (_timeOut < time) or ([_medic] call AS_fnc_isUnconscious) or (_unit != vehicle _unit) or (_medic != vehicle _medic)) exitWith {};
		if (isPlayer _unit) then{
			if ((unitReady _medic) and (alive _medic) and (_medic distance _unit > 3) and !([_medic] call AS_fnc_isUnconscious)) then {_medic setPos position _unit};
		};
		sleep 1;
	};
	_medic enableAI "AUTOCOMBAT";
	if ((_unit distance _medic < 3) and (alive _unit) and (alive _medic)) then
		{
		_medic stop true;
		_unit stop true;
		_medic action ["HealSoldier",_unit];
		if (activeACEMedical) then {
			_medic playMove "AinvPknlMstpSnonWnonDnon_medic_1";
		};
		sleep 10;
		if (activeACEMedical) then {
			[_unit, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
		};
		[_unit, false] call AS_fnc_setUnconscious;
		_medic stop false;
		_unit stop false;
		_unit dofollow leader group _unit;
		_medic doFollow leader group _unit;
		_healed = true;
		if ((alive _medic) and (alive _unit) and !([_medic] call AS_fnc_isUnconscious)) then {
			if (_medic != _unit) then {_medic groupChat format ["You are ready %1",name _unit]};
		};
	};
} else {
	[_medic,_medic] call coverWithSmoke;
	_unit setVariable ["ASmedHelped",true];
	_medic setVariable ["ASmedHelping",true];
	_medic action ["HealSoldierSelf",_medic];
	if (activeACEMedical) then {
		_medic playMove "AinvPknlMstpSnonWnonDnon_medic_1";
	};
	sleep 10;
	if (activeACEMedical) then {
		[_unit, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
	};
	_healed = true;
};
_unit setVariable ["ASmedHelped",nil];
_medic setVariable ["ASmedHelping",nil];
_healed