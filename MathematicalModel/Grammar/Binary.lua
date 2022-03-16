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
        return self.left:interprete() ^ self.right:interprete()
    end
end
