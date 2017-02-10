//
//  ManagedUserTipInfo.m
//  TipOfTheDay
//
//  Created by Tara Cates on 2/8/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import "ManagedUserTipInfo.h"

@implementation ManagedUserTipInfo

@dynamic userName, currentTipIndex, randomNumberSeed;

+ (NSString *)entityName
{
    return @"UserTipInfo";
}

@end
