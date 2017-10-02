params [["_defPos", "none"]];
private ["_dir"];

if !(typeName "_defPos" == "ARRAY") then {
	_dir = fuego getdir cajaVeh;
	_defPos = [getPos fuego, 3, _dir + 45] call BIS_Fnc_relPos;
};

petros setPos _defPos;
petros setDir (petros getDir fuego);

diag_log "Maintenance: Petros repositioned";