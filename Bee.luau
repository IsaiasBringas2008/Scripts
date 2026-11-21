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
	REAL_Name="Bee";MagnitudeDetect=50;Health=3;HipHeight=1.9;WalkSpeed=19;Money=10;Weight=15;Range_MoveTo=3;Change_Anim_Speed_Multi=1;AgentRadius=1.5;AgentHeight=2;Require_Combination=true;Entity_Rarity="Especial";

	WAVE_CORE_ATTACK=true;
	Cancel_Enemy_Parts_Folder=true;

	CUSTOM_START=function(_,Local_Config)
		local self_ = Local_Config.Self
		local Bot_Humanoid = Local_Config.Bot_Humanoid
		local Bot_Character = Local_Config.Bot_Character
		local Bot_Root = Local_Config.Bot_Root
		local Bot_Config = Local_Config.Bot_Config
		local Anim_Config = Local_Config.Anim_Config
		local Bot_Head = Bot_Character:FindFirstChild("Head")

		local at_Style = self_.Attributes.Style 

		self_.get_heal_targets = {}
		self_.CheckEntityToHealTick = tick() + 10
		local can_spit_count,healing_status = 0,0
		-- skin
		local PartsName = at_Style or "Default"
		local Enemy_Personal_Folder = _Services.RepliStorage.Characters.Entity:FindFirstChild("Bee")
		local PartsFolder = Enemy_Personal_Folder:FindFirstChild("Parts")
		--skin
		if self_.Attributes.SubSkin then
			MD_.FF:Fake_Parts(Bot_Character, PartsFolder:FindFirstChild(PartsName).__Random__:FindFirstChild(self_.Attributes.SubSkin),true)
		else
			MD_.FF:Fake_Parts(Bot_Character, PartsFolder:FindFirstChild(PartsName),true) 
		end
		if Bot_Character:FindFirstChild("__Fake__Parts__") then
			Bot_Character:FindFirstChild("__Fake__Parts__").Parent = Bot_Character.Parent
		end

		local EN_Bee_Heal_003 = MD_.FF:PlaySound(Bot_Root,"EN_Bee_Heal_003",{Save=true,NotPlaying=true})
		local FlapAnimation = Bot_Humanoid.Animator:LoadAnimation(Anim_Config.AnimationsFolder.FlapWing)
		FlapAnimation:Play()
		FlapAnimation:GetMarkerReachedSignal("Function"):connect(function()
			if not self_.RagdollMetaBackup then
				MD_.FF:PlaySound(Bot_Root,"EN_BeeWing",{PlaybackSpeed=math.random(250,400)/100})
			end
		end)
		-- animation stop when the parents change xd
		FlapAnimation.Changed:connect(function()
			FlapAnimation:Play()
		end)
		local function Get_Allies_To_Heal ()
			local allies = {}
			for i,v in pairs (MD_.Re_Bots) do
				if v.Team == Local_Config.Team and v.Bot_Root and Local_Config.Entity_ID ~= v.Entity_ID and v.MaxHealth~=v.Health then
					local mag = (v.Bot_Root.CFrame.p-Bot_Root.CFrame.p).magnitude
					if mag < 55 then
						table.insert(allies,v)
					end
				end
			end
			return allies
		end

		local function restart_movement_Action (custom_tag,dont_touch_anim)
			if not dont_touch_anim then
				Anim_Config:AllStopAnimation(.25)
				Anim_Config:Restart_Current_Animation()
			end
			self_.___ACTION_CONFIG = nil
			self_.___ACTION_NAME = custom_tag
		end

		self_.Attacks_Enviorement = {

			--██████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▄▄▄░█
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███▄▄░█
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀

			["ACTION_3"]=function(types,LPI)
				if types == "START" then
					local cs = {Name="Bee_Attack_3" .. tick()}
					local _TIMING_WAITER = tick()+10

					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 		
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
					Anim_Config:AllStopAnimation(.25)

					local animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.Attack3Anim,2)
					animation:AdjustSpeed(1)

					local net_height = Bot_Config.HipHeight + 3
					local bee_parts = {}
					local boost,next_boost = 0,0
					local heal_tick = tick() + 3
					local max_bee_shields = 3
					healing_status = 0

					MD_.FF:PlaySound(Bot_Root,"EN_Bee_Heal_001",{PlayOnRemove=true})
					EN_Bee_Heal_003:Play()
					local currentHealth = Local_Config.Health

					-- Builds the Bee Shields
					for i=1,max_bee_shields do
						local BeeHealPart = _G.Objects_Scripts.BeeHealPart:Clone()
						BeeHealPart.Parent = workspace.Terrain
						BeeHealPart.Anchored = true
						BeeHealPart.Size = Vector3.new()
						BeeHealPart.CFrame = Bot_Root.CFrame
						_Services.Tween:Create(BeeHealPart,TWEEN_IN(3,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(3,1,3)}):Play()
						table.insert(bee_parts,{Honey_Shield=BeeHealPart;Number=i})
					end

					--  Heals Everyone
					local function heal_everyone()
						local healed 
						self_.get_heal_targets = Get_Allies_To_Heal() 

						for i,v in pairs (self_.get_heal_targets) do
							if v.Bot_Root and v.Bot_Root:IsDescendantOf(game) and v.Functions:IncreaseHealth(1) then
								healed = true
								local HoneyBullet = _G.Objects_Scripts.BeeHealBullet:Clone()
								HoneyBullet.Parent = _Services.Workspace.Terrain
								HoneyBullet.Anchored = true
								HoneyBullet.Transparency=0;
								HoneyBullet.CFrame = Bot_Root.CFrame
								_Services.Tween:Create(HoneyBullet,TWEEN_IN(.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,0,false,0),{CFrame=v.Bot_Root.CFrame;Transparency=1,Size=Vector3.new(6,6,6)}):Play()
								delay(2,function()
									MD_.FF:SafeRemove(HoneyBullet)
								end)
							end
						end
						if Local_Config.Functions:IncreaseHealth(1) then
							currentHealth = Local_Config.Health
							healed = true
							local HoneyBullet = _G.Objects_Scripts.BeeHealBullet:Clone()
							HoneyBullet.Parent = _Services.Workspace.Terrain
							HoneyBullet.Anchored = true
							HoneyBullet.Transparency=0;
							HoneyBullet.CFrame = Bot_Root.CFrame
							_Services.Tween:Create(HoneyBullet,TWEEN_IN(.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,0,false,0),{Transparency=1,Size=Vector3.new(8,8,8)}):Play()
							delay(2,function()
								MD_.FF:SafeRemove(HoneyBullet)
							end)
						end

						if healed then
							next_boost += 5
							MD_.FF:PlaySound(Bot_Root,"EN_Bee_Heal_002",{PlayOnRemove=true})
						end
					end

					-- Loop
					repeat _Services.Run.RenderStepped:Wait()
						if heal_tick - tick() < 0 then
							heal_tick = tick() + 3
							heal_everyone()
						end
						boost = MD_.FF:Lerp(boost,next_boost,.025)
						Bot_Humanoid.HipHeight = MD_.FF:Lerp(Bot_Humanoid.HipHeight,net_height,.05)

						-- shields rotation
						for _,sh in pairs (bee_parts) do
							local Honey_Shield = sh.Honey_Shield				
							local radial_order = math.rad((sh.Number*360)/max_bee_shields)
							local my_tick = math.rad((tick()+ boost)%360) + radial_order
							local cf = CFrame.new() * CFrame.Angles(0,my_tick*200 ,0)
							local allcf = (Bot_Root.CFrame + (cf.LookVector*5)) * CFrame.Angles(math.rad(90),my_tick*300,my_tick*200)
							Honey_Shield.CFrame = Honey_Shield.CFrame:Lerp(allcf,.4)
						end
						--
						if currentHealth ~= Local_Config.Health then break end
					until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
					EN_Bee_Heal_003:Stop()

					MD_.FF:PlaySound(Bot_Root,"EN_Bee_Heal_005",{PlayOnRemove=true})
					MD_.FF:PlaySound(Bot_Root,"EN_Bee_Heal_004",{PlayOnRemove=true})
					-- removes shields
					for i,v in pairs (bee_parts) do
						v.Honey_Shield.Anchored = false
						v.Honey_Shield.CanCollide = true
						_Services.Tween:Create(v.Honey_Shield,TWEEN_IN(2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(1,.2,1)}):Play()
						delay(2,function()
							MD_.FF:SafeRemove(v.Honey_Shield)
						end)
					end
					--

					animation:Stop(.2)
					Bot_Humanoid.HipHeight = Bot_Config.HipHeight
					if self_.Body_Mover then self_.Body_Mover:Destroy() end self_.Body_Mover = nil
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 

					self_.CheckEntityToHealTick=tick()+math.random(70,150)/10
					self_.AttackCooldown = tick() + 1.5
					restart_movement_Action(nil)

				elseif types == "LOOP" and LPI then
				end
			end;

			--██████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀▄▄▀█
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███▀▄██
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀

			["ACTION_2"]=function(types,LPI)
				if types == "START" then
					local _TIMING_WAITER = tick()+2
					local animation

					can_spit_count = 0
					local cs = {Name="Bee_Attack_2" .. tick()}
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 		
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 

					local Especial_Actions = {
						["stop"] = function()
							_TIMING_WAITER = tick()
							animation:AdjustSpeed(.2)
						end,
						["StartAttack"] = function()
							animation:AdjustSpeed(.5)
							MD_.FF:PlaySound(Bot_Root,{"EN_BeeSpit_003","EN_BeeSpit_004"},{PlayOnRemove=true,PlaybackSpeed=math.random(100,120)/100})
							MD_.FF:PlaySound(Bot_Root,{"EN_BeeSpit_001","EN_BeeSpit_002"},{PlayOnRemove=true,PlaybackSpeed=math.random(100,120)/100})
							local FijoUnit = Bot_Root.CFrame.LookVector
							local next_Unit = Local_Config.Self.Target_Unit
							if next_Unit then FijoUnit = next_Unit end
							local radx = 35
							local max = 3
							local of = (radx)/(max/2)
							for i=1,max do
								local cff = CFrame.new(Vector3.new(),FijoUnit)* CFrame.Angles(0,math.rad(((radx*i)/max)-of),0)
								_G.Remotes_ClientEvent:Fire("CreateBullet",{damage=1;origin=Bot_Head,direction=cff.LookVector,bullet_speed=55,Debris=2,ignore_descendant=Bot_Character,EntityTableID=Local_Config.Entity_ID,Team=Local_Config.Team;Style="Honey"})
							end
						end,

					}

					MD_.FF:PlaySound(Bot_Root,"EN_BeeAttack_004",{PlayOnRemove=true})
					animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.Attack2Anim,2,Especial_Actions)
					animation:AdjustSpeed(1.5)
					repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_

					animation:Stop(1)

					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 

					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 

					self_.AttackCooldown = tick() + .5
					restart_movement_Action(nil,true)

				elseif types == "LOOP" and LPI then
				end
			end;

			--█████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀░██
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███░██
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀
			["ACTION_1"]=function(types,LPI)
				if types == "START" then
					local _TIMING_WAITER = tick()+.75
					local animation

					local cs = {Name="Bee_Attack_1" .. tick()}
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoAutoRotate,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 

					local Especial_Actions = {

						["StartAttack"] = function()
							if self_.Body_Mover then self_.Body_Mover:Destroy() end self_.Body_Mover = nil
							local Body_Mover = Instance.new("BodyVelocity",Local_Config.Bot_Root)
							local speed = (50)
							local FijoUnit = Bot_Root.CFrame.LookVector
							local next_Unit = Local_Config.Self.Target_Unit
							if next_Unit then FijoUnit = next_Unit end
							Body_Mover.MaxForce = Vector3.new(1,15,1)*250000
							Body_Mover.Velocity = (FijoUnit*Vector3.new(1,0,1))*speed
							self_.Body_Mover = Body_Mover
							_Services.Debris:AddItem(self_.Body_Mover,.5)
							MD_.FF:PlaySound(Bot_Root,"EN_BeeAttack_002",{PlayOnRemove=true})
							MD_.FF:PlaySound(Bot_Root,"EN_BeeAttack_001",{PlayOnRemove=true})
						end,
						["Attack"] = function()
							local Target_Entity = Local_Config.Target_Entity
							local FijoUnit = Bot_Root.CFrame.LookVector
							local next_Unit = Local_Config.Self.Target_Unit
							if next_Unit then
								FijoUnit:Lerp(next_Unit,.2)
							end
							local custom_box = {
								CFrame = Bot_Root.CFrame+(FijoUnit*5);
								Size = Vector3.new(5,5,5);
							}
							local Target_Magnitude = Local_Config.Self.Target_Magnitude
							if Target_Magnitude and Target_Magnitude < 10 then

								local sound
								for i,v in pairs (MD_.FF:hitbox_detector(custom_box,1,false)) do
									if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(1,v.WeakPointEntity.Value) then
										sound = true
										v.Velocity = FijoUnit*55
										Local_Config.Functions:Weak_Point(1,v.WeakPointEntity.Value)
										Local_Config.Functions:Attack()
										break
									end
								end
								if self_.SoundBeeSTING and self_.SoundBeeSTING - tick() < 0 then self_.SoundBeeSTING = nil end
								if not self_.SoundBeeSTING and sound then
									self_.SoundBeeSTING = tick()+1
									MD_.FF:PlaySound(Bot_Root,"EN_BeeSting",{PlayOnRemove=true})
								end
							end
						end;
					}

					MD_.FF:PlaySound(Bot_Root,"EN_BeeAttack_003",{PlayOnRemove=true})
					animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.AttackAnim,2,Especial_Actions)

					repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_

					animation:Stop()
					if self_.Body_Mover then self_.Body_Mover:Destroy() end self_.Body_Mover = nil
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoAutoRotate,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 

					self_.AttackCooldown = tick() + .5
					restart_movement_Action(nil,true)

				elseif types == "LOOP" and LPI then
				end
			end;
		}

		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████

		local Bot_Module_Extender = {}

		--	███████████████████████████████████████████████████████████████
		--	█─▄▄▄─█▄─██─▄█─▄▄▄▄█─▄─▄─█─▄▄─█▄─▀█▀─▄███▄─▄███─▄▄─█─▄▄─█▄─▄▄─█
		--	█─███▀██─██─██▄▄▄▄─███─███─██─██─█▄█─█████─██▀█─██─█─██─██─▄▄▄█
		--	▀▄▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▄▄▀▄▄▄▀▄▄▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▄▄▄▄▀▄▄▄▀▀▀

		Bot_Module_Extender.CUSTOM_LOOP=function()
			local Vel = Bot_Root.Velocity
			FlapAnimation:AdjustSpeed(math.clamp(Local_Config.Self.Current_Force/10,.8,3))
			Bot_Root.Velocity = Vector3.new(Vel.X,math.max(Vel.Y,-20),Vel.Z)

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
				MD_.FF:PlaySound(Bot_Root,"EN_Bee_Damage",{PlayOnRemove=true;PlaybackSpeed=math.random(95,115)/100})
				self_.trigger_damage_tick = tick()+.8
				healing_status += 1
				local DamageAmount = Local_Config.Trigger_Damage:GetAttribute("DamageAmount") or 1
				Local_Config.Health -= DamageAmount
				Local_Config.Functions:Update_Health_UI()
				local Bot_Root = Local_Config.Bot_Root
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
				MD_.FF:PlaySound(Bot_Root,"EN_Bee_Ded",{PlayOnRemove=true})
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
			can_spit_count += .0025

			spawn(function()
				if Target_Magnitude and not self_.___ACTION_NAME then 

					if self_.CheckEntityToHealTick and self_.CheckEntityToHealTick - tick() < 0 then 
						self_.CheckEntityToHealTick=tick()+math.random(70,150)/10
						self_.get_heal_targets = Get_Allies_To_Heal() 
						if #self_.get_heal_targets >= 1 then
							healing_status = 4
						end
					end

					if self_._META_CAN_JOIN_SCENE_ then	
						if Target_Magnitude <= 8 then
							Local_Config.Functions:Attack()
						end
					elseif not self_.AttackCooldown and Local_Config.Functions:CAN_TARGET_TO_ATTACK() then
						if healing_status >= 3 and Target_Magnitude >= 12 then
							self_.___ACTION_NAME = "ACTION_3"
						elseif Target_Magnitude >= 12 and can_spit_count >= 3 then
							self_.___ACTION_NAME = "ACTION_2"
						elseif Target_Magnitude <= 12 then
							can_spit_count+=1
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
				AnimationConfig={AnimModel="Bee_1"}
			};
		};
	};
};