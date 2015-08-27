//
//  VariableSpecifier.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/25/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public struct VariableSpecifier: DebugPrintable {
    public let name: String
    public let valueModifier: ValueModifier?

    public init(name: String, valueModifier: ValueModifier?) {
        self.name = name
        self.valueModifier = valueModifier
    }

    public var debugDescription: String {
        if let modifier = valueModifier {
            return name + "(" + modifier.debugDescription + ")"
        }
        else {
            return name
        }
    }
}
