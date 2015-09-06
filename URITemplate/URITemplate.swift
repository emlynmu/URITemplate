//
//  URITemplate.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/7/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias URITemplateValues = [NSObject : AnyObject]

public protocol URITemplateExpandable {
    func expand(values: URITemplateValues) -> String
}

public struct URITemplate: URITemplateExpandable {
    private let tokens: [Token]

    public init(_ value: Printable) {
        tokens = tokenize(value.description)
    }

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    public func expand(values: URITemplateValues) -> String {
        return join("", tokens.map({ $0.expand(values) }))
    }
}
