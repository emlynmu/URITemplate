//
//  OCRFC6570Level4Tests.m
//  URITemplate
//
//  Created by Emlyn Murphy on 9/27/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//
//
//  Level 4 examples from RFC 6570
//
//  URL: https://tools.ietf.org/html/rfc6570
//

#import <XCTest/XCTest.h>
#import <URITemplate/URITemplate.h>

@interface OCRFC6570Level4Tests : XCTestCase

@property (nonatomic, strong) NSDictionary *values;

@end

@implementation OCRFC6570Level4Tests

- (void)setUp {
    [super setUp];

    self.values = @{ @"var": @"value",
                     @"hello": @"Hello World!",
                     @"path": @"/foo/bar",
                     @"list": @[@"red", @"green", @"blue"],
                     @"keys": @[ @[@"semi", @";"],
                                 @[@"dot", @"."],
                                 @[@"comma", @","] ]
                    };
}

- (void)tearDown {
    self.values = nil;

    [super tearDown];
}


// MARK: - String expansion with value modifiers

- (void)testStringExpansionWithValueModifiers1 {
    URITemplate *template = [URITemplate templateWithString:@"{var:3}"];
    NSString *expected = @"val";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testStringExpansionWithValueModifiers2 {
    URITemplate *template = [URITemplate templateWithString:@"{var:30}"];
    NSString *expected = @"value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testStringExpansionWithValueModifiers3 {
    URITemplate *template = [URITemplate templateWithString:@"{list}"];
    NSString *expected = @"red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testStringExpansionWithValueModifiers4 {
    URITemplate *template = [URITemplate templateWithString:@"{list*}"];
    NSString *expected = @"red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testStringExpansionWithValueModifiers5 {
    URITemplate *template = [URITemplate templateWithString:@"{keys}"];
    NSString *expected = @"semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testStringExpansionWithValueModifiers6 {
    URITemplate *template = [URITemplate templateWithString:@"{keys*}"];
    NSString *expected = @"semi=%3B,dot=.,comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Reserved expansion with value modifiers

- (void)testReservedExpansionWithValueModifiers1 {
    URITemplate *template = [URITemplate templateWithString:@"{+path:6}/here"];
    NSString *expected = @"/foo/b/here";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedExpansionWithValueModifiers2 {
    URITemplate *template = [URITemplate templateWithString:@"{+list}"];
    NSString *expected = @"red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedExpansionWithValueModifiers3 {
    URITemplate *template = [URITemplate templateWithString:@"{+list*}"];
    NSString *expected = @"red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedExpansionWithValueModifiers4 {
    URITemplate *template = [URITemplate templateWithString:@"{+keys}"];
    NSString *expected = @"semi,;,dot,.,comma,,";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedExpansionWithValueModifiers5 {
    URITemplate *template = [URITemplate templateWithString:@"{+keys*}"];
    NSString *expected = @"semi=;,dot=.,comma=,";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Fragment expansion with value modifiers

- (void)testFragmentExpansionWithValueModifiers1 {
    URITemplate *template = [URITemplate templateWithString:@"{#path:6}/here"];
    NSString *expected = @"#/foo/b/here";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentExpansionWithValueModifiers2 {
    URITemplate *template = [URITemplate templateWithString:@"{#list}"];
    NSString *expected = @"#red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentExpansionWithValueModifiers3 {
    URITemplate *template = [URITemplate templateWithString:@"{#list*}"];
    NSString *expected = @"#red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentExpansionWithValueModifiers4 {
    URITemplate *template = [URITemplate templateWithString:@"{#keys}"];
    NSString *expected = @"#semi,;,dot,.,comma,,";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentExpansionWithValueModifiers5 {
    URITemplate *template = [URITemplate templateWithString:@"{#keys*}"];
    NSString *expected = @"#semi=;,dot=.,comma=,";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Label expansion, dot-prefixed

- (void)testLabelExpansionDotPrefixed1 {
    URITemplate *template = [URITemplate templateWithString:@"X{.var:3}"];
    NSString *expected = @"X.val";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelExpansionDotPrefixed2 {
    URITemplate *template = [URITemplate templateWithString:@"X{.list}"];
    NSString *expected = @"X.red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelExpansionDotPrefixed3 {
    URITemplate *template = [URITemplate templateWithString:@"X{.list*}"];
    NSString *expected = @"X.red.green.blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelExpansionDotPrefixed4 {
    URITemplate *template = [URITemplate templateWithString:@"X{.keys}"];
    NSString *expected = @"X.semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelExpansionDotPrefixed5 {
    URITemplate *template = [URITemplate templateWithString:@"X{.keys*}"];
    NSString *expected = @"X.semi=%3B.dot=..comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Path segments, slash-prefixed

- (void)testPathSegmentsSlashPrefixed1 {
    URITemplate *template = [URITemplate templateWithString:@"{/var:1,var}"];
    NSString *expected = @"/v/value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegmentsSlashPrefixed2 {
    URITemplate *template = [URITemplate templateWithString:@"{/list}"];
    NSString *expected = @"/red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegmentsSlashPrefixed3 {
    URITemplate *template = [URITemplate templateWithString:@"{/list*}"];
    NSString *expected = @"/red/green/blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegmentsSlashPrefixed4 {
    URITemplate *template = [URITemplate templateWithString:@"{/list*,path:4}"];
    NSString *expected = @"/red/green/blue/%2Ffoo";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegmentsSlashPrefixed5 {
    URITemplate *template = [URITemplate templateWithString:@"{/keys}"];
    NSString *expected = @"/semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegmentsSlashPrefixed6 {
    URITemplate *template = [URITemplate templateWithString:@"{/keys*}"];
    NSString *expected = @"/semi=%3B/dot=./comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Path-style parameters, semicolon-prefixed

//func testPathStyleParametersSemicolonPrefixed1() {
//    let template = URITemplate(string: "{;hello:5}")
//    let expected = ";hello=Hello"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testPathStyleParametersSemicolonPrefixed2() {
//    let template = URITemplate(string: "{;list}")
//    let expected = ";list=red,green,blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testPathStyleParametersSemicolonPrefixed3() {
//    let template = URITemplate(string: "{;list*}")
//    let expected = ";list=red;list=green;list=blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testPathStyleParametersSemicolonPrefixed4() {
//    let template = URITemplate(string: "{;keys}")
//    let expected = ";keys=semi,%3B,dot,.,comma,%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testPathStyleParametersSemicolonPrefixed5() {
//    let template = URITemplate(string: "{;keys*}")
//    let expected = ";semi=%3B;dot=.;comma=%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}

// MARK: - Form-style query, ampersand-separated

//func testFormStyleQueryAmpersandSeparated1() {
//    let template = URITemplate(string: "{?var:3}")
//    let expected = "?var=val"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryAmpersandSeparated2() {
//    let template = URITemplate(string: "{?list}")
//    let expected = "?list=red,green,blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryAmpersandSeparated3() {
//    let template = URITemplate(string: "{?list*}")
//    let expected = "?list=red&list=green&list=blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryAmpersandSeparated4() {
//    let template = URITemplate(string: "{?keys}")
//    let expected = "?keys=semi,%3B,dot,.,comma,%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryAmpersandSeparated5() {
//    let template = URITemplate(string: "{?keys*}")
//    let expected = "?semi=%3B&dot=.&comma=%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}

// MARK: - Form-style query continuation

//func testFormStyleQueryContinuation1() {
//    let template = URITemplate(string: "{&var:3}")
//    let expected = "&var=val"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryContinuation2() {
//    let template = URITemplate(string: "{&list}")
//    let expected = "&list=red,green,blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryContinuation3() {
//    let template = URITemplate(string: "{&list*}")
//    let expected = "&list=red&list=green&list=blue"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryContinuation4() {
//    let template = URITemplate(string: "{&keys}")
//    let expected = "&keys=semi,%3B,dot,.,comma,%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}
//
//func testFormStyleQueryContinuation5() {
//    let template = URITemplate(string: "{&keys*}")
//    let expected = "&semi=%3B&dot=.&comma=%2C"
//    let result = template.expand(values)
//
//    XCTAssert(expected == result, "expected \"\(expected)\"; got \"\(result)\"")
//}

@end
