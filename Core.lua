local _, Internals = ...;
setfenv( 1, Internals );

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
	title:SetText( L[ "title" ] );
	
	local menu = CreateStackFrame( frame, 0, menuButtonMargin );
	menu:SetPoint( "TOP", frame, "TOPLEFT", 0, -menuMargin );
	menu:SetWidth( 100 );
	
	local tabControl = CreateTabControl( frame );
	for k, v in pairs( _G.TukuiDB ) do
		if ( type( k ) == "string" and type( v ) == "table" ) then
			local button, page = tabControl:Add( L( "menu", k ) );
			
			menu:Insert( button );
			
			page:SetPoint( "TOPLEFT", frame, "TOPLEFT", menu:GetWidth() / 2 + padding, -( title:GetHeight() / 2 + padding ) );
			page:SetPoint( "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -padding, padding );
			
			local scrollFrame = CreateScrollFrame( page );
			scrollFrame:SetPoint( "TOPLEFT", page, "TOPLEFT", 0, 0 );
			scrollFrame:SetPoint( "BOTTOMRIGHT", page, "BOTTOMRIGHT", 0, 0 );
			
			local stackFrame = CreateStackFrame( scrollFrame, 0, 10 );
			for sk, sv in pairs( _G.TukuiDB[ k ] ) do
				local button = CreateFramedText( stackFrame );
				button:SetText( sk .. ": " ..tostring( sv ) );
				stackFrame:Insert( button );
			end
		
			stackFrame:SetWidth( scrollFrame:GetWidth() );
		
			scrollFrame:SetScrollChild( stackFrame );
		end
	end
	frame:SetHeight( menu:GetHeight() + menuMargin * 2 );
end

_G.Tukui_Config = {
	Startup = Startup,
	Show = Show,
};