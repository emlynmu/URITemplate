//
//  LabelTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplate

class LabelTests: XCTestCase {
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
        let template = URITemplate("something{.ext*}")
        let expected = "something.tar.gz"
        let result = template.expand(["ext": ["tar", "gz"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDomainNameLabelValueExpansion() {
        let template = URITemplate("www{.host}.com")
        let expected = "www.monkey.com"
    }

    func testEmpty() {
        let template = URITemplate("X{.empty}")
        let expected = "X."
        let result = template.expand(["empty": ""])
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testUndefined() {
        let template = URITemplate("X{.undefined}")
        let expected = "X"
        let result = template.expand(["empty": ""])
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
