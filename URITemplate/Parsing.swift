/// Swift Migrator:
///
/// This file contains one or more places using either an index
/// or a range with ArraySlice. While in Swift 1.2 ArraySlice
/// indices were 0-based, in Swift 2.0 they changed to match the
/// the indices of the original array.
///
/// The Migrator wrapped the places it found in a call to the
/// following function, please review all call sites and fix
/// incides if necessary.
@available(*, deprecated=2.0, message="Swift 2.0 migration: Review possible 0-based index")
private func __reviewIndex__<T>(value: T) -> T {
    return value
}

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
    return (slice[__reviewIndex__(0...index)], slice[__reviewIndex__((index + 1)..<slice.count)])
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>,
    character: ExpressionBoundary) -> Int? {
        if let end = __reviewIndex__(templateSlice.indexOf(character.rawValue)) {
            return end
        }

        return nil
}

func findExpressionBoundary(templateSlice: ArraySlice<Character>) -> (start: Int, end: Int)? {
    if let s = findExpressionBoundary(templateSlice, character: ExpressionBoundary.Start) {
        if let e = findExpressionBoundary(templateSlice[__reviewIndex__(1..<templateSlice.count)], character: .End) {
            return (start: s, end: e)
        }
    }

    return nil
}

public func parseVariableSpecifier(templateSlice: ArraySlice<Character>) -> VariableSpecifier {
    if templateSlice.count >= 2, let lastCharacter = templateSlice.last where lastCharacter == "*" {
        if __reviewIndex__(templateSlice.indexOf(":")) != nil {
            return VariableSpecifier(name: String(templateSlice), valueModifier: nil)
        }

        let name = String(templateSlice[__reviewIndex__(0 ..< templateSlice.count - 1)])
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

    if let expressionOperator = ExpressionOperator(rawValue: templateSlice[templateSlice.startIndex]) {
        if templateSlice.count < 2 {
            return nil
        }

        let specifierSlices = splitVariableSpecifiers(templateSlice[__reviewIndex__(1 ..< templateSlice.count)])
        let variableSpecifiers = specifierSlices.map({ parseVariableSpecifier($0) })

        switch expressionOperator {
        case .Reserved:
            return Token.Expression(TemplateExpression.Reserved(variableSpecifiers))

        case .Fragment:
            return Token.Expression(TemplateExpression.Fragment(variableSpecifiers))

        case .Label:
            return Token.Expression(TemplateExpression.Label(variableSpecifiers))

        case .PathSegment:
            return Token.Expression(TemplateExpression.PathSegment(variableSpecifiers))

        case .PathStyle:
            return Token.Expression(TemplateExpression.PathStyle(variableSpecifiers))

        case .FormStyleQuery:
            return Token.Expression(TemplateExpression.FormStyleQuery(variableSpecifiers))

        case .FormStyleQueryContinuation:
            return Token.Expression(TemplateExpression.FormStyleQueryContinuation(variableSpecifiers))
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
                let tokenBody = token[__reviewIndex__(1 ..< (token.count - 1))]

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

    if let boundary = findExpressionBoundary(templateSlice[__reviewIndex__(1 ..< templateSlice.count)]) {
        literalSlice = templateSlice[__reviewIndex__(0 ..< boundary.start + 1)]
    }
    else {
        literalSlice = templateSlice
    }

    let remainder: ArraySlice<Character>

    if literalSlice.count < templateSlice.count {
        remainder = templateSlice[__reviewIndex__(literalSlice.count ..< templateSlice.count)]
    }
    else {
        remainder = ArraySlice(arrayLiteral: "")
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
