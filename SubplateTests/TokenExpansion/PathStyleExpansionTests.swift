//
//  PathStyleExpansionTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class PathStyleExpansionTests: XCTestCase {
    // Undefined Match

    func testPathSegmentExpansionUndefined() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testPathSegmentExpansionEmpty() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var"
        let result = subplate.expand(["var": ""])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
    
    // 1 Match
    
    func testPathSegmentExpansion() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var=value"
        let result = subplate.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Two Label Variables

    func testMultiplePathSegmentVariables1() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.PathStyle([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc;var2=def"
        let result = subplate.expand([
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

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc"
        let result = subplate.expand([
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

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1=abc;var2"
        let result = subplate.expand([
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

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var2=def"
        let result = subplate.expand([
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

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X;var1;var2=def"
        let result = subplate.expand([
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

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
