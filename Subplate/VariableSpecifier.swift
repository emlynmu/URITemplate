//
//  VariableSpecifier.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/25/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public struct VariableSpecifier: DebugPrintable {
    public let name: String
    public let valueModifier: ValueModifier?

    public init(name: String, valueModifier: ValueModifier?) {
        self.name = name
        self.valueModifier = valueModifier
    }

    public var debugDescription: String {
        if let modifier = valueModifier {
            return name + "(" + modifier.debugDescription + ")"
        }
        else {
            return name
        }
    }

    private func prefix(expression: TemplateExpression, hasValue: Bool) -> String {
        switch expression {
        case .SimpleString, .Reserved:
            return ""

        case .Fragment:
            return ""

        case .Label:
            return ""

        case .PathSegment:
            return ""

        case .PathStyle:
            return name + (hasValue ? "=" : "")

        case .FormStyleQuery:
            return name + "="

        case .FormStyleQueryContinuation:
            return name + "="
        }
    }

    private func listSeparator(expression: TemplateExpression) -> String {
        if let modifier = valueModifier {
            switch modifier {
            case .Composite:
                switch expression {
                case .SimpleString, .Reserved, .Fragment:
                    break // default

                case .Label:
                    return "."

                case .PathSegment:
                    return "/"

                case .PathStyle:
                    return ";" + name

                case .FormStyleQuery, .FormStyleQueryContinuation:
                    return "&" + name + "="
                }

            case .Prefix:
                break  // default
            }
        }

        return "," // default
    }

    private func allowedCharactersForExpression(expression: TemplateExpression) -> [CharacterClass] {
        switch expression {
        case .Reserved, .Fragment:
            return [.Reserved, .Unreserved]

        default:
            return [.Unreserved]
        }
    }

    private func expandValue(value: AnyObject, inExpression expression: TemplateExpression) -> String {
        let modifiedValue: String

        if let modifier = valueModifier {
            switch modifier {
            case .Prefix(let length):
                let valueString = value.description
                let startIndex = valueString.startIndex
                let endIndex = advance(startIndex, min(length, count(valueString)))
                modifiedValue = valueString[startIndex ..< endIndex]

            default:
                modifiedValue = value.description
            }
        }
        else {
            modifiedValue = value.description
        }

        return percentEncodeString(modifiedValue,
            allowCharacters: allowedCharactersForExpression(expression))
    }

    public func expand(value: AnyObject?, inExpression expression: TemplateExpression) -> String {
        if let values = value as? [AnyObject] {
            if values.count > 0 {
                let separator = listSeparator(expression)

                return values[1..<values.count].reduce(expandValue(values[0],
                    inExpression: expression)) {
                    (result: String, value: AnyObject) -> String in

                        return prefix(expression, hasValue: true) + result + separator +
                            expandValue(value, inExpression: expression)
                }
            }
            else {
                return prefix(expression, hasValue: false)
            }
        }
        else if let value: AnyObject = value {
            return prefix(expression, hasValue: count(value.description) > 0) +
                expandValue(value, inExpression: expression)
        }
        else {
            return prefix(expression, hasValue: false)
        }
    }
}
