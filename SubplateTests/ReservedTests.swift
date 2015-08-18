//
//  ReservedTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class ReservedTests: XCTestCase {
    func testReservedEncoding() {
        let subplate = Subplate("here?ref={+path}")
        let expected = "here?ref=/foo/bar"
        let result = subplate.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testSimpleStringEncoding() {
        let subplate = Subplate("here?ref={path}")
        let expected = "here?ref=%2Ffoo%2Fbar"
        let result = subplate.expand(["path": "/foo/bar"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMixedReservedEncoding() {
        let subplate = Subplate("here?ref={+path}{b}{+c}")
        let expected = "here?ref=/foo/bar%2Fd%2Fe%2Ff/g/h/i"
        let result = subplate.expand(["path": "/foo/bar", "b": "/d/e/f", "c": "/g/h/i"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleMixedReservedEncoding() {
        let subplate = Subplate("here?ref={+path}{b}{+c}")
        let expected = "here?ref=/foo/bar%2Fd%2Fe%2Ff,%2Fg%2Fh%2Fi/j/k/l"
        let result = subplate.expand(["path": "/foo/bar", "b": ["/d/e/f", "/g/h/i"], "c": "/j/k/l"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
