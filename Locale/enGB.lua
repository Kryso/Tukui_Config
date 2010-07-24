local _, Internals = ...;

if ( GetLocale() ~= "enUS" ) then return; end

setfenv( 1, Internals );
LocaleData = { };
setfenv( 1, LocaleData );

title = "Tukui configuration";
saveAndReload = "Save & reload UI";
reload = "Reload ui?"

dictionary = {
	enable = "Enable",
};

settings = {
	nameplate = {
		_title = "Nameplates"
	},
	merchant = {
		_title = "Merchant",
		sellgrays = "Sell gray-quality items",
	},
	general = {
		_title = "General",
	},
	bags = {
		_title = "Bags",
	},
	datatext = {
		_title = "Data text",
	},
	unitframes = {
		_title = "Unit frames",
	},
	buffreminder = {
		_title = "Buff reminder",
	},
	loot = {
		_title = "Loot",
	},
	map = {
		_title = "Map",
	},
	invite = {
		_title = "Invite",
	},
	error = {
		_title = "Error",
	},
	tooltip = {
		_title = "Tooltip",
	},
	combatfont = {
		_title = "Combat font",
	},
	panels = {
		_title = "Panels",
	},
	chat = {
		_title = "Chat",
	},
	actionbar = {
		_title = "Action bar",
	},
	watchframe = {
		_title = "Watch frame",
	},
	arena = {
		_title = "Arena",
	},
	cooldown = {
		_title = "Cooldowns",
	},
};