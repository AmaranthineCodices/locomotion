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

    describe("Start", function()
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
    end)
end