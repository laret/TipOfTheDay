//
//  ManagedUserTipInfo.h
//  TipOfTheDay
//
//  Created by Tara Cates on 2/8/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ManagedUserTipInfo : NSManagedObject

@property NSString *userName;
@property NSInteger randomNumberSeed;
@property NSInteger currentTipIndex;

+(NSString *)entityName;

@end
