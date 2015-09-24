//
//  RFC6570Level2Tests.m
//  URITemplate
//
//  Created by Emlyn Murphy on 9/24/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <URITemplate/URITemplate.h>

@interface RFC6570Level2Tests : XCTestCase

@property (nonatomic, strong) NSDictionary *values;

@end

@implementation RFC6570Level2Tests

- (void)setUp {
    [super setUp];

    self.values = @{ @"var": @"value",
                     @"hello": @"Hello World!",
                     @"path": @"/foo/bar" };
}

- (void)tearDown {
    self.values = nil;

    [super tearDown];
}

- (void)testLevel2Example1 {
    URITemplate *template = [URITemplate templateWithString:@"{+var}"];
    NSString *expected = @"value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result]);
}

- (void)testLevel2Example2 {
    URITemplate *template = [URITemplate templateWithString:@"{+hello}"];
    NSString *expected = @"Hello%20World!";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result]);
}

- (void)testLevel2Example3 {
    URITemplate *template = [URITemplate templateWithString:@"{+path}/here"];
    NSString *expected = @"/foo/bar/here";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result]);
}

- (void)testLevel2Example4 {
    URITemplate *template = [URITemplate templateWithString:@"here?ref={+path}"];
    NSString *expected = @"here?ref=/foo/bar";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result]);
}

@end
