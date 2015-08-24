//
//  Token.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum Token: DebugPrintable, SubplateExpandable {
    case Literal(String)
    case SimpleString([String])
    case Reserved([String])
    case Fragment([String])
    case Label([String])
    case PathSegment([String])
    case PathStyle([String])
    case FormStyleQuery([String])

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

        case .PathSegment(let value):
            return "path_segment(\"\(value)\")"

        case .PathStyle(let value):
            return "path_style(\"\(value)\")"

        case .FormStyleQuery(let value):
            return "form_style_query(\"\(value)\")"
        }
    }

    private func expandValue(variable: String, values: SubplateValues,
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
        case .Literal(let value):
            return String(value)

        case .SimpleString(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved]) })
            return join(",", values)

        case .Reserved(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return join(",", values)

        case .Fragment(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved]) })
            return "#" + join(",", values)

        case .Label(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved, .Reserved], separator: ".")})
            return "." + join(".", values)

        case .PathSegment(let variables):
            let values = variables.map({ self.expandValue($0, values: values,
                allowCharacters: [.Unreserved], separator: "/")})
            return "/" + join("/", values)

        case .PathStyle(let variables):
            let values = variables.map({
                ";" + $0 + (!self.emptyValue(values[$0]) ? "=" : "") +
                    self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return join("", values)

        case .FormStyleQuery(let variables):
            let values = variables.map({
                $0 + "=" + self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return "?" + join("&", values)
        }
    }
}
