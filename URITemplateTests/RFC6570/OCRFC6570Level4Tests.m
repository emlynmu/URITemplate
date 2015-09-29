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

- (void)testPathStyleParametersSemicolonPrefixed1 {
    URITemplate *template = [URITemplate templateWithString:@"{;hello:5}"];
    NSString *expected = @";hello=Hello";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParametersSemicolonPrefixed2 {
    URITemplate *template = [URITemplate templateWithString:@"{;list}"];
    NSString *expected = @";list=red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParametersSemicolonPrefixed3 {
    URITemplate *template = [URITemplate templateWithString:@"{;list*}"];
    NSString *expected = @";list=red;list=green;list=blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParametersSemicolonPrefixed4 {
    URITemplate *template = [URITemplate templateWithString:@"{;keys}"];
    NSString *expected = @";keys=semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParametersSemicolonPrefixed5 {
    URITemplate *template = [URITemplate templateWithString:@"{;keys*}"];
    NSString *expected = @";semi=%3B;dot=.;comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Form-style query, ampersand-separated

- (void)testFormStyleQueryAmpersandSeparated1 {
    URITemplate *template = [URITemplate templateWithString:@"{?var:3}"];
    NSString *expected = @"?var=val";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated2 {
    URITemplate *template = [URITemplate templateWithString:@"{?list}"];
    NSString *expected = @"?list=red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated3 {
    URITemplate *template = [URITemplate templateWithString:@"{?list*}"];
    NSString *expected = @"?list=red&list=green&list=blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated4 {
    URITemplate *template = [URITemplate templateWithString:@"{?keys}"];
    NSString *expected = @"?keys=semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated5 {
    URITemplate *template = [URITemplate templateWithString:@"{?keys*}"];
    NSString *expected = @"?semi=%3B&dot=.&comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

// MARK: - Form-style query continuation

- (void)testFormStyleQueryContinuation1 {
    URITemplate *template = [URITemplate templateWithString:@"{&var:3}"];
    NSString *expected = @"&var=val";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation2 {
    URITemplate *template = [URITemplate templateWithString:@"{&list}"];
    NSString *expected = @"&list=red,green,blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation3 {
    URITemplate *template = [URITemplate templateWithString:@"{&list*}"];
    NSString *expected = @"&list=red&list=green&list=blue";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation4 {
    URITemplate *template = [URITemplate templateWithString:@"{&keys}"];
    NSString *expected = @"&keys=semi,%3B,dot,.,comma,%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation5 {
    URITemplate *template = [URITemplate templateWithString:@"{&keys*}"];
    NSString *expected = @"&semi=%3B&dot=.&comma=%2C";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

@end
