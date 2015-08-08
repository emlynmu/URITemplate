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

    // MARK: - consumeText

    func testConsumeTextOnlySucceed() {
        let template = "hello"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTextWithSimpleString() {
        let template = "hello{there}"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeTextEmpty() {
        let template = ""
        let result = consumeText(template)
        XCTAssert(result == nil)
    }

    func testConsumeTextWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginTextWithStrayExpressionOpen() {
        let template = "{hello"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndTextWithStrayExpressionOpen() {
        let template = "hello{"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTextWithStrayExpressionClose() {
        let template = "hello}there"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeBeginTextWithStrayExpressionClose() {
        let template = "}hello"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeEndTextWithStrayExpressionClose() {
        let template = "hello}"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Reserved

    func testConsumeTokenReserved() {
        let template = "{+hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsReserved(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenReservedWithText() {
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

    func testConsumeTokenTextAndReserved() {
        let result = consumeToken(ArraySlice("abc{+def}"))
        XCTAssert(consumeResultIsText(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeTokenEmptyReserved() {
        let result = consumeToken(ArraySlice("{+}"))
        XCTAssert(consumeResultIsText(result, withValue: "{+}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Simple String

    func testConsumeTokenSimpleString() {
        let template = "{hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsSimpleString(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenSimpleStringWithText() {
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

    func testConsumeTokenTextAndSimpleString() {
        let result = consumeToken(ArraySlice("abc{def}"))
        XCTAssert(consumeResultIsText(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeTokenEmpty() {
        let result = consumeToken(ArraySlice(""))
        XCTAssert(result == nil)
    }

    func testConsumeTokenEmptySimpleString() {
        let result = consumeToken(ArraySlice("{}"))
        XCTAssert(consumeResultIsText(result, withValue: "{}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Text

    func testConsumeTokenTextOnlySucceed() {
        let template = "hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenTextWithSimpleString() {
        let template = "hello{there}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: "{there}"))
    }

    func testConsumeTokenTextEmpty() {
        let template = ""
        let result = consumeToken(ArraySlice(template))
        XCTAssert(result == nil)
    }

    func testConsumeTokenTextWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello{there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginTextWithStrayExpressionOpen() {
        let template = "{hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "{hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndTextWithStrayExpressionOpen() {
        let template = "hello{"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello{"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenTextWithStrayExpressionClose() {
        let template = "hello}there"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello}there"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenBeginTextWithStrayExpressionClose() {
        let template = "}hello"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "}hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenEndTextWithStrayExpressionClose() {
        let template = "hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsText(result, withValue: "hello}"))
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

    func testTokenizeTextWithSimpleString() {
        let template = "hello{there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
    }

    func testTokenizeTextWithReserved() {
        let template = "hello{+there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
    }

    func testTokenizeSimpleStringWithText() {
        let template = "{hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
    }

    func testTokenizeReservedWithText() {
        let template = "{+hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
    }

    func testTokenizeSimpleStringTextSimpleString() {
        let template = "{hello}there{monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsSimpleString(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
        XCTAssert(tokenIsSimpleString(result[2], withText:"monkey"))
    }

    func testTokenizeReservedTextReserved() {
        let template = "{+hello}there{+monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsReserved(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
        XCTAssert(tokenIsReserved(result[2], withText:"monkey"))
    }

    func testTokenizeTextSimpleStringText() {
        let template = "hello{there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsSimpleString(result[1], withText:"there"))
        XCTAssert(tokenIsText(result[2], withValue:"monkey"))
    }

    func testTokenizeTextReservedText() {
        let template = "hello{+there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsReserved(result[1], withText:"there"))
        XCTAssert(tokenIsText(result[2], withValue:"monkey"))
    }

    // MARK: - Tokenize: Unbalanced

    func testTokenizeTextWithStrayExpressionOpen() {
        let template = "hello{there"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"hello{there"))
    }

    func testTokenizeBeginTextWithStrayExpressionOpen() {
        let template = "{hello"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"{hello"))
    }

    func testTokenizeEndTextWithStrayExpressionOpen() {
        let template = "hello{"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"hello{"))
    }

    func testTokenizeTextWithStrayExpressionClose() {
        let template = "hello}there"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"hello}there"))
    }

    func testTokenizeBeginTextWithStrayExpressionClose() {
        let template = "}hello"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"}hello"))
    }

    func testTokenizeEndTextWithStrayExpressionClose() {
        let template = "hello}"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsText(result[0], withValue:"hello}"))
    }

    // MARK: - Data Utilities

    func consumeResultIsText(result: ConsumeResult?, withValue text: String) -> Bool {
        if let result = result {
            return tokenIsText(result.0, withValue: text)
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
    
    func consumeResultIsFragment(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsFragment(result.0, withText: text)
        }

        return false
    }
    
    func tokenIsText(token: Token, withValue text: String) -> Bool {
        switch token {
        case .Text(let value):
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
