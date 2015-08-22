//
//  RFC6570Level4Tests.swift
//  Subplate
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
import Subplate

class RFC6570Level4Tests: XCTestCase {
    var values: [NSObject : AnyObject]!

    override func setUp() {
        super.setUp()

        values = [
            "var": "value",
            "hello": "Hello World!",
            "path": "/foo/bar",
            "list": ["red", "green", "blue"],
            "keys": [
                "semi": ";",
                "dot": ".",
                "comma": ","
            ]
        ]
    }

    // MARK: - String expansion with value modifiers

    func testStringExpansionWithValueModifiers1() {
        let subplate = Subplate("{var:3}")
        let expected = "val"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers2() {
        let subplate = Subplate("{var:30}")
        let expected = "value"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers3() {
        let subplate = Subplate("{list}")
        let expected = "red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers4() {
        let subplate = Subplate("{list*}")
        let expected = "red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers5() {
        let subplate = Subplate("{keys}")
        let expected = "semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testStringExpansionWithValueModifiers6() {
        let subplate = Subplate("{keys*}")
        let expected = "semi=%3B,dot=.,comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Reserved expansion with value modifiers

    func testReservedExpansionWithValueModifiers1() {
        let subplate = Subplate("{+path:6}/here")
        let expected = "/foo/b/here"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers2() {
        let subplate = Subplate("{+list}")
        let expected = "red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers3() {
        let subplate = Subplate("{+list*}")
        let expected = "red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers4() {
        let subplate = Subplate("{+keys}")
        let expected = "semi,;,dot,.,comma,,"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testReservedExpansionWithValueModifiers5() {
        let subplate = Subplate("{+keys*}")
        let expected = "semi=;,dot=.,comma=,"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Fragment expansion with value modifiers

    func testFragmentExpansionWithValueModifiers1() {
        let subplate = Subplate("{#path:6}/here")
        let expected = "#/foo/b/here"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers2() {
        let subplate = Subplate("{#list}")
        let expected = "#red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers3() {
        let subplate = Subplate("{#list*}")
        let expected = "#red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers4() {
        let subplate = Subplate("{#keys}")
        let expected = "#semi,;,dot,.,comma,,"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentExpansionWithValueModifiers5() {
        let subplate = Subplate("{#keys*}")
        let expected = "#semi=;,dot=.,comma=,"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Label expansion, dot-prefixed

    func testLabelExpansionDotPrefixed1() {
        let subplate = Subplate("X{.var:3}")
        let expected = "X.val"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed2() {
        let subplate = Subplate("X{.list}")
        let expected = "X.red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed3() {
        let subplate = Subplate("X{.list*}")
        let expected = "X.red.green.blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed4() {
        let subplate = Subplate("X{.keys}")
        let expected = "X.semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionDotPrefixed5() {
        let subplate = Subplate("X{.keys*}")
        let expected = "X.semi=%3B.dot=..comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Path segments, slash-prefixed

    func testPathSegmentsSlashPrefixed1() {
        let subplate = Subplate("{/var:1,var}")
        let expected = "/v/value"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed2() {
        let subplate = Subplate("{/list}")
        let expected = "/red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed3() {
        let subplate = Subplate("{/list*}")
        let expected = "/red/green/blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed4() {
        let subplate = Subplate("{/list*,path:4}")
        let expected = "/red/green/blue/%2Ffoo"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed5() {
        let subplate = Subplate("{/keys}")
        let expected = "/semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentsSlashPrefixed6() {
        let subplate = Subplate("{/keys*}")
        let expected = "/semi=%3B/dot=./comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Path-style parameters, semicolon-prefixed

    func testPathStyleParametersSemicolonPrefixed1() {
        let subplate = Subplate("{;hello:5}")
        let expected = ";hello=Hello"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed2() {
        let subplate = Subplate("{;list}")
        let expected = ";list=red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed3() {
        let subplate = Subplate("{;list*}")
        let expected = ";list=red;list=green;list=blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed4() {
        let subplate = Subplate("{;keys}")
        let expected = ";keys=semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathStyleParametersSemicolonPrefixed5() {
        let subplate = Subplate("{;keys*}")
        let expected = ";semi=%3B;dot=.;comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Form-style query, ampersand-separated

    func testFormStyleQueryAmpersandSeparated1() {
        let subplate = Subplate("{?var:3}")
        let expected = "?var=val"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated2() {
        let subplate = Subplate("{?list}")
        let expected = "?list=red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated3() {
        let subplate = Subplate("{?list*}")
        let expected = "?list=red&list=green&list=blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated4() {
        let subplate = Subplate("{?keys}")
        let expected = "?keys=semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryAmpersandSeparated5() {
        let subplate = Subplate("{?keys*}")
        let expected = "?semi=%3B&dot=.&comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Form-style query continuation

    func testFormStyleQueryContinuation1() {
        let subplate = Subplate("{&var:3}")
        let expected = "&var=val"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation2() {
        let subplate = Subplate("{&list}")
        let expected = "&list=red,green,blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation3() {
        let subplate = Subplate("{&list*}")
        let expected = "&list=red&list=green&list=blue"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation4() {
        let subplate = Subplate("{&keys}")
        let expected = "&keys=semi,%3B,dot,.,comma,%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFormStyleQueryContinuation5() {
        let subplate = Subplate("{&keys*}")
        let expected = "&semi=%3B&dot=.&comma=%2C"
        let result = subplate.expand(values)

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
