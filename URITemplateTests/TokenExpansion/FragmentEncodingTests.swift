//
//  FragmentEncodingTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class FragmentEncodingTests: XCTestCase {
    func testFragmentEncoding() {
        let template = URITemplate(string: "X{#var}")
        let expected = "X#Hello%20World!"
        let result = template.expand(["var": "Hello World!"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentValueIncludesNumberSymbol() {
        let template = URITemplate(string: "fragment{#value}")
        let expected = "fragment##1#2and#3"
        let result = template.expand(["value": "#1#2and#3"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testFragmentValueNeedsEncoding() {
        let template = URITemplate(string: "fragment{#value}")
        let expected = "fragment#%5E1abc"
        let result = template.expand(["value": "^1abc"])
        
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
