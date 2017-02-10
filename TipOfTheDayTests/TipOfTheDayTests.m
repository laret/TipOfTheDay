//
//  TipOfTheDayTests.m
//  TipOfTheDayTests
//
//  Created by Tara Cates on 2/10/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TipsGenerator.h"

@interface TipOfTheDayTests : XCTestCase

@property (nonatomic) TipsGenerator* tipsGenerator;
@property (nonatomic) NSArray <NSDictionary *> *tips;
@end

@implementation TipOfTheDayTests

- (void)setUp {
    [super setUp];
    
    self.tipsGenerator = [[TipsGenerator alloc] initWithContext:nil withManagedObjectModel:nil];
    self.tipsGenerator.userName = @"Tara";
    self.tipsGenerator.randomNumberSeed = 1;
    self.tipsGenerator.currentTipIndex = 0;
    
    self.tips = @[@{@"[en]": @"I love you.", @"[fr]": @"Je t'aime."},
                  @{@"[en]": @"The cat is hungry.", @"[fr]": @"Le chat a faim."},
                  @{@"[en]": @"This sentence is untranslateable!"}];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEnglishLocale {
    self.tipsGenerator.locale = @"[en]";
    NSArray *tips = self.tips;
    
    NSString *nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"The cat is hungry.", nextTip, @"nextTip should be: 'The cat is hungry.'");
    self.tipsGenerator.currentTipIndex++;
    
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"This sentence is untranslateable!", nextTip, @"nextTip should be: 'This sentence is untranslateable!'");

    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"I love you.", nextTip, @"nextTip should be: 'I love you.'");

    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
}

- (void)testFrenchLocale {
    self.tipsGenerator.locale = @"[fr]";
    NSArray *tips = self.tips;

    NSString *nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"Le chat a faim.", nextTip, @"nextTip should be: 'Le chat a faim.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"This sentence is untranslateable!", nextTip, @"nextTip should be: 'This sentence is untranslateable!'");

    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"Je t'aime.", nextTip, @"nextTip should be: 'Je t'aime.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
}

- (void)testSwappingLocales {
    self.tipsGenerator.locale = @"[en]";
    NSArray *tips = self.tips;
    
    NSString *nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"The cat is hungry.", nextTip, @"nextTip should be: 'The cat is hungry.'");
    self.tipsGenerator.currentTipIndex++;
    
    self.tipsGenerator.locale = @"[fr]";
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"This sentence is untranslateable!", nextTip, @"nextTip should be: 'This sentence is untranslateable!'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"Je t'aime.", nextTip, @"nextTip should be: 'Je t'aime.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
    
    self.tipsGenerator.currentTipIndex++;
    nextTip = [self.tipsGenerator nextTipFromTips:tips];
    XCTAssertEqualObjects(@"There are no more tips left.", nextTip, @"nextTip should be: 'There are no more tips left.'");
}

- (void)testDefaultSettings {
    XCTAssertEqualObjects([TipsGenerator defaultLocale], @"[en]", @"The default local should be english");
    
    self.tipsGenerator.userName = @"q";
    XCTAssertTrue([self.tipsGenerator userWouldLikeToQuit], @"Username is 'q' which means the user wants to quit.");
    
    self.tipsGenerator.userName = @"quit";
    XCTAssertTrue([self.tipsGenerator userWouldLikeToQuit], @"Username is 'quit' which means the user wants to quit.");
    
    self.tipsGenerator.userName = nil;
    XCTAssertFalse([self.tipsGenerator validUserInfo], @"Username is nil which should be marked as invalid.");
}

@end
