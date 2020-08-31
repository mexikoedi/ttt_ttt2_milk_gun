if engine.ActiveGamemode( ) != "terrortown" then return end
if SERVER then
    AddCSLuaFile( )

    if file.Exists( "scripts/sh_convarutil.lua" , "LUA" ) then
        AddCSLuaFile( "scripts/sh_convarutil.lua" )
        print( "[INFO][Milk Gun] Using the utility plugin to handle convars instead of the local version" )
    else
        AddCSLuaFile( "scripts/sh_convarutil_local.lua" )
        print( "[INFO][Milk Gun] Using the local version to handle convars instead of the utility plugin" )
    end
end

if file.Exists( "scripts/sh_convarutil.lua" , "LUA" ) then
    include( "scripts/sh_convarutil.lua" )
else
    include( "scripts/sh_convarutil_local.lua" )
end

// Must run before hook.Add
local cg = ConvarGroup( "Milkgun" , "Milk Gun" )

Convar( cg , false , "ttt_milkgun_automaticFire" , 0 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Enable automatic fire" , "bool" )

Convar( cg , false , "ttt_milkgun_damage" , 100 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Damage dealt on impact" , "int" , 1 , 500 )

Convar( cg , false , "ttt_milkgun_randomDamage" , 5 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Applied on top of the normal damage (+/-)" , "int" , 1 , 200 )

Convar( cg , false , "ttt_milkgun_ammo" , 3 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Default ammo the milkgun has when bought" , "int" , 1 , 255 )

Convar( cg , false , "ttt_milkgun_clipSize" , 3 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Clipsize of the milkgun" , "int" , 1 , 255 )

Convar( cg , false , "ttt_milkgun_rps" , 0.4 , { FCVAR_ARCHIVE , FCVAR_NOTIFY , FCVAR_REPLICATED } , "Packages of milk to shoot per second" , "float" , 0.01 , 10 , 2 )
//
//generateCVTable()
//
