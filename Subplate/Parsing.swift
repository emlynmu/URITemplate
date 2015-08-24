//
//  Parsing.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias Remainder = ArraySlice<Character>
public typealias ConsumeResult = (Token, Remainder)

func split<T>(slice: ArraySlice<T>, atIndex index: Int) -> (ArraySlice<T>, ArraySlice<T>) {
    return (slice[0...index], slice[(index + 1)..<slice.count])
}

func findExpressionBoundary(subplateSlice: ArraySlice<Character>,
    character: ExpressionBoundary) -> Int? {
        if let end = find(subplateSlice, character.rawValue) {
            return end
        }

        return nil
}

func findExpressionBoundary(subplateSlice: ArraySlice<Character>) -> (start: Int, end: Int)? {
    if let s = findExpressionBoundary(subplateSlice, ExpressionBoundary.Start) {
        if let e = findExpressionBoundary(subplateSlice[1..<subplateSlice.count], .End) {
            return (start: s, end: e)
        }
    }

    return nil
}

func splitVariables(subplateSlice: ArraySlice<Character>) -> [String] {
    let variables =  split(subplateSlice, isSeparator: { $0 == "," })
    return variables.map({ return String($0) })
}

public func parseExpressionBody(subplateSlice: ArraySlice<Character>) -> Token? {
    if subplateSlice.count < 1 {
        return nil
    }

    if let expressionOperator = ExpressionOperator(rawValue: subplateSlice[0]) {
        if subplateSlice.count < 2 {
            return nil
        }

        let variables = splitVariables(subplateSlice[1 ..< subplateSlice.count])

        switch expressionOperator {
        case .Reserved:
            return Token.Reserved(variables)

        case .Fragment:
            return Token.Fragment(variables)

        case .Label:
            return Token.Label(variables)

        case .PathSegment:
            return Token.PathSegment(variables)

        case .PathStyle:
            return Token.PathStyle(variables)

        case .FormStyleQuery:
            return Token.FormStyleQuery(variables)

        case .FormStyleQueryContinuation:
            return Token.FormStyleQueryContinuation(variables)
        }
    }

    return Token.SimpleString(splitVariables(subplateSlice))
}

public func consumeExpression(subplateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if let first = subplateSlice.first,
        boundary = ExpressionBoundary(rawValue: first) where boundary == .Start {
            if let end = findExpressionBoundary(subplateSlice, .End) where end >= 2 {
                let (token, remainder) = split(subplateSlice, atIndex: end)
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

public func consumeLiteral(subplateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if subplateSlice.count <= 0 {
        return nil
    }

    let literalSlice: ArraySlice<Character>

    if let boundary = findExpressionBoundary(subplateSlice[1 ..< subplateSlice.count]) {
        literalSlice = subplateSlice[0 ..< boundary.start + 1]
    }
    else {
        literalSlice = subplateSlice
    }

    let remainder: ArraySlice<Character>

    if literalSlice.count < subplateSlice.count {
        remainder = subplateSlice[literalSlice.count ..< subplateSlice.count]
    }
    else {
        remainder = ArraySlice("")
    }

    return (Token.Literal(String(literalSlice)), remainder)
}

public func consumeLiteral(string: String) -> ConsumeResult? {
    return consumeLiteral(ArraySlice<Character>(string))
}

public func consumeToken(subplateSlice: ArraySlice<Character>) -> (Token, Remainder)? {
    if let result = consumeExpression(subplateSlice) {
        return result
    }
    else if let result = consumeLiteral(subplateSlice) {
        return result
    }

    return nil
}

public func tokenize(subplateSlice: ArraySlice<Character>, tokens: [Token] = []) -> [Token] {
    if let (token, remainder) = consumeToken(subplateSlice) {
        return tokenize(remainder, tokens: tokens + [token])
    }

    return tokens
}

public func tokenize(subplateString: String) -> [Token] {
    return tokenize(ArraySlice<Character>(subplateString))
}
