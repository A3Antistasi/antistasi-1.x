																							/**				Conditions:				***
                                                                                            ***		(Spawn / Despawn) & Capture		***
                                                                                            ***										**/
/*from combinedCA.sqf
### Is line 9 coherent with other checks? what am i missing? ###*/

waitUntil
{
	sleep 5;
	(
		//Operative soldiers < 1/3 of All soldiers. LOSS
		({(alive _x) and (lifeState _x != "INCAPACITATED") and !(fleeing _x)} count _allSoldiers < (round ((count _allSoldiers)/3))) OR

		//time is over LOSS
		(time > _attackDuration) OR

		//objective has been captured WIN
		(_marker in mrkAAF) OR

		//(Operative FIA within 100m) < (Operative AAF within 100m) WIN
		(
    	2*count (allUnits select {(side _x == side_blue) AND (_x distance _markerPos <= 100) and (lifeState _x != "INCAPACITATED") and !(fleeing _x)})
   		<
    	count (allUnits select {((side _x == side_green) OR (side _x == side_red)) AND (_x distance _markerPos <= 100) and (lifeState _x != "INCAPACITATED")}
    )
	)
};

if ((_marker in mrkAAF) or (
    	2*count (allUnits select {(side _x == side_blue) AND (_x distance _markerPos <= 100) and (lifeState _x != "INCAPACITATED") and !(fleeing _x)})
   		<
    	count (allUnits select {((side _x == side_green) OR (side _x == side_red)) AND (_x distance _markerPos <= 100) and (lifeState _x != "INCAPACITATED")}
    )) then {hint "WIN"} else {hint "LOSS"};






//from Create(AAF).sqf (AAFcreateBase.sqf createaereopuerto.sqf)
//### I'd make a function cause it's repeating in all the files ###


//Despawning conditions for AAF marker
  waitUntil {sleep 1;
      !(spawner getVariable _marker) OR
			(
      	({!(vehicle _x isKindOf "Air")}
        count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits))
        > 3*
        count (allUnits select {
        	((side _x == side_green) OR (side _x == side_red)) AND
          (_x distance _markerPos <= (_size max 300)) AND
          !(captive _x) OR
          (lifeState _x != "INCAPACITATED")
    		})
      )
	};
---> [_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;

/*from Create(FIA).sqf
### I'd make a function cause it's repeating in all the files ###*/


waitUntil {sleep 1;
	!(spawner getVariable _marker) OR
	(
	 	({not(vehicle _x isKindOf "Air")}
	 	count ([_size,0,_markerPos,"OPFORSpawn"] call distanceUnits))
	 	> 3*
	 	(({alive _x} count _allSoldiers) + count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits))
	)
};
/*First make a sweep without sleeps to all the soldier array, so you quickly remove all those which are far, after that make the procedure you have there.
Why having 120 paralell instances of spawn, for each soldier, with its waituntil for one sec if there is no need in some of them?*/
---> [_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;



/*from fn_despawnunits.sqf
###	I have to check this one still- actually i think here lies the reason of a duplication bug that show duplicated friendly garrison ###*/



/*For below: Check warlords despawn.

//Barbolani: I dont see sense on the below. Despawning of an attack has to check Blufors nearby, and those blufors have to be "BLUFORSpawn" because of not, some garrison will keep those units in map.
//WOTP DESPAWNING (THE MOST PERFECT SYSTEM A HUMAN, IF YOU CAN CALL ME HUMAN, CAN DO):
//CHECK VARIABLE NAMES, OF COURSE*/

//CURRENT
params [["_groups", []], ["_soldiers", []], ["_vehicles", []]];

if (count _vehicles > 0) then {
	{
		if !(_x in staticsToSave) then {
			[_x] spawn {
				waitUntil {sleep 1; !([distanciaSPWN,1,_this select 0,"BLUFORSpawn"] call distanceUnits)};
				deleteVehicle (_this select 0);
			};
		};
		if (_x in reportedVehs) then {
			reportedVehs = reportedVehs - [_x];
			publicVariable "reportedVehs";
		};
	} forEach _vehicles;
};

if (count _soldiers > 0) then {
	{
		[_x] spawn {
			waitUntil {sleep 1; !([distanciaSPWN,1,_this select 0,"BLUFORSpawn"] call distanceUnits)};
			deleteVehicle (_this select 0);
		};
	} forEach _soldiers;
};

if (count _groups > 0) then {
	{
		_x deleteGroupWhenEmpty true;
	} forEach _groups;
};

// from WOTP and adapted
params [["_groups", []], ["_soldiers", []], ["_vehicles", []]];

//select 0
	{
		_veh = _x;
		if (
		    !([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits) and
			(({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)
		) then {deleteVehicle _x};
	} forEach _vehicles;

//select 1
	{
		_veh = _x;
		if (
		    !([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits) and
			(({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)
		) then {deleteVehicle _x; _soldiers = _soldiers - [_x]};
	} forEach _soldiers;

//select 2
	if (count _groups > 0) then {
		{
			_x deleteGroupWhenEmpty true;
		} forEach _groups;
	};


if (count _soldiers > 0) then {
	{
		[_x] spawn {
			private ["_veh"];
			_veh = _this select 0;
			waitUntil {sleep 1;
				!([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits) and
				( ({_x distance _veh <= distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F"))) == 0)
			};
		deleteVehicle _veh;
		};
	} forEach _soldiers;
};



//QRF
	[_marker] spawn {sleep random [300,420,600]; [_this select 0] spawn patrolCA;};

	[_marker] spawn {sleep random [300,420,600]; if ((player distance [_this select 0]) < 300) then {[_this select 0] spawn patrolCA;};};




// Air reaction
if (_vehicleType in heli_armed + opAir + opCASFW) exitWith {
		_eh = _vehicle addEventHandler ["Fired", {
			if (random 8 < 1) then { //maybe add spawn here
				if(player in crew _vehicle) then {
					_targetpos = position (_vehicle);
					_airportpos = getmakerpos ["spawnCSAT"];
					_depart = [_airportpos select 0, _airportpos select 1,300];
					_jet = [_depart, 0,dogfight, side_green] call bis_fnc_spawnvehicle;
					_pilot = driver (_jet select 0);
					_pilot reveal [driver _vehicle,4];
					_pilot dotarget _vehicle;

				};
			};
		};
	};

_vehicle = vehicle player;
_eh = _vehicle addEventHandler ["Fired", {
    	if(player in crew _vehicle) then {
     		systemchat "Eventhandler ecec"
     	};
   	}
 ];