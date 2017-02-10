//
//  main.m
//  TipOfTheDay
//
//  Created by Tara Cates on 2/8/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMutableArray+Shuffle.h"
#import "TipsGenerator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        while (1) {
            NSLog(@"Please type username and locale, e.g. tara [en], or q to quit.");
            TipsGenerator *tipsGenerator = [[TipsGenerator alloc] init];
            [tipsGenerator parseUserDataFromStandardInput];
            if (![tipsGenerator validUserInfo]) {
                continue;
            }
            if ([tipsGenerator userWouldLikeToQuit]) {
                NSLog(@"goodbye!");
                exit(1);
            }
            
            [tipsGenerator populateUserTipInfoFromCoreData];
            
            NSString *nextTip = [tipsGenerator nextTip];
            NSLog(@"%@", nextTip);

            [tipsGenerator updateIndex];
        }
    }

    return 0;
}
