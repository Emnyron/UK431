/*	
	INITILIZATION
*/
startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];
#include "gcam\config.hpp" //Load Gcam Config

//REALLY IMPORTANT VALUES
dayZ_instance = 1;					//The instance
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

//disable greeting menu 
player setVariable ["BIS_noCoreConversations", true];
//disable radio messages to be heard and shown in the left lower corner of the screen

//Load in compiled functions
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "fixes\compiles.sqf"; //Compile regular functions		//Compile regular functions
player_chopWood =            compile preprocessFileLineNumbers "fixes\player_chopWood.sqf"; //Better Chopping of wood
progressLoadingScreen 1.0;
spawn_loot = compile preprocessFileLineNumbers "fixes\spawn_loot.sqf";
stream_locationCheck = {
}; //Remove rubbish on the road

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

if ((!isServer) && (isNull player) ) then
{
waitUntil {!isNull player};
waitUntil {time > 3};
};

if ((!isServer) && (player != player)) then
{
  waitUntil {player == player};
  waitUntil {time > 3};
};

if (isServer) then {
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

if (!isDedicated) then {
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
	
	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";	
	_logistic = execVM "=BTC=_Logistic\=BTC=_Logistic_Init.sqf"; //Helicopter lift script
	_void = [] execVM "R3F_Realism\R3F_Realism_Init.sqf"; //Initialise weight counter
};

//STARTING HALO SCRIPT

if (!isDedicated) then {
	[] spawn {
		while {true} do
		{
			if ( (cursorTarget isKindOf "Air") and (getDammage cursorTarget < 0.95) and (!isNull player) ) then {
			  _vehicle = cursorTarget;
			  _HALO_CARGO_ActionAdded = _vehicle getVariable["HALO_CARGO_ActionAdded",false];
			 
			  if( !_HALO_CARGO_ActionAdded ) then {
				_vehicle setVariable ["HALO_CARGO_ActionAdded", true];
				// HALO Jump
				s_halo_action = _vehicle addAction [("<t color=""#FF9800"">" + ("HALO Jump") + "</t>"),"fixes\haloInit.sqf",[],2,false,true,"","(getPosATL player select 2) > 10"];
			  };
			};
			sleep 1;
		};
	};
};

//END OF HALO SCRIPT

//STARTING SPECTATE SCRIPT

#ifdef GCAM
	#ifdef ADMINS
		fnc_keyDown = 
		{
			private["_handled", "_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];
			_ctrl = _this select 0;
			_dikCode = _this select 1;
			_shift = _this select 2;
			_ctrlKey = _this select 3;
			_alt = _this select 4;

			_handled = false;

			if (!_shift && !_ctrlKey && !_alt) then
			{
				if (_dikCode == 210 ) then
				{
					#ifdef DEBUG
						diag_log format ["GCAM Starting"];
					#endif

					GCamKill = false;
					handle = [] execVM "gcam\gcam.sqf";
					_handled = true;
				};

				if (_dikCode == 207 ) then
				{
					#ifdef DEBUG
						diag_log format ["GCAM Stopping"];
					#endif

					GCamKill = true;
					_handled = true;
				};
			};

			_handled;
		};

		waitUntil {(!isNull Player) and (alive Player) and (player == player)};
		_uid = (getPlayerUID vehicle player);
	
		#ifdef DEBUG
			diag_log format ["GCAM Checking if player %1 is admin", _uid];
		#endif

		if (((_uid) in ADMINS)) then
		{
			waituntil {!(IsNull (findDisplay 46))};
			(findDisplay 46) displayAddEventHandler ["keyDown", "_this call fnc_keyDown"];

			#ifdef DEBUG
				diag_log format ["GCAM keyevent loaded for admin: %1", _uid];
			#endif
		};
	#endif
#endif
//END SPECTATE SCRIPT