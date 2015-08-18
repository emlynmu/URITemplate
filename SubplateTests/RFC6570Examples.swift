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

    func testExampleSearch() {
        let subplate = Subplate("http://example.com/search{?q,lang}")

        let expectedEnglish = "http://example.com/search?q=cat&lang=en"
        let resultEnglish = subplate.expand(["q": "cat", "lang": "en"])

        let expectedFrench = "http://example.com/search?q=chien&lang=fr"
        let resultFrench = subplate.expand(["q": "chien", "lang": "fr"])
    }

    func testExampleQueryNumber() {
        let subplate = Subplate("http://www.example.com/foo{?query,number}")
        let expected = "http://www.example.com/foo?query=mycelium&number=100"

        let result = subplate.expand([
            "query": "mycelium",
            "number": 100
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testSimpleString() {
        let values = [
            "var": "value",
            "hello": "Hello World!"
        ]

        let subplate1 = Subplate("{var}")
        let result1 = subplate1.expand(values)
        let expected1 = "value"

        XCTAssert(result1 == expected1, "expected \"\(result1)\"; got \"\(result1)\"")

        let subplate2 = Subplate("{hello}")
        let expected2 = "Hello%20World%21"
        let result2 = subplate2.expand(values)

        XCTAssert(result2 == expected2, "expected \"\(result2)\"; got \"\(expected2)\"")
    }
}
