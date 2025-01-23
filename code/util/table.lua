local Table = {}

Table.extend = function(t, l)
	for _, val in pairs(l) do
		table.insert(t, val)
	end
end

Table.concat = function(tables)
	-- Given a list of lists, returns a new list with all elements from all lists, in order.
	local result = {}
	for _, t in pairs(tables) do
		for _, v in pairs(t) do
			table.insert(result, v)
		end
	end
	return result
end

Table.hasEntry = function(v, list)
	for _, entry in pairs(list) do
		if v == entry then return true end
	end
	return false
end

Table.stringProduct = function(strings1, strings2)
	-- Given two lists of strings, returns a list of all combinations of the two.
	local result = {}
	for _, s1 in pairs(strings1) do
		for _, s2 in pairs(strings2) do
			table.insert(result, s1 .. s2)
		end
	end
	return result
end

Table.setFields = function(a, b)
	-- Given tables a and b, set a[.] to b[.] for all keys in b.
	-- Uses string "nil" to represent nil values, else those don't work properly.
	for k, v in pairs(b) do
		if v == "nil" then v = nil end
		a[k] = v
	end
end

Table.maybeGet = function(t, k)
	-- Equivalent to the "?." operator.
	if t == nil then return nil end
	return t[k]
end

Table.listToSet = function(l)
	-- Converts sth like {"a", "b", "c"} to {a=true, b=true, c=true}.
	local s = {}
	for _, v in pairs(l) do
		s[v] = true
	end
	return s
end

Table.allInSet = function(list, set)
	-- Returns true iff all items in list are in set.
	for _, item in pairs(list) do
		if not set[item] then
			return false
		end
	end
	return true
end

Table.copyAndEdit = function(t, edits)
	-- Returns a copy of t, with edits applied.
	-- Uses string "nil" to represent nil values, else those don't work properly.
	local new = table.deepcopy(t)
	for k, v in pairs(edits) do
		if v == "nil" then v = nil end
		new[k] = v
	end
	return new
end

Table.filter = function(l, filter)
	-- Given a list, returns a new list with only elements matching the filter.
	local result = {}
	for _, v in pairs(l) do
		if filter(v) then
			table.insert(result, v)
		end
	end
	return result
end

---@param list table
---@param predicate fun(item: any): boolean
---@return number
Table.countIf = function(list, predicate)
	local count = 0
	for _, item in pairs(list) do
		if predicate(item) then
			count = count + 1
		end
	end
	return count
end

return Table