//
//  CharacterEncoding.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum CharacterClass: String {
    case Unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    case Reserved = ":/?#[]@!$&'()*+,;="

    func contains(unicodeScaler: UnicodeScalar) -> Bool {
        return rawValue.unicodeScalars.indexOf(unicodeScaler) != nil
    }
}

public func percentEncodeUnicodeScalar(scalar: UnicodeScalar) -> String {
    return "%" + String(scalar.value, radix: 16, uppercase: true)
}

public func percentEncodeString(string: String,
    allowCharacters allowed: [CharacterClass]) -> String {
        return string.unicodeScalars.map({ (scalar) -> String in
            return allowed.reduce(false, combine: { (result, characterClass) in
                result ||
                    characterClass.contains(scalar) } ) ?
                    String(scalar) : percentEncodeUnicodeScalar(scalar)
        }).reduce("", combine: { $0 + $1 })
}
