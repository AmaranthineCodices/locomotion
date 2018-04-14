--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.

	Implements a variety of easing functions.
	Easing functions take a progress value and return a new one.
]]

local easings = {}

--[[
	The linear easing returns the same progress value.
]]
function easings.linear(progress)
	return progress
end

return easings