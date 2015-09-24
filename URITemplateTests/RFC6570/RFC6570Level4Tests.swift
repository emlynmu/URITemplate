//
//  RFC6570Level4Tests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/22/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 4 examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

import UIKit
import XCTest
import URITemplate

class RFC6570Level4Tests: XCTestCase {
    var values: URITemplateValues!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!",
            "path": "/foo/bar",
            "list": ["red", "green", "blue"],
            "keys": [
                ["semi", ";"],
                ["dot", "."],
                ["comma", ","]
            ]
        ]
    }

    // MARK: - String expansion with value modifiers

    func testStringExpansionWithValueModifiers1() {
        let template = URITemplate(string: "{var:3}")
        let expected = "val"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers2() {
        let template = URITemplate(string: "{var:30}")
        let expected = "value"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers3() {
        let template = URITemplate(string: "{list}")
        let expected = "red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers4() {
        let template = URITemplate(string: "{list*}")
        let expected = "red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers5() {
        let template = URITemplate(string: "{keys}")
        let expected = "semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers6() {
        let template = URITemplate(string: "{keys*}")
        let expected = "semi=%3B,dot=.,comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Reserved expansion with value modifiers

    func testReservedExpansionWithValueModifiers1() {
        let template = URITemplate(string: "{+path:6}/here")
        let expected = "/foo/b/here"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers2() {
        let template = URITemplate(string: "{+list}")
        let expected = "red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers3() {
        let template = URITemplate(string: "{+list*}")
        let expected = "red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers4() {
        let template = URITemplate(string: "{+keys}")
        let expected = "semi,;,dot,.,comma,,"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers5() {
        let template = URITemplate(string: "{+keys*}")
        let expected = "semi=;,dot=.,comma=,"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Fragment expansion with value modifiers

    func testFragmentExpansionWithValueModifiers1() {
        let template = URITemplate(string: "{#path:6}/here")
        let expected = "#/foo/b/here"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers2() {
        let template = URITemplate(string: "{#list}")
        let expected = "#red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers3() {
        let template = URITemplate(string: "{#list*}")
        let expected = "#red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers4() {
        let template = URITemplate(string: "{#keys}")
        let expected = "#semi,;,dot,.,comma,,"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers5() {
        let template = URITemplate(string: "{#keys*}")
        let expected = "#semi=;,dot=.,comma=,"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Label expansion, dot-prefixed

    func testLabelExpansionDotPrefixed1() {
        let template = URITemplate(string: "X{.var:3}")
        let expected = "X.val"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed2() {
        let template = URITemplate(string: "X{.list}")
        let expected = "X.red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed3() {
        let template = URITemplate(string: "X{.list*}")
        let expected = "X.red.green.blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed4() {
        let template = URITemplate(string: "X{.keys}")
        let expected = "X.semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed5() {
        let template = URITemplate(string: "X{.keys*}")
        let expected = "X.semi=%3B.dot=..comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Path segments, slash-prefixed

    func testPathSegmentsSlashPrefixed1() {
        let template = URITemplate(string: "{/var:1,var}")
        let expected = "/v/value"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed2() {
        let template = URITemplate(string: "{/list}")
        let expected = "/red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed3() {
        let template = URITemplate(string: "{/list*}")
        let expected = "/red/green/blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed4() {
        let template = URITemplate(string: "{/list*,path:4}")
        let expected = "/red/green/blue/%2Ffoo"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed5() {
        let template = URITemplate(string: "{/keys}")
        let expected = "/semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed6() {
        let template = URITemplate(string: "{/keys*}")
        let expected = "/semi=%3B/dot=./comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Path-style parameters, semicolon-prefixed

    func testPathStyleParametersSemicolonPrefixed1() {
        let template = URITemplate(string: "{;hello:5}")
        let expected = ";hello=Hello"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed2() {
        let template = URITemplate(string: "{;list}")
        let expected = ";list=red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed3() {
        let template = URITemplate(string: "{;list*}")
        let expected = ";list=red;list=green;list=blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed4() {
        let template = URITemplate(string: "{;keys}")
        let expected = ";keys=semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed5() {
        let template = URITemplate(string: "{;keys*}")
        let expected = ";semi=%3B;dot=.;comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Form-style query, ampersand-separated

    func testFormStyleQueryAmpersandSeparated1() {
        let template = URITemplate(string: "{?var:3}")
        let expected = "?var=val"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated2() {
        let template = URITemplate(string: "{?list}")
        let expected = "?list=red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated3() {
        let template = URITemplate(string: "{?list*}")
        let expected = "?list=red&list=green&list=blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated4() {
        let template = URITemplate(string: "{?keys}")
        let expected = "?keys=semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated5() {
        let template = URITemplate(string: "{?keys*}")
        let expected = "?semi=%3B&dot=.&comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Form-style query continuation

    func testFormStyleQueryContinuation1() {
        let template = URITemplate(string: "{&var:3}")
        let expected = "&var=val"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation2() {
        let template = URITemplate(string: "{&list}")
        let expected = "&list=red,green,blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation3() {
        let template = URITemplate(string: "{&list*}")
        let expected = "&list=red&list=green&list=blue"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation4() {
        let template = URITemplate(string: "{&keys}")
        let expected = "&keys=semi,%3B,dot,.,comma,%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation5() {
        let template = URITemplate(string: "{&keys*}")
        let expected = "&semi=%3B&dot=.&comma=%2C"
        let result = template.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
