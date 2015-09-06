//
//  RFC6570Level1Tests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/17/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 1 examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import URITemplate

class RFC6570Level1Tests: XCTestCase {
    var values: URITemplateValues!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!"
        ]
    }

    func testSimpleStringExpansion1() {
        let template = URITemplate("{var}")
        let expected = "value"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testSimpleStringExpansion2() {
        let template = URITemplate("{hello}")
        let expected = "Hello%20World%21"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
