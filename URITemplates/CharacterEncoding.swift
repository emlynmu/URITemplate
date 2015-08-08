//
//  CharacterEncoding.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

public enum CharacterClass: String {
    case Uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case Lowercase = "abcdefghijklmnopqrstuvwxyz"
    case Alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    case Digit = "0123456789"
    case HexDigit = "0123456789ABCDEFabcdef"
    case GeneralDelimeter = ":/?#[]@"
    case SubDelimeter = "!$&'()*+,;="
    case Unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    case Reserved = ":/?#[]@!$&'()*+,;="

    func contains(unicodeScaler: UnicodeScalar) -> Bool {
        return find(rawValue.unicodeScalars, unicodeScaler) != nil
    }
}

public func percentEncodeUnicodeScalar(scalar: UnicodeScalar) -> String {
    return "%" + String(scalar.value, radix: 16, uppercase: true)
}

public func percentEncodeString(string: String, allowCharacters allowed: CharacterClass) -> String {
    return map(string.unicodeScalars, {
        allowed.contains($0) ? String($0) : percentEncodeUnicodeScalar($0)
    }).reduce("", combine: { $0 + $1 })
}
