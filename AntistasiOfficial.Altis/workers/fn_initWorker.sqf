/*
 * Author: IrLED
 * Executes the initialization of headless client.
 * That includes registartion of ownerId on the Server
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

if !(isNil "headlessInit") exitWith {};
if (!hasInterface && !isDedicated) then {
    INFO_1("Headless client initialization. ownerID: %1", clientOwner);
    LOG("Sending registration info to the server");
    [clientOwner] remoteExec ["AS_fnc_registerWorker", 2];
};
headlessInit = 1;