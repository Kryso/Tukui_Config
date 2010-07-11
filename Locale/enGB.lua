local _, Internals = ...;

Internals.Locale = {
		"datatext" = "Data text",
	};

setmetatable( Internals.Locale, {
		__index = function( self, index ) 
			return self[ index ] or index;
		end
	} );