//
//  Subplate.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/7/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public typealias SubplateValues = [NSObject : AnyObject]

public protocol SubplateExpandable {
    func expand(values: SubplateValues) -> String
}

public struct Subplate: SubplateExpandable {
    private let tokens: [Token]

    public init(_ value: Printable) {
        tokens = tokenize(value.description)
    }

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    public func expand(values: SubplateValues) -> String {
        return join("", tokens.map({ $0.expand(values) }))
    }
}
