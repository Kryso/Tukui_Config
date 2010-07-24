local _, Internals = ...;
setfenv( 1, Internals );

--[[ 
	Creates scroll frame
	
	Constructor arguments:
		parent (UIRegion)       - parent frame
		
	Methods:

]]
CreateScrollFrame = nil;
do
	local MAGIC_WHEEL_AMPLIFIER_OF_ETERNAL_FLAMES_WITH_TINY_THING_FLYING_AROUND = 50;

	local base, metatable, methods = nil, nil, { };
	
	local OnMouseWheel = function( self, delta )
		local offset = self:GetVerticalScroll();
		local contentHeight = self:GetScrollChild():GetHeight();
		local height = self:GetHeight();
	
		delta = -delta * MAGIC_WHEEL_AMPLIFIER_OF_ETERNAL_FLAMES_WITH_TINY_THING_FLYING_AROUND;
		
		if ( offset + delta < 0 ) then
			self:SetVerticalScroll( 0 );
		elseif ( offset + height + delta > contentHeight ) then
			self:SetVerticalScroll( contentHeight > height and contentHeight - height or 0 );
		else
			self:SetVerticalScroll( offset + delta );
		end
	end	
	
	CreateScrollFrame = function( parent )
		-- defaults
		parent = parent or UIParent;
	
		-- construction
		local self = CreateFrame( "scrollframe", nil, parent, nil );	
		self:SetScript( "OnMouseWheel", OnMouseWheel );
		self:EnableMouseWheel( true );
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
	
		return self;
	end
end