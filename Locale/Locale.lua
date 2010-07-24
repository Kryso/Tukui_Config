local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Locale logic
	
	2 accessors
		L( path, ... )         - allows us to select path to resource by argument list
		
		L[ compressedPath ]    - allows us to compress path to single string, separator is '-'
]]

LD = { };
L = { };

local Decompress = function( path )
	return strsplit( "-", path );
end

local DataLookup = function( ... )
	local argCount = select( "#", ... );
	
	local data = LocaleData;
	for i = 1, argCount do
		local currentArg = select( i, ... );
	
		if ( type( data ) ~= "table" ) then
			data = nil;
			break;
		end

		data = data[ currentArg ];
	end
	
	return data, not data and select( argCount, ... );
end

setmetatable( L, {
		__call = function( self, ... )
			local result, default = DataLookup( ... );		
			return result or default;
		end,
		__index = function( self, path )
			return L( Decompress( path ) ) or index;
		end,
	} );
setmetatable( LD, {
		__call = function( self, ... )
			local result, default = DataLookup( ... );		
			return result or ( LocaleData.dictionary and LocaleData.dictionary[ default ] ) or default;
		end,
		__index = function( self, path )
			return LD( Decompress( path ) ) or index;
		end,
	} );