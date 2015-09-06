//
//  RFC6570Level2Tests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/22/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 2 examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import URITemplate

class RFC6570Level2ExampleTests: XCTestCase {
    var values: URITemplateValues!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!",
            "path": "/foo/bar"
        ]
    }

    func testLevel2Examples() {
        let reservedStringURITemplate1 = URITemplate("{+var}")
        let reservedStringExpected1 = "value"
        let reservedStringResult1 = reservedStringURITemplate1.expand(values)

        XCTAssert(reservedStringExpected1 == reservedStringResult1,
            "expected \"\(reservedStringExpected1)\"; got \"\(reservedStringResult1)\"")

        let reservedStringURITemplate2 = URITemplate("{+hello}")
        let reservedStringExpected2 = "Hello%20World!"
        let reservedStringResult2 = reservedStringURITemplate2.expand(values)

        XCTAssert(reservedStringExpected2 == reservedStringResult2,
            "expected \"\(reservedStringExpected2)\"; got \"\(reservedStringResult2)\"")

        let reservedStringURITemplate3 = URITemplate("{+path}/here")
        let reservedStringExpected3 = "/foo/bar/here"
        let reservedStringResult3 = reservedStringURITemplate3.expand(values)

        XCTAssert(reservedStringExpected3 == reservedStringResult3,
            "expected \"\(reservedStringExpected3)\"; got \"\(reservedStringResult3)\"")

        let reservedStringURITemplate4 = URITemplate("here?ref={+path}")
        let reservedStringExpected4 = "here?ref=/foo/bar"
        let reservedStringResult4 = reservedStringURITemplate4.expand(values)

        XCTAssert(reservedStringExpected4 == reservedStringResult4,
            "expected \"\(reservedStringExpected4)\"; got \"\(reservedStringResult4)\"")
    }
}
