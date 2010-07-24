local _, Internals = ...;
setfenv( 1, Internals );

Database = { };

local GetDB = function()
	local db = _G.Tukui_Config_GDB;
	if ( not db ) then
		db = { };
		_G.Tukui_Config_GDB = db;
	end
	
	return db;
end

local ApplyCategory = function( category, localCategory, categoryKey )
	for key, _ in pairs( category ) do
		local localValue = localCategory[ key ];
	
		if ( localValue ~= nil ) then
			category[ key ] = localValue == false and nil or localValue;
			print( categoryKey .. "." .. key .. " set to " .. tostring( localValue ) );
		end
	end
end

Database.Get = function( self, categoryKey, key, default )
	local localCategory = GetDB()[ categoryKey ];
	local localValue = localCategory and localCategory[ key ];
	if ( localValue ) then
		return localValue;
	end
	
	local category = _G.TukuiDB[ categoryKey ];
	local value = category and category[ key ];
	if ( value ~= nil ) then
		return value == false and nil or value;
	end
	
	return default;
end

Database.Set = function( self, categoryKey, key, value )
	print( "set " .. tostring( categoryKey ) .. "." .. key .. " to " .. tostring( value ) );

	local db = GetDB();
	
	if ( value == nil ) then
		value = false;
	end
	
	local category = db[ categoryKey ];	
	if ( not category ) then
		category = { };
		db[ categoryKey ] = category;
	end
	
	category[ key ] = value;
end

Database.Startup = function( self )
	local tukuiDB = _G.TukuiDB;
	if ( type( tukuiDB ) ~= "table" ) then
		print( "Tukui_Config: Tukui database not found" );
		return;
	end
	
	local db = GetDB();

	for categoryKey, category in pairs( tukuiDB ) do if ( type( categoryKey ) == "string" and type( category ) == "table" ) then
		
		local localCategory = db[ categoryKey ];
		if ( localCategory ) then
			ApplyCategory( category, localCategory, categoryKey );
		end
		
	end end

end