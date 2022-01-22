Token = {}
TokenType = {
    LEFT_PAREN = "LEFT_PAREN",
    RIGHT_PAREN = "RIGHT_PAREN",
    PLUS = "PLUS",
    MINUS = "MINUS",
    STAR = "STAR",
    SLASH = "SLASH",
    CARET = "CARET",

    IDENTIFIER = "IDENTIFIER",
    NUMBER = "NUMBER",
    STRING = "STRING",

    EOS = "EOS"
}

function Token.new(tType, lexeme, literal, column)
    local instance = {
        type = tType,
        lexeme = lexeme,
        literal = literal,
        column = column,
        getType = Token.getType,
        getColumn = Token.getColumn,
        getLexeme = Token.getLexeme,
        getLiteral = Token.getLiteral,
        toString = Token.toString
    }

    return instance
end

function Token:getType()
    return self.type
end

function Token:getColumn()
    return self.column
end

function Token:getLexeme()
    return self.lexeme
end

function Token:getLiteral()
    return self.literal
end

function Token:toString()
    return ("Type:   %s\nLexeme: %s\nColumn: %i "):format(self.type, self.lexeme, self.column)
end
