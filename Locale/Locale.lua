local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Locale logic
	
	2 accessors
		L( path, ... )         - allows us to select path to resource by argument list
		
		L[ compressedPath ]    - allows us to compress path to single string, separator is '-'
]]

L = { };
setmetatable( L, {
		__call = function( self, ... )
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
			
			return data or select( argCount, ... );
		end,
		__index = function( self, index )
			return L( strsplit( "-", index ) ) or index;
		end
	} );