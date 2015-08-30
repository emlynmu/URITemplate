//
//  LabelExpansionExplodeListTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import Subplate

class LabelExpansionExplodeListTests: XCTestCase {
    /// Label List Empty Expand
    func testLabelListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label List Expand
    func testLabelListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a,b,c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label List Explode
    func testLabelListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a.b.c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label Key-Value Pair Expand
    func testLabelKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a,b,c,d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label Key-Value Pair With Missing Value Expand
    func testLabelKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a,b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label Key-Value Pair Explode
    func testLabelKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a=b.c=d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Label Key-Value Pair With Missing Value Explode
    func testLabelKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X.a=b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
