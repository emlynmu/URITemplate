//
//  URITemplate.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/7/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias URITemplateValues = [NSObject : AnyObject]

public protocol URITemplateExpandable {
    func expand(values: URITemplateValues) -> String
}

public class URITemplate: NSObject, URITemplateExpandable {
    private let tokens: [Token]

    public init(string: String) {
        tokens = tokenize(string)
    }

    public static func templateWithString(string: String) -> URITemplate {
        return URITemplate(string: string)
    }

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    public func expand(values: URITemplateValues) -> String {
        return tokens.map({ $0.expand(values) }).joinWithSeparator("")
    }
}
