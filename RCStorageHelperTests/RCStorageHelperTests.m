//
//  RCStorageHelperTests.m
//  RCStorageHelperTests
//
//  Created by Looping on 14-4-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+RCStorage.h"

@interface RCStorageHelperTests : XCTestCase

@end

@implementation RCStorageHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSStringStorageAddition {
    NSString *string = @"you_1_are_2_so_3_cute_4";
    NSString *theNewString = [string convertFromUnderscoreCaseToCamelCase];

    NSAssert([theNewString isEqualToString:@"you1Are2So3Cute4"], @"convertFromUnderscoreCaseToCamelCase error");
    
    NSString *theNewNewString = [theNewString convertFromCamelCaseToUnderscoreCase];

    NSAssert([theNewNewString isEqualToString:string], @"convertFromCamelCaseToUnderscoreCase error");

}

@end
