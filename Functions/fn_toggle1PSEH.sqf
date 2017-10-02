if !(isNil "AS_1PS_EH") exitWith {
	removeMissionEventHandler ['Draw3D', AS_1PS_EH];
	AS_1PS_EH = nil;
};

AS_enable3rdInVeh = true;
AS_enable3rdDist = 50;
if(!isDedicated && hasInterface) then {
    AS_1PS_EH = addMissionEventHandler ["Draw3D", {
         if (cameraView in ["INTERNAL","GUNNER"]) exitWith {};
         if ((AS_enable3rdDist) > (player distance (getMarkerPos guer_respawn))) exitWith {};
         if (AS_enable3rdInVeh && (vehicle player != player)) exitWith {};
         vehicle player switchCamera "INTERNAL";
    }];
};