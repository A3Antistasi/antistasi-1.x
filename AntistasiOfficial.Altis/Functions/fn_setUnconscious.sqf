/*
 * Author: IrLED
 * Sets the object/player Unconscious
 *
 * Arguments:
 * player: OBJECT
 * state: BOOLEAN true - set unit unconscious, false(default)- set unit conscious
 *
 * Return Value:
 * None
 *
 * Public: No
 */
params [["_player", objNull], ["_state", false]];
if (isNull _player) exitWith {};
[_player, _state] remoteExec ["setUnconscious", _player];
_player setVariable ["ASunconscious", _state, true];
_player setVariable ["ACE_isUnconscious", _state, true];
