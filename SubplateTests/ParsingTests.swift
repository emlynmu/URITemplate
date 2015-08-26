//
//  ParsingTests.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class ParsingTests: XCTestCase {
    // MARK: - parseVariableSpecifier

    func testParseVariableSpecifierWithPrefixModifier() {
        let variableSpecifierString = "term:1"
        let expectedVariableName = "term"
        let expectedPrefixLength = 1
        let result = parseVariableSpecifier(ArraySlice<Character>(variableSpecifierString))

        XCTAssert(expectedVariableName == result.name,
            "expected \"\(expectedVariableName)\"; got \"\(result.name)\"")

        if let modifier = result.valueModifier {
            switch modifier {
            case .Prefix(let resultLength):
                XCTAssert(expectedPrefixLength == resultLength,
                    "expected \"\(expectedPrefixLength)\"; got \"\(resultLength)\"")

            default:
                XCTFail("expected prefix value modifier")
            }
        }
        else {
            XCTFail("expected to receive a value modifier")
        }
    }

    func testParseVariableSpecifierWithTooLongPrefixModifier() {
        let variableSpecifierString = "term:10000"
        let expectedVariableName = "term:10000"
        let result = parseVariableSpecifier(ArraySlice<Character>(variableSpecifierString))

        XCTAssert(expectedVariableName == result.name,
            "expected \"\(expectedVariableName)\"; got \"\(result.name)\"")
        XCTAssert(result.valueModifier == nil, "expected nil; got \"\(result.valueModifier)\"")
    }

    func testParseVariableSpecifierNoModifier() {
        let variableSpecifierString = "term"
        let expectedVariableName = "term"
        let expectedPrefixLength = 1
        let result = parseVariableSpecifier(ArraySlice<Character>(variableSpecifierString))

        XCTAssert(expectedVariableName == result.name,
            "expected \"\(expectedVariableName)\"; got \"\(result.name)\"")
        XCTAssert(result.valueModifier == nil, "expected nil; got \"\(result.valueModifier)\"")
    }

    func testParseCompositeModifier() {
        let variableSpecifierString = "terms*"
        let expectedVariableName = "terms"
        let expectedPrefixLength = 1
        let result = parseVariableSpecifier(ArraySlice<Character>(variableSpecifierString))

        XCTAssert(expectedVariableName == result.name,
            "expected \"\(expectedVariableName)\"; got \"\(result.name)\"")

        if let modifier = result.valueModifier {
            switch modifier {
            case .Composite:
                break

            default:
                XCTFail("expected prefix value modifier")
            }
        }
        else {
            XCTFail("expected to receive a value modifier")
        }
    }

    func testParseVariableSpecifierWithPrefixModifierAndCompositeModifier() {
        let variableSpecifierString = "term:1*"
        let expectedVariableName = "term:1*"
        let result = parseVariableSpecifier(ArraySlice<Character>(variableSpecifierString))

        XCTAssert(expectedVariableName == result.name,
            "expected \"\(expectedVariableName)\"; got \"\(result.name)\"")
        XCTAssert(nil == result.valueModifier,
            "expected nil; got \"\(result.valueModifier)\"")
    }

    // MARK: - consumeExpression

    func testExpressionEmpty() {
        let result = consumeExpression("")
        XCTAssert(result == nil)
    }

    func testExpressionEmptyDelimiters() {
        let result = consumeExpression("{}")
        XCTAssert(result == nil)
    }

    // MARK: - consumeLabel

    func testConsumeLabelEmptyLabel() {
        let result = consumeExpression("{.}")
        XCTAssert(result == nil)
    }

    func testConsumeLabelOnly() {
        let subplate = "{.hello}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsLabel(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLabelWithText() {
        let subplate = "{.abc}def"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsLabel(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoLabels() {
        let subplate = "{.abc}{.def}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsLabel(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{.def}"))
    }

    func testConsumeLabelFail() {
        let result = consumeExpression("abc{.def}")
        XCTAssert(result == nil)
    }

    func testConsumeLabelSingleCharacterLabel() {
        let result = consumeExpression("{.x}")
        XCTAssert(consumeResultIsLabel(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeFragment

    func testConsumeFragmentEmptyFragment() {
        let result = consumeExpression("{#}")
        XCTAssert(result == nil)
    }

    func testConsumeFragmentOnly() {
        let subplate = "{#hello}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsFragment(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeFragmentWithText() {
        let subplate = "{#abc}def"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsFragment(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoFragments() {
        let subplate = "{#abc}{#def}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsFragment(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{#def}"))
    }

    func testConsumeFragmentFail() {
        let result = consumeExpression("abc{#def}")
        XCTAssert(result == nil)
    }

    func testConsumeFragmentSingleCharacterFragment() {
        let result = consumeExpression("{#x}")
        XCTAssert(consumeResultIsFragment(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeReserved

    func testConsumeReservedEmptyReserved() {
        let result = consumeExpression("{+}")
        XCTAssert(result == nil)
    }

    func testConsumeReservedOnly() {
        let subplate = "{+hello}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeReservedWithText() {
        let subplate = "{+abc}def"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoReserveds() {
        let subplate = "{+abc}{+def}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeReservedFail() {
        let result = consumeExpression("abc{+def}")
        XCTAssert(result == nil)
    }

    func testConsumeReservedSingleCharacterReserved() {
        let result = consumeExpression("{+x}")
        XCTAssert(consumeResultIsReserved(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeSimpleString

    func testConsumeSimpleStringOnly() {
        let subplate = "{hello}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeSimpleStringWithText() {
        let subplate = "{abc}def"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoSimpleStrings() {
        let subplate = "{abc}{def}"
        let result = consumeExpression(subplate)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeSimpleStringFail() {
        let result = consumeExpression("abc{def}")
        XCTAssert(result == nil)
    }

    // MARK: - consumeLiteral

    func testConsumeLiteralOnlySucceed() {
        let subplate = "hello"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLiteralWithSimpleString() {
        let subplate = "hello{there}"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeLiteralEmpty() {
        let subplate = ""
        let result = consumeLiteral(subplate)
        XCTAssert(result == nil)
    }

    func testConsumeLiteralWithStrayExpressionOpen() {
        let subplate = "hello{there"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginLiteralWithStrayExpressionOpen() {
        let subplate = "{hello"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndLiteralWithStrayExpressionOpen() {
        let subplate = "hello{"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLiteralWithStrayExpressionClose() {
        let subplate = "hello}there"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginLiteralWithStrayExpressionClose() {
        let subplate = "}hello"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndLiteralWithStrayExpressionClose() {
        let subplate = "hello}"
        let result = consumeLiteral(subplate)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Reserved

    func testConsumeTokenEmptyReserved() {
        let result = consumeToken(ArraySlice("{+}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{+}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenReserved() {
        let subplate = "{+hello}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenReservedWithLiteral() {
        let subplate = "{+abc}def"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoReserveds() {
        let subplate = "{+abc}{+def}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeTokenLiteralAndReserved() {
        let result = consumeToken(ArraySlice("abc{+def}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    // MARK: - consumeToken: Simple String

    func testConsumeTokenSimpleString() {
        let subplate = "{hello}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenSimpleStringWithLiteral() {
        let subplate = "{abc}def"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoSimpleStrings() {
        let subplate = "{abc}{def}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeTokenLiteralAndSimpleString() {
        let result = consumeToken(ArraySlice("abc{def}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeTokenEmptySimpleString() {
        let result = consumeToken(ArraySlice("{}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Literal

    func testConsumeTokenOnlyOpenExpression() {
        let subplate = "{"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenOnlyCloseExpression() {
        let subplate = "}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralOnlySucceed() {
        let subplate = "hello"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralWithSimpleString() {
        let subplate = "hello{there}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeTokenLiteralEmpty() {
        let subplate = ""
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(result == nil)
    }

    func testConsumeTokenLiteralWithStrayExpressionOpen() {
        let subplate = "hello{there"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginLiteralWithStrayExpressionOpen() {
        let subplate = "{hello"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndLiteralWithStrayExpressionOpen() {
        let subplate = "hello{"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralWithStrayExpressionClose() {
        let subplate = "hello}there"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginLiteralWithStrayExpressionClose() {
        let subplate = "}hello"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndLiteralWithStrayExpressionClose() {
        let subplate = "hello}"
        let result = consumeToken(ArraySlice(subplate))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - Tokenize: Balanced

    func testTokenizeEmpty() {
        let subplate = ""
        let result = tokenize(subplate)
        XCTAssert(result.count == 0)
    }

    func testTokenizeWithSimpleStringOnly() {
        let subplate = "{hello}"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
    }

    func testTokenizeWithReservedOnly() {
        let subplate = "{+hello}"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
    }

    func testTokenizeLiteralWithSimpleString() {
        let subplate = "hello{there}"
        let result = tokenize(subplate)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
    }

    func testTokenizeLiteralWithReserved() {
        let subplate = "hello{+there}"
        let result = tokenize(subplate)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
    }

    func testTokenizeSimpleStringWithLiteral() {
        let subplate = "{hello}there"
        let result = tokenize(subplate)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
    }

    func testTokenizeReservedWithLiteral() {
        let subplate = "{+hello}there"
        let result = tokenize(subplate)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
    }

    func testTokenizeSimpleStringLiteralSimpleString() {
        let subplate = "{hello}there{monkey}"
        let result = tokenize(subplate)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
        XCTAssert(tokenIsSimpleString(result[2], withText:"monkey"))
    }

    func testTokenizeReservedLiteralReserved() {
        let subplate = "{+hello}there{+monkey}"
        let result = tokenize(subplate)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
        XCTAssert(tokenIsReserved(result[2], withText:"monkey"))
    }

    func testTokenizeLiteralSimpleStringLiteral() {
        let subplate = "hello{there}monkey"
        let result = tokenize(subplate)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
        XCTAssert(tokenIsLiteral(result[2], withValue:"monkey"))
    }

    func testTokenizeLiteralReservedLiteral() {
        let subplate = "hello{+there}monkey"
        let result = tokenize(subplate)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
        XCTAssert(tokenIsLiteral(result[2], withValue:"monkey"))
    }

    // MARK: - Tokenize: Unbalanced

    func testTokenizeLiteralWithStrayExpressionOpen() {
        let subplate = "hello{there"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello{there"))
    }

    func testTokenizeBeginLiteralWithStrayExpressionOpen() {
        let subplate = "{hello"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"{hello"))
    }

    func testTokenizeEndLiteralWithStrayExpressionOpen() {
        let subplate = "hello{"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello{"))
    }

    func testTokenizeLiteralWithStrayExpressionClose() {
        let subplate = "hello}there"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello}there"))
    }

    func testTokenizeBeginLiteralWithStrayExpressionClose() {
        let subplate = "}hello"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"}hello"))
    }

    func testTokenizeEndLiteralWithStrayExpressionClose() {
        let subplate = "hello}"
        let result = tokenize(subplate)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello}"))
    }

    // MARK: - Data Utilities

    func consumeResultIsLiteral(result: ConsumeResult?, withValue text: String) -> Bool {
        if let result = result {
            return tokenIsLiteral(result.0, withValue: text)
        }

        return false
    }

    func consumeResultIsSimpleString(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsSimpleString(result.0, withText: text)
        }

        return false
    }

    func consumeResultIsReserved(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsReserved(result.0, withText: text)
        }

        return false
    }

    func consumeResultIsLabel(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsLabel(result.0, withText: text)
        }

        return false
    }

    func consumeResultIsFragment(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsFragment(result.0, withText: text)
        }

        return false
    }

    func tokenIsLiteral(token: Token, withValue text: String) -> Bool {
        switch token {
        case .Literal(let value):
            return text == String(value)

        default:
            return false
        }
    }

    func tokenIsSimpleString(token: Token, withText text: String) -> Bool {
        switch token {
        case .SimpleString(let value):
            return text == value[0]

        default:
            return false
        }
    }

    func tokenIsReserved(token: Token, withText text: String) -> Bool {
        switch token {
        case .Reserved(let value):
            return text == value[0]

        default:
            return false
        }
    }

    func tokenIsLabel(token: Token, withText text: String) -> Bool {
        switch token {
        case .Label(let value):
            return text == value[0]

        default:
            return false
        }
    }

    func tokenIsFragment(token: Token, withText text: String) -> Bool {
        switch token {
        case .Fragment(let value):
            return text == value[0]

        default:
            return false
        }
    }

    func consumeResult(result: ConsumeResult?, hasRemainder remainder: String) -> Bool {
        if let result = result {
            return String(result.1) == remainder
        }
        
        return false
    }
}
