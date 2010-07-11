local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Creates frame with tukui-friendly border, text and implements auto-size logic
	
	Constructor arguments:
		parent (UIRegion)       - parent frame (default value inherited from FramedFrame)
		padding (number)        - distance between inner border and text
		font (string)           - path font file
		fontSize (number)       - font size in pixels	
		borderSize (number)     - size of line in the middle of border (default value inherited from FramedFrame)
		borderPadding (number)  - size of "lines" around middle line of border (default value inherited from FramedFrame)
		
	Methods:
		SetText                 -
		SetWidth                -
		SetHeight               -
]]
CreateFramedText = nil;
do
	local base, metatable, methods = nil, nil, { };

	methods.SetText = function( self, text )
		assert( type( text ) == "string", "Usage: SetText( string text )" );
	
		self.text:SetText( text );
		
		if ( self.disableAutoWidth == nil ) then
			base.SetWidth( self, self.text:GetWidth() + ( self.padding + self.borderSize + self.borderPadding * 2 ) * 2 );
		end
		
		if ( self.disableAutoHeight == nil ) then
			base.SetHeight( self, self.text:GetHeight() + ( self.padding + self.borderSize + self.borderPadding * 2 ) * 2 );
		end
	end

	methods.SetWidth = function( self, value )
		assert( type( value ) == "nil" or type( value ) == "number", "Usage: SetWidth( [number value] )" );
		
		if ( value ~= nil ) then
			self.disableAutoWidth = true;
			base.SetWidth( self, value );
		else
			self.disableAutoWidth = nil;
		end
	end
	
	methods.SetHeight = function( self, value )
		assert( type( value ) == "nil" or type( value ) == "number", "Usage: SetHeight( [number value] )" );
		
		if ( value ~= nil ) then
			self.disableAutoHeight = true;
			base.SetHeight( self, value );
		else
			self.disableAutoHeight = nil;
		end
	end
	
	CreateFramedText = function( parent, padding, font, fontSize, borderSize, borderPadding )
		assert( parent ~= nil, "Usage: CreateFramedText( frame parent, [number padding], [string font], [number fontSize], [number borderSize], [number borderPadding] )" );
		
		-- defaults
		padding = padding or 5;
		font = font or [[fonts\ARIALN.ttf]];
		fontSize = fontSize or 12;
		
		-- construction
		local frame = CreateFramedFrame( parent, borderSize, borderPadding );
		
		local text = frame:CreateFontString( nil, "ARTWORK", nil );
		text:SetFont( font, fontSize );
		text:SetPoint( "CENTER", frame, "CENTER", 0, 0 );
		frame.text = text;
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, frame );
		frame.padding = padding;
	
		return frame;
	end
end