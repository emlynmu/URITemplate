//
//  Token.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum Token: DebugPrintable, URITemplateExpandable {
    case Literal(String)
    case SimpleString([String])
    case Reserved([String])
    case Fragment([String])
    case Label([String])
    case Path([String])

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

        case .Path(let value):
            return "path(\"\(value)\")"
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

    public func expand(values: URITemplateValues) -> String {
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

        case .Path(let variables):
            let values = variables.map({
                ";" + $0 + (values[$0] != nil ? "=" : "") +
                    self.expandValue($0, values: values, allowCharacters: [.Unreserved])
            })
            return join("", values)
        }
    }
}
