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
    // MARK: - consumeAllowReservedExpression

    func testConsumeAllowReservedExpressionOnly() {
        let template = "{+hello}"
        let result = consumeAllowReservedExpression(template)
        println("result: \(result)")
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeAllowReservedExpressionWithText() {
        let template = "{+abc}def"
        let result = consumeAllowReservedExpression(template)
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoAllowReservedExpressions() {
        let template = "{+abc}{+def}"
        let result = consumeAllowReservedExpression(template)
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeAllowReservedExpressionFail() {
        let result = consumeAllowReservedExpression("abc{+def}")
        XCTAssert(result == nil)
    }

    func testConsumeAllowReservedExpressionEmpty() {
        let result = consumeAllowReservedExpression("")
        XCTAssert(result == nil)
    }

    func testConsumeAllowReservedExpressionEmptyAllowReservedExpression() {
        let result = consumeAllowReservedExpression("{+}")
        XCTAssert(result == nil)
    }

    func testConsumeAllowReservedExpressionSingleCharacterAllowReservedExpression() {
        let result = consumeAllowReservedExpression("{+x}")
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "x"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeExpression

    func testConsumeExpressionOnly() {
        let template = "{hello}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsExpression(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeExpressionWithText() {
        let template = "{abc}def"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeFirstOfTwoExpressions() {
        let template = "{abc}{def}"
        let result = consumeExpression(template)
        XCTAssert(consumeResultIsExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeExpressionFail() {
        let result = consumeExpression("abc{def}")
        XCTAssert(result == nil)
    }

    func testConsumeExpressionEmpty() {
        let result = consumeExpression("")
        XCTAssert(result == nil)
    }

    func testConsumeExpressionEmptyExpression() {
        let result = consumeExpression("{}")
        XCTAssert(result == nil)
    }

    // MARK: - consumeText

    func testConsumeTextOnlySucceed() {
        let template = "hello"
        let result = consumeText(template)
        XCTAssert(consumeResultIsText(result, withValue: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTextWithExpression() {
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

    // MARK: - consumeToken: AllowReserved Expression

    func testConsumeTokenAllowReservedExpression() {
        let template = "{+hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenAllowReservedExpressionWithText() {
        let template = "{+abc}def"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoAllowReservedExpressions() {
        let template = "{+abc}{+def}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsAllowReservedExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeTokenTextAndAllowReservedExpression() {
        let result = consumeToken(ArraySlice("abc{+def}"))
        XCTAssert(consumeResultIsText(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{+def}"))
    }

    func testConsumeTokenEmptyAllowReservedExpression() {
        let result = consumeToken(ArraySlice("{+}"))
        XCTAssert(consumeResultIsText(result, withValue: "{+}"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    // MARK: - consumeToken: Expression

    func testConsumeTokenExpression() {
        let template = "{hello}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsExpression(result, withText: "hello"))
        XCTAssert(consumeResult(result, hasRemainder: ""))
    }

    func testConsumeTokenExpressionWithText() {
        let template = "{abc}def"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "def"))
    }

    func testConsumeTokenFirstOfTwoExpressions() {
        let template = "{abc}{def}"
        let result = consumeToken(ArraySlice(template))
        XCTAssert(consumeResultIsExpression(result, withText: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeTokenTextAndExpression() {
        let result = consumeToken(ArraySlice("abc{def}"))
        XCTAssert(consumeResultIsText(result, withValue: "abc"))
        XCTAssert(consumeResult(result, hasRemainder: "{def}"))
    }

    func testConsumeTokenEmpty() {
        let result = consumeToken(ArraySlice(""))
        XCTAssert(result == nil)
    }

    func testConsumeTokenEmptyExpression() {
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

    func testConsumeTokenTextWithExpression() {
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

    func testTokenizeWithExpressionOnly() {
        let template = "{hello}"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsExpression(result[0], withText:"hello"))
    }

    func testTokenizeWithAllowReservedExpressionOnly() {
        let template = "{+hello}"
        let result = tokenize(template)
        XCTAssert(result.count == 1)
        XCTAssert(tokenIsAllowReservedExpression(result[0], withText:"hello"))
    }

    func testTokenizeTextWithExpression() {
        let template = "hello{there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsExpression(result[1], withText:"there"))
    }

    func testTokenizeTextWithAllowReservedExpression() {
        let template = "hello{+there}"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsAllowReservedExpression(result[1], withText:"there"))
    }

    func testTokenizeExpressionWithText() {
        let template = "{hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsExpression(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
    }

    func testTokenizeAllowReservedExpressionWithText() {
        let template = "{+hello}there"
        let result = tokenize(template)

        XCTAssert(result.count == 2)
        XCTAssert(tokenIsAllowReservedExpression(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
    }

    func testTokenizeExpressionTextExpression() {
        let template = "{hello}there{monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsExpression(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
        XCTAssert(tokenIsExpression(result[2], withText:"monkey"))
    }

    func testTokenizeAllowReservedExpressionTextAllowReservedExpression() {
        let template = "{+hello}there{+monkey}"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsAllowReservedExpression(result[0], withText:"hello"))
        XCTAssert(tokenIsText(result[1], withValue:"there"))
        XCTAssert(tokenIsAllowReservedExpression(result[2], withText:"monkey"))
    }

    func testTokenizeTextExpressionText() {
        let template = "hello{there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsExpression(result[1], withText:"there"))
        XCTAssert(tokenIsText(result[2], withValue:"monkey"))
    }

    func testTokenizeTextAllowReservedExpressionText() {
        let template = "hello{+there}monkey"
        let result = tokenize(template)

        XCTAssert(result.count == 3)
        XCTAssert(tokenIsText(result[0], withValue:"hello"))
        XCTAssert(tokenIsAllowReservedExpression(result[1], withText:"there"))
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

    func consumeResultIsExpression(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsExpression(result.0, withText: text)
        }

        return false
    }

    func consumeResultIsAllowReservedExpression(result: ConsumeResult?, withText text: String) -> Bool {
        if let result = result {
            return tokenIsAllowReservedExpression(result.0, withText: text)
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

    func tokenIsExpression(token: Token, withText text: String) -> Bool {
        switch token {
        case .Expression(let value):
            return text == String(value)

        default:
            return false
        }
    }

    func tokenIsAllowReservedExpression(token: Token, withText text: String) -> Bool {
        switch token {
        case .AllowReservedExpression(let value):
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
