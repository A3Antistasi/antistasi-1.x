// select a group from a collection of groups
params ["_groupType", "_affiliation"];

if (count _this < 2) exitWith {diag_log "Error in AS_fnc_pickGroup, incorrect number of parameters.";};

private _failureText = "";
private _returnGroup = "";
private _cfgPath = "";

switch (_affiliation) do {
	// special case to account for the fact that the player side will most likely be of the same affiliation as their support (ie: FIA & NATO are "west")
	case "guer": {
		_cfgPath = guer_cfg_inf;
	};
	case side_green: {
		_cfgPath = cfgInf;
	};
	case side_red: {
		_cfgPath = opCfgInf;
	};
	case side_blue: {
		_cfgPath = bluCfgInf;
	};
	default {
		_failureText = format ["Error in AS_fnc_pickGroup, incorrect affiliation. Group type: %1; affiliation: %2", _groupType, _affiliation];
	};
};

_AS_fnc_pickGroupSingle = {
	params ["_input"];
	private _output = "";

	// array of units
	if (typeName _input == "ARRAY") then {
		_output = _input;
	}
	else {
		if (typeName _input == "STRING") then {
			// group name without config path
			if (isClass (_cfgPath >> _input)) then {
				_output = (_cfgPath >> _input);
			};
		}
		else {
			// group name with config paths
			if (isClass _input) then {
				_output = _input;
			};
		};
	};
	_output
};

if (typeName _groupType == "ARRAY") then {
	private _randomGroup = selectRandom _groupType;

	if (typeName _randomGroup == "STRING") then {
		// array of soldiers
		if !(isClass (_cfgPath >> _randomGroup)) then {
			_returnGroup = _groupType;
		}
		else {
			_returnGroup = [_randomGroup] call _AS_fnc_pickGroupSingle;
		};
	}
	else {
		_returnGroup = [_randomGroup] call _AS_fnc_pickGroupSingle;
	};
}
else {
	if (typeName _groupType == "STRING") then {
		// group name without config path
		if (isClass (_cfgPath >> _groupType)) then {
			_returnGroup = (_cfgPath >> _groupType);
		}
		else {
			_failureText = format ["Error in AS_fnc_pickGroup, incorrect group type. Group type: %1; affiliation: %2", _groupType, _affiliation];
		};
	}
	else {
		// group name with config path
		if (isClass _groupType) then {
			_returnGroup = _groupType;
		};
	};
};
if !(_failureText == "") exitWith {
	diag_log _failureText;
};

_returnGroup