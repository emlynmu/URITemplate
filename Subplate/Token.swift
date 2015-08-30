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
    case Expression(TemplateExpression)

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
