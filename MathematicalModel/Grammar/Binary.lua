Binary = {
    left = {},
    operator = {},
    right = {}
}

function Binary.new(left, operator, right)
    local instance = {
        left = left,
        operator = operator,
        right = right,
        interprete = Binary.interprete
    }

    return instance
end

function Binary:interprete()
    local tType = self.operator:getType()
    if tType == TokenType.MINUS then
        return self.left:interprete() - self.right:interprete()
    elseif tType == TokenType.PLUS then
        return self.left:interprete() + self.right:interprete()
    elseif tType == TokenType.SLASH then
        return self.left:interprete() / self.right:interprete()
    elseif tType == TokenType.STAR then
        return self.left:interprete() * self.right:interprete()
    elseif tType == TokenType.CARET then
        local b = self.left:interprete()
        local a = b < 0 and -1 or 1
        local x = self.right:interprete()
        return a * math.exp(x * math.log(a * b))
    end
end
