//
//  RFC6570Examples.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/17/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//  All of the examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import Subplate

class RFC6570Examples: XCTestCase {
    func testUserName() {
        let subplate = Subplate("http://example.com/~{username}/")

        let expectedFred = "http://example.com/~fred/"
        let resultFred = subplate.expand([
            "username": "fred"
            ])

        XCTAssert(expectedFred == resultFred, "expected \"\(expectedFred)\"; got \"\(resultFred)\"")

        let expectedMark = "http://example.com/~mark/"
        let resultMark = subplate.expand([
            "username": "mark"
            ])

        XCTAssert(expectedMark == resultMark, "expected \"\(expectedMark)\"; got \"\(resultMark)\"")
    }

    func testDictionary() {
        let subplate = Subplate("http://example.com/dictionary/{term:1}/{term}")

        let expectedCat = "http://example.com/dictionary/c/cat"
        let resultCat = subplate.expand(["term": "cat"])

        XCTAssert(expectedCat == resultCat, "expected \"\(expectedCat)\"; got \"\(resultCat)\"")

        let expectedDog = "http://example.com/dictionary/d/dog"
        let resultDog = subplate.expand(["term": "dog"])

        XCTAssert(expectedDog == resultDog, "expected \"\(expectedDog)\"; got \"\(resultDog)\"")
    }

    func testFirst() {
        let subplate = Subplate("http://www.example.com/foo{?query,number}")
        let expected = "http://www.example.com/foo?query=mycelium&number=100"

        let result = subplate.expand([
            "query": "mycelium",
            "number": 100
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
