local _, Internals = ...;
setfenv( 1, Internals );

CreateBooleanRenderer = nil;
do
	local base, metatable, methods = nil, nil, { };

	local OnMouseDown = function( self )
		self:SetValue( not self.value );
	end
	
	methods.SetValue = function( self, value )
		if ( value ) then
			self.switch:SetText( "true" );
			self.value = true;
		else
			self.switch:SetText( "false" );
			self.value = nil;
		end
		
		if ( ( self.value and true or false ) == ( Database:Get( self.category, self.key ) and true or false ) ) then
			self.switch:SetTextColor( 0, 1, 0, 1 );
		else
			self.switch:SetTextColor( 1, 0, 0, 1 );
		end
	end
	
	methods.Save = function( self )
		Database:Set( self.category, self.key, self.value and true or false );
	end
	
	CreateBooleanRenderer = function( parent, category, key, padding, font, fontSize )
		assert( type( category ) == "string", "Usage: CreateBooleanRenderer( parent, category, key, [font, [fontSize]] )" );
		assert( type( key ) == "string", "Usage: CreateBooleanRenderer( parent, category, key, [font, [fontSize]] )" );
	
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
		
		local switch = self:CreateFontString( nil, "ARTWORK", nil );
		switch:SetFont( font, fontSize );
		switch:SetPoint( "TOPLEFT", self, "TOPLEFT", 200, -padding );
		switch:SetPoint( "BOTTOMRIGHT", self, "BOTTOMRIGHT", -padding, padding );
		self.switch = switch;
		
		self:SetHeight( title:GetHeight() + padding * 2 );

		self.category = category;
		self.key = key;
		self.padding = padding;
		self.font = font;
		self.fontSize = fontSize;
		
		self:SetScript( "OnMouseDown", OnMouseDown );	
		self:EnableMouse( true );
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
		
		self:SetValue( Database:Get( category, key ) );
		
		return self;
	end
end