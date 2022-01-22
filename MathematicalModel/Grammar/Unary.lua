Unary = {
    operator = {},
    right = {}
}

function Unary.new(operator, right)
    local instance = {
        operator = operator,
        right = right,
        interprete = Unary.interprete
    }

    return instance
end

function Unary:interprete()
    return -(self.right:interprete())
end
