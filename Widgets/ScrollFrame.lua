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
	local base, metatable, methods = nil, nil, { };
	local instanceCount = 0;
	
	local OnMouseWheel = function( self, delta )
		local offset = self:GetVerticalScroll();
		local contentHeight = self:GetScrollChild():GetHeight();
		local height = self:GetHeight();
	
		delta = -delta * 50;
		
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
		local self = CreateFrame( "scrollframe", "Tukui_Config_ScrollFrame" .. tostring( instanceCount ), parent, nil );		

		self:SetScript( "OnMouseWheel", OnMouseWheel );

		self:EnableMouseWheel( true );
		
		-- initialize class
		base, metatable = InitClass( base, metatable, methods, self );
	
		instanceCount = instanceCount + 1;
	
		return self;
	end
end