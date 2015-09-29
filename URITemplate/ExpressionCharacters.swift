//
//  ExpressionCharacters.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/13/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
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
    case PathSegment = "/"
    case PathStyle = ";"
    case FormStyleQuery = "?"
    case FormStyleQueryContinuation = "&"
}
