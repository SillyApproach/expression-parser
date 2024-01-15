Literal = {
    value = {}
}

function Literal.new(value)
    local instance = {
        value = value,
        interprete = Literal.interprete
    }

    return instance
end

function Literal:interprete()
    return self.value
end
