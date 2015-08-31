//
//  PathStyleExpansionExplodeListTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import Subplate

class PathStyleExpansionExplodeListTests: XCTestCase {
    /// Path Style List Empty Expand
    func testPathStyleListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var"
        let result = subplate.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style List Expand
    func testPathStyleListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var=a,var=b,var=c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style List Explode
    func testPathStyleListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var=a;var=b;var=c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style Key-Value Pair Expand
    func testPathStyleKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;a=b,c=d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style Key-Value Pair With Missing Value Expand
    func testPathStyleKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;a=b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style Key-Value Pair Explode
    func testPathStyleKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;a=b;c=d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Style Key-Value Pair With Missing Value Explode
    func testPathStyleKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;a=b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
