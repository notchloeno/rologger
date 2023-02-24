return {
    -- Global settings
    Levels = {
        Debug = 1,
        Info = 2,
        Warning = 3,
        Error = 4,
        Critical = 5
    },
    -- These end with a space for formatting reasons
    LevelText = {
        "[Debug] ",
        "[Info] ",
        "[Warn] ",
        "[ERROR] ",
        "[CRITICAL!] "
    },

    -- Default local options
    DefaultOptions = {
        Level = 1,  -- Messages with level strictly below this are ignored
        Depth = 1000,  -- How many messages will be stored in memory
        TracebackLevel = 4,  -- Messages at or above this level will generate a traceback
    }
}