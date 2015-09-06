//
//  ValueModifiers.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/24/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum ValueModifier: DebugPrintable {
    case Prefix(Int)
    case Composite

    public var debugDescription: String {
        switch self {
        case .Prefix(let length):
            return "prefix=\(length)"

        case .Composite:
            return "composite"
        }
    }
}
