//
//  ParsingTests.swift
//  URITemplate
//
//  Created by Emlyn Murphy on 8/8/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import XCTest
import URITemplates

class ParsingTests: XCTestCase {
    // MARK - findExpressionBoundary

    func testFindExpressionBoundaryOnly() {
        let template = "{hello}"
        let expected = (start: 0, end: 6)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindEmptyExpressionBoundary() {
        let template = "{}"
        let expected = (start: 0, end: 1)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindExpressionBoundaryNoClose() {
        let template = "{hello"
        let result = findExpressionBoundary(ArraySlice(template))
        XCTAssert(result == nil)
    }

    func testFindExpressionBoundaryOpenOnly() {
        let template = "{"
        let result = findExpressionBoundary(ArraySlice(template))
        XCTAssert(result == nil)
    }

    func testFindExpressionBoundaryCloseOnly() {
        let template = "}"
        let result = findExpressionBoundary(ArraySlice(template))
        XCTAssert(result == nil)
    }

    func testFindExpressionBoundaryWithLiteral() {
        let template = "{hello}abc"
        let expected = (start: 0, end: 6)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindLiteralWithExpressionBoundary() {
        let template = "abc{hello}"
        let expected = (start: 3, end: 9)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindExpressionBoundaryBetweenLiterals() {
        let template = "abc{hello}def"
        let expected = (start: 3, end: 9)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindExpressionBoundaryBetweenLiteralsWithStrayOpen() {
        let template = "abc{hel{lo}def"
        let expected = (start: 3, end: 10)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    func testFindExpressionBoundaryBetweenLiteralsWithStrayClose() {
        let template = "a}bc{hello}def"
        let expected = (start: 4, end: 10)

        if let result = findExpressionBoundary(ArraySlice(template)) {
            XCTAssert(expected.start == result.start && expected.end == result.end,
                "expected (start: \(expected.start), end: \(expected.end)); " +
                "got (start: \(result.start), end: \(result.end))")
        }
        else {
            XCTFail("failed to find expression boundary")
        }
    }

    // MARK: - consumeLabel

    func testConsumeLabelOnly() {
        let template = "{.hello}"
        let result = consumeLabel(template)
        XCTAssert(consumeResultIsLabel(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeLabelWithText() {
        let template = "{.abc}def"
        let result = consumeLabel(template)
        XCTAssert(consumeResultIsLabel(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoLabels() {
        let template = "{.abc}{.def}"
        let result = consumeLabel(template)
        XCTAssert(consumeResultIsLabel(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{.def}"))
    }

    func testConsumeLabelFail() {
        let result = consumeLabel("abc{.def}")
        XCTAssert(result == nil)
    }

    func testConsumeLabelEmpty() {
        let result = consumeLabel("")
        XCTAssert(result == nil)
    }

    func testConsumeLabelEmptyLabel() {
        let result = consumeLabel("{.}")
        XCTAssert(result == nil)
    }

    func testConsumeLabelSingleCharacterLabel() {
        let result = consumeLabel("{.x}")
        XCTAssert(consumeResultIsLabel(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeFragment

    func testConsumeFragmentOnly() {
        let template = "{#hello}"
        let result = consumeFragment(template)
        XCTAssert(consumeResultIsFragment(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeFragmentWithText() {
        let template = "{#abc}def"
        let result = consumeFragment(template)
        XCTAssert(consumeResultIsFragment(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoFragments() {
        let template = "{#abc}{#def}"
        let result = consumeFragment(template)
        XCTAssert(consumeResultIsFragment(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{#def}"))
    }

    func testConsumeFragmentFail() {
        let result = consumeFragment("abc{#def}")
        XCTAssert(result == nil)
    }

    func testConsumeFragmentEmpty() {
        let result = consumeFragment("")
        XCTAssert(result == nil)
    }

    func testConsumeFragmentEmptyFragment() {
        let result = consumeFragment("{#}")
        XCTAssert(result == nil)
    }

    func testConsumeFragmentSingleCharacterFragment() {
        let result = consumeFragment("{#x}")
        XCTAssert(consumeResultIsFragment(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeReserved

    func testConsumeReservedOnly() {
        let template = "{+hello}"
        let result = consumeReserved(template)
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeReservedWithText() {
        let template = "{+abc}def"
        let result = consumeReserved(template)
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoReserveds() {
        let template = "{+abc}{+def}"
        let result = consumeReserved(template)
        XCTAssert(consumeResultIsReserved(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeReservedFail() {
        let result = consumeReserved("abc{+def}")
        XCTAssert(result == nil)
    }

    func testConsumeReservedEmpty() {
        let result = consumeReserved("")
        XCTAssert(result == nil)
    }

    func testConsumeReservedEmptyReserved() {
        let result = consumeReserved("{+}")
        XCTAssert(result == nil)
    }

    func testConsumeReservedSingleCharacterReserved() {
        let result = consumeReserved("{+x}")
        XCTAssert(consumeResultIsReserved(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }
    
    // MARK: - consumeSimpleString

    func testConsumeSimpleStringOnly() {
        let template = "{hello}"
        let result = consumeSimpleString(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeSimpleStringWithText() {
        let template = "{abc}def"
        let result = consumeSimpleString(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoSimpleStrings() {
        let template = "{abc}{def}"
        let result = consumeSimpleString(template)
        XCTAssert(consumeResultIsSimpleString(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeSimpleStringFail() {
        let result = consumeSimpleString("abc{def}")
        XCTAssert(result == nil)
    }

    func testConsumeSimpleStringEmpty() {
        let result = consumeSimpleString("")
        XCTAssert(result == nil)
    }

    func testConsumeSimpleStringEmptyExpression() {
        let result = consumeSimpleString("{}")
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

    func testConsumeTokenEmptyReserved() {
        let result = consumeToken(ArraySlice("{+}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{+}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
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

    func testConsumeTokenEmpty() {
        let result = consumeToken(ArraySlice(""))
        XCTAssert(result == nil)
    }

    func testConsumeTokenEmptySimpleString() {
        let result = consumeToken(ArraySlice("{}"))
        XCTAssert(consumeResultIsLiteral(result, withValue: "{}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Literal

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
            return text == String(value)

        default:
            return false
        }
    }

    func tokenIsReserved(token: Token, withText text: String) -> Bool {
        switch token {
        case .Reserved(let value):
            return text == String(value)

        default:
            return false
        }
    }

    func tokenIsLabel(token: Token, withText text: String) -> Bool {
        switch token {
        case .Label(let value):
            return text == String(value)

        default:
            return false
        }
    }

    func tokenIsFragment(token: Token, withText text: String) -> Bool {
        switch token {
        case .Fragment(let value):
            return text == String(value)

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
