dofile("./BooleanModel/Grammar/Expression.lua")
dofile("./BooleanModel/Grammar/Binary.lua")
dofile("./BooleanModel/Grammar/Unary.lua")
dofile("./BooleanModel/Grammar/Group.lua")
dofile("./BooleanModel/Grammar/Literal.lua")
dofile("./BooleanModel/Grammar/Identifier.lua")

Parser = {}
local _parser = {}

function Parser.new(source, tokens)
    local instance = {
        source = source,
        tokens = tokens,
        current = 1,
        parse = Parser.parse
    }

    return instance
end

function Parser:parse()
    local expr = _parser.expression(self)

    if not _parser.endOfStream(self) then
        _parser.error(self, _parser.advance(self), "Expected EOS after expression.")
    end

    return expr
end

function _parser:expression()
    return _parser.term(self)
end

function _parser:term()
    local expr = _parser.factor(self)

    while _parser.match(self, TokenType.PLUS) do
        local operator = _parser.previous(self)
        local right = _parser.factor(self)
        expr = Binary.new(expr, operator, right)
    end

    return expr
end

function _parser:factor()
    local expr = _parser.unary(self)

    while _parser.match(self, TokenType.STAR) do
        local operator = _parser.previous(self)
        local right = _parser.unary(self)
        expr = Binary.new(expr, operator, right)
    end

    return expr
end

function _parser:unary()
    if _parser.match(self, TokenType.EXCLAMATION) then
        local operator = _parser.previous(self)
        local right = _parser.unary(self)
        return Unary.new(operator, right)
    end

    return _parser.primary(self)
end

function _parser:primary()
    if _parser.match(self, TokenType.TRUE, TokenType.FALSE) then
        return Literal.new(_parser.previous(self):getLiteral())
    end

    if _parser.match(self, TokenType.IDENTIFIER) then
        return Identifier.new(_parser.previous(self):getLexeme())
    end

    if (_parser.match(self, TokenType.LEFT_PAREN)) then
        local expr = _parser.expression(self)
        _parser.consume(self, TokenType.RIGHT_PAREN, "Expected ')' after expression.")
        return Group.new(expr)
    end

    _parser.error(self, _parser.peek(self), "Expected expression.")
end

function _parser:check(tType)
    return not _parser.endOfStream(self) and _parser.peek(self):getType() == tType
end

function _parser:advance()
    if not _parser.endOfStream(self) then
        self.current = self.current + 1
        return _parser.previous(self)
    end
end

function _parser:consume(tType, message)
    if _parser.check(self, tType) then
        return _parser.advance(self)
    end

    _parser.error(self, _parser.peek(self), message)
end

function _parser:error(token, message)
    local msg = ("Unexpected \"%s\" at %s\n%s"):format(
        token:getLexeme(),
        (token:getType() == TokenType.EOS) and "end" or tostring(token:getColumn()),
        message
    )

    local marker = ("%s%s%s"):format(
        (" "):rep(token:getColumn() - 1),
        ("^"):rep(#token:getLexeme()),
        ("-"):rep(#self.source - (token:getColumn() + #token:getLexeme() - 1))
    )

    local preview = ("%s\n%s Here"):format(self.source, marker)
    error(("%s\n\n%s\n"):format(msg, preview))
end

function _parser:match(...)
    for _, tType in ipairs({...}) do
        if _parser.check(self, tType) then
            _parser.advance(self);
            return true
        end
    end

    return false
end

function _parser:endOfStream()
    return _parser.peek(self):getType() == TokenType.EOS
end

function _parser:peek()
    return self.tokens[self.current]
end

function _parser:previous()
    return self.tokens[self.current - 1]
end
