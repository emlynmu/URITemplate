//
//  VariableSpecifierTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/29/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class VariableSpecifierTests: XCTestCase {
    var value: AnyObject!

    override func setUp() {
        super.setUp()

        value = ["one", "two", "three"]
    }

    func testVariableSpecifierExpansion1() {
        let specifier = VariableSpecifier(name: "count", valueModifier: nil)
        let expression = ExpressionType.SimpleString([specifier])
        let expected = "one,two,three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion2() {
        let specifier = VariableSpecifier(name: "count", valueModifier: ValueModifier.Composite)
        let expression = ExpressionType.SimpleString([specifier])
        let expected = "one,two,three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion3() {
        let specifier = VariableSpecifier(name: "count", valueModifier: nil)
        let expression = ExpressionType.PathSegment([specifier])
        let expected = "/one,two,three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion4() {
        let specifier = VariableSpecifier(name: "count", valueModifier: ValueModifier.Composite)
        let expression = ExpressionType.PathSegment([specifier])
        let expected = "/one/two/three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion5() {
        let specifier = VariableSpecifier(name: "count", valueModifier: nil)
        let expression = ExpressionType.PathStyle([specifier])
        let expected = ";count=one,two,three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion6() {
        let specifier = VariableSpecifier(name: "count", valueModifier: ValueModifier.Composite)
        let expression = ExpressionType.PathStyle([specifier])
        let expected = ";count=one;count=two;count=three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion7() {
        let specifier = VariableSpecifier(name: "count", valueModifier: nil)
        let expression = ExpressionType.FormStyleQuery([specifier])
        let expected = "?count=one,two,three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion8() {
        let specifier = VariableSpecifier(name: "count", valueModifier: ValueModifier.Composite)
        let expression = ExpressionType.FormStyleQuery([specifier])
        let expected = "?count=one&count=two&count=three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testVariableSpecifierExpansion9() {
        let specifier = VariableSpecifier(name: "count", valueModifier: ValueModifier.Composite)
        let expression = ExpressionType.FormStyleQueryContinuation([specifier])
        let expected = "&count=one&count=two&count=three"
        let result = specifier.expand(value, inExpression: expression)
        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
