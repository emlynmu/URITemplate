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

    public func expand(values: SubplateValues) -> String {
        return tokens.reduce("") { (result, token) -> String in
            return result + token.expand(values)
        }
    }
}
