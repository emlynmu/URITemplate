//
//  PathStyleExpansionTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplate

class PathStyleExpansionTests: XCTestCase {
    // Undefined Match

    func testPathSegmentExpansionUndefined() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentExpansionEmpty() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var"
        let result = template.expand(["var": ""])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
    
    // 1 Match
    
    func testPathSegmentExpansion() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var=value"
        let result = template.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Two Label Variables

    func testMultiplePathSegmentVariables1() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc;var2=def"
        let result = template.expand([
            "var1": "abc",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePathSegmentVariables2() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc"
        let result = template.expand([
            "var1": "abc"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePathSegmentVariables3() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc;var2"
        let result = template.expand([
            "var1": "abc",
            "var2": ""
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePathSegmentVariables4() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var2=def"
        let result = template.expand([
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePathSegmentVariables5() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1;var2=def"
        let result = template.expand([
            "var1": "",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultiplePathSegmentVariables6() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
