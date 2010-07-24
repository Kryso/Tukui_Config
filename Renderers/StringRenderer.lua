local _, Internals = ...;
setfenv( 1, Internals );

CreateStringRenderer = nil;
do
	local base, metatable, methods = nil, nil, { };

	local OnTextChanged = function( self )
		local parent = self.parent;
	
		if ( self:GetText() == tostring( Database:Get( parent.category, parent.key ) ) ) then
			self:SetTextColor( 0, 1, 0, 1 );
		else
			self:SetTextColor( 1, 0, 0, 1 );
		end
	end
	
	local OnEditFocusGained = function( self )
		self:SetAlpha( 1 );
	end
	
	local OnEditFocusLost = function( self )
		self:SetAlpha( 0.6 );
	end
	
	local OnEscapePressed = function( self )
		local parent = self.parent;
	
		self:SetText( Database:Get( parent.category, parent.key, "" ) );
		self:ClearFocus();
	end
	
	local OnEnterPressed = function( self )
		local parent = self.parent;
		
		self:ClearFocus();
	end
	
	methods.Save = function( self )
		Database:Set( self.category, self.key, self.editBox:GetText() );	
	end
	
	CreateStringRenderer = function( parent, category, key, padding, font, fontSize )
		assert( type( category ) == "string", "Usage: CreateStringRenderer( parent, category, key, [font, [fontSize]] )" );
		assert( type( key ) == "string", "Usage: CreateStringRenderer( parent, category, key, [font, [fontSize]] )" );
	
		-- defaults
		padding = padding or 0;
		font = font or [[fonts\ARIALN.ttf]];
		fontSize = fontSize or 12;
	
		-- construction
		local self = CreateFrameEx( parent );
		
		self:SetPoint( "CENTER", parent, "CENTER", 0, 0 );
		
		local title = self:CreateFontString( nil, "ARTWORK", nil );
		title:SetFont( font, fontSize );
		title:SetPoint( "LEFT", self , "LEFT", padding, 0 );
		title:SetText( LD( "settings", category, key ) );
		self.title = title;
		
		local editBox = CreateEditBox( self );
		editBox:SetPoint( "TOPLEFT", self, "TOPLEFT", 200, -padding );
		editBox:SetPoint( "BOTTOMRIGHT", self, "BOTTOMRIGHT", -padding, padding );
		editBox:SetText( tostring( _G.TukuiDB[ category ][ key ] ) );
		editBox:SetAlpha( 0.6 );
		self.editBox = editBox;
		
		self:SetHeight( title:GetHeight() + padding * 2 );

		self.category = category;
		self.key = key;
		self.padding = padding;
		self.font = font;
		self.fontSize = fontSize;
		
		editBox:SetScript( "OnTextChanged", OnTextChanged );	
		editBox:SetScript( "OnEditFocusGained", OnEditFocusGained );
		editBox:SetScript( "OnEditFocusLost", OnEditFocusLost );
		editBox:SetScript( "OnEscapePressed", OnEscapePressed );
		editBox:SetScript( "OnEnterPressed", OnEnterPressed );
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
		
		return self;
	end
end