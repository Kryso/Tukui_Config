local _, Internals = ...;
setfenv( 1, Internals );

--[[
	Creates frame that automatically sorts inserted frames under each other
	
	Constructor arguments:
		parent (UIRegion)       - parent frame (default value inherited from FramedFrame)
		padding (number)        - distance between frame border and items
		itemMargin (number)     - distance between items
		
	Methods:
		Insert                  - 
]]
CreateStackFrame = nil;
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