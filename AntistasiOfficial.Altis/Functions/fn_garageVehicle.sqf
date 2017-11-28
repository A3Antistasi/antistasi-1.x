params [["_FIA", false]];
private ["_veh","_vehType", "_permission", "_text"];

[cursorobject,caja,true] remoteExec ["AS_fnc_transferGear",2];
cursorobject call jn_fnc_garage_garageVehicle;