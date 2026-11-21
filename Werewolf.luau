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
	REAL_Name="Werewolf";MagnitudeDetect=70;Health=6;HipHeight=3.5;WalkSpeed=12;Money=30;Weight=15;Range_MoveTo=4;Change_Anim_Speed_Multi=2;AgentRadius=2;AgentHeight=2;Require_Combination=true;Entity_Rarity="Aggressive";
	
	WAVE_CORE_ATTACK=true;
	Cancel_Enemy_Parts_Folder=true;
	
	CUSTOM_START=function(_,Local_Config)
		local self_ = Local_Config.Self
		self_.tick_start_running = tick() + 5
		local Bot_Humanoid = Local_Config.Bot_Humanoid
		local Bot_Character = Local_Config.Bot_Character
		local Bot_Root = Local_Config.Bot_Root
		local Bot_Config = Local_Config.Bot_Config
		local Anim_Config = Local_Config.Anim_Config
		local SHARPEFFECT = Bot_Character:FindFirstChild("Arm_Right_3"):FindFirstChild("SHARPEFFECT")
		local SHARPEFFECT2 = Bot_Character:FindFirstChild("LowerTorso"):FindFirstChild("SHARPEFFECT2")
		self_.Body_Gyro.D = 5
		self_.Body_Gyro.P = 2400
		
		local Time_Multiplier = 1
		local at_Style = self_.Attributes.Style 
		local Enemy_Personal_Folder = _Services.RepliStorage.Characters.Entity:FindFirstChild("Werewolf")
		
		local PartsName = at_Style or "Default"
		local ProtoMode = at_Style == "Proto" or at_Style == "FullyPower"
		
		if ProtoMode then
			Bot_Humanoid.WalkSpeed += 5
			PartsName = "Proto"
			Local_Config.Functions:Update_Health_Max(9)
			Time_Multiplier = 2
		end
		
		--Use Werewolf's skin instead when proto's empty
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
		
		self_.COUNT_FOR_3_ATTACK = 0
		self_.My_Meta_Elements = {
			ATTACKING={LockSwitch={}};	
		}

		function self_:Create_BodyVe(quick,speed)
			if self_.Body_Mover then self_.Body_Mover:Destroy() end self_.Body_Mover = nil
			local Body_Mover = Instance.new("BodyVelocity",Local_Config.Bot_Root)
			local speed = speed or ((quick and 95) or 72)
			local FijoUnit = Bot_Root.CFrame.LookVector*Vector3.new(1,0,1)
			local Unit = FijoUnit
			Body_Mover.MaxForce = Vector3.new(1,1,1)*250000
			Body_Mover.Velocity = FijoUnit*speed
			self_.Body_Gyro.CFrame = CFrame.new(Bot_Root.CFrame.p,Bot_Root.CFrame.p+(FijoUnit*2555))
			self_.Body_Mover=Body_Mover
			
			if not quick then
				SHARPEFFECT.Enabled = true
			else
				SHARPEFFECT2.Enabled = true
			end
		end
		
		function self_:Remove_BodyVe(all)
			if self_.Body_Mover then 
				SHARPEFFECT.Enabled = false
				SHARPEFFECT2.Enabled = false
				self_.Body_Mover:Destroy()
				self_.Body_Mover = nil
			end
		end
		
		local function restart_movement_Action (custom_tag,dont_touch_anim)
			if not dont_touch_anim then
				Anim_Config:AllStopAnimation(0)
				Anim_Config:Restart_Current_Animation()
			end
			self_.___ACTION_CONFIG = nil
			self_.___ACTION_NAME = custom_tag
		end
		
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████
		--███████████████████████████████████████████████████████████████████████████████
		
		self_.Attacks_Enviorement = {

			--██████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▄▄▄░█
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███▄▄░█
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀
			["ACTION_3"]=function(types,LPI)
				if types == "START" then
					local cs = {Name="Werewolf_Attack_3" .. tick()}

					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
					
					Anim_Config:AllStopAnimation(.25)
					
					local _TIMING_WAITER = tick()+4.25
					local animation,confirm_plr
					self_.___ACTION_CONFIG = {}
					
					local Especial_Actions = {
						["WaitForPLR"] = function()
							animation:AdjustSpeed(0)
							repeat wait() local Target_Magnitude = Local_Config.Self.Target_Magnitude if Target_Magnitude <= 12 then  confirm_plr = true break end until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
							if confirm_plr then
								animation:AdjustSpeed(1.5)
								MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
								MD_.FF:PlaySound(Local_Config.Bot_Root,"EN_Werewolf_Attack_002",{PlayOnRemove=true})
							else
								self_.tick_running = tick() + 10
								self_.tick_start_running = tick()
								Bot_Humanoid.WalkSpeed += 12
								delay(3,function()
									Bot_Humanoid.WalkSpeed -= 12
								end)
							end
						end,
						["Attack"] = function()
							if not confirm_plr then return end
							self_.___ACTION_CONFIG.Attack=true
							MD_.FF:PlaySound(Local_Config.Bot_Root,"Other_Swoosh_004",{PlayOnRemove=true})
							local WerewolfAnimatedAttack = _G.Objects_Scripts.WerewolfAnimatedAttack:Clone()
							WerewolfAnimatedAttack.Parent = Bot_Character
							require(WerewolfAnimatedAttack:FindFirstChild("ANIMATED"))
							WerewolfAnimatedAttack.Main.CFrame = Bot_Root.CFrame * CFrame.new(0,0,-7)
							_TIMING_WAITER = tick()+.15
							if ProtoMode then
								self_:Create_BodyVe(nil,80)
							else
								self_:Create_BodyVe(nil,50)
							end
						end,
					}
					
					MD_.FF:PlaySound(Local_Config.Bot_Root,"EN_Werewolf_ambient_2",{PlayOnRemove=true})
					animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.Attack3Anim,1*Time_Multiplier,Especial_Actions)
 
					repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
					
					self_.___ACTION_CONFIG.Attack=false
					MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
					
					self_:Remove_BodyVe()
					animation:Stop(.3)
					
					delay(.3,function()
						
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil})
						
						self_.COUNT_FOR_3_ATTACK = 0
						if confirm_plr then
							self_.AttackCooldown = tick() + 1
						else
							self_.AttackCooldown = tick() 
						end
						restart_movement_Action(nil)
					end)
				elseif types == "LOOP" and LPI then
					if LPI.Attack then
						local Target_Magnitude = Local_Config.Self.Target_Magnitude
						if Target_Magnitude and Target_Magnitude <= 16 then
							if self_.Attack_Create_Hitbox_Tick and self_.Attack_Create_Hitbox_Tick - tick() < 0 then self_.Attack_Create_Hitbox_Tick = nil end
							if not self_.Attack_Create_Hitbox_Tick then -- attack
								self_.Attack_Create_Hitbox_Tick = tick() + .15
								local custom_box = {
									CFrame = Bot_Root.CFrame* CFrame.new(0,0,-6);
									Size = Vector3.new(3.5,5,6);
								}
								local sound
								for i,v in pairs (MD_.FF:hitbox_detector(custom_box,1.5,false)) do
									if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(2,v.WeakPointEntity.Value) then
										sound = true 
										v.Velocity = Bot_Root.CFrame.lookVector*115 
										Local_Config.Functions:Attack() 
									end
								end
								if sound then MD_.FF:PlaySound(Bot_Root,"EN_Attack_001",{PlayOnRemove=true}) end
							end
						end
					end
				end
			end;
			--██████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀▄▄▀█
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███▀▄██
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▀
			["ACTION_2"]=function(types,LPI)
				if types == "START" then
					local cs = {Name="Werewolf_Attack_2" .. tick()}
					
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=self_.My_Meta_Elements.ATTACKING,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
					
					self_.Body_Gyro.CFrame = CFrame.new(Bot_Root.CFrame.p,Bot_Root.CFrame.p+(Local_Config.Self.Target_Unit*2555))
					
					Anim_Config:AllStopAnimation(.25)
					
					local _TIMING_WAITER = tick()+.25
					local animation
					
					self_:Create_BodyVe(true)
					MD_.FF:PlaySound(Local_Config.Bot_Root,"EN_Werewolf_Attack_001",{PlayOnRemove=true})
					animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.Attack2Anim,1)
					Bot_Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					
					repeat wait() until _TIMING_WAITER - tick() < 0 or not self_._META_CAN_ATTACK_KEEP_
					Bot_Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					
					self_:Remove_BodyVe()
					animation:Stop(.3)
					MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
					Anim_Config:AllStopAnimation(0)
					Anim_Config:Restart_Current_Animation()
					self_.tick_running = nil
					
					delay(.15,function()
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=self_.My_Meta_Elements.ATTACKING,TS=cs,NN=nil,FF=nil}) 

						self_.AttackCooldown = tick() + 1
						restart_movement_Action(nil,true)
					end)
				elseif types == "LOOP" and LPI then
				end
			end;
			--█████████████████████████████████████████
			--██▀▄─██─▄─▄─█─▄─▄─██▀▄─██─▄▄▄─█▄─█─▄█▀░██
			--██─▀─████─█████─████─▀─██─███▀██─▄▀███░██
			--▀▄▄▀▄▄▀▀▄▄▄▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀
			["ACTION_1"]=function(types,LPI)
				if types == "START" then	
					local cs = {Name="Werewolf_Attack_1" .. tick()}
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
					MD_.FF:check__switch({BB=true,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
					
					Anim_Config:AllStopAnimation(.25)
					
					local _TIMING_WAITER = tick()+2.75
					local animation,break_attack

					self_.___ACTION_CONFIG = {}
					
					local Especial_Actions = {
						["Attack"] = function()
							local self_ = Local_Config.Self
							self_:Create_BodyVe()
							Bot_Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
							MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
							MD_.FF:check__switch({BB=true,TM=self_.My_Meta_Elements.ATTACKING,TS=cs,NN=nil,FF=nil}) 
						end,
						["AttackStop"] = function()
							local self_ = Local_Config.Self
							self_:Remove_BodyVe()
							animation:AdjustSpeed(0)
							break_attack = true
						end,
					}

					MD_.FF:PlaySound(Local_Config.Bot_Root,"EN_Werewolf_Attack_001",{PlayOnRemove=true})
					animation = Local_Config.Functions:custom_playing_animation(Anim_Config.Animations.AttackAnim,(math.random(100,150)/100)*Time_Multiplier,Especial_Actions)
					
					repeat wait() until _TIMING_WAITER - tick() < 0 or break_attack or not self_._META_CAN_ATTACK_KEEP_
					Bot_Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					
					self_:Remove_BodyVe()
					animation:Stop(.5)
					
					delay(.2,function()
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.NoMovement,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.AntiRagdoll,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Anim_Config,TS=cs,NN="Custom_Animation_Process",FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=Local_Config.Meta_Elements.CustomBodyGyro,TS=cs,NN=nil,FF=nil}) 
						MD_.FF:check__switch({BB=nil,TM=self_.My_Meta_Elements.ATTACKING,TS=cs,NN=nil,FF=nil}) 
						self_.AttackCooldown = tick() + .5
						restart_movement_Action()
					end)
				elseif types == "LOOP" and LPI then
				end
			end,	
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
			local Target_Entity = Local_Config.Target_Entity
			local Target_Magnitude = Local_Config.Self.Target_Magnitude

			if self_.___ACTION_NAME and self_.___ACTION_CONFIG then -- loop PHASE for each attack
				self_.Attacks_Enviorement[self_.___ACTION_NAME]("LOOP",self_.___ACTION_CONFIG) 
			end
			
			-- hitbox detector
			if Target_Magnitude and Target_Magnitude <= 10 then
				if self_.Attack_Create_Hitbox_Tick and self_.Attack_Create_Hitbox_Tick - tick() < 0 then self_.Attack_Create_Hitbox_Tick = nil end
				if MD_.FF:not_empty__switch(self_.My_Meta_Elements.ATTACKING.LockSwitch) and not self_._META_CANT_ATTACK_ and not self_.Attack_Create_Hitbox_Tick then -- attack
					self_.Attack_Create_Hitbox_Tick = tick() + .1

					local next_Unit = Local_Config.Self.Target_Unit
					if next_Unit then
						next_Unit = Bot_Root.CFrame.lookVector:Lerp(next_Unit,.45)*Vector3.new(1,.5,1)
						local custom_box = {
							CFrame = Bot_Root.CFrame+(next_Unit*5);
							Size = Vector3.new(2,4,4);
						}
						if Anim_Config.RunningToggle  then
							next_Unit = Bot_Root.CFrame.lookVector:Lerp(next_Unit,.35)*Vector3.new(1,0,1)
							custom_box.CFrame = Bot_Root.CFrame+(next_Unit*8);
							custom_box.Size = Vector3.new(4,3,6);
						end
						local sound
						for i,v in pairs (MD_.FF:hitbox_detector(custom_box,1.5,false)) do
							if v:FindFirstChild("WeakPointEntity") and Local_Config.Functions:Weak_Point(2,v.WeakPointEntity.Value) then
								sound = true 
								v.Velocity = next_Unit*85 
								Local_Config.Functions:Attack() 
							end
						end
						if sound then MD_.FF:PlaySound(Bot_Root,"EN_Attack_001",{PlayOnRemove=true}) end
					end
				end
			end
			
			-- if not target, cant run xd
			if not Target_Entity then
				if self_.tick_running then self_.tick_running = tick() end
			end

			--start running
			if self_.tick_start_running and self_.tick_start_running - tick() < 0 then self_.tick_start_running = nil end
			if not self_.Are_Running and not self_.tick_start_running and not self_.Defeated then -- Start Running 
				self_.Are_Running = true
				if not self_.tick_running then
					self_.tick_running = tick() + 5
				end
				Anim_Config.RunningToggle = true
				Bot_Humanoid.WalkSpeed += 21
				Local_Config.Self.Using_Change_Anim_Speed = .9
			end

			--stop running
			if (self_.tick_running and self_.tick_running - tick() < 0) then self_.tick_running = nil end
			if self_.Are_Running and (not self_.tick_running or self_.Defeated) then -- Stop Running
				self_.Are_Running = nil
				Anim_Config.RunningToggle = false
				Bot_Humanoid.WalkSpeed -= 21
				Local_Config.Self.Using_Change_Anim_Speed = Bot_Config.Change_Anim_Speed_Multi
				self_.tick_start_running = tick() + math.random(600,800)/100
			end

			-----damage

			if self_.trigger_getback_tick and self_.trigger_getback_tick - tick() < 0 then self_.trigger_getback_tick = nil end
			if self_.trigger_damage_tick and self_.trigger_damage_tick - tick() < 0 then self_.trigger_damage_tick = nil end
			if Local_Config.Trigger_GetBack.Value and not self_.Defeated and not self_.trigger_getback_tick then
				self_.trigger_getback_tick = tick()+1
				local BodyVelocity = Instance.new("BodyVelocity",Bot_Root)
				BodyVelocity.MaxForce=Vector3.new(99999,9999e9999,99999)
				BodyVelocity.Velocity=Vector3.new(0,20,0)  + (Bot_Root.CFrame.lookVector*-45) 
				_Services.Debris:AddItem(BodyVelocity,.1)
				Bot_Root.Velocity = Bot_Root.Velocity + (Bot_Root.CFrame.lookVector*-45) + Vector3.new(0,20,0)
				MD_.FF:PlaySound(Bot_Root,"EN_Get_Damage_001",{PlaybackSpeed=1.15;Volume=1.5})
			end

			--███████████████████████████████▀███████████████████████████████████████
			--█▄─▄▄▀██▀▄─██▄─▀█▀─▄██▀▄─██─▄▄▄▄█▄─▄▄─█▄─▄▄─█▄─█─▄█▄─▄▄─█▄─▀█▄─▄█─▄─▄─█
			--██─██─██─▀─███─█▄█─███─▀─██─██▄─██─▄█▀██─▄█▀██▄▀▄███─▄█▀██─█▄▀─████─███
			--▀▄▄▄▄▀▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▀▄▀▀▀▄▄▄▄▄▀▄▄▄▀▀▄▄▀▀▄▄▄▀▀

			if Local_Config.Trigger_Damage.Value and not self_.trigger_damage_tick and not self_.Defeated and self_._META_CAN_KEEP_ then
				self_.trigger_damage_tick = tick()+.8
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

				MD_.FF:PlaySound(Bot_Root,"EN_GetHit",{PlayOnRemove=true})
				MD_.FF:CreatedParticle("Defeated_Particles",Bot_Root.Position,{CustomParent=Bot_Root;DebrisTime=2;ParticleTime=.1})

				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.CantAttack,TS={Name="Defeated"},NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Local_Config.Meta_Elements.Ragdoll,TS={Name="Defeated"},NN=nil,FF=nil}) 
				MD_.FF:check__switch({BB=true,TM=Anim_Config,TS={Name="Defeated"},NN="Custom_Animation_Process",FF=nil}) 
				Anim_Config:AllStopAnimation(0)
			end
		end;

		--	███████████████████████████████████████████████████████████████▀█████████████
		--	█▄─▀█▀─▄█─▄▄─█─▄─▄─█▄─▄▄─███─▄─▄─█─▄▄─███─▄─▄─██▀▄─██▄─▄▄▀█─▄▄▄▄█▄─▄▄─█─▄─▄─█
		--	██─█▄█─██─██─███─████─▄█▀█████─███─██─█████─████─▀─███─▄─▄█─██▄─██─▄█▀███─███
		--	▀▄▄▄▀▄▄▄▀▄▄▄▄▀▀▄▄▄▀▀▄▄▄▄▄▀▀▀▀▄▄▄▀▀▄▄▄▄▀▀▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀

		Bot_Module_Extender.MOVE_TO_TARGET=function()	
			local Target_Entity = Local_Config.Target_Entity
			local Target_Magnitude = Local_Config.Self.Target_Magnitude

			self_.COUNT_FOR_3_ATTACK += 0.004
			if self_.AttackCooldown and self_.AttackCooldown - tick() < 0 then self_.AttackCooldown=nil end
			
			spawn(function()
				if Target_Magnitude and not self_.___ACTION_NAME then 
					if self_._META_CAN_JOIN_SCENE_ then -- sex
						if Target_Magnitude and Target_Magnitude <= 9 then
							Local_Config.Functions:Attack()
						end
					elseif not self_.AttackCooldown and Local_Config.Functions:CAN_TARGET_TO_ATTACK() then  -- attacks
						if self_.COUNT_FOR_3_ATTACK >= 3 and Target_Magnitude <= 16 then
							self_.___ACTION_NAME = "ACTION_3"
						elseif Anim_Config.RunningToggle and Target_Magnitude <= 16 and Target_Magnitude <= 9 then
							self_.___ACTION_NAME = "ACTION_2"
							self_.COUNT_FOR_3_ATTACK +=1
						elseif Target_Magnitude <= 9 then
							self_.___ACTION_NAME = "ACTION_1"
							self_.COUNT_FOR_3_ATTACK +=.5
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
	end,
	Animation_Events={
	};
	Conditions_For_Combinations={
		Human={
			["One"]={
				Request=function(Current_Combination,NAME)
					return Current_Combination[NAME].Amount == 0
				end,
				AnimationConfig={AnimModel="Werewolf_1"}
			};
			["Two"]={
				Request=function(Current_Combination,NAME)
					return Current_Combination[NAME].Amount == 1
				end,
				AnimationConfig={AnimModel="Werewolf_2"}
			};
		};
	};
};