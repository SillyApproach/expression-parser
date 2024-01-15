Identifier = {
    name = {}
}

function Identifier.new(name)
    local instance = {
        name = name,
        interprete = Identifier.interprete
    }

    return instance
end

function Identifier:interprete()
    return self.name
end
