local _, Internals = ...;

if ( GetLocale() ~= "enUS" ) then return; end

setfenv( 1, Internals );
LocaleData = { };
setfenv( 1, LocaleData );

title = "Tukui configuration";

menu = {
	nameplate = "Nameplates",
	merchant = "Merchant",
	general = "General",
	bags = "Bags",
	datatext = "Data text",
	unitframes = "Unit frames",
	buffreminder = "Buff reminder",
	loot = "Loot",
	map = "Map",
	invite = "Invite",
	error = "Error",
	tooltip = "Tooltip",
	combatfont = "Combat font",
	panels = "Panels",
	chat = "Chat",
	actionbar = "Action bar",
	watchframe = "Watch frame",
	arena = "Arena",
	cooldown = "Cooldowns",
};