# Lua File Input/Output

## Reading Files

### Read Entire File
```lua
local function read_file(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    local content = file:read("*all")
    file:close()
    return content
end

-- Usage
local text = read_file("input.txt")
print(text)
```

### Read Line by Line
```lua
local function read_lines(filename)
    local lines = {}
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    return lines
end

-- Usage
local lines = read_lines("input.txt")
for i, line in ipairs(lines) do
    print(i, line)
end
```

### Read Specific Amount
```lua
local file = io.open("input.txt", "r")
if file then
    -- Read 10 bytes
    local chunk = file:read(10)

    -- Read one line
    local line = file:read("*line")

    -- Read a number
    local num = file:read("*number")

    file:close()
end
```

## Writing Files

### Write String to File
```lua
local function write_file(filename, content)
    local file = io.open(filename, "w")
    if not file then
        error("Could not open file: " .. filename)
    end

    file:write(content)
    file:close()
end

-- Usage
write_file("output.txt", "Hello World\n")
```

### Write Lines
```lua
local function write_lines(filename, lines)
    local file = io.open(filename, "w")
    if not file then
        error("Could not open file: " .. filename)
    end

    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end

-- Usage
local data = {"Line 1", "Line 2", "Line 3"}
write_lines("output.txt", data)
```

### Append to File
```lua
local file = io.open("log.txt", "a")  -- "a" for append mode
if file then
    file:write("New log entry\n")
    file:close()
end
```

## File Modes

```lua
"r"   -- Read (default). File must exist.
"w"   -- Write. Creates new file or truncates existing.
"a"   -- Append. Creates new file or appends to existing.
"r+"  -- Read and write. File must exist.
"w+"  -- Read and write. Creates new or truncates existing.
"a+"  -- Read and append. Creates new or appends to existing.
"rb"  -- Read binary
"wb"  -- Write binary
"ab"  -- Append binary
```

## File Read Methods

```lua
file:read("*all")    -- Read entire file
file:read("*line")   -- Read next line (without newline)
file:read("*number") -- Read next number
file:read(n)         -- Read n bytes
file:read()          -- Same as "*line"
```

## Checking File Existence

```lua
local function file_exists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Usage
if file_exists("input.txt") then
    print("File exists")
else
    print("File not found")
end
```

## Safe File Operations with pcall

```lua
local function safe_read_file(filename)
    local success, result = pcall(function()
        local file = io.open(filename, "r")
        if not file then
            error("Could not open file: " .. filename)
        end
        local content = file:read("*all")
        file:close()
        return content
    end)

    if success then
        return result
    else
        print("Error: " .. result)
        return nil
    end
end
```

## Common AOC File Patterns

### Read Grid/Matrix
```lua
local function read_grid(filename)
    local grid = {}
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for line in file:lines() do
        local row = {}
        for char in line:gmatch(".") do
            table.insert(row, char)
        end
        table.insert(grid, row)
    end
    file:close()
    return grid
end

-- Usage
local grid = read_grid("input.txt")
print(grid[1][1])  -- First character of first line
```

### Read Numbers from Each Line
```lua
local function read_numbers(filename)
    local numbers = {}
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for line in file:lines() do
        local num = tonumber(line)
        if num then
            table.insert(numbers, num)
        end
    end
    file:close()
    return numbers
end
```

### Read CSV-like Data
```lua
local function read_csv(filename, delimiter)
    delimiter = delimiter or ","
    local data = {}
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for line in file:lines() do
        local row = {}
        for value in string.gmatch(line, "[^" .. delimiter .. "]+") do
            table.insert(row, value)
        end
        table.insert(data, row)
    end
    file:close()
    return data
end

-- Usage
local data = read_csv("data.csv", ",")
```

### Read Groups Separated by Blank Lines
```lua
local function read_groups(filename)
    local groups = {}
    local current_group = {}
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for line in file:lines() do
        if line == "" then
            if #current_group > 0 then
                table.insert(groups, current_group)
                current_group = {}
            end
        else
            table.insert(current_group, line)
        end
    end

    -- Add last group if exists
    if #current_group > 0 then
        table.insert(groups, current_group)
    end

    file:close()
    return groups
end
```

## Using io.lines Directly

```lua
-- Iterate without opening/closing manually
for line in io.lines("input.txt") do
    print(line)
end

-- Read all lines into table
local lines = {}
for line in io.lines("input.txt") do
    table.insert(lines, line)
end
```

## Standard Input/Output

```lua
-- Read from stdin
local input = io.read()
local all_input = io.read("*all")

-- Write to stdout
io.write("Hello World\n")
print("Hello World")  -- Automatically adds newline

-- Write to stderr
io.stderr:write("Error message\n")
```

## File Position

```lua
local file = io.open("input.txt", "r")
if file then
    -- Get current position
    local pos = file:seek()

    -- Set position to beginning
    file:seek("set", 0)

    -- Move forward 10 bytes
    file:seek("cur", 10)

    -- Go to end
    file:seek("end", 0)

    -- Get file size
    local size = file:seek("end")
    file:seek("set", 0)  -- Reset to beginning

    file:close()
end
```

## Buffering

```lua
local file = io.open("output.txt", "w")
if file then
    -- No buffering
    file:setvbuf("no")

    -- Line buffering
    file:setvbuf("line")

    -- Full buffering with 4KB buffer
    file:setvbuf("full", 4096)

    file:close()
end
```

## Tips

1. Always check if file opened successfully
2. Always close files when done
3. Use `file:lines()` for line-by-line reading (most common in AOC)
4. Use `pcall` for error handling
5. For AOC, `io.lines()` is usually the simplest approach
