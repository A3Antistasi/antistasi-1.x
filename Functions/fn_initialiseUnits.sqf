params ["_soldiersToInit", ["_initSide", side_green], ["_triggerSpawn", false], ["_vehicleToInit", "none"]];

private _AAF = genInitBASES;
if (_triggerSpawn) then {
	_AAF = genInit;
};

if (typeName _initSide == "GROUP") then {
	_initSide = side _initSide;
};

if (_initSide == side_red) then {
	if (typeName _soldiersToInit == "ARRAY") then {
		{[_x] spawn CSATinit} forEach _soldiersToInit;
	}
	else {
		{[_x] spawn CSATinit} forEach units _soldiersToInit;
	};
    if !(_vehicleToInit isEqualTo "none") then {
    	[_vehicleToInit] spawn CSATVEHinit;
    };
} else {
	if (typeName _soldiersToInit == "ARRAY") then {
		{[_x] spawn _AAF} forEach _soldiersToInit;
	}
	else {
		{[_x] spawn _AAF} forEach units _soldiersToInit;
	};
    if !(_vehicleToInit isEqualTo "none") then {
    	[_vehicleToInit] spawn genVEHinit;
    };
};