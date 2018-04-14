--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.
]]

return function()
	local Action = require(script.Parent.Action)

	describe("new", function()
		it("should create actions", function()
			expect(Action.new(print)).to.be.ok()
		end)

		it("should error if given a bad initializer", function()
			expect(function()
				Action.new("hi")
			end).to.throw()
		end)
	end)

	describe("start", function()
		it("should always return a table with a Stop function", function()
			local dummyAction = Action.new(function() end)
			local startResult = dummyAction:start()

			expect(typeof(startResult)).to.equal("table")
			expect(typeof(startResult.stop)).to.equal("function")
		end)

		it("should call the initializer", function()
			local callCount = 0
			local action = Action.new(function()
				callCount = callCount + 1
			end)

			action:start()
			expect(callCount).to.equal(1)
		end)

		it("should return the API from the initializer function", function()
			-- Declared here so we can verify that the Stop function isn't
			-- being clobbered
			local function stop() end

			local action = Action.new(function()
				return {
					test = 1,
					stop = stop,
				}
			end)

			local api = action:start()
			expect(api.test).to.equal(1)
			expect(api.stop).to.equal(stop)
		end)

		it("should pass the callbacks map to the initializer", function()
			local function update()
			end

			local action = Action.new(function(callbacks)
				expect(callbacks.update).to.equal(update)
			end)

			action:start({
				update = update
			})
		end)

		it("should use a single function as the update callback", function()
			local function update()
			end

			local action = Action.new(function(callbacks)
				expect(callbacks.update).to.equal(update)
			end)

			action:start(update)
		end)
	end)

	describe("map", function()
		it("should return a new action", function()
			local original = Action.new(function() end)
			local mapped = original:map(function() end)

			expect(mapped).to.never.equal(original)
		end)

		it("should execute mappers in sequence", function()
			local firstCount = 0
			local secondCount = 0

			local base = Action.new(function(callbacks)
				callbacks.update(1)
			end)

			local mapped = base:map(function(value)
				firstCount = firstCount + 1
				return value + 1
			end, function(value)
				secondCount = secondCount + 1
				return value * 10
			end)

			mapped:start(function(value)
				expect(value).to.equal(20)
			end)

			expect(firstCount).to.equal(1)
			expect(secondCount).to.equal(1)
		end)
	end)
end