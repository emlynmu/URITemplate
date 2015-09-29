//
//  ReservedExpansionTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/30/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import Foundation

import XCTest
import URITemplate

class ReservedExpansionTests: XCTestCase {
    // 0 Matches

    func testFragmentExpansionEmpty() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // 1 Match

    func testFragmentExpansion() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xvalue"
        let result = template.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Two Simple String Variables

    func testTwoSimpleStringVariables1() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Reserved([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc,def"
        let result = template.expand([
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

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc"
        let result = template.expand([
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

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xabc"
        let result = template.expand([
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

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xdef"
        let result = template.expand([
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

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "Xdef"
        let result = template.expand([
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

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
