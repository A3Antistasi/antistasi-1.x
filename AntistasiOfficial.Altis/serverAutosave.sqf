if (!isServer) exitWith {};

while {true} do{
	_needToTerminate = false;
	sleep 3600; // 3600
	if(!(isNil "placementDone")) then //Check if placement is done
	{
			diag_log "serverAutosave.sqf: placement is done.";
			//[] execVM "statSave\saveGame.sqf";
			_found = false;
			{
				if (_x select 0 == "resourcecheck") then{
					if (_x select 2) exitWith {_found = true};
				};
			} forEach diag_activeSQFScripts;


			if(_found) then //If it's not broken, save the game
			{
				call AS_fnc_saveGame;
				diag_log "serverAutosave.sqf: game has been saved.";
			}
			else
			{
				_needToTerminate = true;
				diag_log "serverAutosave.sqf: error: resourcecheck.sqf has NOT been found. Unknown causes. Proceeding to end the mission.";
			};
	}
	else
	{
		diag_log "serverAutosave.sqf: placement is NOT done yet. The game has NOT been saved.";
	};
	if (_needToTerminate) exitWith {}
};

while {true} do{
	[petros,"locHint","STR_HINTS_SERV_AUTO_SAVE"] remoteExec ["commsMP"];
	sleep 10;
};