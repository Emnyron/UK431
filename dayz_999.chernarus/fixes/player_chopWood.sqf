private["_location","_isOk","_dir","_classname"];
private["_item"];
_item = _this;
call gear_ui_init;

private "_nearByTrees";

_nearByTrees = 0;

{
	if ([" t_", str _x, false] call fnc_inString) then 
	{
		_nearByTrees = _nearByTrees + 1;
	};
} forEach nearestObjects [getPos player, [], 30];

if (_nearByTrees >= 3) then {
	_result = [player,"PartWoodPile"] call BIS_fnc_invAdd;
	if (_result) then {
		cutText [localize "str_player_25", "PLAIN DOWN"];
	} else {
		cutText [localize "str_player_24", "PLAIN DOWN"];
	};
} else {
	cutText [localize "str_player_23", "PLAIN DOWN"];
};






