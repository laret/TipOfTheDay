//
//  TipsGenerator.m
//  TipOfTheDay
//
//  Created by Tara Cates on 2/10/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import "TipsGenerator.h"

#import "NSMutableArray+Shuffle.h"
#import "ManagedUserTipInfo.h"
#import "TipsManagedObjectContext.h"

@interface TipsGenerator()

@property NSManagedObjectModel *mom;
@property NSManagedObjectContext *context;
@property ManagedUserTipInfo *userInfo;

@end

@implementation TipsGenerator
@synthesize userName;
@synthesize locale;
@synthesize mom;
@synthesize context;
@synthesize randomNumberSeed;
@synthesize currentTipIndex;
@synthesize userInfo;

+ (NSArray <NSDictionary *> *)tips
{
    return @[@{@"[en]": @"I love you.", @"[fr]": @"Je t'aime."},
             @{@"[en]": @"The cat is hungry.", @"[fr]": @"Le chat a faim."},
             @{@"[en]": @"This sentence is untranslateable!"}];
}

+ (NSString*)defaultLocale
{
    return @"[en]";
}

- (id)init
{
    return [self initWithContext:[TipsManagedObjectContext sharedContext] withManagedObjectModel:[TipsManagedObjectContext managedObjectModel]];
}

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext withManagedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
    self = [super init];
    if (self != nil) {
        self.locale = [self.class defaultLocale];
        self.userName = nil;
        self.mom = managedObjectModel;
        self.context = managedObjectContext;
    }
    return self;
}

- (BOOL)validUserInfo
{
    return self.userName != nil;
}

- (BOOL)userWouldLikeToQuit
{
    NSString *userNameString = self.userName;
    
    if ([userNameString isEqualToString:@"q"] || [userNameString isEqualToString:@"quit"]) {
        return YES;
    }
    return NO;
}


- (void)parseUserDataFromStandardInput
{
    NSFileHandle *standardInput = [NSFileHandle fileHandleWithStandardInput];
    NSData *inputData = [standardInput availableData];
    NSString *userString = [[NSString alloc] initWithData:inputData
                                                 encoding:NSUTF8StringEncoding];
    
    // tokenize input by white space
    NSArray <NSString*>*userTokensFromStdIn = [userString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    userTokensFromStdIn = [userTokensFromStdIn filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    
    if (userTokensFromStdIn.count > 0) {
        self.userName = userTokensFromStdIn[0];
    }

    if (userTokensFromStdIn.count > 1) {
        self.locale = userTokensFromStdIn[1];
    }
}

- (void)populateUserTipInfoFromCoreData
{
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[ManagedUserTipInfo entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"userName == %@", self.userName];
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"Error while searching for user(%@) \n%@", self.userName, error);
    }
      
    time_t randomSeed;
    NSUInteger tipIndex;
    
    ManagedUserTipInfo *userTipInfo = [results firstObject];
    if (userTipInfo != nil) {
        randomSeed = userTipInfo.randomNumberSeed;
        tipIndex = userTipInfo.currentTipIndex;
    } else {
        randomSeed = time(NULL);
        tipIndex = 0;
        
        NSEntityDescription *userTipInfoEntity = [[mom entitiesByName] objectForKey:[ManagedUserTipInfo entityName]];
        userTipInfo = [[ManagedUserTipInfo alloc] initWithEntity:userTipInfoEntity
                                                         insertIntoManagedObjectContext:context];
        
        userTipInfo.userName = userName;
        userTipInfo.currentTipIndex = tipIndex;
        userTipInfo.randomNumberSeed = randomSeed;
        
        if (![self.context save:&error]) {
            NSLog(@"Error while saving new user(%@) \n%@", userTipInfo, error);
        }
    }
    self.userInfo = userTipInfo;
    self.randomNumberSeed = randomSeed;
    self.currentTipIndex = tipIndex;
}

- (void)updateIndex
{
    NSUInteger numberOfTips = [[self class] tips].count;
    
    if (self.userInfo.currentTipIndex < numberOfTips) {
        NSError *error = nil;

        self.userInfo.currentTipIndex++;
        
        if (![self.context save:&error]) {
            NSLog(@"Error while saving updated tip index.\n%@",
                  ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
}

- (NSString*)nextTip
{
    return [self nextTipFromTips:[self.class tips]];
}

- (NSString*)nextTipFromTips:(NSArray*)tips
{
    time_t userRandomSeed = self.randomNumberSeed;
    NSUInteger usersCurrentTipIndex = self.currentTipIndex;
    NSString *userLocale = self.locale;
    
    NSMutableArray *shuffledArrayOfIndexes = [tips mutableArrayOfIndexes];
    [shuffledArrayOfIndexes shuffleWithSeed:userRandomSeed];
    
    if (usersCurrentTipIndex < tips.count) {
        NSNumber *randomizedUserTipIndex = shuffledArrayOfIndexes[usersCurrentTipIndex];

        NSDictionary *currentTipsInAllLocales = tips[randomizedUserTipIndex.unsignedIntegerValue];
        NSString *currentTipString = currentTipsInAllLocales[userLocale];
        if (currentTipString == nil) {
            currentTipString = currentTipsInAllLocales[[TipsGenerator defaultLocale]];
        }
        return currentTipString;        
    } else {
        return @"There are no more tips left.";
    }
}

@end
