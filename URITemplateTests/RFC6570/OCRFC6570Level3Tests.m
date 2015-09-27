//
//  OCRFC6570Level3Tests.m
//  URITemplate
//
//  Created by Emlyn Murphy on 9/24/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <URITemplate/URITemplate.h>

@interface OCRFC6570Level3Tests : XCTestCase

@property (nonatomic, strong) NSDictionary *values;

@end

@implementation OCRFC6570Level3Tests

- (void)setUp {
    [super setUp];

    self.values = @{ @"var": @"value",
                     @"hello": @"Hello World!",
                     @"empty": @"",
                     @"path": @"/foo/bar",
                     @"x": @1024,
                     @"y": @768 };
}

- (void)tearDown {
    self.values = nil;

    [super tearDown];
}

- (void)testMultipleVariableURITemplate1 {
    URITemplate *template = [URITemplate templateWithString:@"map?{x,y}"];
    NSString *expected = @"map?1024,768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testMultipleVariableURITemplate2 {
    URITemplate *template = [URITemplate templateWithString:@"{x,hello,y}"];
    NSString *expected = @"1024,Hello%20World%21,768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedMultipleVariablesURITemplate1 {
    URITemplate *template = [URITemplate templateWithString:@"{+x,hello,y}"];
    NSString *expected = @"1024,Hello%20World!,768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testReservedMultipleVariablesURITemplate2 {
    URITemplate *template = [URITemplate templateWithString:@"{+path,x}/here"];
    NSString *expected = @"/foo/bar,1024/here";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentMultipleVariablesURITemplate1 {
    URITemplate *template = [URITemplate templateWithString:@"{#x,hello,y}"];
    NSString *expected = @"#1024,Hello%20World!,768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFragmentMultipleVariablesURITemplate2 {
    URITemplate *template = [URITemplate templateWithString:@"{#x,hello,y}"];
    NSString *expected = @"#1024,Hello%20World!,768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelURITemplate1 {
    URITemplate *template = [URITemplate templateWithString:@"X{.var}"];
    NSString *expected = @"X.value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testLabelURITemplate2 {
    URITemplate *template = [URITemplate templateWithString:@"X{.x,y}"];
    NSString *expected = @"X.1024.768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegments1 {
    URITemplate *template = [URITemplate templateWithString:@"{/var}"];
    NSString *expected = @"/value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathSegments2 {
    URITemplate *template = [URITemplate templateWithString:@"{/var,x}/here"];
    NSString *expected = @"/value/1024/here";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParameters1 {
    URITemplate *template = [URITemplate templateWithString:@"{;x,y}"];
    NSString *expected = @";x=1024;y=768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testPathStyleParameters2 {
    URITemplate *template = [URITemplate templateWithString:@"{;x,y,empty}"];
    NSString *expected = @";x=1024;y=768;empty";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated1 {
    URITemplate *template = [URITemplate templateWithString:@"{?x,y}"];
    NSString *expected = @"?x=1024&y=768";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryAmpersandSeparated2 {
    URITemplate *template = [URITemplate templateWithString:@"{?x,y,empty}"];
    NSString *expected = @"?x=1024&y=768&empty=";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation1 {
    URITemplate *template = [URITemplate templateWithString:@"?fixed=yes{&x}"];
    NSString *expected = @"?fixed=yes&x=1024";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

- (void)testFormStyleQueryContinuation2 {
    URITemplate *template = [URITemplate templateWithString:@"{&x,y,empty}"];
    NSString *expected = @"&x=1024&y=768&empty=";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got \"%@\"", expected, result);
}

@end
