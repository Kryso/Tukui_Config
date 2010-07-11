local _, Internals = ...;

local InitClass = function( base, metatable, methods, instance )
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

--[[
	Creates extended frame
]]
local CreateFrameEx;
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
		local frame = CreateFrame( "frame", nil, parent, nil );		
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, frame );
	
		return frame;
	end
end

--[[ 
	Creates frame with tukui-friendly border
]]
local CreateFramedFrame;
do
	local base, metatable, methods = nil, nil, { };

	methods.SetInnerBackgroundColor = function( self, r, g, b, a )
		self.innerBackground:SetTexture( r, g, b, a );
	end
	
	CreateFramedFrame = function( parent, borderSize, borderPadding )
		-- defaults
		parent = parent or UIParent;
		borderSize = borderSize or 1;
		borderPadding = borderPadding or 1;
	
		-- construction
		local frame = CreateFrameEx( parent );		
		
		local background = frame:CreateTexture( nil, "BACKGROUND", nil );
		background:SetPoint( "TOPLEFT", frame, "TOPLEFT", 0, 0 );
		background:SetPoint( "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0 );
		background:SetTexture( 0, 0, 0, 1 );
		frame.background = background;	
		
		local borderLeft = frame:CreateTexture( nil, "BORDER", nil );
		borderLeft:SetPoint( "TOPLEFT", background, "TOPLEFT", borderPadding, -borderPadding );
		borderLeft:SetPoint( "BOTTOMRIGHT", background, "BOTTOMLEFT", borderPadding + borderSize, borderPadding );
		borderLeft:SetTexture( 1, 1, 1, 1 );
		frame.borderLeft = borderLeft;
	
		local borderRight = frame:CreateTexture( nil, "BORDER", nil );
		borderRight:SetPoint( "TOPLEFT", background, "TOPRIGHT", -borderPadding - borderSize, -borderPadding );
		borderRight:SetPoint( "BOTTOMRIGHT", background, "BOTTOMRIGHT", -borderPadding, borderPadding );
		borderRight:SetTexture( 1, 1, 1, 1 );
		frame.borderRight = borderRight;
	
		local borderTop = frame:CreateTexture( nil, "BORDER", nil );
		borderTop:SetPoint( "TOPLEFT", borderLeft, "TOPRIGHT", 0, 0 );
		borderTop:SetPoint( "BOTTOMRIGHT", borderRight, "TOPLEFT", 0, -borderSize );
		borderTop:SetTexture( 1, 1, 1, 1 );
		frame.borderTop = borderTop;
	
		local borderBottom = frame:CreateTexture( nil, "BORDER", nil );
		borderBottom:SetPoint( "TOPLEFT", borderLeft, "BOTTOMRIGHT", 0, borderSize );
		borderBottom:SetPoint( "BOTTOMRIGHT", borderRight, "BOTTOMLEFT", 0, 0 );
		borderBottom:SetTexture( 1, 1, 1, 1 );
		frame.borderBottom = borderBottom;
	
		local innerBackground = frame:CreateTexture( nil, "BORDER", nil );
		innerBackground:SetPoint( "TOPLEFT", borderTop, "BOTTOMLEFT", 0, 0 );
		innerBackground:SetPoint( "BOTTOMRIGHT", borderBottom, "TOPRIGHT", 0, 0 );
		innerBackground:SetTexture( 0, 0, 0, 1 );
		frame.innerBackground = innerBackground;
	
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, frame );
		frame.borderSize = borderSize;
		frame.borderPadding = borderPadding;
	
		return frame;
	end
end

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
local CreateFramedText;
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

--[[
	Creates frame that automatically sorts inserted frames under each other
	
	Constructor arguments:
		parent (UIRegion)       - parent frame (default value inherited from FramedFrame)
		padding (number)        - distance between frame border and items
		itemMargin (number)     - distance between items
		
	Methods:
		Insert                  - 
]]
local CreateStackFrame;
do
	local base, metatable, methods = nil, nil, { };

	methods.Insert = function( self, region ) 
		assert( region ~= nil, "Usage: Insert( UIRegion region )" );
		
		local items = self.items;	
		local padding = self.padding;
		local itemMargin = self.itemMargin;

		local itemCount = #items;
		
		if ( itemCount <= 0 ) then
			region:SetPoint( "TOPLEFT", self, "TOPLEFT", padding, -padding );
			region:SetPoint( "TOPRIGHT", self, "TOPRIGHT", -padding, -padding );
		else
			region:SetPoint( "TOPLEFT", items[ itemCount ], "BOTTOMLEFT", 0, -itemMargin );
			region:SetPoint( "TOPRIGHT", items[ itemCount ], "BOTTOMRIGHT", 0, -itemMargin );
		end
		
		tinsert( items, region );
		
		local totalHeight = padding * 2;
		for _, v in ipairs( items ) do
			totalHeight = totalHeight + v:GetHeight() + itemMargin;
		end
		totalHeight = totalHeight - itemMargin;
		
		if ( self:GetHeight() < totalHeight ) then
			base.SetHeight( self, totalHeight );
		end
	end
	
	CreateStackFrame = function( parent, padding, itemMargin )
		-- defaults
		padding = padding or 0;
		itemMargin = itemMargin or 0;
		
		-- construction
		local frame = CreateFrameEx( parent );
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, frame );
		frame.padding = padding;
		frame.itemMargin = itemMargin;
		frame.items = { };
		
		return frame;
	end
end

--[[
	Creates tab button and its frame
	
	Constructor arguments:
		parent (UIRegion)       - parent frame (default value inherited from FrameEx / FramedFrame)
		title (string)          - button text
		
	Methods
		Add                     -
		SetActivePage           -
]]
local CreateTabControl
do
	local base, metatable, methods = nil, nil, { };

	local CreatePage;
	do
		local base, metatable, methods = nil, nil, { };
	
		CreatePage = function ( parent )
			local self = CreateFrameEx( parent.parent );
		
			-- initialize class
			base, metatable = InitClass( base, metatable, methods, self );
			
			self:Hide();
			
			return self;
		end
	end
	
	local CreateButton;
	do
		local base, metatable, methods = nil, nil, { };
	
		local OnClick = function( self )
			self:SetActive();
		end
	
		methods.SetInactive = function( self )
			self:SetInnerBackgroundColor( 0, 0, 0, 1 );
			self.tabPage:Hide();
		end
	
		methods.SetActive = function( self )
			for _, v in ipairs( self.parent.buttons ) do
				v:SetInactive();
			end
			
			self:SetInnerBackgroundColor( 0, 0.5, 0, 1 );
			self.tabPage:Show();
		end
	
		CreateButton = function( parent, title )
			local self = CreateFramedText( parent.parent );
			
			self:EnableMouse( true );
			self:SetScript( "OnMouseDown", OnClick );
			
			self:SetText( title );
			
			-- initialize class
			base, metatable = InitClass( base, metatable, methods, self );
			self.parent = parent;
			
			return self;
		end
	end
	
	methods.Add = function( self, title )
		local tabButton = CreateButton( self, title );
		local tabPage = CreatePage( self );
		
		tabButton.tabPage = tabPage;
		
		tinsert( self.buttons, tabButton );
		tinsert( self.pages, tabPage );
		
		return tabButton, tabPage;
	end
	
	CreateTabControl = function( parent )
		local self = { };
	
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
		self.parent = parent;
		
		self.buttons = { };
		self.pages = { };
		
		return self;
	end
end

--[[ 
	Shows configuration frame
]]
local Show = function( _ )

end

--[[
	Sets tukui configuration variables to ingame selected ones in previous sessions
]]
local Startup = function( _ )
	local menuButtonMargin = -3;
	local menuMargin = 20;
	local padding = 20;

	local frame = CreateFramedFrame();
	frame:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 );
	frame:SetMinHeight( 400 );
	frame:SetWidth( 600 );
	
	local title = CreateFramedText( frame, 8, nil, 16 );
	title:SetPoint( "CENTER", frame, "TOP", 0, 0 );
	title:SetText( "Tukui configuration" );
	
	local menu = CreateStackFrame( frame, 0, menuButtonMargin );
	menu:SetPoint( "TOP", frame, "TOPLEFT", 0, -menuMargin );
	menu:SetWidth( 100 );
	
	local tabControl = CreateTabControl( frame );
	for k, v in pairs( TukuiDB ) do
		if ( type( k ) == "string" and type( v ) == "table" ) then
			local button, page = tabControl:Add( strupper( k ) );
			
			menu:Insert( button );
			
			page:SetPoint( "TOPLEFT", frame, "TOPLEFT", menu:GetWidth() / 2 + padding, -( title:GetHeight() / 2 + padding ) );
			page:SetPoint( "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -padding, padding );
			
			local stackFrame = CreateStackFrame( page, 0, 10 );
			for sk, sv in pairs( TukuiDB[ k ] ) do
				local button = CreateFramedText( page );
				button:SetText( sk .. ": " ..tostring( sv ) );
				stackFrame:Insert( button );
			end
			stackFrame:SetPoint( "TOPLEFT", page, "TOPLEFT", 0, 0 );
			stackFrame:SetPoint( "BOTTOMRIGHT", page, "BOTTOMRIGHT", 0, 0 );
		end
	end
	frame:SetHeight( menu:GetHeight() + menuMargin * 2 );	
end

Tukui_Config = {
	Startup = Startup,
	Show = Show,
};