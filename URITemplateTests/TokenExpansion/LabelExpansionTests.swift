//
//  LabelExpansionTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/12/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplate

class LabelExpansionTests: XCTestCase {
    // Undefined Match

    func testLabelExpansionUndefined() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand(["var2": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testLabelExpansionEmpty() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X."
        let result = template.expand(["var": ""])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
    
    // 1 Match
    
    func testLabelExpansion() {
        let literalToken = Token.Literal("X")
        let variableSpecifier = VariableSpecifier(name: "var", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier]))
        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X.value"
        let result = template.expand(["var": "value"])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    // MARK: - Two Label Variables

    func testMultipleLabelVariables1() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X.abc.def"
        let result = template.expand([
            "var1": "abc",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleLabelVariables2() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X.abc"
        let result = template.expand([
            "var1": "abc"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleLabelVariables3() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X.abc."
        let result = template.expand([
            "var1": "abc",
            "var2": ""
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleLabelVariables4() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X.def"
        let result = template.expand([
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleLabelVariables5() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X..def"
        let result = template.expand([
            "var1": "",
            "var2": "def"
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }

    func testMultipleLabelVariables6() {
        let literalToken = Token.Literal("X")

        let variableSpecifier1 = VariableSpecifier(name: "var1", valueModifier: nil)
        let variableSpecifier2 = VariableSpecifier(name: "var2", valueModifier: nil)
        let expressionToken = Token.Expression(TemplateExpression.Label([variableSpecifier1,
            variableSpecifier2]))

        let template = URITemplate(tokens: [literalToken, expressionToken])
        let expected = "X"
        let result = template.expand([:])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
