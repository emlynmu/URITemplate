//
//  Token.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum ExpressionType: DebugPrintable {
    case SimpleString([VariableSpecifier])
    case Reserved([VariableSpecifier])
    case Fragment([VariableSpecifier])
    case Label([VariableSpecifier])
    case PathSegment([VariableSpecifier])
    case PathStyle([VariableSpecifier])
    case FormStyleQuery([VariableSpecifier])
    case FormStyleQueryContinuation([VariableSpecifier])

    public var debugDescription: String {
        switch self {
        case .SimpleString(let variableSpecifier):
            return "simple_string(\"\(variableSpecifier)\")"

        case .Reserved(let variableSpecifier):
            return "reserved(\"\(variableSpecifier)\")"

        case .Fragment(let variableSpecifier):
            return "fragment(\"\(variableSpecifier)\")"

        case .Label(let variableSpecifier):
            return "label(\"\(variableSpecifier)\")"

        case .PathSegment(let variableSpecifier):
            return "path_segment(\"\(variableSpecifier)\")"

        case .PathStyle(let variableSpecifier):
            return "path_style(\"\(variableSpecifier)\")"

        case .FormStyleQuery(let variableSpecifier):
            return "form_style_query(\"\(variableSpecifier)\")"

        case .FormStyleQueryContinuation(let variableSpecifier):
            return "form_style_query_continuation(\"\(variableSpecifier)\")"
        }
    }

    private func applyModifierIfAny(modifier: ValueModifier?, toValue value: String) -> String {
        if let modifier = modifier {
            return modifier.applyToValue(value)
        }
        else {
            return value
        }
    }

    private func expandValue(variable: VariableSpecifier, values: SubplateValues,
        allowCharacters: [CharacterClass], separator: String = ",") -> String {
            if let values = values[variable.name] as? [AnyObject] {
                return join(separator, map(values, {
                    percentEncodeString(self.applyModifierIfAny(variable.valueModifier, toValue: $0.description ?? ""),
                    allowCharacters: allowCharacters) }))
            }
            else {
                return percentEncodeString(self.applyModifierIfAny(variable.valueModifier, toValue: values[variable.name]?.description ?? ""),
                    allowCharacters: allowCharacters)
            }
    }

    private func objectIsEmptyString(value: AnyObject) -> Bool {
        if let string = value as? String where count(string) == 0 {
            return true
        }

        return false
    }

    private func emptyValue(value: AnyObject?) -> Bool {
        return value == nil || objectIsEmptyString(value!)
    }

    public func expand(values: SubplateValues) -> String {
        switch self {
        case .SimpleString(let variableSpecifiers):
            let values = variableSpecifiers.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved]) })
            return join(",", values)

        case .Reserved(let variableSpecifiers):
            let values = variableSpecifiers.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return join(",", values)

        case .Fragment(let variableSpecifiers):
            let values = variableSpecifiers.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return "#" + join(",", values)

        case .Label(let variableSpecifiers):
            let values = variableSpecifiers.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved], separator: ".")})
            return "." + join(".", values)

        case .PathSegment(let variableSpecifiers):
            let values = variableSpecifiers.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved], separator: "/")})
            return "/" + join("/", values)

        case .PathStyle(let variableSpecifiers):
            let values = variableSpecifiers.map({
                ";" + $0.name + (!self.emptyValue(values[$0.name]) ? "=" : "") +
                    self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return join("", values)

        case .FormStyleQuery(let variableSpecifiers):
            let values = variableSpecifiers.map({
                $0.name + "=" + self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return "?" + join("&", values)

        case .FormStyleQueryContinuation(let variableSpecifiers):
            let values = variableSpecifiers.map({
                $0.name + "=" + self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return "&" + join("&", values)
        }
    }
}

public enum Token: DebugPrintable, SubplateExpandable {
    case Literal(String)
    case Expression(ExpressionType)

    public func expand(values: SubplateValues) -> String {
        switch self {
        case .Literal(let value):
            return value

        case .Expression(let expression):
            return expression.expand(values)
        }
    }


    public var debugDescription: String {
        switch self {
        case .Literal(let value):
            return "literal(\"\(value)\")"

        case .Expression(let expression):
            return expression.debugDescription
        }
    }
}
