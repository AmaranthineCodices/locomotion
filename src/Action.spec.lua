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
end