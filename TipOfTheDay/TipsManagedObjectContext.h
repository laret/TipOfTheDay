//
//  TipsManagedObjectContext.h
//  TipOfTheDay
//
//  Created by Tara Cates on 2/10/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TipsManagedObjectContext : NSManagedObjectContext

+ (NSManagedObjectModel*)managedObjectModel;
+ (NSManagedObjectContext*)sharedContext;

@end
