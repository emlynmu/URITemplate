//
//  SimpleStringTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class SimpleStringTests: XCTestCase {
    func testSimpleStringExpansion() {
        let subplate = Subplate("my{adjective}subplate")
        let expected = "myfunkysubplate"
        let result = subplate.expand(["adjective": "funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleSimpleStringExpansion() {
        let subplate = Subplate("my{adjective}subplate")
        let expected = "myfunky,freshsubplate"
        let result = subplate.expand(["adjective": ["funky", "fresh"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiVariableSimpleStringExpansion() {
        let subplate = Subplate("coordinates:({x,y})")
        let expected = "coordinates:(1,2)"
        let result = subplate.expand([
            "x": 1,
            "y": 2 ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiVariableOneEmptySimpleStringExpansion() {
        let subplate = Subplate("coordinates:({x,y})")
        let expected = "coordinates:(1,)"
        let result = subplate.expand([
            "x": 1])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMissingValueExpansion() {
        let subplate = Subplate("my{adjective}subplate")
        let expected = "mysubplate"
        let result = subplate.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPercentEncodedValueExpansion() {
        let subplate = Subplate("my {adjective} subplate")
        let expected = "my super%20funky subplate"
        let result = subplate.expand(["adjective": "super funky"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePercentEncodedValueExpansion() {
        let subplate = Subplate("my {adjective} subplate")
        let expected = "my super%20funky,super%20freaky subplate"
        let result = subplate.expand(["adjective": ["super funky", "super freaky"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
