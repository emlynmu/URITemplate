//
//  ExpressionCharacters.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/13/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

enum ExpressionBoundary: Character {
    case Start = "{"
    case End = "}"
}

enum ExpressionOperator: Character {
    case Reserved = "+"
    case Fragment = "#"
    case Label = "."
}