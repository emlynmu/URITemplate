//
//  RFC6570Examples.swift
//  Subplate
//
//  Created by Emlyn Murphy on 8/17/15.
//  Copyright (c) 2015 Emlyn Murphy. All rights reserved.
//

import UIKit
import XCTest
import Subplate

class RFC6570Examples: XCTestCase {
    func testFirst() {
        let subplate = Subplate("http://www.example.com/foo{?query,number}")
        let expected = "http://www.example.com/foo?query=mycelium&number=100"

        let result = subplate.expand([
            "query": "mycelium",
            "number": 100
            ])

        XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
    }
}
