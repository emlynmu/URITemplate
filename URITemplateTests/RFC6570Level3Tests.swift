//
//  RFC6570Level3Tests.swift
//  URITemplate
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
import URITemplate

class RFC6570Level3ExampleTests: XCTestCase {
    var values: URITemplateValues!

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

    func testMultipleVariableURITemplate1() {
        let template = URITemplate("map?{x,y}")
        let expected = "map?1024,768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleVariableURITemplate2() {
        let template = URITemplate("{x,hello,y}")
        let expected = "1024,Hello%20World%21,768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedMultipleVariablesURITemplate1() {
        let template = URITemplate("{+x,hello,y}")
        let expected = "1024,Hello%20World!,768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedMultipleVariablesURITemplate2() {
        let template = URITemplate("{+path,x}/here")
        let expected = "/foo/bar,1024/here"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentMultipleVariablesURITemplate1() {
        let template = URITemplate("{#x,hello,y}")
        let expected = "#1024,Hello%20World!,768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentMultipleVariablesURITemplate2() {
        let template = URITemplate("{#x,hello,y}")
        let expected = "#1024,Hello%20World!,768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelURITemplate1() {
        let template = URITemplate("X{.var}")
        let expected = "X.value"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelURITemplate2() {
        let template = URITemplate("X{.x,y}")
        let expected = "X.1024.768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegments1() {
        let template = URITemplate("{/var}")
        let expected = "/value"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegments2() {
        let template = URITemplate("{/var,x}/here")
        let expected = "/value/1024/here"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParameters1() {
        let template = URITemplate("{;x,y}")
        let expected = ";x=1024;y=768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParameters2() {
        let template = URITemplate("{;x,y,empty}")
        let expected = ";x=1024;y=768;empty"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated1() {
        let template = URITemplate("{?x,y}")
        let expected = "?x=1024&y=768"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated2() {
        let template = URITemplate("{?x,y,empty}")
        let expected = "?x=1024&y=768&empty="
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation1() {
        let template = URITemplate("?fixed=yes{&x}")
        let expected = "?fixed=yes&x=1024"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation2() {
        let template = URITemplate("{&x,y,empty}")
        let expected = "&x=1024&y=768&empty="
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
