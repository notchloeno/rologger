return function()
    local Logger = require(script.Parent.Parent.Logger.Logger)

    local stubSource

    beforeEach(function()
        stubSource = Instance.new("Script")
    end)


    afterEach(function()
        if stubSource then
            stubSource:Destroy()
        end
    end)


    it("SHOULD have the correct properties", function()
        stubSource.Name = "aRandomTestName_1@"
        local logger = Logger.new(stubSource)
        expect(logger.source).to.equal(stubSource)
        expect(logger.name).to.equal(`[{stubSource.Name}]`)
    end)

    it("SHOULD NOT throw when we log at any level", function()
        local logger = Logger.new(stubSource)
        expect(function()
            logger:Debug("Debug")
            logger:Info("Info")
            logger:Warn("Warn")
            logger:Error("Error")
            logger:Critical("Critical")
        end).to.never.throw()
    end)

    it("SHOULD throw when no source is provided", function()
        expect(function()
            Logger.new()
        end).to.throw()
    end)

    it("SHOULD NOT throw when we provide no options", function()
        expect(function()
            Logger.new(stubSource)
        end).to.never.throw()
    end)

    it("SHOULD return the logged message", function()
        stubSource.Name = "TEST"
        local logger = Logger.new(stubSource)
        local loggedMessage = logger:Info("TEST")
        expect(loggedMessage).to.be.ok()
        expect(loggedMessage).to.equal("[TEST] [Info] TEST")
    end)

    it("SHOULD NOT throw when we try to log multiple values", function()
        local logger = Logger.new(stubSource)
        expect(function()
            logger:Info("Hello", "World")
        end).to.never.throw()
    end)

end