--[[

 $$$$$$\   $$$$$$\           
$$  __$$\ $$  __$$\   $$\    
$$ /  $$ |$$ /  \__|  $$ |   
$$ |  $$ |\$$$$$$\ $$$$$$$$\ 
$$ |  $$ | \____$$\\__$$  __|
$$ |  $$ |$$\   $$ |  $$ |   
 $$$$$$  |\$$$$$$  |  \__|   
 \______/  \______/          
                             
Copyright (c) 2026 HD_Nyx

MIT license

]]

-- Currently only tested on windows

local OperatingSystem = nil
local Check = package.config:sub(1,1)

if Check == "\\" then
    OperatingSystem = "Windows"
elseif Check == "/" then
    OperatingSystem = "Posix-Based" -- Can't say the u word...
else 
    OperatingSystem = "TempleOS-or-some-shit"
    os.exit(1)
end

local OSP = {}

function OSP.CreateDirectory(FolderPath)
    
    local Platform = OSP.GetOS()

    if Platform == "Windows" then
        os.execute("mkdir " .. FolderPath)
    else
        os.execute("mkdir -p " .. FolderPath)
    end
end

function OSP.CreateFile(FileName, Path, InitialContent) -- Create a file, your choice of what it is

    if Path:sub(-1) ~= "/" and Path:sub(-1) ~= "//" then
        Path = Path .. "/"
    end

    local CompleteFilePath = Path .. FileName

    local FileHandle, ErrorMessage = io.open(CompleteFilePath, "w")

    if not FileHandle then
        return nil, "Failed to create file " .. (ErrorMessage or "Unknown error")
    end

    if InitialContent then
        FileHandle:write(InitialContent)
    end

    FileHandle:close()
    return CompleteFilePath
end

-- For OSP.ExecuteFile
local AutoExecuters = {
    go = "go run ",
    js = "node ",
    ps1 = "powershell ",
    py = "python ",
    rb = "ruby ",
    sh = "bash "
}

local CustomExecutors = {}

function OSP.RegisterExtension(Extension, Handler) -- Register a custom extenstion for ExecuteFile with your own code (VeronikaKerman for idea)
    CustomExecutors[Extension] = Handler
end

function OSP.ExecuteFile(FilePath) 

    local FileName, Error = OSP.GetFileName(FilePath)

    if not FileName then
        return nil, Error
    end

    local Extension = FileName:match("^.+%.(.+)$")

    if not Extension then
        return nil, "Could not determine file extension"
    end

    local function ExecuteProcess(Command)
        local Handle = io.popen(Command)

        if not Handle then
           return nil, "Failed to execute command: " .. Command
        end

        local Output = Handle:read("*a")
        Handle:close()
        return Output
    end
    

    if Extension == "lua" then

        local Chunk, Error = loadfile(FilePath)

        if not Chunk then
            return nil, "Failed to load file: " .. Error
        end

        return Chunk()

    elseif CustomExecutors[Extension] then
            return CustomExecutors[Extension](FilePath)

    elseif AutoExecuters[Extension] then
        return ExecuteProcess(AutoExecuters[Extension] .. FilePath)

    else
        return nil, "Unsupported file type: " .. Extension .. ", You could use OSP.RegisterExtension"
    end
end

function OSP.DeleteDirectory(FolderPath)

    local Platform = OSP.GetOS()

    if Platform == "Windows" then
        return os.execute("rmdir /s /q " .. FolderPath)
    else
        return os.execute("rm -rf " .. FolderPath)
    end
end

function OSP.Exists(FilePath) -- Do you have schizophrenia or does file explorer have it?
    
    local FileHandle = io.open(FilePath, "rb")

    if FileHandle then
        FileHandle:close()
        return true
    else
        return false
    end
end

function OSP.GetFileName(FilePath) -- Do I event need to explain?
    
    local FileName = FilePath:match("^.+[\\/](.+)$")

    if FileName then
        return FileName
    else
        return nil, "Failed to retrive file name"
    end
end

function OSP.GetFileSize(FilePath) -- Gets file size of path in bytes

    local FileHandle = io.open(FilePath, "rb")

    if not FileHandle then
        return nil, "Couldn't find file"
    end

    local FileSize = FileHandle:seek("end")
    FileHandle:close()

    return FileSize
end

function OSP.GetOS() -- Reuturns Windows, macOS or Linux

    if package.config:sub(1,1) == "\\" then
        return "Windows"
    end

    local Handle = io.popen("uname -s")

    if not Handle then
           return nil, "Failed to execute command"
    end

    local Result = Handle:read("*l")
    Handle:close()
    
    if Result == "Darwin" then 
        return "macOS" 
    end

    if Result == "Linux" then 
        return "Linux" 
    end
end

function OSP.ListDirectory(Path) -- Input a path and returns all files/folders

    local Platform = OSP.GetOS()
    local Handle = nil
    local Error = nil

    if Platform == "Windows" then
        Handle, Error = io.popen("dir /b " .. Path)
    else
        Handle, Error = io.popen("ls " .. Path)
    end

    if not Handle then
        return nil, Error
    end

    local Output = Handle:read("*a")
    Handle:close()

    local Files = {}

    for File in Output:gmatch("[^\n]+") do
        table.insert(Files, File)
    end

    return Files
end

function OSP.MoveFile(FilePath, Destination)
    return os.rename(FilePath, Destination)
end

function OSP.ReadFile(FilePath) -- Get everything inside the file as a string and return that string

    local FileHandle, ErrorMessage = io.open(FilePath, "rb")

    if not FileHandle then
        return nil, "Could not open file: " .. (ErrorMessage or "Unknown error")
    end

    local Contents = FileHandle:read("*a")
    FileHandle:close()

    return Contents
end

function OSP.WriteFile(FilePath, Content)

    local FileHandle = io.open(FilePath, "w")

    if not FileHandle then
        return nil, "Failed to find file: " .. FilePath
    end

    FileHandle:write(Content)
    FileHandle:close()
end

return OSP