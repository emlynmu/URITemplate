//
//  Parsing.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias Remainder = ArraySlice<Character>
public typealias ConsumeResult = (Token, Remainder)

func split<T>(slice: ArraySlice<T>, atIndex index: Int) -> (ArraySlice<T>, ArraySlice<T>) {
    return (slice[(slice.startIndex...index)], slice[((index + 1)..<slice.endIndex)])
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>,
    character: ExpressionBoundary) -> Int? {
        if let end = templateSlice.indexOf(character.rawValue) {
            return end
        }

        return nil
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>) -> (start: Int, end: Int)? {
    if let s = findExpressionBoundary(templateSlice, character: ExpressionBoundary.Start) {
        if let e = findExpressionBoundary(
            templateSlice[templateSlice.startIndex + 1 ..< templateSlice.endIndex],
            character: .End) {
                return (start: s, end: e)
        }
    }

    return nil
}

public func parseVariableSpecifier(templateSlice: ArraySlice<Character>) -> VariableSpecifier {
    if templateSlice.count >= 2, let lastCharacter = templateSlice.last where lastCharacter == "*" {
        if templateSlice.indexOf(":") != nil {
            return VariableSpecifier(name: String(templateSlice), valueModifier: nil)
        }

        let name = String(templateSlice[templateSlice.startIndex ..< templateSlice.endIndex - 1])
        return VariableSpecifier(name: name,
            valueModifier: ValueModifier.Composite)
    }

    let specifierParts = templateSlice.split(isSeparator: { $0 == ":" })

    if specifierParts.count == 2 {
        if let length = Int(String(specifierParts[1])) where length < 10000 {
            return VariableSpecifier(name: String(specifierParts[0]),
                valueModifier: ValueModifier.Prefix(length))
        }
    }

    return VariableSpecifier(name: String(templateSlice), valueModifier: nil)
}

func splitVariableSpecifiers(templateSlice: ArraySlice<Character>) -> [ArraySlice<Character>] {
    let variables =  templateSlice.split(isSeparator: { $0 == "," })
    return variables.map({ return $0 })
}

public func parseExpressionBody(templateSlice: ArraySlice<Character>) -> Token? {
    if templateSlice.count < 1 {
        return nil
    }

    if let expressionOperator = ExpressionOperator(rawValue:
        templateSlice[templateSlice.startIndex]) {
            if templateSlice.count < 2 {
                return nil
            }

            let specifierSlices = splitVariableSpecifiers(
                templateSlice[templateSlice.startIndex + 1 ..< templateSlice.endIndex])
            let variableSpecifiers = specifierSlices.map({ parseVariableSpecifier($0) })

            switch expressionOperator {
            case .Reserved:
                return Token.Expression(.Reserved(variableSpecifiers))

            case .Fragment:
                return Token.Expression(.Fragment(variableSpecifiers))

            case .Label:
                return Token.Expression(.Label(variableSpecifiers))

            case .PathSegment:
                return Token.Expression(.PathSegment(variableSpecifiers))

            case .PathStyle:
                return Token.Expression(.PathStyle(variableSpecifiers))

            case .FormStyleQuery:
                return Token.Expression(.FormStyleQuery(variableSpecifiers))

            case .FormStyleQueryContinuation:
                return Token.Expression(.FormStyleQueryContinuation(variableSpecifiers))
            }
    }

    let specifierSlices = splitVariableSpecifiers(templateSlice)
    let variableSpecifiers = specifierSlices.map({ parseVariableSpecifier($0) })
    return Token.Expression(TemplateExpression.SimpleString(variableSpecifiers))
}

public func consumeExpression(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if let first = templateSlice.first,
        boundary = ExpressionBoundary(rawValue: first) where boundary == .Start {
            if let end = findExpressionBoundary(templateSlice, character: .End) where end >= 2 {
                let (token, remainder) = split(templateSlice, atIndex: end)
                let tokenBody = token[token.startIndex + 1 ..< (token.endIndex - 1)]

                if let token = parseExpressionBody(tokenBody) {
                    return (token, remainder)
                }
            }
    }

    return nil
}

public func consumeExpression(string: String) -> ConsumeResult? {
    return consumeExpression(Remainder(string.characters))
}

public func consumeLiteral(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count <= 0 {
        return nil
    }

    let literalSlice: ArraySlice<Character>

    if let boundary = findExpressionBoundary(
        templateSlice[(templateSlice.startIndex + 1) ..< templateSlice.endIndex]) {
            literalSlice = templateSlice[templateSlice.startIndex ..< boundary.start]
    }
    else {
        literalSlice = templateSlice
    }

    let remainder: ArraySlice<Character>

    if literalSlice.count < templateSlice.endIndex {
        remainder = templateSlice[literalSlice.endIndex ..< templateSlice.endIndex]
    }
    else {
        remainder = ArraySlice("".characters)
    }

    return (Token.Literal(String(literalSlice)), remainder)
}

public func consumeLiteral(string: String) -> ConsumeResult? {
    return consumeLiteral(ArraySlice<Character>(string.characters))
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
    return tokenize(ArraySlice<Character>(templateString.characters))
}
