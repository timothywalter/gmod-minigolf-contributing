if(isMiniGolfGamemodeActive())then return end -- Don't run if we have the gamemode running

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "MiniGolf Goal"
ENT.Author = "TJjokerR"
ENT.Information = "The goal of a hole"
ENT.Category = "Fun + Games"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Model = Model("models/props_c17/pulleywheels_small01.mdl")
ENT.ModelScale = .5
