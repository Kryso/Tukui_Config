local _, Internals = ...;
setfenv( 1, Internals );

local GetFrame = nil;
do
	local frame = nil;
	
	local menuButtonMargin = -3;
	local menuMargin = 20;
	local padding = 20;
	
	local CreateFrame = function()
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
				local button, page = tabControl:Add( L( "settings", k, "_title" ) );
				
				menu:Insert( button );
				
				page:SetPoint( "TOPLEFT", frame, "TOPLEFT", menu:GetWidth() / 2 + padding, -( title:GetHeight() / 2 + padding ) );
				page:SetPoint( "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -padding, padding );
				
				local scrollFrame = CreateScrollFrame( page );
				scrollFrame:SetPoint( "TOPLEFT", page, "TOPLEFT", 0, 0 );
				scrollFrame:SetPoint( "BOTTOMRIGHT", page, "BOTTOMRIGHT", 0, 0 );
				
				local stackFrame = CreateStackFrame( scrollFrame, 0, 10 );
				for sk, sv in pairs( _G.TukuiDB[ k ] ) do
				
					local button = CreateFramedText( stackFrame );
					button:SetText( "Warning: undefined renderer; key '" .. sk .. "', type '" ..type( sv ) .. "'" );
					stackFrame:Insert( button );
					
				end
			
				stackFrame:SetWidth( scrollFrame:GetWidth() );
			
				scrollFrame:SetScrollChild( stackFrame );
			end
		end
		
		frame:SetHeight( menu:GetHeight() + menuMargin * 2 );
		
		frame.title = title;
		frame.menu = menu;
		frame.tabControl = tabControl;
		
		return frame;
	end
	
	GetFrame = function( _ )
		if ( not frame ) then
			frame = CreateFrame();
		end
		
		return frame;
	end
end

--[[ 
	Shows configuration frame
]]
local Show = function( _ )
	GetFrame():Show();
end

--[[
	Sets tukui configuration variables to ingame selected ones in previous sessions
]]
local Startup = function( _ )
	Show();
end

_G.Tukui_Config = {
	Startup = Startup,
	Show = Show,
};