--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.

	An action is the interface to all of Locomotion's animations. All animators
	produce an Action, which can be started, stopped, and interacted with
	regardless of how the action moves.
]]

-- A no-op function used to avoid creating a closure for every action start.
local function noop() end

local Action = {}
Action.__index = Action

--[[
	Creates a new action.
]]
function Action.new(init)
	assert(typeof(init) == "function", "init function must be a function")

	local self = setmetatable({
		_init = init,
	}, Action)

	return self
end

--[[
	Starts the action. Returns the API returned by the action init function.
]]
function Action:start(callbacks)
	callbacks = callbacks or {}

	-- If only one callback is supplied, use it as the "update" callback
	if typeof(callbacks) == "function" then
		callbacks = {
			update = callbacks
		}
	end

	-- Get the action's API.
	-- This may or may not be supplied by the init function.
	local api = self._init(callbacks) or {}

	-- If there's no stop action provided, use the no-op one.
	if api.stop == nil then
		api.stop = noop
	end

	return api
end

return Action
