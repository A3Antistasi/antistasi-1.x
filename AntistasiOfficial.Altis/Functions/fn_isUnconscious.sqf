/*
 * Author: IrLED
 * Checks if the player is unconscious
 *
 * Arguments:
 * player: OBJECT
 *
 * Return Value:
 * BOOLEAN - true if the object is unconscious
 *
 * Public: No
 */
params [["_player", objNull]];
if (isNull _player) then {
    true;
} else {
    (_player getVariable ["ASunconscious",false]) || (_player getVariable ["ACE_isUnconscious",false]);
};