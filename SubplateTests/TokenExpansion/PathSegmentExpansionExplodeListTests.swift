//
//  PathSegmentExpansionExplodeListTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import Subplate

class PathSegmentExpansionExplodeListTests: XCTestCase {
    /// Path Segment List Empty Expand
    func testPathSegmentListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/"
        let result = subplate.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment List Expand
    func testPathSegmentListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a,b,c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment List Explode
    func testPathSegmentListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a/b/c"
        let result = subplate.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment Key-Value Pair Expand
    func testPathSegmentKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a,b,c,d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment Key-Value Pair With Missing Value Expand
    func testPathSegmentKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a,b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment Key-Value Pair Explode
    func testPathSegmentKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a=b/c=d"
        let result = subplate.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Path Segment Key-Value Pair With Missing Value Explode
    func testPathSegmentKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.PathSegment([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X/a=b"
        let result = subplate.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
