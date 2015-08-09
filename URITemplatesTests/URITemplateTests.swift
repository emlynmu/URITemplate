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
    // MARK: - Simple String

    func testSimpleStringExpansion() {
        let template = URITemplate("my{adjective}template")
        let expected = "myfunkytemplate"
        let result = template.expand(["adjective": "funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleSimpleStringExpansion() {
        let template = URITemplate("my{adjective}template")
        let expected = "myfunky,freshtemplate"
        let result = template.expand(["adjective": ["funky", "fresh"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMissingValueExpansion() {
        let template = URITemplate("my{adjective}template")
        let expected = "mytemplate"
        let result = template.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodedValueExpansion() {
        let template = URITemplate("my {adjective} template")
        let expected = "my super%20funky template"
        let result = template.expand(["adjective": "super funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePercentEncodedValueExpansion() {
        let template = URITemplate("my {adjective} template")
        let expected = "my super%20funky,super%20freaky template"
        let result = template.expand(["adjective": ["super funky", "super freaky"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Reserved

    func testReservedEncoding() {
        let template = URITemplate("here?ref={+path}")
        let expected = "here?ref=/foo/bar"
        let result = template.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testSimpleStringEncoding() {
        let template = URITemplate("here?ref={path}")
        let expected = "here?ref=%2Ffoo%2Fbar"
        let result = template.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMixedReservedEncoding() {
        let template = URITemplate("here?ref={+path}{b}{+c}")
        let expected = "here?ref=/foo/bar%2Fd%2Fe%2Ff/g/h/i"
        let result = template.expand(["path": "/foo/bar", "b": "/d/e/f", "c": "/g/h/i"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleMixedReservedEncoding() {
        let template = URITemplate("here?ref={+path}{b}{+c}")
        let expected = "here?ref=/foo/bar%2Fd%2Fe%2Ff,%2Fg%2Fh%2Fi/j/k/l"
        let result = template.expand(["path": "/foo/bar", "b": ["/d/e/f", "/g/h/i"], "c": "/j/k/l"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Fragment

    func testFragmentExpansion() {
        let template = URITemplate("X{#var}")
        let expected = "X#value"
        let result = template.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentEncoding() {
        let template = URITemplate("X{#var}")
        let expected = "X#Hello%20World!"
        let result = template.expand(["var": "Hello World!"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
