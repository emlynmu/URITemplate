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
    case SimpleString(String)
    case Reserved(String)
    case Fragment(String)
    case Label(String)

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

    private func expandValue(variable: String, values: URITemplateValues,
        allowCharacters: CharacterClass) -> String {
            return expandValue(variable, values: values, allowCharacters: [allowCharacters])
    }

    public func expand(values: URITemplateValues) -> String {
        switch self {
        case .Literal(let value):
            return String(value)

        case .SimpleString(let variable):
            return expandValue(variable, values: values, allowCharacters: .Unreserved)

        case .Reserved(let variable):
            return expandValue(variable, values: values, allowCharacters: [.Unreserved, .Reserved])

        case .Fragment(let variable):
            return "#" + expandValue(variable, values: values,
                allowCharacters: [.Unreserved, .Reserved])

        case .Label(let variable):
            return "." + expandValue(variable, values: values,
                allowCharacters: [.Unreserved, .Reserved], separator: ".")
        }
    }
}

public typealias Remainder = ArraySlice<Character>
public typealias ConsumeResult = (Token, Remainder)

func split<T>(slice: ArraySlice<T>, atIndex index: Int) -> (ArraySlice<T>, ArraySlice<T>) {
    return (slice[0...index], slice[(index + 1)..<slice.count])
}

func findExpressionBoundaryCharacter(character: ExpressionBoundary,
    inTemplateSlice templateSlice: ArraySlice<Character>) -> Int? {
        return find(templateSlice, character.rawValue)
}

public func findExpressionBoundary(templateSlice: ArraySlice<Character>) ->
    (start: Int, end: Int)? {
        if let start = findExpressionBoundaryCharacter(.Start,
            inTemplateSlice: templateSlice),
            end = findExpressionBoundaryCharacter(.End,
                inTemplateSlice: templateSlice[(start + 1)..<templateSlice.count]) {
                    return (start: start, end: start + end + 1)
        }

        return nil
}

public func consumeLabel(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 4,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0]),
        secondExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[1])
        where firstExpressionCharacter == .Start && secondExpressionCharacter == .Label {
            for (index, currentCharacter) in enumerate(templateSlice) {
                if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                    where currentExpressionCharacter == .End && index > 1 {
                        let (token, remainder) = split(templateSlice, atIndex: index)
                        return (Token.Label(
                            String(token[2 ..< (token.count - 1)])), remainder)
                }
            }
    }

    return nil
}

public func consumeLabel(string: String) -> ConsumeResult? {
    return consumeLabel(Remainder(string))
}

public func consumeFragment(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 4,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0]),
        secondExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[1])
        where firstExpressionCharacter == .Start && secondExpressionCharacter == .Fragment {
            for (index, currentCharacter) in enumerate(templateSlice) {
                if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                    where currentExpressionCharacter == .End && index > 1 {
                        let (token, remainder) = split(templateSlice, atIndex: index)
                        return (Token.Fragment(
                            String(token[2 ..< (token.count - 1)])), remainder)
                }
            }
    }

    return nil
}

public func consumeFragment(string: String) -> ConsumeResult? {
    return consumeFragment(Remainder(string))
}

public func consumeReserved(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 4,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0]),
        secondExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[1])
        where firstExpressionCharacter == .Start && secondExpressionCharacter == .Reserved {
            for (index, currentCharacter) in enumerate(templateSlice) {
                if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                    where currentExpressionCharacter == .End && index > 1 {
                        let (token, remainder) = split(templateSlice, atIndex: index)
                        return (Token.Reserved(
                            String(token[2 ..< (token.count - 1)])), remainder)
                }
            }
    }

    return nil
}

public func consumeReserved(string: String) -> ConsumeResult? {
    return consumeReserved(Remainder(string))
}

public func consumeSimpleString(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count >= 3,
        let firstExpressionCharacter = ExpressionCharacter(rawValue: templateSlice[0])
        where firstExpressionCharacter == .Start &&
            (templateSlice.count >= 4 || ExpressionCharacter(rawValue: templateSlice[1]) == nil) {
                for (index, currentCharacter) in enumerate(templateSlice) {
                    if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
                        where currentExpressionCharacter == .End && index > 1 {
                            let (token, remainder) = split(templateSlice, atIndex: index)
                            return (Token.SimpleString(String(token[1 ..< (token.count - 1)])), remainder)
                    }
                }
    }

    return nil
}

public func consumeSimpleString(string: String) -> ConsumeResult? {
    return consumeSimpleString(Remainder(string))
}

public func consumeLiteral(templateSlice: ArraySlice<Character>) -> ConsumeResult? {
    if templateSlice.count <= 0 {
        return nil
    }

    for (index, currentCharacter) in enumerate(templateSlice) {
        if let currentExpressionCharacter = ExpressionCharacter(rawValue: currentCharacter)
            where currentExpressionCharacter == .Start {
                if consumeSimpleString(templateSlice[index..<templateSlice.count]) != nil {
                    let (token, remainder) = split(templateSlice, atIndex: index - 1)
                    return (Token.Literal(String(token)), remainder)
                }
        }
    }

    return (Token.Literal(String(templateSlice)), ArraySlice(""))
}

public func consumeLiteral(string: String) -> ConsumeResult? {
    return consumeLiteral(ArraySlice<Character>(string))
}

public func consumeToken(templateSlice: ArraySlice<Character>) -> (Token, Remainder)? {
    if let result = consumeFragment(templateSlice) {
        return result
    }
    else if let result = consumeReserved(templateSlice) {
        return result
    }
    else if let result = consumeSimpleString(templateSlice) {
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
