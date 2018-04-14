--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.

	The 'tween' animator tweens from one value to another over a fixed time.
]]

local RunService = game:GetService("RunService")

local Action = require(script.Parent.Parent.Action)
local easings = require(script.Parent.Parent.easings)

local function lerpNumber(a, b, alpha)
	return (1 - alpha) * a + b * alpha
end

local function tween(props)
	local from = props.from or 1
	local to = props.to or 1
	local easing = props.easing or easings.linear
	local duration = props.duration or 1

	assert(typeof(from) == typeof(to), "cannot tween between two different types")
	local lerpFunction = lerpNumber

	if typeof(to) ~= "number" then
		lerpFunction = to.Lerp

		if not lerpFunction then
			error(("the type %q has no Lerp method"):format(typeof(to)), 2)
		end
	end

	return Action.new(function(callbacks)
		local startTick = tick()

		local connection
		connection = RunService.RenderStepped:Connect(function()
			local alpha = (tick() - startTick) / duration

			if alpha >= 1 then
				connection:Disconnect()

				if callbacks.complete then
					callbacks.complete(to)
				end
			else
				local easedAlpha = easing(alpha)
				local intermediate = lerpFunction(from, to, easedAlpha)
				callbacks.update(intermediate)
			end
		end)

		return {
			stop = function()
				connection:Disconnect()
			end,
		}
	end)
end

return tween
