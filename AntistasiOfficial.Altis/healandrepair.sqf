private ["_posHQ"];
_posHQ = getMarkerPos guer_respawn;

{
	if (((side _x == side_blue) OR (side _x == civilian)) AND (_x distance _posHQ < 100)) then {
		if (activeACEMedical) then {
			[_x, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

{if ((side _x == side_blue) AND (_x distance _posHQ < 30)) then {_x setVariable ["compromised",0];}} forEach (allPlayers - entities "HeadlessClient_F");


{
	if (_x distance _posHQ < 100 AND {alive _x}) then {
		 reportedVehs = reportedVehs - [_x];
		_x setDamage 0;
		if(fuel _x < 0.005) then {_x setFuel 0.005};
		[_x,1] remoteExec ["setVehicleAmmo",_x];
	};
} forEach vehicles;

publicVariable "reportedVehs";

hint localize "STR_HINTS_HNR_ALL";