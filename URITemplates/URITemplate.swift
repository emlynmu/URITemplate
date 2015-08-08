//
//  URITemplate.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/7/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias URITemplateValues = [String : String]

enum ExpressionCharacter: Character {
    case Start = "{"
    case End = "}"
    case Reserved = "+"
    case Fragment = "#"
}

public protocol URITemplateExpandable {
    func expand(values: URITemplateValues) -> String
}

public struct URITemplate: URITemplateExpandable {
    private let tokens: [Token]

    public init(string: String) {
        tokens = tokenize(string)
    }

    public func expand(values: URITemplateValues) -> String {
        return tokens.reduce("") { (result, token) -> String in
            return result + token.expand(values)
        }
    }
}
