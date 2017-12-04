/*
 * Author: IrLED
 * Executes the initialization of headless client.
 * That includes registartion of ownerId on the Server
 *
 * Arguments:
 * 0: id of the worker to register <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

if !isServer exitWith {};
params["_id"];
INFO_1("Registartion request received. ID: %1", _id);
//validation
if ({owner _x == _id;}count allPlayers != 1) exitWith {ERROR_1("Validation failed, no entity with id:%1 found", _id);};
INFO("Validation passed");
//registartion
workerArray pushBackUnique _id;

//custom post-registartion execution
private _workerInitialization ={INFO("[SERVER] Registartion successful.");};
[_workerInitialization] remoteExec ["call", _id];