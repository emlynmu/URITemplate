//
//  ReservedExpansionExplodeListTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class ReservedExpansionExplodeListTests: XCTestCase {
    /// Reserved List Empty Expand
    func testReservedListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved List Expand
    func testReservedListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved List Explode
    func testReservedListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved Key-Value Pair Expand
    func testReservedKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b,c,d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved Key-Value Pair With Missing Value Expand
    func testReservedKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa,b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved Key-Value Pair Explode
    func testReservedKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa=b,c=d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Reserved Key-Value Pair With Missing Value Explode
    func testReservedKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xa=b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
