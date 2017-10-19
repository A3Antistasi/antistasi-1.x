//[] remoteExec ["AS_fnc_saveGame",2]; //What is this?? Sparker.
[] remoteExec ["AS_fnc_loadGame",2];

//placementDone = true; publicVariable 'placementDone';
waitUntil {sleep 0.5; !(isNil "ASA3_saveLoaded")};
ASA3_saveLoaded = nil;
