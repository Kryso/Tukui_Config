local _, Internals = ...;
setfenv( 1, Internals );

--[[ 
	Creates frame with tukui-friendly border
]]
CreateFramedFrame = nil;
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
		local frame = CreateFrameEx( parent, nil );		
		
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