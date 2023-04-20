local LoggerManager = {}

local Logger = require(script.Logger)


function LoggerManager.new(source, options)
    if not source then
        error("No source script passed for argument #1")
    elseif not options then
        options = {}
    end
    return Logger.new(source, options)
end



return LoggerManager