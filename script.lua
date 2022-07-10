------------------------------------------------------------------
--  this is a free script and may not be used in any commercial	--
--  way without written permission from Halvhjearne				--
------------------------------------------------------------------

-- Not doing anything for AIs
if car.isAIControlled then
	return nil
end
--set vars
local ButtonDown = false
local shiftLayout = false
--start with Conventional layout (not possible to detect h shifter correctly?)
local dogActive = false
-- set default true for me tho, he he
if ac.getDriverName() == 'Halvhjearne' then
	dogActive = true
end

function script.update(dt)
	-- get extra f state
	local extraFstate = car.extraF
	-- check if extra f is pressed (true) and ButtonDown is false
	if extraFstate and not ButtonDown then
		-- if extra f is pressed change ButtonDown and shiftLayout to true
		ButtonDown = true
		shiftLayout = true
	end
	-- check if extra f is released (false) and ButtonDown has changed to true
	if not extraFstate and ButtonDown then
		-- if extra f was pressed and released we change ButtonDown state
		ButtonDown= false
	end
	-- if shiftLayout changed we run this block 
	if shiftLayout then
		-- get car physics
		local data = ac.accessCarPhysics()
		-- check if gear lever is in neutral (1) position (-1=R,0=1,1=N,2=2,3=3,...)
		if data.gear == 1 then
			-- if all is well we change dogActive state and send a message
			if dogActive then
				ac.setMessage('Conventional five-speed gear layout')
				dogActive = false
			else
				ac.setMessage('Dogleg five-speed gear layout', 'First gear is left and down, reverse is left and up')
				dogActive = true
			end
		else
			-- if if not in neutral we send a message
			ac.setMessage('Move your H-shifter to Neutral position','and press the button again to change gear layout')
		end
		-- reset shiftLayout state
		shiftLayout = false
	end
	-- if dogActive is true we run this block to change the gear layout
	if dogActive then
		-- from CSP github --
		local data = ac.accessCarPhysics()
		if data.requestedGearIndex == 2 then
		-- If first gear is requested, change to reverse
			data.requestedGearIndex = 0
		elseif data.requestedGearIndex > 2 then
		-- If above frist gear is requested, bump it one down
			data.requestedGearIndex = data.requestedGearIndex - 1
		else
		-- Otherwise, set it to neutral
			data.requestedGearIndex = 1
		end
		-- from CSP github --
	end
end
