private["_itemType","_iPos","_indexLootSpawn","_iArray","_iItem","_iClass","_item","_qty","_max","_tQty","_arrayLootSpawn","_canType","_holderItem"];
// [_itemType,_weights]
_iItem = _this select 0;
_iClass = _this select 1;
_iPos = _this select 2;
_radius = _this select 3;
_holderItem = _iItem;
switch (_iItem) do {
case "BAF_AS50_scoped": { _holderItem = "M40A3"};
case "5Rnd_127x99_as50": { _holderItem = "5Rnd_762x51_M24"};
case "M107_DZ": { _holderItem = "M4SPR"};
case "10Rnd_127x99_m107": { _holderItem = "30Rnd_556x45_StanagSD"};
case "M136": { _holderItem = "M4A3_RCO_GL_EP1"};
case "m136": { _holderItem = "30Rnd_556x45_Stanag"};
case "PipeBomb": { _holderItem = "M4A3_RCO_GL_EP1"};

default {};
};
_iItem = _holderItem;
switch (_iClass) do {
default {
//Item is food, add random quantity of cans along with an item (if exists)
_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
_arrayLootSpawn = [] + getArray (configFile >> "cfgLoot" >> _iClass);
_itemType = _arrayLootSpawn select 0;
_weights = _arrayLootSpawn call fnc_buildWeightedArray;
_qty = 0;
_max = ceil(random 4) + 1;
//diag_log ("LOOTSPAWN: QTY: " + str(_max) + " ARRAY: " + str(_arrayLootSpawn));
while {_qty < _max} do {
private["_tQty","_indexLootSpawn","_canType"];
_tQty = floor(random 1) + 1;
//diag_log ("LOOTSPAWN: ITEM QTY: " + str(_tQty));

_indexLootSpawn = _weights call BIS_fnc_selectRandom;
_canType = _itemType select _indexLootSpawn;

_holderItem = _canType;
switch (_canType) do {
case "10Rnd_127x99_m107": { _holderItem = "30Rnd_556x45_StanagSD"};
case "5Rnd_127x99_as50": { _holderItem = "5Rnd_762x51_M24"};
case "m136": { _holderItem = "30Rnd_556x45_Stanag"};
case "PipeBomb": { _holderItem = "M4A3_RCO_GL_EP1"};
default {};
};
_canType = _holderItem;

//diag_log ("LOOTSPAWN: ITEM: " + str(_canType));
_item addMagazineCargoGlobal [_canType,_tQty];
_qty = _qty + _tQty;
};
if (_iItem != "") then {
_item addWeaponCargoGlobal [_iItem,1];
};
};
case "weapon": {
//Item is a weapon, add it and a random quantity of magazines
_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
_item addWeaponCargoGlobal [_iItem,1];
_mags = [] + getArray (configFile >> "cfgWeapons" >> _iItem >> "magazines");
if (count _mags > 0) then {
_item addMagazineCargoGlobal [(_mags select 0),(round(random 3)+2)];
};
};
case "magazine": {
//Item is one magazine
_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
_item addMagazineCargoGlobal [_iItem,1];
};
case "object": {
//Item is one magazine
_item = createVehicle [_iItem, _iPos, [], _radius, "CAN_COLLIDE"];
};
};
if (count _iPos > 2) then {
_item setPosATL _ipos;
};