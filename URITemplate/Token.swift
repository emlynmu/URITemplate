//
//  Token.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum Token: CustomDebugStringConvertible, URITemplateExpandable {
    case Literal(String)
    case Expression(TemplateExpression)

    public func expand(values: URITemplateValues) -> String {
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
