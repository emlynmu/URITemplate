//
//  Parsing.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum Token: DebugPrintable, URITemplateExpandable {
    case Text(String)
    case Expression(String)
    case AllowReservedExpression(String)

    public var debugDescription: String {
        switch self {
        case .Text(let value):
            return "text(\"\(value)\")"

        case .Expression(let value):
            return "expression(\"\(value)\")"

        case .AllowReservedExpression(let value):
            return "allow_reserved_expression(\"\(value)\")"
        }
    }

    public func expand(values: URITemplateValues) -> String {
        switch self {
        case .Text(let value):
            return String(value)

        case .Expression(let variable):
            return percentEncodeString((values[String(variable)] ?? ""),
                allowCharacters: .Unreserved)

        case .AllowReservedExpression(let variable):
            return percentEncodeString((values[String(variable)] ?? ""),
                allowCharacters: [.Unreserved, .Reserved])
        }
    }
}

public typealias Remainder = ArraySlice<Character>
public typealias ConsumeResult = (Token, Remainder)

enum ExpressionCharacter: Character {
    case Start = "{"
    case End = "}"
    case AllowReserved = "+"
}

func split<T>(slice: ArraySlice<T>, atIndex index: Int) -> (ArraySlice<T>, ArraySlice<T>) {
    return (slice[0...index], slice[(index + 1)..<slice.count])
}

public func consumeAllowReservedExpression(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 4,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0]),
        secondExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[1])
        where firstExpressionCharacter == .Start && secondExpressionCharacter == .AllowReserved {
            for (index, currentCharacter) in enumerate(templateSlice) {
                if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                    where currentExpressionCharacter == .End && index > 1 {
                        let (token, remainder) = split(templateSlice, atIndex: index)
                        return (Token.AllowReservedExpression(
                            String(token[2 ..< (token.count - 1)])), remainder)
                }
            }
    }

    return nil
}

public func consumeAllowReservedExpression(string: String) -> ConsumeResult? {
    return consumeAllowReservedExpression(Remainder(string))
}

public func consumeExpression(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 3,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0])
        where firstExpressionCharacter == .Start &&
            (templateSlice.count >= 4 || ExpressionCharacter(rawValue: templateSlice[1]) == nil) {
                for (index, currentCharacter) in enumerate(templateSlice) {
                    if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                        where currentExpressionCharacter == .End && index > 1 {
                            let (token, remainder) = split(templateSlice, atIndex: index)
                            return (Token.Expression(String(token[1 ..< (token.count - 1)])), remainder)
                    }
                }
    }

    return nil
}

public func consumeExpression(string: String) -> ConsumeResult? {
    return consumeExpression(Remainder(string))
}

public func consumeText(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count <= 0 {
        return nil
    }

    for (index, currentCharacter) in enumerate(templateSlice) {
        if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
            where currentExpressionCharacter == .Start {
                if consumeExpression(templateSlice[index..<templateSlice.count]) != nil {
                    let (token, remainder) = split(templateSlice, atIndex: index - 1)
                    return (Token.Text(String(token)), remainder)
                }
        }
    }

    return (Token.Text(String(templateSlice)), ArraySlice(""))
}

public func consumeText(string: String) -> ConsumeResult? {
    return consumeText(ArraySlice<Character>(string))
}

public func consumeToken(templateSlice: ArraySlice<Character>) -> (Token, Remainder)? {
    if let result = consumeAllowReservedExpression(templateSlice) {
        return result
    }
    else if let result = consumeExpression(templateSlice) {
        return result
    }
    else if let result = consumeText(templateSlice) {
        return result
    }

    return nil
}

public func tokenize(templateSlice: ArraySlice<Character>, tokens: [Token] = []) -> [Token] {
    if let (token, remainder) = consumeToken(templateSlice) {
        return tokenize(remainder, tokens: tokens + [token])
    }

    return tokens
}

public func tokenize(templateString: String) -> [Token] {
    return tokenize(ArraySlice<Character>(templateString))
}
