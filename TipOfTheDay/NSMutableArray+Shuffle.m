//
//  NSMutableArray+Shuffle.m
//  TipOfTheDay
//
//  Created by Tara Cates on 2/9/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffleWithSeed:(time_t)seed
{
    srand((unsigned)seed);
    NSUInteger count = self.count;
    
    for (NSUInteger i=0; i<count; i++) {
        NSUInteger itemsLeftForSwapping = count-i;
        NSUInteger swapIndex = rand() % itemsLeftForSwapping;
        NSDictionary *currentItem = self[i];
        
        self[i] = self[i+swapIndex];
        self[i+swapIndex] = currentItem;
    }
}
@end

@implementation NSArray (Shuffle)

- (NSMutableArray*)mutableArrayOfIndexes
{
    NSMutableArray *array = [NSMutableArray array];
    for(int i=0; i<self.count; i++) {
        [array addObject:@(i)];
    }
    return array;
}

@end
