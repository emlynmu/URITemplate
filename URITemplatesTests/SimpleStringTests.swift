//
//  SimpleStringTests.swift
//  URITemplates
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplates

class SimpleStringTests: XCTestCase {
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

    func testMultiVariableSimpleStringExpansion() {
        let template = URITemplate("coordinates:({x,y})")
        let expected = "coordinates:(1,2)"
        let result = template.expand([
            "x": 1,
            "y": 2 ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiVariableOneEmptySimpleStringExpansion() {
        let template = URITemplate("coordinates:({x,y})")
        let expected = "coordinates:(1,)"
        let result = template.expand([
            "x": 1])

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
}
