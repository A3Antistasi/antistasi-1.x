if (petros getVariable ["AS_animPetros", false]) exitWith {};
petros setVariable ["AS_animPetros", true, true];

AS_AP_checkPresence = false;
AS_AP_duration = 5 + round (random 5);

private _anim_safe = "BIS_fnc_ambientAnim";
private _anim_aware = "BIS_fnc_ambientAnimCombat";
private _safe_standing = ["BRIEFING_POINT_TABLE", "GUARD", "BRIEFING"];
private _safe_sitting = ["SIT1", "SIT2"];
private _aware_standing = ["STAND_IA", "WATCH", "STAND", "WATCH2"];

private _contact = false;
private _currentAnim = "";
private _animType = _anim_safe;
private _timer = AS_AP_duration * 60;
private _loopTime = 30;

private _dir = fuego getdir cajaVeh;
private _defPos = [getPos fuego, 8, _dir + 90] call BIS_Fnc_relPos;

_fnc_terminate = {
	[petros] remoteExec ["BIS_fnc_ambientAnim__terminate", [0,-2] select isDedicated, true];
	if (primaryweapon petros != "") then {petros selectweapon primaryWeapon petros};
	_dir = fuego getdir cajaVeh;
	_defPos = [getPos fuego, 3, _dir + 90] call BIS_Fnc_relPos;
	petros setpos _defPos;
	sleep 0.25;
	petros setDir (petros getDir fuego);
};

_fnc_initiate = {
	[] call _fnc_terminate;
	[petros, _currentAnim, "ASIS"] remoteExec [_animType, [0,-2] select isDedicated, true];
	_timer = 0;
};

_fnc_check = {
	params [["_force", false]];

	if !(_force) then {
		if (_timer > (AS_AP_duration * 60) - 1) then {
			if (AS_AP_checkPresence) then {
				if ({_x distance petros < 50} count playableUnits < 1) then {
					[] call _fnc_initiate;
				};
			} else {
				[] call _fnc_initiate;
			};
		};
	} else {
		[] call _fnc_initiate;
	};
};

sleep 30;

while {(group petros != group Slowhand) && (petros getVariable ["AS_animPetros", false])} do {
	if ({((side _x == side_green) || (side _x == side_red)) and (_x distance petros < 800) and !(captive _x)} count allUnits > 0) then {
		_contact = true;
		petros allowDamage true;
	} else {
		_contact = false;
		petros allowDamage false;
	};

	call {
		private _force = false;
		if (behaviour petros == "SAFE") exitWith {
			if (_contact) then {
				petros setBehaviour "AWARE";
				_currentAnim = selectRandom _aware_standing;
				_animType = _anim_aware;
				_force = true;
			} else {
				_currentAnim = selectRandom _safe_standing;
				_animType = _anim_safe;
			};

			[_force] call _fnc_check;
		};
		if (behaviour petros == "AWARE") exitWith {
			if !(_contact) then {
				petros setBehaviour "SAFE";
				_force = true;
			};
			_currentAnim = selectRandom _aware_standing;
			_animType = _anim_aware;

			[_force] call _fnc_check;
		};
		if (behaviour petros == "COMBAT") exitWith {
			if !(_contact) then {
				petros setBehaviour "AWARE";
				[] call _fnc_terminate;
			};
		};
	};

	// remove the AI that is being spawned by the ambient animation module -- report side effects of this, none witnessed so far
	{
	    if ((_x distance position petros < 20) && !(_x in playableUnits) && (uniform _x == "") && (_x != petros) && !(count (weapons _x) > 0)) then {
	        deleteVehicle _x;
	    };
	} forEach allUnits;
	_timer = _timer + _loopTime;
	sleep _loopTime;
};

[] call _fnc_terminate;
petros setVariable ["AS_animPetros", nil, true];

[] call AS_fnc_MAINT_resetPetros;