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

    private func prefix(expression: ExpressionType) -> String {
        switch expression {
        case .SimpleString, .Reserved:
            return ""

        case .Fragment:
            return "#"

        case .Label:
            return "."

        case .PathSegment:
            return "/"

        case .PathStyle:
            return ";" + name + "="

        case .FormStyleQuery:
            return "?" + name + "="

        case .FormStyleQueryContinuation:
            return "&" + name + "="
        }
    }

    private func listSeparator(expression: ExpressionType) -> String {
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
                    return ";" + name + "="

                case .FormStyleQuery, .FormStyleQueryContinuation:
                    return "&" + name + "="
                }

            case .Prefix:
                break  // default
            }
        }

        return "," // default
    }

    public func expand(value: AnyObject?, inExpression expression: ExpressionType) -> String {
        if let values = value as? [AnyObject] {
            if values.count > 0 {
                let separator = listSeparator(expression)

                return prefix(expression) + values[1..<values.count].reduce(values[0].description) { (result: String, value: AnyObject) -> String in
                    return result + separator + value.description
                }
            }
            else {
                return ""
            }
        }
        else if let value: AnyObject = value {
            return prefix(expression) + value.description
        }
        else {
            return prefix(expression)
        }
    }
}
