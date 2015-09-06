//
//  TemplateExpression.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum TemplateExpression: DebugPrintable, URITemplateExpandable {
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

    private func objectIsEmptyString(value: AnyObject) -> Bool {
        if let string = value as? String where count(string) == 0 {
            return true
        }

        return false
    }

    private func objectIsEmptyList(value: AnyObject) -> Bool {
        if let list = value as? [AnyObject] {
            if count(list) == 0 {
                return true
            }
        }

        return false
    }

    private func objectIsListOfKeyValuePairs(value: AnyObject?) -> Bool {
        if let keyValuePairs = value as? [[AnyObject]] {
            return true
        }

        return false
    }

    private func emptyValue(value: AnyObject?) -> Bool {
        return value == nil || objectIsEmptyString(value!) || objectIsEmptyList(value!)
    }

    private func definedVariableSpecifiers(variableSpecifiers: [VariableSpecifier],
        values: URITemplateValues, allowEmpty: Bool = false) -> [VariableSpecifier] {
            return variableSpecifiers.filter { variableSpecifier -> Bool in
                if let value: AnyObject = values[variableSpecifier.name] {
                    if allowEmpty {
                        return true
                    }
                    else if let values = value as? [AnyObject] {
                        if let modifier = variableSpecifier.valueModifier {
                            switch modifier {
                            case .Composite:
                                if let keyValuePairs = values as? [[AnyObject]] {
                                    for pair in keyValuePairs {
                                        if count(keyValuePairs) >= 2 {
                                            return true
                                        }
                                    }
                                }

                            default:
                                break
                            }
                        }

                        if values.count > 1 {
                            return true
                        }
                    }
                    else if count(value.description) > 0 {
                        return true
                    }
                }

                return false
            }
    }

    public func expand(values: URITemplateValues) -> String {
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
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values,
                allowEmpty: true)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                return variableSpecifier.expand(values[variableSpecifier.name],
                    inExpression: self)
            }

            return (definedSpecifiers.count > 0 ? "/" : "") + join("/", values)

        case .PathStyle(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values,
                allowEmpty: true)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                let value: AnyObject? = values[variableSpecifier.name]

                if self.emptyValue(value) {
                    return ";" + variableSpecifier.name
                }

                let prefix = ";" + (self.objectIsListOfKeyValuePairs(value) &&
                    variableSpecifier.hasExplodeModifier ? "" : variableSpecifier.name + "=")

                return prefix + variableSpecifier.expand(value, inExpression: self)
            }

            return join("", values)

        case .FormStyleQuery(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values,
                allowEmpty: true)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                let value: AnyObject? = values[variableSpecifier.name]

                if self.emptyValue(value) {
                    return variableSpecifier.name + "="
                }

                let prefix = (self.objectIsListOfKeyValuePairs(value) &&
                    variableSpecifier.hasExplodeModifier ? "" : variableSpecifier.name + "=")

                return prefix + variableSpecifier.expand(value, inExpression: self)
            }
            
            return (definedSpecifiers.count > 0 ? "?" : "") + join("&", values)
            
        case .FormStyleQueryContinuation(let variableSpecifiers):
            let definedSpecifiers = definedVariableSpecifiers(variableSpecifiers, values: values,
                allowEmpty: true)

            let values = definedSpecifiers.map { variableSpecifier -> String in
                let value: AnyObject? = values[variableSpecifier.name]

                if self.emptyValue(value) {
                    return variableSpecifier.name + "="
                }

                let prefix = (self.objectIsListOfKeyValuePairs(value) &&
                    variableSpecifier.hasExplodeModifier ? "" : variableSpecifier.name + "=")

                return prefix + variableSpecifier.expand(value, inExpression: self)
            }

            return (definedSpecifiers.count > 0 ? "&" : "") + join("&", values)
        }
    }
}
