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

    // MARK: - Label

    func testSimpleLabelExpansion() {
        let template = URITemplate("{.who}")
        let expected = ".fred"
        let result = template.expand(["who": "fred"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDoubleSimpleLabelExpansion() {
        let template = URITemplate("{.who,who}")
        let expected = ".fred.fred"
        let result = template.expand(["who": "fred"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFileExtensionExpansion() {
        let template = URITemplate("something{.ext}")
        let expected = "something.tar"
        let result = template.expand(["ext": "tar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDoubleFileExtensionExpansion() {
        let template = URITemplate("something{.ext}")
        let expected = "something.tar.gz"
        let result = template.expand(["ext": ["tar", "gz"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDomainNameLabelValueExpansion() {
        let template = URITemplate("www{.host}.com")
        let expected = "www.monkey.com"
    }
}
