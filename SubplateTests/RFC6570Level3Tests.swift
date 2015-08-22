//
//  RFC6570Level3Tests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/21/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 3 examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import Subplate

class RFC6570Level3ExampleTests: XCTestCase {
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

    func testLabelSubplate1() {
        let subplate = Subplate("X{.var}")
        let expected = "X.value"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelSubplate2() {
        let subplate = Subplate("X{.x,y}")
        let expected = "X.1024.768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegments1() {
        let subplate = Subplate("{/var}")
        let expected = "/value"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegments2() {
        let subplate = Subplate("{/var,x}/here")
        let expected = "/value/1024/here"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParameters1() {
        let subplate = Subplate("{;x,y}")
        let expected = ";x=1024;y=768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParameters2() {
        let subplate = Subplate("{;x,y,empty}")
        let expected = ";x=1024;y=768;empty"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated1() {
        let subplate = Subplate("{?x,y}")
        let expected = "?x=1024&y=768"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated2() {
        let subplate = Subplate("{?x,y,empty}")
        let expected = "?x=1024&y=768&empty="
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation1() {
        let subplate = Subplate("?fixed=yes{&x}")
        let expected = "?fixed=yes&x=1024"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation2() {
        let subplate = Subplate("{&x,y,empty}")
        let expected = "&x=1024&y=768&empty="
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
