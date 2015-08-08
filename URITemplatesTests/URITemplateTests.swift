//
//  URITemplateTests.swift
//  URITemplateTests
//
//  Created by Emlyn Murphy on 8/6/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplates

class URITemplateTests: XCTestCase {
    func testSimpleExpansion() {
        let template = URITemplate(string: "my{adjective}template")
        let expected = "myfunkytemplate"
        let result = template.expand(["adjective": "funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMissingValueExpansion() {
        let template = URITemplate(string: "my{adjective}template")
        let expected = "mytemplate"
        let result = template.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodedValueExpansion() {
        let template = URITemplate(string: "my {adjective} template")
        let expected = "my super%20funky template"
        let result = template.expand(["adjective": "super funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testAllowReservedExpressionEncoding() {
        let template = URITemplate(string: "here?ref={+path}")
        let expected = "here?ref=/foo/bar"
        let result = template.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testExpressionEncoding() {
        let template = URITemplate(string: "here?ref={path}")
        let expected = "here?ref=%2Ffoo%2Fbar"
        let result = template.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMixedReservedExpressionEncoding() {
        let template = URITemplate(string: "here?ref={+path}{b}{+c}")
        let expected = "here?ref=/foo/bar%2Fd%2Fe%2Ff/g/h/i"
        let result = template.expand(["path": "/foo/bar", "b": "/d/e/f", "c": "/g/h/i"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
