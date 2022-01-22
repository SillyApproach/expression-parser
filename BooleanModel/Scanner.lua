dofile("./BooleanModel/Token.lua")

Scanner = {}
local _scanner = {}

function Scanner.new(source)
    local instance = {
        source = source,
        tokens = {},
        start = 1,
        current = 1,
        scan = Scanner.scan
    }

    return instance
end

function Scanner:scan()
    while not _scanner.endOfStream(self) do
        self.start = self.current
        _scanner.scanToken(self)
    end

    self.start = self.current
    _scanner.addToken(self, TokenType.EOS)
    return self.tokens
end

function _scanner:scanToken()
    local c = _scanner.advance(self)

    if c =="(" then
        _scanner.addToken(self, TokenType.LEFT_PAREN)
    elseif c == ")" then
        _scanner.addToken(self, TokenType.RIGHT_PAREN)
    elseif c == "+" then
        _scanner.addToken(self, TokenType.PLUS)
    elseif c == "*" then
        _scanner.addToken(self, TokenType.STAR)
    elseif c == "!" then
        _scanner.addToken(self, TokenType.EXCLAMATION)
    elseif c:match("%s+") then
        local _, j = self.source:find("%s+", self.start)
        self.current = j + 1
    elseif c == "0" then
        _scanner.addToken(self, TokenType.FALSE, false)
    elseif c == "1" then
        _scanner.addToken(self, TokenType.TRUE, true)
    elseif c:match("[%a_]") then
        local _, j , text = self.source:find("([_%a][_%w]*)", self.start)
        self.current = j + 1
        _scanner.addToken(self, TokenType.IDENTIFIER, text)
    else
        _scanner.error(self, c)
    end
end

function _scanner:error(c)
    local msg = ("Unexpected \"%s\" at position %i"):format(c, self.current - 1)
    local marker = ("%s^%s"):format((" "):rep(self.current - 2), ("-"):rep(#self.source - self.start))
    local preview = ("%s\n%s Here"):format(self.source, marker)
    error(("%s\n\n%s\n"):format(msg, preview))
end

function _scanner:endOfStream()
    return self.current > #self.source
end

function _scanner:addToken(tokenType, literal)
    local text = self.source:sub(self.start, self.current - 1)
    table.insert(self.tokens, Token.new(tokenType, text, literal, self.start))
end

function _scanner:advance()
    local c = self.source:sub(self.current, self.current)
    self.current = self.current + 1
    return c
end

function _scanner:peek()
    if _scanner.endOfStream(self) then
        return ""
    end

    return self.source:sub(self.current, self.current)
end

function _scanner:match(expected)
    if _scanner.endOfStream(self)
    or self.source:sub(self.current, self.current) ~= expected then
        return false
    end

    self.current = self.current + 1
    return true
end
