//
//  Parsing.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum Token: DebugPrintable, URITemplateExpandable {
    case Literal(String)
    case SimpleString([String])
    case Reserved([String])
    case Fragment([String])
    case Label([String])

    public var debugDescription: String {
        switch self {
        case .Literal(let value):
            return "text(\"\(value)\")"

        case .SimpleString(let value):
            return "simple_string(\"\(value)\")"

        case .Reserved(let value):
            return "reserved(\"\(value)\")"

        case .Fragment(let value):
            return "fragment(\"\(value)\")"

        case .Label(let value):
            return "label(\"\(value)\")"
        }
    }

    private func expandValue(variable: String, values: URITemplateValues,
        allowCharacters: [CharacterClass], separator: String = ",") -> String {
            if let values = values[variable] as? [AnyObject] {
                return join(separator, map(values, { percentEncodeString(($0.description ?? ""),
                    allowCharacters: allowCharacters) }))
            }
            else {
                return percentEncodeString((values[variable]?.description ?? ""),
                    allowCharacters: allowCharacters)
            }
    }

    public func expand(values: URITemplateValues) -> String {
        switch self {
        case .Literal(let value):
            return String(value)

        case .SimpleString(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved]) })
            return join(",", values)

        case .Reserved(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return join(",", values)

        case .Fragment(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return "#" + join(",", values)

        case .Label(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved], separator: ".")})
            return "." + join(".", values)
        }
    }
}

public typealias Remainder = ArraySlice<Character>
public typealias ConsumeResult = (Token, Remainder)

func split<T>(slice: ArraySlice<T>, atIndex index: Int) -> (ArraySlice<T>, ArraySlice<T>) {
    return (slice[0...index], slice[(index + 1)..<slice.count])
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>,
    character: ExpressionBoundary) -> Int? {
        if let end = find(templateSlice, character.rawValue) {
            return end
        }

        return nil
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>) -> (start: Int, end: Int)? {
    if let s = findExpressionBoundary(templateSlice, ExpressionBoundary.Start) {
        if let e = findExpressionBoundary(templateSlice[1..<templateSlice.count], .End) {
            return (start: s, end: e)
        }
    }

    return nil
}

func splitVariables(templateSlice: ArraySlice<Character>) -> [String] {
    let variables =  split(templateSlice, isSeparator: { $0 == "," })
    return variables.map({ return String($0) })
}

public func parseExpressionBody(templateSlice: ArraySlice<Character>) -> Token? {
    if templateSlice.count < 1 {
        return nil
    }

    if let expressionOperator = ExpressionOperator(rawValue: templateSlice[0]) {
        if templateSlice.count < 2 {
            return nil
        }

        let variables = splitVariables(templateSlice[1 ..< templateSlice.count])

        switch expressionOperator {
        case .Reserved:
            return Token.Reserved(variables)

        case .Fragment:
            return Token.Fragment(variables)

        case .Label:
            return Token.Label(variables)
        }
    }

    return Token.SimpleString(splitVariables(templateSlice))
}

public func consumeExpression(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if let first = templateSlice.first,
        boundary = ExpressionBoundary(rawValue: first) where boundary == .Start {
            if let end = findExpressionBoundary(templateSlice, .End) where end >= 2 {
                let (token, remainder) = split(templateSlice, atIndex: end)
                let tokenBody = token[1 ..< (token.count - 1)]

                if let token = parseExpressionBody(tokenBody) {
                    return (token, remainder)
                }
            }
    }

    return nil
}

public func consumeExpression(string: String) -> ConsumeResult? {
    return consumeExpression(Remainder(string))
}

public func consumeLiteral(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count <= 0 {
        return nil
    }

    let literalSlice: ArraySlice<Character>

    if let boundary = findExpressionBoundary(templateSlice[1 ..< templateSlice.count]) {
        literalSlice = templateSlice[0 ..< boundary.start + 1]
    }
    else {
        literalSlice = templateSlice
    }

    let remainder: ArraySlice<Character>

    if literalSlice.count < templateSlice.count {
        remainder = templateSlice[literalSlice.count ..< templateSlice.count]
    }
    else {
        remainder = ArraySlice("")
    }

    return (Token.Literal(String(literalSlice)), remainder)
}

public func consumeLiteral(string: String) -> ConsumeResult? {
    return consumeLiteral(ArraySlice<Character>(string))
}

public func consumeToken(templateSlice: ArraySlice<Character>) -> (Token, Remainder)? {
    if let result = consumeExpression(templateSlice) {
        return result
    }
    else if let result = consumeLiteral(templateSlice) {
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
