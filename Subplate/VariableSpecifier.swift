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

    var hasExplodeModifier: Bool {
        if let valueModifier = valueModifier {
            switch valueModifier {
            case .Composite:
                return true

            default:
                break
            }
        }

        return false
    }

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

    private func listSeparator(expression: TemplateExpression, keyValuePairs: Bool) -> String {
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
                    return ";" + (keyValuePairs ? "" : name + "=")

                case .FormStyleQuery, .FormStyleQueryContinuation:
                    return "&" + (keyValuePairs ? "" : name + "=")
                }

            case .Prefix:
                break  // default
            }
        }
        else {
            switch expression {
            case .PathStyle:
                return "," + (keyValuePairs ? name + "=" : "")

            default:
                break
            }
        }

        return "," // default
    }

    private func keyValueSeparator(expression: TemplateExpression, explodeModifier: Bool) -> String {
        if explodeModifier {
            switch expression {
            case .SimpleString:
                return "="

            case .Reserved:
                return "="

            case .Fragment:
                return "="

            case .Label:
                return "="

            case .PathSegment:
                return "="

            case .PathStyle:
                return "="
                
            case .FormStyleQuery:
                return "="
                
            case .FormStyleQueryContinuation:
                return "="
            }
        }
        else {
            switch expression {
            case .SimpleString:
                return ","

            case .Reserved:
                return ","

            case .Fragment:
                return ","

            case .Label:
                return ","

            case .PathSegment:
                return ","

            case .PathStyle:
                return ","
                
            case .FormStyleQuery:
                return ","
                
            case .FormStyleQueryContinuation:
                return ","
            }
        }
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

    private func extractKeyValuePairs(keyValuePairs: [[AnyObject]]) -> [(String, String)] {
        return keyValuePairs.filter({ count($0) >= 2 }).map({ ($0[0].description, $0[1].description) })
    }

    private func explodeKeyValuePairs(keyValuePairs: [[AnyObject]], inExpression expression: TemplateExpression) -> String {
        let separator = listSeparator(expression, keyValuePairs: true)

        return separator.join(extractKeyValuePairs(keyValuePairs).map({
            return ($0.0 ?? "") + self.keyValueSeparator(expression, explodeModifier: true) +
                percentEncodeString($0.1 ?? "",
                    allowCharacters: self.allowedCharactersForExpression(expression))
        }))
    }

    private func flattenKeyValuePairs(keyValuePairs: [[AnyObject]], inExpression expression: TemplateExpression) -> String {
        return ",".join(extractKeyValuePairs(keyValuePairs).map({
            return $0.0 + self.keyValueSeparator(expression, explodeModifier: false) +
                percentEncodeString($0.1 ?? "",
                    allowCharacters: self.allowedCharactersForExpression(expression))
        }))
    }

    public func expand(value: AnyObject?, inExpression expression: TemplateExpression) -> String {
        if let values = value as? [[AnyObject]] {
            if let modifier = valueModifier {
                switch modifier {
                case .Composite:
                    return explodeKeyValuePairs(values, inExpression: expression)

                default:
                    break // flatten
                }
            }

            return flattenKeyValuePairs(values, inExpression: expression)
        }
        else if let values = value as? [AnyObject] {
            if values.count > 0 {
                let separator = listSeparator(expression, keyValuePairs: false)

                return values[1..<values.count].reduce(expandValue(values[0],
                    inExpression: expression)) {
                    (result: String, value: AnyObject) -> String in
                        return result + separator + expandValue(value, inExpression: expression)
                }
            }
            else {
                return ""
            }
        }
        else if let value: AnyObject = value {
            return expandValue(value, inExpression: expression)
        }
        else {
            return ""
        }
    }
}
