local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Creates tab button and its frame
	
	Constructor arguments:
		parent (UIRegion)       - parent frame (default value inherited from FrameEx / FramedFrame)
		title (string)          - button text
		
	Methods
		Add                     -
]]
CreateTabControl = nil;
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
		assert( type( title ) == "string", "Usage: Add( string title )" );
	
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