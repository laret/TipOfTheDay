//
//  TipsGenerator.h
//  TipOfTheDay
//
//  Created by Tara Cates on 2/10/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <CoreData/CoreData.h>
@interface TipsGenerator : NSObject

+ (NSString *)defaultLocale;
+ (NSArray <NSDictionary *> *)tips;

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *locale;
@property NSInteger randomNumberSeed;
@property NSInteger currentTipIndex;

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext withManagedObjectModel:(NSManagedObjectModel *)managedObjectModel;
- (void)parseUserDataFromStandardInput;
- (void)populateUserTipInfoFromCoreData;
- (BOOL)validUserInfo;
- (BOOL)userWouldLikeToQuit;
- (void)updateIndex;
- (NSString*)nextTip;
- (NSString*)nextTipFromTips:(NSArray*)tips;

@end
