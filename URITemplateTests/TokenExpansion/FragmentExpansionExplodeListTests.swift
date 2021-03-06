//
//  FragmentExpansionExplodeListTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class FragmentExpansionExplodeListTests: XCTestCase {
    /// Fragment List Empty Expand
    func testFragmentListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment List Expand
    func testFragmentListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment List Explode
    func testFragmentListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment Key-Value Pair Expand
    func testFragmentKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a,b,c,d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment Key-Value Pair With Missing Value Expand
    func testFragmentKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a,b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment Key-Value Pair Explode
    func testFragmentKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a=b,c=d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Fragment Key-Value Pair With Missing Value Explode
    func testFragmentKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.Fragment([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X#a=b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
