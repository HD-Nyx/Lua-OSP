# Lua-OSP

Extend Lua's `os` library with OS+, a portable, cross-platform, single file library designed to fill the gaps that Lua's built-in `os` library leaves behind.

## Usage
Drop `OSP.lua` into your project and require it

```lua
local osp = require("OSP")
```

## Examples

**Create a file**
```lua
-- FileName: str, Path: str, InitialContent: str
OSP.CreateFile("Hello.txt", "C:/", "Hello from OS+!")
-- Returns: filepath of file created
```

**File exists?**
```lua
-- FilePath: str
OSP.FileExists("C:/Hello.txt")
-- Returns: true/false
```

**Get file name**
```lua
-- FilePath: str
OSP.GetFileName("C:/Hello.txt")
-- Returns: "Hello.txt"
```

**Get file size**
```lua
-- FilePath: str
OSP.GetFileSize("C:/Hello.txt")
-- Returns: file size in bytes
```

**Read file**
```lua
-- FilePath: str
OSP.ReadFile("C:/Hello.txt")
-- Returns: file contents as a string
```

**Get timezone offset**
```lua
-- IncludeUTC: bool
OSP.GetTimeZoneOffset(true)  -- Returns: "UTC +12:00"
OSP.GetTimeZoneOffset(false) -- Returns: "+12:00"
```

**Get OS**
```lua
OSP.GetOS()
-- Returns: "Windows", "macOS", or "Linux"
```
