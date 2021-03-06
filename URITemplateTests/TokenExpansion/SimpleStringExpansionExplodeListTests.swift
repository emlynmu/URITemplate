//
//  SimpleStringExpansionExplodeListTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class SimpleStringExpansionExplodeListTests: XCTestCase {
    /// Simple String List Empty Expand
    func testSimpleStringListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String List Expand
    func testSimpleStringListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String List Explode
    func testSimpleStringListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair Expand
    func testSimpleStringKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c,d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair With Missing Value Expand
    func testSimpleStringKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair Explode
    func testSimpleStringKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa=b,c=d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Simple String Key-Value Pair With Missing Value Explode
    func testSimpleStringKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.SimpleString([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa=b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
