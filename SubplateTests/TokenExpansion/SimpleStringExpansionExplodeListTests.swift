//
//  SimpleStringExpansionExplodeListTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import Subplate

class SimpleStringExpansionExplodeListTests: XCTestCase {
    /// Simple String List Empty Expand
    func testSimpleStringListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String List Expand
    func testSimpleStringListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String List Explode
    func testSimpleStringListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair Expand
    func testSimpleStringKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c,d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair Explode
    func testSimpleStringKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xa=b,c=d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
