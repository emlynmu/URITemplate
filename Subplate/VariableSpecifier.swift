//
//  VariableSpecifier.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/25/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

struct VariableSpecifier {
    let name: String
    let valueModifier: ValueModifier?

    init(name: String, valueModifier: ValueModifier?) {
        self.name = name
        self.valueModifier = valueModifier
    }
}
