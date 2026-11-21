local _Services = {
	["Workspace"] = game:GetService("Workspace");
	["Lighting"] = game:GetService("Lighting");
	["Player"] = game:GetService("Players");
	["Run"] = game:GetService("RunService");
	["Debris"] = game:GetService("Debris");
	["UserInput"] = game:GetService("UserInputService");
	["Tween"] = game:GetService("TweenService");
	["Physics"] = game:GetService("PhysicsService");
	["StarterGui"] = game:GetService("StarterGui");
	["StarterPlayer"] = game:GetService("StarterPlayer");
	["RepliStorage"] = game:GetService("ReplicatedStorage");
	["ServerStorage"] = game:GetService("ServerStorage");
	["Chat"] = game:GetService("Chat");
	["Teleport"] = game:GetService("TeleportService");
	["HttpService"] = game:GetService("HttpService");
	["ContentProvider"] = game:GetService("ContentProvider");
}

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒--
--♦♥--MEMORY LIBRARY--♦♥--
local INST 		= Instance.new
local NRAY 		= Ray.new
local RAPM		= RaycastParams.new
local PHYSIPRO 	= PhysicalProperties.new
local VE3 		= Vector3.new
local UDI2		= UDim2.new
local CFN 		= CFrame.new
local TWEEN_IN	= TweenInfo.new
local CFA 		= CFrame.Angles
local M_COS		= math.cos
local M_SIN		= math.sin
local M_RAD		= math.rad
local M_RAN 	= math.random
local M_FLOOR 	= math.floor
local M_SQRT 	= math.sqrt
local M_MA 		= math.max
local M_MI 		= math.min
local M_CL		= math.clamp
local M_ABS		= math.abs
local S_SUB 	= string.sub
local S_FND 	= string.find
local CO_CRE	= coroutine.create
local CO_RES	= coroutine.resume
local NUMSEQ	= NumberSequence.new
local TA_RE 	= table.remove
local TA_IN 	= table.insert
local TA_SO 	= table.sort
local COR_RGB 	= Color3.fromRGB
--♦♥--♦♥--♦♥--♦♥--♦♥--♦♥--
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒--

local MD_ = _G._MD

return {
	REAL_Name="Noob";MagnitudeDetect=60;Health=3;HipHeight=1.9;WalkSpeed=19;Money=5;Weight=3;Range_MoveTo=2;Change_Anim_Speed_Multi=1;AgentRadius=1.5;AgentHeight=2;Require_Combination=true;Entity_Rarity="Common";
	
	WAVE_CORE_ATTACK=true;
	Cancel_Enemy_Parts_Folder=true;
	
	CUSTOM_START=function(_,Local_Config)
		local self_ = Local_Config.Self
		local Bot_Humanoid = Local_Config.Bot_Humanoid
		local Bot_Character = Local_Config.Bot_Character
		local Bot_Root = Local_Config.Bot_Root
		local Bot_Config = Local_Config.Bot_Config
		local Anim_Config = Local_Config.Anim_Config
		
		local at_Style = self_.Attributes.Style 
		local Enemy_Personal_Folder = _Services.RepliStorage.Characters.Entity:FindFirstChild("Noob")
		local PartsName = at_Style or "Default"
		local HeavyMode = at_Style == "Heavy"
		
		local plus_for_attack2 = 0
		local SwordModel,_TRAIL

		if HeavyMode then
			Local_Config.Using_Change_Anim_Speed = .7
			Bot_Humanoid.WalkSpeed -= 7
						
			Local_Config.Display_Name = "Heavy Noob"
			Local_Config.Functions:Update_Health_Max(6)
			Local_Config.Functions:Update_Rarity("Aggressive")
			
			local ATTACH_TO = Bot_Character:FindFirstChild("RightArm")
			SwordModel = game.ReplicatedStorage.Objects:FindFirstChild("Noob_Axe"):Clone()
			SwordModel.Parent = Bot_Character
			local MainPart = SwordModel.MainPart
			MD_.FF:CLEAN_TOOL_MODEL(SwordModel,MainPart)
			
			MainPart.CFrame= ATTACH_TO.CFrame
			MainPart.Name = "MAINPART_AXE"
			Bot_Config.Range_MoveTo=5
			Bot_Config.Money=15
			local Motor_6D = MD_.FF:Motor6D(ATTACH_TO,MainPart) 
			Motor_6D.Parent=MainPart
			Motor_6D.Name="AxeMotor6D"
			
			Anim_Config:Animation_Setup_Folder(Anim_Config.AnimationsFolder:FindFirstChild("Heavy",true))
			
			_TRAIL = SwordModel:FindFirstChild("_TRAIL")
		end
		
		--Use Noob's skin instead when Heavy's empty
		local PartsFolder = Enemy_Personal_Folder:FindFirstChild("Parts")
		if #PartsFolder:FindFirstChild(PartsName):GetChildren() == 0 or 
			(PartsFolder:FindFirstChild(PartsName):FindFirstChild("__Random__") and #PartsFolder:FindFirstChild(PartsName):FindFirstChild("__Random__"):GetChildren() == 0) then
			PartsName = "Default"
		end

		--skin
		if self_.Attributes.SubSkin then
			MD_.FF:Fake_Parts(Bot_Character, PartsFolder:FindFirstChild(PartsName).__Random__:FindFirstChild(self_.Attributes.SubSkin),true)
		else
			MD_.FF:Fake_Parts(Bot_Character, PartsFolder:FindFirstChild(PartsName),true) 
		end
		if Bot_Character:FindFirstChild("__Fake__Parts__") then
			Bot_Character:FindFirstChild("__Fake__Parts__").Parent = Bot_Character.Parent
		end
		--
		
		local function restart_movement_Action (custom_tag,dont_touch_anim)
			if not dont_touch_anim then
				Anim_Config:AllStopAnimation(.25)
				Anim_Config:Restart_Current_Animation()
			end
			self_.___ACTION_CONFIG = nil
			self_.___ACTION_NAME = custom_tag
		end
		
		if HeavyMode then
			
			--█░░█ █▀▀ █▀▀█ ▀█░█▀ █░░█ 
			--█▀▀█ █▀▀ █▄▄█ ░█▄█░ █▄▄█ 
			--▀░░▀ ▀▀▀ ▀░░▀ ░░▀░░ ▄▄▄█
			
			self_.Attacks_Enviorement = {
				
				--██████████████████████████████████████████
				--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀▄▄▀█
				--██─▀─████─█████─████─▀─██─███▀██─▄▀███▀▄██
				--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀
				["ACTION_2"]=function(types,LPI)
					if types == "START" then
						local _TIMING_WAITER = tick()+3
						local animation
						plus_for_attack2 = 0
						local cs = {Name="HeavyNoob2" .. tick()}

						MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
						Anim_Config:AllStopAnimation(.5)
						self_.___ACTION_CONFIG = {}
						
						local Other_Swing_005_loop = MD_.FF:PlaySound(Bot_Root,"Other_Swing_005_loop",{NotPlaying=true,Save=true})
						local Especial_Actions = {

							["stop"] = function()
								animation:AdjustSpeed(.15)
								_TIMING_WAITER = tick()					
							end,
							["stopattack"] = function()
								_TRAIL.Enabled = false
								animation:AdjustSpeed(1)
								Other_Swing_005_loop:Stop()
								self_.___ACTION_CONFIG.Figther1 = false
							end,
							["swing"] = function()
								Other_Swing_005_loop:Play()
							end,
							["Attack1"] = function()
								_TRAIL.Enabled = true
								self_.___ACTION_CONFIG.Figther1 = true
								animation:AdjustSpeed(1)
								MD_.FF:PlaySound(Bot_Root,{"Other_Swoosh_003","Other_Swoosh_004","Other_Swoosh_002","Other_Swing_005","Other_Swing_006"},{PlayOnRemove=true})
							end;
						}
						MD_.FF:PlaySound(Bot_Root,"EN_HeavyOof",{PlayOnRemove=true,PlaybackSpeed=.85})
						animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.Attack2Anim,.2,Especial_Actions)
						animation:AdjustSpeed(1.5)

						repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
						Other_Swing_005_loop:Destroy()
				
						animation:Stop(.25)
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
						self_.AttackCooldown = tick() + .6
						restart_movement_Action(nil)

					elseif types == "LOOP" and LPI then
						if LPI.Figther1 then
							local Target_Magnitude = Local_Config.Self.Target_Magnitude
							if Target_Magnitude and Target_Magnitude <= 12 then
								if self_.Attack_Create_Hitbox_Tick and self_.Attack_Create_Hitbox_Tick - tick() < 0 then self_.Attack_Create_Hitbox_Tick = nil end
								if not self_.Attack_Create_Hitbox_Tick then -- attack
									self_.Attack_Create_Hitbox_Tick = tick() + .05
									local custom_box = SwordModel.Hitbox
									local sound
									for i,v in pairs (MD_.FF:hitbox_detector(custom_box,2,false)) do
										if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(3,v.WeakPointEntity.Value) then
											sound = true 
											v.Velocity = Bot_Root.CFrame.lookVector*115 
											Local_Config.Functions:Attack() 
										end
									end
									if sound then MD_.FF:PlaySound(Bot_Root,"EN_Attack_001",{PlayOnRemove=true}) self_.Attack_Create_Hitbox_Tick = tick() + .15 end
								end
							end
						end
					end
				end;
				--█████████████████████████████████████████
				--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀░██
				--██─▀─████─█████─████─▀─██─███▀██─▄▀███░██
				--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀
				["ACTION_1"]=function(types,LPI)
					if types == "START" then
						local _TIMING_WAITER = tick()+2.5
						local animation
						
						local cs = {Name="HeavyNoob1" .. tick()}

						MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
						Anim_Config:AllStopAnimation(0)
						self_.___ACTION_CONFIG = {}
						
						local Especial_Actions = {
							
							["Stop"] = function()
								self_.AttackCooldown = false
								_TIMING_WAITER = tick()
							end,
							["StopAttack"] = function()
								self_.___ACTION_CONFIG.Figther1 = false
							end,
							["GroundHit"] = function()
								_TRAIL.Enabled = false
								MD_.FF:PlaySound(Bot_Root,"Other_Slam_001",{PlayOnRemove=true,PlaybackSpeed=math.random(130,170)/100})
								MD_.FF:PlaySound(Bot_Root,"Other_Slam_004",{PlayOnRemove=true,PlaybackSpeed=math.random(90,110)/100})
								
								local HeavyNoobGroundHit = _G.Objects_Scripts.HeavyNoobGroundHit:Clone()
								HeavyNoobGroundHit.Parent = Bot_Character
								require(HeavyNoobGroundHit:FindFirstChild("ANIMATED"))
								HeavyNoobGroundHit.MainPart.CFrame = Bot_Root.CFrame * CFrame.new(0,-3.5,-7)
							end,
							["Attack1"] = function()
								_TRAIL.Enabled = true
								self_.___ACTION_CONFIG.Figther1 = true
								animation:AdjustSpeed(1)
								MD_.FF:PlaySound(Bot_Root,{"Other_Swoosh_003","Other_Swoosh_004","Other_Swoosh_002","Other_Swing_005","Other_Swing_006"},{PlayOnRemove=true})
							end;
						}
						MD_.FF:PlaySound(Bot_Root,"EN_HeavyOof",{PlayOnRemove=true,PlaybackSpeed=math.random(90,110)/100})
						animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.AttackAnim,.2,Especial_Actions)
						animation:AdjustSpeed(1.5)
						
						repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
						
						animation:Stop(.25)
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
						self_.AttackCooldown = tick() + .6
						restart_movement_Action(nil)

					elseif types == "LOOP" and LPI then
						if LPI.Figther1 then
							local Target_Magnitude = Local_Config.Self.Target_Magnitude
							if Target_Magnitude and Target_Magnitude <= 9 then
								if self_.Attack_Create_Hitbox_Tick and self_.Attack_Create_Hitbox_Tick - tick() < 0 then self_.Attack_Create_Hitbox_Tick = nil end
								if not self_.Attack_Create_Hitbox_Tick then -- attack
									self_.Attack_Create_Hitbox_Tick = tick() + .05
									local custom_box = SwordModel.Hitbox
									local sound
									for i,v in pairs (MD_.FF:hitbox_detector(custom_box,1.5,false)) do
										if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(3,v.WeakPointEntity.Value) then
											sound = true 
											v.Velocity = Bot_Root.CFrame.lookVector*115 
											Local_Config.Functions:Attack() 
										end
									end
									if sound then MD_.FF:PlaySound(Bot_Root,"EN_Attack_001",{PlayOnRemove=true}) self_.Attack_Create_Hitbox_Tick = tick() + .15 end
								end
							end
						end
					end
				end;
			}
			
		else

			--	█▀▀▄ █▀▀ █▀▀ █▀▀█ █░░█ █░░ ▀▀█▀▀ 
			--	█░░█ █▀▀ █▀▀ █▄▄█ █░░█ █░░ ░░█░░ 
			--	▀▀▀░ ▀▀▀ ▀░░ ▀░░▀ ░▀▀▀ ▀▀▀ ░░▀░░
					
			self_.Attacks_Enviorement = {

				--█████████████████████████████████████████
				--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀░██
				--██─▀─████─█████─████─▀─██─███▀██─▄▀███░██
				--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀
				["ACTION_1"]=function(types,LPI)
					if types == "START" then
						local _TIMING_WAITER = tick()+1.3
						local animation

						local Especial_Actions = {
							
							["Stop"] = function()
								self_.AttackCooldown = false
								_TIMING_WAITER = tick()+.1
							end,
							["Attack"] = function()
								local Target_Entity = Local_Config.Target_Entity
								local FijoUnit = Bot_Root.CFrame.LookVector

								local next_Unit = Local_Config.Self.Target_Unit
								if next_Unit then FijoUnit = next_Unit end

								local custom_box = {
									CFrame = Bot_Root.CFrame+(FijoUnit*5);
									Size = Vector3.new(3,3,3);
								}
								MD_.FF:PlaySound(Bot_Root,"EN_Attack_001",{PlayOnRemove=true})
								for i,v in pairs (MD_.FF:hitbox_detector(custom_box,1,false)) do
									if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(1,v.WeakPointEntity.Value) then
										v.Velocity = FijoUnit*55
										Local_Config.Functions:Attack()
									end
								end
							end;
						}

						animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.AttackAnim,1,Especial_Actions)

						repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
						self_.AttackCooldown = tick() + .15
						restart_movement_Action(nil,true)
					
					elseif types == "LOOP" and LPI then
					end
				end;
			}
		end
		
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████

		local Bot_Module_Extender = {}

		--	███████████████████████████████████████████████████████████████
		--	█─▄▄▄─█▄─██─▄█─▄▄▄▄█─▄─▄─█─▄▄─█▄─▀█▀─▄███▄─▄███─▄▄─█─▄▄─█▄─▄▄─█
		--	█─███▀██─██─██▄▄▄▄─███─███─██─██─█▄█─█████─██▀█─██─█─██─██─▄▄▄█
		--	▀▄▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▄▄▀▄▄▄▀▄▄▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▄▄▄▄▀▄▄▄▀▀▀
		
		Bot_Module_Extender.CUSTOM_LOOP=function()
			if self_.trigger_getback_tick and self_.trigger_getback_tick - tick() < 0 then self_.trigger_getback_tick = nil end
			if self_.trigger_damage_tick and self_.trigger_damage_tick - tick() < 0 then self_.trigger_damage_tick = nil end
			
			if self_.___ACTION_NAME and self_.___ACTION_CONFIG then -- loop PHASE for each attack
				self_.Attacks_Enviorement[self_.___ACTION_NAME]("LOOP",self_.___ACTION_CONFIG) 
			end
			
			if Local_Config.Trigger_GetBack.Value and not self_.Defeated and not self_.trigger_getback_tick and self_._META_CAN_KEEP_ then
				self_.trigger_getback_tick = tick()+1
				local BodyVelocity = Instance.new("BodyVelocity",Bot_Root)
				BodyVelocity.MaxForce=Vector3.new(99999,9999e9999,99999)
				BodyVelocity.Velocity=Vector3.new(0,20,0)  + (Bot_Root.CFrame.lookVector*-45) 
				_Services.Debris:AddItem(BodyVelocity,.1)
				Bot_Root.Velocity = Bot_Root.Velocity + (Bot_Root.CFrame.lookVector*-45) + Vector3.new(0,20,0)
				MD_.FF:PlaySound(Bot_Root,"EN_Get_Damage_001",{PlaybackSpeed=1.15;Volume=1.5})
				local customtag = {Name="GetBack" .. tick()}
				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CantAttack,TS=customtag,NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.Ragdoll,TS=customtag,NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=customtag,NN="Custom_Animation_Process",FF=nil}) 
				delay(2,function()
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.CantAttack,TS=customtag,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.Ragdoll,TS=customtag,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=customtag,NN="Custom_Animation_Process",FF=nil}) 
				end)
			end

			--███████████████████████████████▀███████████████████████████████████████
			--█▄─▄▄▀██▀▄─██▄─▀█▀─▄██▀▄─██─▄▄▄▄█▄─▄▄─█▄─▄▄─█▄─█─▄█▄─▄▄─█▄─▀█▄─▄█─▄─▄─█
			--██─██─██─▀─███─█▄█─███─▀─██─██▄─██─▄█▀██─▄█▀██▄▀▄███─▄█▀██─█▄▀─████─███
			--▀▄▄▄▄▀▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▀▄▀▀▀▄▄▄▄▄▀▄▄▄▀▀▄▄▀▀▄▄▄▀▀
			
			if Local_Config.Trigger_Damage.Value and not self_.trigger_damage_tick and not self_.Defeated and self_._META_CAN_KEEP_ then
				self_.trigger_damage_tick = tick()+.8
				plus_for_attack2 += 1
				local DamageAmount = Local_Config.Trigger_Damage:GetAttribute("DamageAmount") or 1
				Local_Config.Health -= DamageAmount
				Local_Config.Functions:Update_Health_UI()
				MD_.FF:PlaySound(Bot_Root,"EN_Get_Damage_001",{PlaybackSpeed=1.15;Volume=1.5})

				local BodyVelocity = Instance.new("BodyVelocity",Bot_Root)
				BodyVelocity.MaxForce=Vector3.new(99999,9999e9999,99999)
				BodyVelocity.Velocity=Vector3.new(0,25,0)  + (Bot_Root.CFrame.lookVector*-45) 
				_Services.Debris:AddItem(BodyVelocity,.1)
				Bot_Root.Velocity = Bot_Root.Velocity + (Bot_Root.CFrame.lookVector*-45) + Vector3.new(0,25,0)

				if Local_Config.Health <= 0 then
					self_._Getting_Dead = true	
				end
			end
			
			--███████████████████████████████████████████████████████████
			--█▄─▄▄▀█▄─▄▄─██▀▄─██▄─▄▄▀███▄─▄▄─█▄─█─▄█▄─▄▄─█▄─▀█▄─▄█─▄─▄─█
			--██─██─██─▄█▀██─▀─███─██─████─▄█▀██▄▀▄███─▄█▀██─█▄▀─████─███
			--▀▄▄▄▄▀▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀▀▀▀▄▄▄▄▄▀▀▀▄▀▀▀▄▄▄▄▄▀▄▄▄▀▀▄▄▀▀▄▄▄▀▀

			if self_._Getting_Dead and not self_.___ACTION_NAME then
				self_.Defeated = true	

				MD_.FF:PlaySound(Bot_Root,"EN_NoobDeath",{PlayOnRemove=true})
				MD_.FF:PlaySound(Bot_Root,"EN_GetHit",{PlayOnRemove=true})
				MD_.FF:CreatedParticle("Defeated_Particles",Bot_Root.Position,{CustomParent=Bot_Root;DebrisTime=2;ParticleTime=.1})

				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CantAttack,TS={Name="Defeated"},NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.Ragdoll,TS={Name="Defeated"},NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Anim_Config,TS={Name="Defeated"},NN="Custom_Animation_Process",FF=nil}) 
				Anim_Config:AllStopAnimation(0)
			end
		end

		--	███████████████████████████████████████████████████████████████▀█████████████
		--	█▄─▀█▀─▄█─▄▄─█─▄─▄─█▄─▄▄─███─▄─▄─█─▄▄─███─▄─▄─██▀▄─██▄─▄▄▀█─▄▄▄▄█▄─▄▄─█─▄─▄─█
		--	██─█▄█─██─██─███─████─▄█▀█████─███─██─█████─████─▀─███─▄─▄█─██▄─██─▄█▀███─███
		--	▀▄▄▄▀▄▄▄▀▄▄▄▄▀▀▄▄▄▀▀▄▄▄▄▄▀▀▀▀▄▄▄▀▀▄▄▄▄▀▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀

		Bot_Module_Extender.MOVE_TO_TARGET=function()	
			
			local Target_Magnitude = Local_Config.Self.Target_Magnitude
			if self_.AttackCooldown and self_.AttackCooldown - tick() < 0 then self_.AttackCooldown=nil end
			
			plus_for_attack2 += .0001
			spawn(function()
				if Target_Magnitude and not self_.___ACTION_NAME then 
					if self_._META_CAN_JOIN_SCENE_ then	
						if Target_Magnitude <= 7 then
							Local_Config.Functions:Attack()
						end
					elseif not self_.AttackCooldown and Local_Config.Functions:CAN_TARGET_TO_ATTACK() then
						if plus_for_attack2 >= 2 and Target_Magnitude <= 12 and HeavyMode then
							self_.___ACTION_NAME = "ACTION_2"
						elseif Target_Magnitude <= 7 then
							plus_for_attack2 += .5
							self_.___ACTION_NAME = "ACTION_1"
						end
						if self_.___ACTION_NAME then self_.Attacks_Enviorement[self_.___ACTION_NAME]("START") end -- first PHASE function for each attack
					end
				end
			end)
			
		end;

		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████

		return Bot_Module_Extender
	end;
	Animation_Events={
	};
	Conditions_For_Combinations={
		Human={
			["One"]={
				Request=function(Current_Combination,NAME)
					return Current_Combination[NAME].Amount == 0
				end,
				AnimationConfig={AnimModel="Noob_1"}
			};
			["Two"]={
				Request=function(Current_Combination,NAME)
					return Current_Combination[NAME].Amount == 1
				end,
				AnimationConfig={AnimModel="Noob_2"}
			};
			["Three"]={
				Request=function(Current_Combination,NAME)
					return Current_Combination[NAME].Amount == 2
				end,
				AnimationConfig={AnimModel="Noob_3"}
			};
		};
	};
};