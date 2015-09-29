//
//  CharacterEncodingTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplate

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

    func testPercentEncodeLessThanSymbol() {
        let scalar = characterToUnicodeScalar("<")
        let expected = "%3C"
        let result = percentEncodeUnicodeScalar(scalar)

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
