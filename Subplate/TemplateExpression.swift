//
//  TemplateExpression.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum TemplateExpression: DebugPrintable {
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

    private func listSeparatorForModifier(modifier: ValueModifier?) -> String {
        if let modifier = modifier {
            switch modifier {
            case .Composite:
                return "="

            default:
                break
            }
        }

        return ","
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

    private func listSeparatorForValueModifier(modifier: ValueModifier?) -> String {
        if let modifier = modifier {
            switch modifier {
            case .Composite:
                switch self {
                case .SimpleString:
                    break

                case .Reserved:
                    break

                case .Fragment:
                    break

                case .Label:
                    return "."

                case .PathSegment:
                    return "/"

                case .PathStyle:
                    return ";"

                case .FormStyleQuery:
                    break

                case .FormStyleQueryContinuation:
                    break
                }

            default:
                break
            }
        }

        return ","
    }

    private func definedVariableSpecifiers(variableSpecifiers: [VariableSpecifier],
        values: SubplateValues, allowEmpty: Bool = false) -> [VariableSpecifier] {
            return variableSpecifiers.filter { variableSpecifier -> Bool in
                if let value: AnyObject = values[variableSpecifier.name]
                    where allowEmpty || !allowEmpty && count(value.description) > 0 {
                        return true
                }

                return false
            }
    }

    public func expand(values: SubplateValues) -> String {
        switch self {
        case .SimpleString(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return join(",", values)

        case .Reserved(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return join(",", values)

        case .Fragment(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return (definedSpecifiers.count > 0 ? "#" : "") + join(",", values)

        case .Label(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values,
                allowEmpty: true)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return (definedSpecifiers.count > 0 ? "." : "") + join(".", values)

        case .PathSegment(let variableSpecifiers):
            let values = variableSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return "/" + join("/", values)

        case .PathStyle(let variableSpecifiers):
            let values = variableSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return ";" + join(";", values)

        case .FormStyleQuery(let variableSpecifiers):
            let values = variableSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }
            
            return "?" + join("&", values)
            
        case .FormStyleQueryContinuation(let variableSpecifiers):
            let values = variableSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }
            
            return "&" + join("&", values)
        }
    }
}
