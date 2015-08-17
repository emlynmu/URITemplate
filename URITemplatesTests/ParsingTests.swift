//
//  ParsingTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import Subplate

class ParsingTests: XCTestCase {
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
        let template = "{.hello}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsLabel(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLabelWithText() {
        let template = "{.abc}def"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsLabel(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoLabels() {
        let template = "{.abc}{.def}"
        let result = consumeExpression(template)
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
        let template = "{#hello}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsFragment(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeFragmentWithText() {
        let template = "{#abc}def"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsFragment(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoFragments() {
        let template = "{#abc}{#def}"
        let result = consumeExpression(template)
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
        let template = "{+hello}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeReservedWithText() {
        let template = "{+abc}def"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoReserveds() {
        let template = "{+abc}{+def}"
        let result = consumeExpression(template)
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
        let template = "{hello}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeSimpleStringWithText() {
        let template = "{abc}def"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoSimpleStrings() {
        let template = "{abc}{def}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeSimpleStringFail() {
        let result = consumeExpression("abc{def}")
        XCTAssert(result == nil)
    }

    // MARK: - consumeLiteral

    func testConsumeLiteralOnlySucceed() {
        let template = "hello"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLiteralWithSimpleString() {
        let template = "hello{there}"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeLiteralEmpty() {
        let template = ""
        let result = consumeLiteral(template)
        XCTAssert(result == nil)
    }

    func testConsumeLiteralWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginLiteralWithStrayExpressionOpen() {
        let template = "{hello"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndLiteralWithStrayExpressionOpen() {
        let template = "hello{"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLiteralWithStrayExpressionClose() {
        let template = "hello}there"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginLiteralWithStrayExpressionClose() {
        let template = "}hello"
        let result = consumeLiteral(template)
        XCTAssert(consumeResultIsLiteral(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndLiteralWithStrayExpressionClose() {
        let template = "hello}"
        let result = consumeLiteral(template)
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
        let template = "{+hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenReservedWithLiteral() {
        let template = "{+abc}def"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoReserveds() {
        let template = "{+abc}{+def}"
        let result = consumeToken(ArraySlice(template))
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
        let template = "{hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenSimpleStringWithLiteral() {
        let template = "{abc}def"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoSimpleStrings() {
        let template = "{abc}{def}"
        let result = consumeToken(ArraySlice(template))
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
        let template = "{"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenOnlyCloseExpression() {
        let template = "}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralOnlySucceed() {
        let template = "hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralWithSimpleString() {
        let template = "hello{there}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeTokenLiteralEmpty() {
        let template = ""
        let result = consumeToken(ArraySlice(template))
        XCTAssert(result == nil)
    }

    func testConsumeTokenLiteralWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginLiteralWithStrayExpressionOpen() {
        let template = "{hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndLiteralWithStrayExpressionOpen() {
        let template = "hello{"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenLiteralWithStrayExpressionClose() {
        let template = "hello}there"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginLiteralWithStrayExpressionClose() {
        let template = "}hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndLiteralWithStrayExpressionClose() {
        let template = "hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsLiteral(result, withValue: "hello}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - Tokenize: Balanced

    func testTokenizeEmpty() {
        let template = ""
        let result = tokenize(template)
        XCTAssert(result.count == 0)
    }

    func testTokenizeWithSimpleStringOnly() {
        let template = "{hello}"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
    }

    func testTokenizeWithReservedOnly() {
        let template = "{+hello}"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
    }

    func testTokenizeLiteralWithSimpleString() {
        let template = "hello{there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
    }

    func testTokenizeLiteralWithReserved() {
        let template = "hello{+there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
    }

    func testTokenizeSimpleStringWithLiteral() {
        let template = "{hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
    }

    func testTokenizeReservedWithLiteral() {
        let template = "{+hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
    }

    func testTokenizeSimpleStringLiteralSimpleString() {
        let template = "{hello}there{monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
        XCTAssert(tokenIsSimpleString(result[2], withText:"monkey"))
    }

    func testTokenizeReservedLiteralReserved() {
        let template = "{+hello}there{+monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsLiteral(result[1], withValue:"there"))
        XCTAssert(tokenIsReserved(result[2], withText:"monkey"))
    }

    func testTokenizeLiteralSimpleStringLiteral() {
        let template = "hello{there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
        XCTAssert(tokenIsLiteral(result[2], withValue:"monkey"))
    }

    func testTokenizeLiteralReservedLiteral() {
        let template = "hello{+there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
        XCTAssert(tokenIsLiteral(result[2], withValue:"monkey"))
    }

    // MARK: - Tokenize: Unbalanced

    func testTokenizeLiteralWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello{there"))
    }

    func testTokenizeBeginLiteralWithStrayExpressionOpen() {
        let template = "{hello"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"{hello"))
    }

    func testTokenizeEndLiteralWithStrayExpressionOpen() {
        let template = "hello{"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello{"))
    }

    func testTokenizeLiteralWithStrayExpressionClose() {
        let template = "hello}there"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"hello}there"))
    }

    func testTokenizeBeginLiteralWithStrayExpressionClose() {
        let template = "}hello"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsLiteral(result[0], withValue:"}hello"))
    }

    func testTokenizeEndLiteralWithStrayExpressionClose() {
        let template = "hello}"
        let result = tokenize(template)
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
