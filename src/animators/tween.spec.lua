--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.
]]

return function()
	local tween = require(script.Parent.tween)

	it("should error if types differ", function()
		expect(function()
			tween({
				from = 1,
				to = "test",
			})
		end).to.throw()
	end)

	it("should error if given an unlerpable type", function()
		expect(function()
			tween({
				from = "test",
				to = "test",
			})
		end).to.throw()
	end)

	describe("animation", function()
		-- These tests depend on RunService and the event loop.
		if _G.LEMUR_TESTING then
			SKIP()
		end

		it("should call update", function()
			tween({
				from = 0,
				to = 1,
			}):start(function(value)
				-- luacheck: ignore 143
				expect(math.clamp(value, 0, 1)).to.equal(value)
			end)
		end)

		it("should call complete if present", function()
			tween({
				from = 0,
				to = 1,
			}):start({
				update = function(value)
					-- luacheck: ignore 143
					expect(math.clamp(value, 0, 1)).to.equal(value)
				end,
				complete = function(value)
					expect(value).to.equal(1)
				end,
			})
		end)
	end)
end