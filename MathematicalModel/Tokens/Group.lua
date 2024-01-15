Group = {
    expression = {}
}

function Group.new(expression)
    local instance = {
        expression = expression,
        interprete = Group.interprete
    }

    return instance
end

function Group:interprete()
    return self.expression:interprete()
end
