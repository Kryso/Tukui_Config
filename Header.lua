local _, Internals = ...;
Internals[ "_G" ] = _G;
setfenv( 1, Internals );

-- initialize addon environment
print, tostring, type, assert, getmetatable, setmetatable, select, getfenv, setfenv = _G.print, _G.tostring, _G.type, _G.assert, _G.getmetatable, _G.setmetatable, _G.select, _G.getfenv, _G.setfenv;
strupper, strsplit, string, strlen = _G.strupper, _G.strsplit, _G.string, _G.strlen;
tinsert = _G.tinsert;
pairs, ipairs = _G.pairs, _G.ipairs;
min, max = _G.min, _G.max;

UIParent = _G.UIParent;
CreateFrame = _G.CreateFrame;

Renderers = { };

--[[
	Very basic oop logic
]]
InitClass = function( base, metatable, methods, instance )
	-- initialize class if required
	if ( base == nil ) then
		local baseMetatable = getmetatable( instance );
	
		if ( baseMetatable ~= nil ) then
			base = baseMetatable.__index;
			metatable = {
					__index = setmetatable( methods, baseMetatable )
				};
		else
			base = { };
			metatable = {
					__index = methods
				};
		end
	end
	
	-- initialize instance
	setmetatable( instance, metatable );
	
	return base, metatable;
end