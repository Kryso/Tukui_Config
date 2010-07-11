local _, Internals = ...;
setfenv( 1, Internals );

LocaleData = {
		[ "configFrameTitle" ] = "Tukui configuration",
		[ "nameplate" ] = "Nameplates",
		[ "merchant" ] = "Merchant",
		[ "general" ] = "General",
		[ "bags" ] = "Bags",
		[ "datatext" ] = "Data text",
		[ "unitframes" ] = "Unit frames",
		[ "buffreminder" ] = "Buff reminder",
		[ "loot" ] = "Loot",
		[ "map" ] = "Map",
		[ "invite" ] = "Invite",
		[ "error" ] = "Error",
		[ "tooltip" ] = "Tooltip",
		[ "combatfont" ] = "Combat font",
		[ "panels" ] = "Panels",
		[ "chat" ] = "Chat",
		[ "actionbar" ] = "Action bar",
		[ "watchframe" ] = "Watch frame",
		[ "arena" ] = "Arena",
		[ "cooldown" ] = "Cooldowns",
	};

L = { };
setmetatable( L, {
		__index = function( self, index )
			return LocaleData[ index ] or index;
		end
	} );