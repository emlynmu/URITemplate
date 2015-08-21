//
//  RFC6570Level3Tests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/21/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 3examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import Subplate

class RFC6570Level3Tests: XCTestCase {
    var values: [String : String]!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!",
            "empty": "",
            "path": "/foo/bar",
            "x": "1024",
            "y": "768"
        ]
    }

    func testMultipleVariableSubplate1() {
        let subplate = Subplate("map?{x,y}")
        let expected = "map?1024,768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleVariableSubplate2() {
        let subplate = Subplate("{x,hello,y}")
        let expected = "1024,Hello%20World%21,768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedMultipleVariablesSubplate1() {
        let subplate = Subplate("{+x,hello,y}")
        let expected = "1024,Hello%20World!,768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedMultipleVariablesSubplate2() {
        let subplate = Subplate("{+path,x}/here")
        let expected = "/foo/bar,1024/here"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentMultipleVariablesSubplate1() {
        let subplate = Subplate("{#x,hello,y}")
        let expected = "#1024,Hello%20World!,768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentMultipleVariablesSubplate2() {
        let subplate = Subplate("{#x,hello,y}")
        let expected = "#1024,Hello%20World!,768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
