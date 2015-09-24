//
//  RFC6570OverviewTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/24/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Overview examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import URITemplate

class RFC6570OverviewTests: XCTestCase {
    func testPersonalWebSpacesExample() {
        let template = URITemplate(string: "http://example.com/~{username}/")

        let values1 = [ "username": "fred" ]
        let expected1 = "http://example.com/~fred/"
        let result1 = template.expand(values1)

        XCTAssert(expected1 == result1, "expected \"\(expected1)\"; got \"\(result1)\"")

        let values2 = [ "username": "mark" ]
        let expected2 = "http://example.com/~mark/"
        let result2 = template.expand(values2)

        XCTAssert(expected2 == result2, "expected \"\(expected2)\"; got \"\(result2)\"")
    }

    func testDictionaryExample() {
        let template = URITemplate(string: "http://example.com/dictionary/{term:1}/{term}")

        let values1 = ["term": "cat"]
        let expected1 = "http://example.com/dictionary/c/cat"
        let result1 = template.expand(values1)

        XCTAssert(expected1 == result1, "expected \"\(expected1)\"; got \"\(result1)\"")

        let values2 = ["term": "dog"]
        let expected2 = "http://example.com/dictionary/d/dog"
        let result2 = template.expand(values2)

        XCTAssert(expected2 == result2, "expected \"\(expected2)\"; got \"\(result2)\"")
    }

    func testSearchExample() {
        let template = URITemplate(string: "http://example.com/search{?q,lang}")

        let values1 = ["q": "cat", "lang": "en"]
        let expected1 = "http://example.com/search?q=cat&lang=en"
        let result1 = template.expand(values1)

        XCTAssert(expected1 == result1, "expected \"\(expected1)\"; got \"\(result1)\"")

        let values2 = ["q": "chien", "lang": "fr"]
        let expected2 = "http://example.com/search?q=chien&lang=fr"
        let result2 = template.expand(values2)

        XCTAssert(expected2 == result2, "expected \"\(expected2)\"; got \"\(result2)\"")
    }

    func testFormStyleFormStyleParameterExample() {
        let template = URITemplate(string: "http://www.example.com/foo{?query,number}")
        let expected = "http://www.example.com/foo?query=mycelium&number=100"

        let values = [
            "query": "mycelium",
            "number": 100
        ]

        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
