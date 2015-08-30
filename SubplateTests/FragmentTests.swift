//
//  FragmentTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class FragmentTests: XCTestCase {
    func testFragmentExpansion() {
        let subplate = Subplate("X{#var}")
        let expected = "X#value"
        let result = subplate.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
    
    func testFragmentExpansionEmpty() {
        let subplate = Subplate("X{#var}")
        let expected = "X"
        let result = subplate.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
    
    func testFragmentEncoding() {
        let subplate = Subplate("X{#var}")
        let expected = "X#Hello%20World!"
        let result = subplate.expand(["var": "Hello World!"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentValueIncludesNumberSymbol() {
        let subplate = Subplate("fragment{#value}")
        let expected = "fragment##1#2and#3"
        let result = subplate.expand(["value": "#1#2and#3"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentValueNeedsEncoding() {
        let subplate = Subplate("fragment{#value}")
        let expected = "fragment#%5E1abc"
        let result = subplate.expand(["value": "^1abc"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Multiple Fragment Variables


}
