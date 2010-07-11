local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Creates extended frame
]]
CreateFrameEx = nil;
do
	local base, metatable, methods = nil, nil, { };

	methods.SetMinWidth = function( self, value )
		assert( type( value ) == "number" or type( value ) == "nil", "Usage: SetMinWidth( [number value] )" );
		
		self.minWidth = value;
		if ( self:GetWidth() < value ) then
			base.SetWidth( self, value );
		end
	end
	
	methods.SetMinHeight = function( self, value )
		assert( type( value ) == "number" or type( value ) == "nil", "Usage: SetMinHeight( [number value] )" );
	
		self.minHeight = value;
		if ( self:GetHeight() < value ) then
			base.SetHeight( self, value );
		end
	end
	
	methods.SetWidth = function( self, value ) 
		assert( type( value ) == "number" or type( value ) == "nil", "Usage: SetWidth( [number value] )" );
		
		if ( self.minWidth == nil ) then
			base.SetWidth( self, value );
		else
			base.SetWidth( self, max( self.minWidth, value ) );
		end
	end
	
	methods.SetHeight = function( self, value )
		assert( type( value ) == "number" or type( value ) == "nil", "Usage: SetHeight( [number value] )" );
	
		if ( self.minHeight == nil ) then
			base.SetHeight( self, value );
		else
			base.SetHeight( self, max( self.minHeight, value ) );
		end
	end
		
	CreateFrameEx = function( parent )
		-- defaults
		parent = parent or UIParent;
	
		-- construction
		local self = CreateFrame( "frame", nil, parent, nil );		
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
	
		return self;
	end
end