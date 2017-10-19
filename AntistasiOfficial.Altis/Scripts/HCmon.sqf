if ((!isServer) or (count hcArray == 0)) exitWith {};

private _initialHCs =+ hcArray;
private _numHCs = count (entities "HeadlessClient_F");
private _currentHCs = [];
private _text = "To facilitate a smoother transition, please leave the spawn radius of all units. You have three minutes.";

_reset = {
	HCciviles = 2;
	HCgarrisons = 2;
	HCattack = 2;
	hcArray = entities "HeadlessClient_F";
	if (count hcArray > 0) then {
		HCciviles = hcArray select 0;
		HCgarrisons = hcArray select 0;
		HCattack = hcArray select 0;
		diag_log "Antistasi MP Server. Headless Client 1 detected";
		if (count hcArray > 1) then {
		   	HCciviles = hcArray select 1;
		    HCattack = hcArray select 1;
		    diag_log "Antistasi MP Server. Headless Client 2 detected";
		    if (count hcArray > 2) then {
		    	HCciviles = hcArray select 2;
		    	diag_log "Antistasi MP Server. Headless Client 3 detected";
		    };
		};
	};
	publicVariable "HCciviles";
	publicVariable "HCgarrisons";
	publicVariable "HCattack";
	publicVariable "hcArray";
};

_addHC = {
	call {
		if (count _currentHCs == 1) exitWith {
			hcArray = entities "HeadlessClient_F";
			HCciviles = hcArray select 0;
			HCgarrisons = hcArray select 0;
			HCattack = hcArray select 0;
		};
		if (count _currentHCs == 2) exitWith {
			{
				if !(_x in hcArray) then {hcArray pushBack _x};
			} forEach _currentHCs;
		   	HCciviles = hcArray select 1;
		    HCattack = hcArray select 1;
		};
		if (count _currentHCs == 3) exitWith {
			{
				if !(_x in hcArray) then {hcArray pushBack _x};
			} forEach _currentHCs;
			HCciviles = hcArray select 2;
		};
	};
};

while {true} do {
	_currentHCs = entities "HeadlessClient_F";

	if (!(count _currentHCs == _numHCs) && _currentHCs < 4) then {
		if (count _currentHCs > _numHCs) then {
			if (count _currentHCs > count _initialHCs) then {
				_text = format ["A new client has connected. %1", _text];
				[petros,"hint",_text] remoteExec ["commsMP", Slowhand];
				sleep 180;
				0 = [] call _addHC;
			} else {
				_text = format ["A headless client has reconnected. %1", _text];
				[petros,"hint",_text] remoteExec ["commsMP", Slowhand];
				sleep 180;
				0 = [] call _reset;
			};
			_numHCs =+ _currentHCs;
		} else {
			_text = format ["A headless client has lost connection. %1", _text];
			[petros,"hint",_text] remoteExec ["commsMP", Slowhand];
			sleep 180;
			0 = [] call _reset;
		};

	};
	sleep 60;
};