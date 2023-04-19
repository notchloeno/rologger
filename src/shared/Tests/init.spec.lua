local defaultOptions = { Level = 2 }

return function()
    local Logger = require(script.Parent.Parent.Logger.Logger)
    it("SHOULD have the correct properties", function()
        local stubSource = Instance.new("Script")
        stubSource.Name = "aRandomTestName_1@"
        local logger = Logger.new(stubSource, defaultOptions)
        expect(logger.source).to.equal(stubSource)
        expect(logger.name).to.equal(`[{stubSource.Name}]`)

        stubSource:Destroy()
    end)

    it("SHOULD NOT throw when we log at any level", function()
        local stubSource = Instance.new("Script")
        local logger = Logger.new(stubSource, defaultOptions)
        expect(function()
            logger:Debug("Debug")
            logger:Info("Info")
            logger:Warn("Warn")
            logger:Error("Error")
            logger:Critical("Critical")
        end).to.never.throw()

        stubSource:Destroy()
    end)

    it("SHOULD throw when no source is provided", function()
        expect(function()
            Logger.new()
        end).to.throw()
    end)

    it("SHOULD NOT throw when we provide no options", function()
        local stubSource = Instance.new("Script")
        expect(function()
            Logger.new(stubSource)
        end).to.never.throw()
    end)
end