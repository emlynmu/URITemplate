//
//  RFC6570Level2Tests.swift
//  Subplate
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
import Subplate

class RFC6570Level2ExampleTests: XCTestCase {
    var values: SubplateValues!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!",
            "path": "/foo/bar"
        ]
    }

    func testLevel2Examples() {
        let reservedStringSubplate1 = Subplate("{+var}")
        let reservedStringExpected1 = "value"
        let reservedStringResult1 = reservedStringSubplate1.expand(values)

        XCTAssert(reservedStringExpected1 == reservedStringResult1,
            "expected \"\(reservedStringExpected1)\"; got \"\(reservedStringResult1)\"")

        let reservedStringSubplate2 = Subplate("{+hello}")
        let reservedStringExpected2 = "Hello%20World!"
        let reservedStringResult2 = reservedStringSubplate2.expand(values)

        XCTAssert(reservedStringExpected2 == reservedStringResult2,
            "expected \"\(reservedStringExpected2)\"; got \"\(reservedStringResult2)\"")

        let reservedStringSubplate3 = Subplate("{+path}/here")
        let reservedStringExpected3 = "/foo/bar/here"
        let reservedStringResult3 = reservedStringSubplate3.expand(values)

        XCTAssert(reservedStringExpected3 == reservedStringResult3,
            "expected \"\(reservedStringExpected3)\"; got \"\(reservedStringResult3)\"")

        let reservedStringSubplate4 = Subplate("here?ref={+path}")
        let reservedStringExpected4 = "here?ref=/foo/bar"
        let reservedStringResult4 = reservedStringSubplate4.expand(values)

        XCTAssert(reservedStringExpected4 == reservedStringResult4,
            "expected \"\(reservedStringExpected4)\"; got \"\(reservedStringResult4)\"")
    }
}
