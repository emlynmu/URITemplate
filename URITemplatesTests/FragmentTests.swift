//
//  FragmentTests.swift
//  URITemplates
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplates

class FragmentTests: XCTestCase {
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
