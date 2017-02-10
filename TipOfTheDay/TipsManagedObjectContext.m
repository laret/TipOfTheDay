//
//  TipsManagedObjectContext.m
//  TipOfTheDay
//
//  Created by Tara Cates on 2/10/17.
//  Copyright © 2017 Tara Cates. All rights reserved.
//

#import "TipsManagedObjectContext.h"

#import "ManagedUserTipInfo.h"

@implementation TipsManagedObjectContext

+ (NSURL *)applicationLogDirectory
{
    NSString *LOG_DIRECTORY = @"CDCLI";
    static NSURL *ald = nil;
    
    if (ald == nil) {
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        NSURL *libraryURL = [fileManager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
        if (libraryURL == nil) {
            NSLog(@"Could not access Library directory\n%@", [error localizedDescription]);
        }
        else {
            ald = [libraryURL URLByAppendingPathComponent:@"Logs"];
            ald = [ald URLByAppendingPathComponent:LOG_DIRECTORY];
            NSDictionary *properties = [ald resourceValuesForKeys:@[NSURLIsDirectoryKey]
                                                            error:&error];
            if (properties == nil) {
                if (![fileManager createDirectoryAtURL:ald withIntermediateDirectories:YES attributes:nil error:&error]) {
                    NSLog(@"Could not create directory %@\n%@", [ald path], [error localizedDescription]);
                    ald = nil;
                }
            }
        }
    }
    return ald;
}

+ (NSManagedObjectContext *)sharedContext
{
    static NSManagedObjectContext *moc = nil;
    
    if (moc != nil) {
        return moc;
    }
    
    NSString *STORE_TYPE = NSXMLStoreType;
    NSString *STORE_FILENAME = @"CDCLI.cdcli";
//    NSString *SUPPORT_DIRECTORY = @"CDCLI";

    /*
     Create the Core Data stack:
     
     * A persistent store coordinator
     * The managed object context.
     
     The persistent store coordinator requires a managed object model; also associate a persistent store.
     Initialize the managed object context for use on the main queue, and set its persistent store coordinator.
     */
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [TipsManagedObjectContext managedObjectModel]];
    
    NSError *error;
    /* Change this path/code to point to your App's data store. */
    NSURL *url = [[[self class] applicationLogDirectory] URLByAppendingPathComponent:STORE_FILENAME];
    
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
        NSLog(@"Store Configuration Failure\n%@",
              ([error localizedDescription] != nil) ?
              [error localizedDescription] : @"Unknown Error");
    }
    
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:coordinator];
    
    return moc;
}


+ (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *mom = nil;
    
    if (mom != nil) {
        return mom;
    }
    
    // Create an entity description object for the UserTipInfo entity.
    NSEntityDescription *userInfoEntity = [[NSEntityDescription alloc] init];
    [userInfoEntity setName:[ManagedUserTipInfo entityName]];
    [userInfoEntity setManagedObjectClassName:@"ManagedUserTipInfo"];
    
    /*
     * Create the attributes for the UserTipInfo entity.
     */
    
    // The 'userName' attribute is type NSStringAttributeType, and it's not optional.
    NSAttributeDescription *userNameAttribute;
    userNameAttribute = [[NSAttributeDescription alloc] init];
    
    [userNameAttribute setName:@"userName"];
    [userNameAttribute setAttributeType:NSStringAttributeType];
    [userNameAttribute setOptional:NO];
    
    NSAttributeDescription *randomNumberSeedAttribute;
    
    randomNumberSeedAttribute = [[NSAttributeDescription alloc] init];
    
    [randomNumberSeedAttribute setName:@"randomNumberSeed"];
    [randomNumberSeedAttribute setAttributeType:NSInteger64AttributeType];
    [randomNumberSeedAttribute setOptional:YES];
    
    // The 'currentTipIndex' attribute should not have a value less than 0
    NSAttributeDescription *currentTipIndexAttribute;
    
    currentTipIndexAttribute = [[NSAttributeDescription alloc] init];
    
    [currentTipIndexAttribute setName:@"currentTipIndex"];
    [currentTipIndexAttribute setAttributeType:NSInteger64AttributeType];
    [currentTipIndexAttribute setOptional:NO];
    [currentTipIndexAttribute setDefaultValue:@0];
    
    NSExpression *lhs = [NSExpression expressionForEvaluatedObject];
    NSExpression *rhs = [NSExpression expressionForConstantValue:@0];
    NSPredicate *validationPredicate = [NSComparisonPredicate
                                        predicateWithLeftExpression:lhs
                                        rightExpression:rhs
                                        modifier:NSDirectPredicateModifier
                                        type:NSGreaterThanOrEqualToPredicateOperatorType
                                        options:0];
    
    NSString *validationWarning = @"current tip index < 0";
    
    [currentTipIndexAttribute setValidationPredicates:@[validationPredicate]
                               withValidationWarnings:@[validationWarning]];
    
    
    [userInfoEntity setProperties:@[userNameAttribute, currentTipIndexAttribute, randomNumberSeedAttribute]];
    
    
    // Create a new managed object model instance, and set the entities of the model to an array containing just the Run entity.
    mom = [[NSManagedObjectModel alloc] init];
    [mom setEntities:@[userInfoEntity]];
    
    // Create a localization dictionary for the model instance, and assign it to the model.
    NSDictionary *localizationDictionary = @{
                                             @"Property/userName/Entity/UserTipInfo":@"User name",
                                             @"Property/randomNumberSeed/Entity/UserTipInfo":@"Random number seed",
                                             @"Property/currentTipIndex/Entity/UserTipInfo":@"Current index into the tip array",
                                             @"ErrorString/current tip index < 0":@"Current index into the tip array must not be less than 0"
                                             };
    
    [mom setLocalizationDictionary:localizationDictionary];
    
    return mom;
}



@end
