//
//  ReservedExpansionTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import Subplate

class ReservedExpansionTests: XCTestCase {
    // 0 Matches

    func testFragmentExpansionEmpty() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // 1 Match

    func testFragmentExpansion() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xvalue"
        let result = subplate.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Two Simple String Variables

    func testTwoSimpleStringVariables1() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc,def"
        let result = subplate.expand([
            "var1": "abc",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testTwoSimpleStringVariables2() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc"
        let result = subplate.expand([
            "var1": "abc"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testTwoSimpleStringVariables3() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc"
        let result = subplate.expand([
            "var1": "abc",
            "var2": ""
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testTwoSimpleStringVariables4() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xdef"
        let result = subplate.expand([
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testTwoSimpleStringVariables5() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "Xdef"
        let result = subplate.expand([
            "var1": "",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testTwoSimpleStringVariables6() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let subplate = Subplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = subplate.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
