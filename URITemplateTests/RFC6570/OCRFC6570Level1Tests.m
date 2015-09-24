//
//  OCRFC6570Level1Tests.m
//  URITemplate
//
//  Created by Emlyn Murphy on 9/24/15.
//  Copyright © 2015 Emlyn Murphy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <URITemplate/URITemplate.h>

@interface OCRFC6570Level1Tests : XCTestCase

@property (nonatomic, strong) NSDictionary *values;

@end

@implementation OCRFC6570Level1Tests

- (void)setUp {
    [super setUp];

    self.values = @{ @"var": @"value",
                     @"hello": @"Hello World!" };
}

- (void)tearDown {
    self.values = nil;

    [super tearDown];
}

- (void)testSimpleStringExpansion1 {
    URITemplate *template = [URITemplate templateWithString:@"{var}"];
    NSString *expected = @"value";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got: \"%@\"", expected, result);
}

- (void)testSimpleStringExpansion2 {
    URITemplate *template = [URITemplate templateWithString:@"{hello}"];
    NSString *expected = @"Hello%20World%21";
    NSString *result = [template expand:self.values];

    XCTAssert([expected isEqualToString:result], @"expected \"%@\"; got: \"%@\"", expected, result);
}

@end
