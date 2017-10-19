/*
  SHK_Fastrope by Shuko (LDD Kyllikki)
  Version 1.30

  Inspired by v1g Fast Rope by [STELS]Zealot (modified by TheRick for Altis Life)

  Place following into (at the start) initPlayerLocal.sqf

    #include "SHK_Fastrope.sqf"

  Access to toss and cut ropes are determined by global variable SHK_Fastrope_AccessLevel
  0 = everyone (default), 1 = cargo only, 2 = pilots only

  Fast-roping AI units or groups
    grpAI call SHK_Fastrope_fnc_AIs
    [unit1,unit2,unit3] call SHK_Fastrope_fnc_AIs

  Version history
    1.30  Changed: Reverted back to free-fall descending instead of attached to rope
          Fixed:   Only units in cargo can fast-rope. Now grouped AI pilot should not follow
          Added:   Access level setting for tossing and cutting (for Moon_chilD)
          Added:   Fail-safe to prevent units getting stuck at the lower end of the rope
    1.21  Fixed:   ACE actions (thanks cyborg111)
          Added:   Roof detection; detect end of rope instead of ground (for delta_actual)
    1.20  Added:   Support for ACE interaction menu (for delta_actual)
          Added:   AI groups can be fast-roped (for iWazaru)
          Changed: Descending code, now attached to rope instead of slowed free-fall
    1.11  Added:   Door names for RHS UH60 and UH1 (thanks DÄZ)
    1.10  Added:   Support for respawn (thanks cyborg111)
    1.01  Added:   MELB_MH6M (thanks cyborg111)

  TODO
    - Queue emptying when ropes are cut too early (by chopper moving)
    - Multi-rope (one per unit) for CH-47 etc with rear door
    - More dynamic ropes
*/


#define MAX_ALTITUDE_ROPES_AVAIL 70
#define MIN_ALTITUDE_ROPES_AVAIL 5
#define MAX_SPEED_ROPES_AVAIL 50

#define ROPE_LENGTH 75

#define STR_TOSS_ROPES "Toss ropes"
#define STR_FAST_ROPE "Fast-rope"
#define STR_CUT_ROPES "Cut ropes"

#define STR_JOIN_QUEUE_HINT "You're in the fast-rope queue."

// Who can toss and cut ropes
// 0 = everyone, 1 = cargo only, 2 = pilots only
SHK_Fastrope_AccessLevel = 0;

// ["ClassName",["Door_L","Door_R"],[[ropeAttachPosition1],[ropeAttachPosition2]]]
// Search for the chopper type is done from top to bottom. You can use vehicle base classes,
// but specific vehicles should be at the top because first match is used (which could be base class and not the subclass).
SHK_Fastrope_Helis = [

  //[MELB] Mission Enhanced Little Bird
  ["MELB_MH6M",[],[[1.2,0.8,-0.1],[-1.2,0.8,-0.1]]],

  // RHS: Armed Forces of Russian Federation
  ["RHS_Mi8_base",[],[[0,-3,0]]],
  ["RHS_Mi24_base",[],[[1.6,3.3,0],[-0.4,3.3,0]]],
  ["RHS_Ka60_grey",[],[[1.4,1.35,0],[-1.4,1.35,0]]],

  //RHS: United States Armed Forces
  ["RHS_CH_47F_base",[],[[0,-0.4,0]]],
  ["RHS_UH60_base",["DoorRB"],[[1.44,1.93,-0.49]]],
  ["RHS_UH1_base",["DoorLB","DoorRB"],[[0.95,3,-0.9],[-0.95,3,-0.9]]],

  // Arma 3
  ["Heli_Light_01_unarmed_base_F",[],[[1.1,0.5,-0.5],[-1.1,0.5,-0.5]]], //Hummingbird
  ["Heli_Transport_01_base_F",["door_L","door_R"],[[-1.01,2.5,0.25],[1.13,2.5,0.25]]], //Ghost Hawk
  ["Heli_Transport_03_base_F",["Door_rear_source"],[[-1.35,-4.6,-0.5],[1.24,-4.6,-0.5]]], //Huron  Side doors: "Door_L_source","Door_R_source"
  ["I_Heli_Transport_02_F",["CargoRamp_Open"],[[0,-5,0]]], //Mohawk
  ["Heli_light_03_base_F",[],[[0.95,3,-0.9],[-0.95,3,-0.9]]], //Hellcat
  ["Heli_Attack_02_base_F",["door_L","door_R"],[[1.3,1.3,-0.6],[-1.3,1.3,-0.6]]], //Kajman
  ["Heli_Light_02_base_F",[],[[1.35,1.35,0],[-1.45,1.35,0]]], //Orca
  ["O_Heli_Transport_04_covered_F",["Door_4_source","Door_5_source"],[[1.3,1.3,-0.1],[-1.5,1.3,-0.1]]], //Taru covered
  ["O_Heli_Transport_04_bench_F",["Door_4_source","Door_5_source"],[[1.3,0.15,-0.1],[-1.5,0.15,-0.1]]] //Taru bench underneath


];

SHK_Fastrope_fnc_addActions = {
  player addAction["<t color='#ffff00'>"+STR_TOSS_ROPES+"</t>", SHK_Fastrope_fnc_createRopes, [], -1, false, false, '','call SHK_Fastrope_fnc_canCreate'];
  player addAction["<t color='#ff0000'>"+STR_CUT_ROPES+"</t>", SHK_Fastrope_fnc_cutRopes, [], -1, false, false, '','call SHK_Fastrope_fnc_canCut'];
  player addAction["<t color='#00ff00'>"+STR_FAST_ROPE+"</t>", SHK_Fastrope_fnc_queueUp, [], 15, false, false, '','call SHK_Fastrope_fnc_canFastrope'];
};

// grpAI call SHK_Fastrope_fnc_AIs
// [unit1,unit2,unit3] call SHK_Fastrope_fnc_AIs
SHK_Fastrope_fnc_AIs = {
  params [["_units",[],[[],grpNull]],"_heli"];

  if !(_units isEqualType []) then {
    _units = units _units;
  };

  _heli = objectParent (_units select 0);

  doStop (driver _heli);
  (driver _heli) setBehaviour "Careless";
  (driver _heli) setCombatMode "Blue";

  [_heli, _units] spawn {
    params ["_heli","_units","_ropes","_rope","_count","_sh",["_i",0]];
    _sh = _heli spawn SHK_Fastrope_fnc_createRopes;
    waitUntil {scriptDone _sh};

    if (_heli isKindOf "RHS_CH_47F_base") then {sleep 2};
    _ropes = _heli getVariable ["SHK_Fastrope_Ropes",[]];
    _count = count _ropes;

    {
      if (!alive _x || isPlayer _x || objectParent _x != _heli) then {
        _units = _units - [_x];
      };
    } forEach _units;

    {
      if (_count > 0) then {
        if (_count == 2) then {
          _rope = _ropes select _i;
          if (_i == 0) then {  _i = 1 } else { _i = 0 };
        } else {
          _rope = _ropes select 0;
        };
        [_x,_rope] call SHK_Fastrope_fnc_fastRope;
      };
    } forEach _units;

    waituntil {sleep 0.5; { (getPosATL _x select 2) < 1 } count _units == count _units };
    sleep 3;
    if ((count (_heli getVariable ["SHK_Fastrope_Ropes",[]])) > 0) then {
      _heli call SHK_Fastrope_fnc_cutRopes;
    };
    sleep 5;
    (driver _heli) doFollow (leader group (driver _heli));
    (driver _heli) setBehaviour "Aware";
    (driver _heli) setCombatMode "White";
  };
};

// Check if the player is allowed to drop the ropes
// Conditions: chopper speed low enough, no ropes attached yet, chopper altitude between given values, suitable access level
SHK_Fastrope_fnc_canCreate = {
  private ["_heli","_alt","_altBool","_speedBool","_ropesBool","_role","_roleBool"];
  _heli = objectParent player;
  _roleBool = call SHK_Fastrope_fnc_hasAccess;

  _alt = (getPosATL _heli select 2);
  _altBool = ((_alt < MAX_ALTITUDE_ROPES_AVAIL) && (_alt > MIN_ALTITUDE_ROPES_AVAIL));
  _speedBool = ((abs (speed _heli)) < MAX_SPEED_ROPES_AVAIL);
  _ropesBool = (count (_heli getVariable ["SHK_Fastrope_Ropes",[]]) == 0);

  (_altBool && _speedBool && _ropesBool && _roleBool)
};

SHK_Fastrope_fnc_canCut = {
  private ["_heli","_flag","_ropesBool","_roleBool"];
  _heli = objectParent player;
  _roleBool = call SHK_Fastrope_fnc_hasAccess;
  _ropesBool = (count (_heli getVariable ["SHK_Fastrope_Ropes",[]]) > 0);

  (_roleBool && _ropesBool)
};

// Check if the player is allowed to fastrope down
// Conditions: ropes attached to chopper, player is not in the queue, chopper altitude low enough, player in the cargo of the chopper
SHK_Fastrope_fnc_canFastrope = {
  private ["_heli","_alt","_flag"];
  _heli = objectParent player;
  _alt = getPosATL _heli select 2;
  _flag = (!(player in (_heli getVariable ["SHK_Fastrope_Queue",[]])) && (count (_heli getVariable ["SHK_Fastrope_Ropes",[]]) > 0) && (_alt < MAX_ALTITUDE_ROPES_AVAIL) && _heli getCargoIndex player > -1);
  _flag
};

SHK_Fastrope_fnc_createRopes = {
  private ["_heli","_ropesPos","_ropesObj","_rope"];

  _heli = _this;

  if (_this isEqualType []) then {
    _heli = objectParent player;
  };

  _ropesPos = _heli getVariable ["SHK_Fastrope_Ropes",[]];

  // Ropes already exist
  if (count _ropesPos > 0) exitWith {};

  {
      if (_heli isKindOf (_x select 0)) exitWith {
      // Open doors
      {
        _heli animateDoor [_x,1];
      } forEach (_x select 1);

      // Rope attach positions
      _ropesPos = (_x select 2);
    };
  } forEach SHK_Fastrope_Helis;

  // Create ropes
  _ropesObj = [];
  {
    _rope = ropeCreate [_heli, _x, ROPE_LENGTH];
    _ropesObj pushBack _rope;
  } forEach _ropesPos;

  _heli setVariable ["SHK_Fastrope_Ropes", _ropesObj, true];
  _heli setVariable ["SHK_Fastrope_Queue", [], true];

  // Destroy ropes if chopper moves too fast
  _heli spawn {
    params ["_heli","_ropes"];
    waitUntil {_ropes = (_heli getVariable ["SHK_Fastrope_Ropes",[]]); abs (speed _heli) > MAX_SPEED_ROPES_AVAIL || (count _ropes == 0)};

    // Ropes already removed by call from addAction
    if (count _ropes > 0) then {
      _heli call SHK_Fastrope_fnc_cutRopes;
    };
  };
};

SHK_Fastrope_fnc_cutRopes = {
  private ["_heli","_ropes"];

  _heli = _this;

  // Function is called from addAction without helicopter parameter, use the chopper player is in.
  if (_this isEqualType []) then {
    _heli = objectParent player;
  };

  _ropes = _heli getVariable ["SHK_Fastrope_Ropes",[]];
  {
    ropeCut [_x,0];
  } forEach _ropes;

  _heli setVariable ["SHK_Fastrope_Ropes", [], true];
  _heli setVariable ["SHK_Fastrope_Queue", [], true];

  // Close doors
  {
    if (_heli isKindOf (_x select 0)) exitWith {
      {
        _heli animateDoor [_x,0];
      } forEach (_x select 1);
    };
  } forEach SHK_Fastrope_Helis;
};

SHK_Fastrope_fnc_fastRope = {
  params ["_unit","_rope"];

  [_unit,_rope] spawn { // Wait for the unit to be move out of the chopper.
    params ["_unit","_rope","_ropePos","_endOfRope","_heli","_altPrev","_altCur"];
    _heli = objectParent _unit;

    waitUntil {isNull objectParent _unit};
    if (local _unit) then {
      _unit allowDamage false;
      unassignVehicle _unit;
      [_unit] allowGetIn false;
      _ropePos = (ropeEndPosition _rope) select 0;
      _unit setPosATL [(_ropePos select 0),(_ropePos select 1),(_ropePos select 2)-2];
      _unit switchMove "LadderRifleStatic";
      _endOfRope = ((ropeEndPosition _rope select 1) select 2);
      //_z = -2;

      _altPrev = 0;
      while {_altCur = (getPosATL _unit select 2); alive _unit && (_altCur - _endOfRope) > 1} do {
        if (_altPrev isEqualTo _altCur) exitWith {}; // Failsafe incase rope falls through an object onto the ground, but unit stop at the object
        //_unit attachTo [_rope, [0,-0.25,_z]];
        //_z = _z - 0.7;
        _unit setVelocity [0,0,-8];
        sleep 0.2;
        _altPrev = _altCur;
      };
      _unit setVelocity [0,0,0];
      _unit playMove "LadderRifleDownOff";
      _unit switchMove "";
      //detach _unit;
      _unit allowDamage true;
    };
  };

  moveOut _unit;

  sleep 1.2 + (random 0.3); // delay to leave cap between units
};

// Does the player have correct access level?
// 0 = everyone, 1 = cargo only, 2 = pilots only
SHK_Fastrope_fnc_hasAccess = {
  private ["_heli","_role","_roleBool"];
  _heli = objectParent player;
  _role = _heli getCargoIndex player;
  _roleBool = true;

  if (SHK_Fastrope_AccessLevel == 1 && _role < 0) then { _roleBool = false }; // No pilots
  if (SHK_Fastrope_AccessLevel == 2 && _role >= 0) then { _roleBool = false }; // No cargo

  _roleBool
};

SHK_Fastrope_fnc_processQueue = {
  params ["_heli","_queue","_ropes","_count","_rope",["_i",0]];

  _heli = objectParent player;
  _queue = _heli getVariable ["SHK_Fastrope_Queue",[]];
  _ropes = _heli getVariable ["SHK_Fastrope_Ropes",[]];
  _count = count _ropes;

  waitUntil {_queue find player == 0};
  hintSilent "";

  doStop (driver _heli);
  (driver _heli) setBehaviour "Careless";
  (driver _heli) setCombatMode "Blue";

  {
    // Player or an AI in player's group
    if (_x == player || (group _x == group player && !isPlayer _x)) then {
      _queue = _queue - [_x];
      if (_count > 0) then {
        if (_count == 2) then {
          _rope = _ropes select _i;
          if (_i == 0) then {  _i = 1 } else { _i = 0 };
        } else {
          _rope = _ropes select 0;
        };
        [_x,_rope] call SHK_Fastrope_fnc_fastRope;
      };
    };
  } forEach _queue;

  _heli setVariable ["SHK_Fastrope_Queue", _queue, true];

  sleep 5;
  (driver _heli) doFollow (leader group (driver _heli));
  (driver _heli) setBehaviour "Aware";
  (driver _heli) setCombatMode "White";
};

SHK_Fastrope_fnc_queueUp = {
  params ["_heli","_queue","_veh"];

  _heli = objectParent player;
  _queue = _heli getVariable ["SHK_Fastrope_Queue",[]];

  _queue pushBack player;
  hintSilent STR_JOIN_QUEUE_HINT;

  // If the player is a group leader, queue up his subordinate AIs
  // Only units in cargo space can fast-rope
  if (player == leader group player) then {
    {
      _veh = objectParent _x;
      if (!isPlayer _x && _veh == _heli && _heli getCargoIndex _x > -1) then {
        _queue pushBack _x;
      };
    } forEach (units group player);
  };

  _heli setVariable ["SHK_Fastrope_Queue", _queue, true];

  _heli spawn SHK_Fastrope_fnc_processQueue;
};

if !(isServer) then {
  // If ACE is loaded, use ACE interaction menu
  if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
    private ["_actMenu","_actCreate","_actCut","_actUse"];
    _actMenu = ["SHK_Fastrope", "Fast-rope", "", {}, {true}] call ace_interact_menu_fnc_createAction;
    _actCreate = ["SHK_Fastrope_createRopes",STR_TOSS_ROPES, "", SHK_Fastrope_fnc_createRopes, {call SHK_Fastrope_fnc_canCreate}] call ace_interact_menu_fnc_createAction;
    _actCut = ["SHK_Fastrope_cutRope",STR_CUT_ROPES, "", SHK_Fastrope_fnc_cutRopes, {call SHK_Fastrope_fnc_canCut}] call ace_interact_menu_fnc_createAction;
    _actUse = ["SHK_Fastrope_fastRope",STR_FAST_ROPE, "", {[] spawn SHK_Fastrope_fnc_queueUp}, {call SHK_Fastrope_fnc_canFastrope}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _actMenu] call ace_interact_menu_fnc_addActionToObject;
    [player, 1, ["ACE_SelfActions","SHK_Fastrope"], _actCreate] call ace_interact_menu_fnc_addActionToObject;
    [player, 1, ["ACE_SelfActions","SHK_Fastrope"], _actCut] call ace_interact_menu_fnc_addActionToObject;
    [player, 1, ["ACE_SelfActions","SHK_Fastrope"], _actUse] call ace_interact_menu_fnc_addActionToObject;
  } else { // No ACE found, add normal actions
    call SHK_Fastrope_fnc_addActions;
    player addEventHandler ["Respawn",{call SHK_Fastrope_fnc_addActions;}];
  };
};
