params ["_unit"];
private ["_unit","_EHkilledIdx"];

_unit setSkill 0;
_unit setSpeedMode "LIMITED";

_EHkilledIdx = _unit addEventHandler ["killed", {
	params ["_victim","_killer"];
	private ["_multiplicator"];

	if (activeACE) then {
		if ((isNull _killer) OR (_killer == _victim)) then {
			_killer = _victim getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};

	if (_victim == _killer) then {
		[-1,-1,getPos _victim] remoteExec ["AS_fnc_changeCitySupport",2];
	} else {
		if (isPlayer _killer) then {
			if !(isMultiPlayer) then {
				[0,-20] remoteExec ["resourcesFIA",2];
				_killer addRating -500;
			} else {
				if (typeOf _victim in CIV_workers) then {_killer addRating -1000};
				[-10,_killer] call playerScoreAdd;
			};
		};
		_multiplicator = 1;
		if (typeOf _victim in CIV_journalists) then {_multiplicator = 10};
		call {
			if (side _killer == side_blue) exitWith {
				[-1*_multiplicator,0] remoteExec ["prestige",2];
				[1,0,getPos _victim] remoteExec ["AS_fnc_changeCitySupport",2];
			};
			if (side _killer == side_green) exitWith {
				[1*_multiplicator,0] remoteExec ["prestige",2];
				[0,1,getPos _victim] remoteExec ["AS_fnc_changeCitySupport",2];
			};
			if (side _killer == side_red) exitWith {
				[2*_multiplicator,0] remoteExec ["prestige",2];
				[-1,1,getPos _victim] remoteExec ["AS_fnc_changeCitySupport",2];
			};
		};
	};
}];