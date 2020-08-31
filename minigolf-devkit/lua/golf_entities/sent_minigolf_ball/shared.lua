if(isMiniGolfGamemodeActive())then return end -- Don't run if we have the gamemode running

DEFINE_BASECLASS( "base_anim" )

DISTANCE_TO_BALL_MAX = 80

ENT.PrintName = "MiniGolf Ball"
ENT.Author = "TJjokerR"
ENT.Information = "The ball to play with"
ENT.Category = "Fun + Games"

ENT.Spawnable = false

--[[ Sadly an effect and has no physics:
ENT.Model = Model("models/nomad/golfball.mdl")
ENT.ModelScale = false]]
-- Shitty alternative: "models/xqm/rails/gumball_1.mdl"
ENT.Model = Model("models/billiards/ball.mdl")