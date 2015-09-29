//
//  FormStyleQueryExpansionExplodeListTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class FormStyleQueryExpansionExplodeListTests: XCTestCase {
    /// Form Style Query List Empty Expand
    func testFormStyleQueryListEmptyExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?var="
        let result = template.expand(["var": []])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query List Expand
    func testFormStyleQueryListExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?var=a,b,c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query List Explode
    func testFormStyleQueryListExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?var=a&var=b&var=c"
        let result = template.expand(["var": ["a", "b", "c"]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query Key-Value Pair Expand
    func testFormStyleQueryKeyValuePairExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?var=a,b,c,d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query Key-Value Pair With Missing Value Expand
    func testFormStyleQueryKeyValuePairWithMissingValueExpand() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?var=a,b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query Key-Value Pair Explode
    func testFormStyleQueryKeyValuePairExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?a=b&c=d"
        let result = template.expand(["var": [["a", "b"], ["c", "d"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    /// Form Style Query Key-Value Pair With Missing Value Explode
    func testFormStyleQueryKeyValuePairWithMissingValueExplode() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: ValueModifier.Composite)
        let expressionToken = Token.Expression(TemplateExpression.FormStyleQuery([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X?a=b"
        let result = template.expand(["var": [["a", "b"], ["c"]]])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
