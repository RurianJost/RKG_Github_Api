SERVER = IsDuplicityVersion()
CLIENT = not SERVER

function table.maxn(t)
	local max = 0
	
	for key in pairs(t) do
		local number = tonumber(key)

		if number and number > max then 
			max = number 
		end
	end

	return max
end

function parseInt(v)
	local number = tonumber(v)
	
	if number == nil then
		return 0
	else
		return math.floor(number)
	end
end

local modules = {}

function require(resourceName, path)
	if path == nil then
		path = resourceName
		
		resourceName = GetCurrentResourceName()
	end

	local key = resourceName..path
	local module = modules[key]

	if module then
		return module
	else
		local code = LoadResourceFile(resourceName, path..'.lua')
		
		if code then
			local file, loadError = load(code, resourceName..'/'..path..'.lua')
			
			if file then
				local ok, res = xpcall(file, debug.traceback)
				
				if ok then
					modules[key] = res
					
					return res
				else
					error('error loading module '..resourceName..'/'..path..':'..res)
				end
			else
				error('error parsing module '..resourceName..'/'..path..':'..debug.traceback(loadError))
			end
		else
			error('resource file '..resourceName..'/'..path..'.lua not found')
		end
	end
end

local function wait(self)
	local rets = Citizen.Await(self.p)
	
	if not rets then
		rets = self.r 
	end

	return table.unpack(rets, 1, table.maxn(rets))
end

local function areturn(self, ...)
	self.r = {...}
	self.p:resolve(self.r)
end

function async(func)
	if func then
		Citizen.CreateThreadNow(func)
	else
		return setmetatable({ 
			wait = wait, 
			p = promise.new() 
		}, { 
			__call = areturn 
		})
	end
end

function table:length()
	local length = 0 

	for i in pairs(self) do 
		length = length + 1
	end 

	return length
end 

function table:equals(comparation)
    if self == comparation then 
		return true 
	end

    local o1Type = type(self)
    local o2Type = type(comparation)
	
    if o1Type ~= o2Type then 
		return false 
	end

    if o1Type ~= 'table' then 
		return false 
	end

    local keySet = {}

    for key1, value1 in pairs(self) do
        local value2 = comparation[key1]
		
        if value2 == nil or table.equals(value1, value2) == false then
            return false
        end

        keySet[key1] = true
    end

    for key2, _ in pairs(comparation) do
        if not keySet[key2] then 
			return false 
		end
    end

    return true
end

module = require