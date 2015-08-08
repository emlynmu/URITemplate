//
//  CharacterEncodingTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplates

class CharacterEncodingTests: XCTestCase {
    // MARK: - percentEncodeUnicodeScalar

    func testPercentEncodeSpace() {
        let scalar = characterToUnicodeScalar(" ")
        let expected = "%20"
        let result = percentEncodeUnicodeScalar(scalar)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeAtSymbol() {
        let scalar = characterToUnicodeScalar("@")
        let expected = "%40"
        let result = percentEncodeUnicodeScalar(scalar)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeSemicolon() {
        let scalar = characterToUnicodeScalar(";")
        let expected = "%3B"
        let result = percentEncodeUnicodeScalar(scalar)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeLowercaseJ() {
        let scalar = characterToUnicodeScalar("j")
        let expected = "%6A"
        let result = percentEncodeUnicodeScalar(scalar)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeLessThanSymbol() {
        let scalar = characterToUnicodeScalar("<")
        let expected = "%3C"
        let result = percentEncodeUnicodeScalar(scalar)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - percentEncodeString

    func testPercentEncodeHelloWorld() {
        let string = "Hello World!"
        let expected = "Hello%20World%21"
        let result = percentEncodeString(string, allowCharacters: .Unreserved)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeAllowUppercase() {
        let string = "AaBbCcDd"
        let expected = "A%61B%62C%63D%64"
        let result = percentEncodeString(string, allowCharacters: .Uppercase)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodeAllowLowercase() {
        let string = "AaBbCcDd"
        let expected = "%41a%42b%43c%44d"
        let result = percentEncodeString(string, allowCharacters: .Lowercase)

        XCTAssert(expected == result,
            "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Data Utilities

    func characterToUnicodeScalar(character: Character) -> UnicodeScalar {
        let string = String(character)
        let scalars = string.unicodeScalars
        return scalars[scalars.startIndex]
    }
}
