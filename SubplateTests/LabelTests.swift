//
//  LabelTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class LabelTests: XCTestCase {
    func testSimpleLabelExpansion() {
        let subplate = Subplate("{.who}")
        let expected = ".fred"
        let result = subplate.expand(["who": "fred"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDoubleSimpleLabelExpansion() {
        let subplate = Subplate("{.who,who}")
        let expected = ".fred.fred"
        let result = subplate.expand(["who": "fred"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFileExtensionExpansion() {
        let subplate = Subplate("something{.ext}")
        let expected = "something.tar"
        let result = subplate.expand(["ext": "tar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDoubleFileExtensionExpansion() {
        let subplate = Subplate("something{.ext}")
        let expected = "something.tar.gz"
        let result = subplate.expand(["ext": ["tar", "gz"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testDomainNameLabelValueExpansion() {
        let subplate = Subplate("www{.host}.com")
        let expected = "www.monkey.com"
    }
}
