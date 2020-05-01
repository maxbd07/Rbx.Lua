-- Retarded Chat; using a "__namecall" hook
-- Author: maxbd (maxbd07, maxbd123, 0xEB)



local options = {
	UseEmojis = true,
	EmojiRarity = 5,
	
	local Emojis = {
		'🤑',
		'😎',
		'😳',
		'😰',
		'😱',
		'😩',
		'😤',
		'😠',
		'😡',
		'🤡',
		'🤦',
		'🤷',
		'🎅'
	}
}



local function changestring(pA, pB)
	local vA = ""
	
	math.randomseed(pB)
	
	for lvA = 1, string.len(pA) do
		local tvA = math.random(1, table.getn(options.Emojis))

		if math.random(0, 1) == 0 then
			vA = vA .. string.lower(string.sub(pA, lvA, lvA))
		else
			vA = vA .. string.upper(string.sub(pA, lvA, lvA))
		end

		if options.UseEmojis == true then
			if math.random(1, options.EmojiRarity) == 1 then
				vA = vA .. options.Emojis[tvA]
			end	
		end
    	end

	return vA
end



local metatable = getrawmetatable(game)
local proxy = {__namecall = metatable.__namecall}



setreadonly(metatable, false)



metatable.__namecall = function(self, ...)
	if self.Name == "SayMessageRequest" then
        	local arguments = {...}
        	return proxy.__namecall(self, changestring(arguments[1], string.len(arguments[1])), arguments[2])
    	end

	return proxy.__namecall(self, ...)
end



setreadonly(metatable, true)
