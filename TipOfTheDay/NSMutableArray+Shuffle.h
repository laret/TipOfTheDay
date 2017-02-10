//
//  NSMutableArray+Shuffle.h
//  TipOfTheDay
//
//  Created by Tara Cates on 2/9/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSMutableArray (Shuffle)

- (void)shuffleWithSeed:(time_t)seed;

@end

@interface NSArray (Shuffle)

- (NSMutableArray*)mutableArrayOfIndexes;

@end
