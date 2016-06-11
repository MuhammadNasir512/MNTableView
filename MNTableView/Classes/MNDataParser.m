//
//  MNDataParser.m
//  MNTableView
//
//  Created by Muhammad Nasir on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "MNDataParser.h"
#import "AppDelegate.h"

static NSString *const MNEntityName = @"MNTableItem";

@interface MNDataParser ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentCoordinator;
@end

@implementation MNDataParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _context = [self managedObjectContext];
        _persistentCoordinator = [self persistentStoreCoordinator];
    }
    return self;
}

- (void)parseData:(NSData*)data callback:(void (^)(NSArray *items))callback {
    // Following one line should be in another file and this class should have single responsibility of managing core data. But I am leaving it here as a future improvement. Since i have limited time to complete this task.
    
    NSArray *rawItems = [self arrayRepresentationOfData:data];
    if (rawItems.count > 0) {
        [self deleteAllItems];
        for (NSDictionary *item in rawItems) {
            [self saveManagedObjectWithItem:item forEntityName:MNEntityName];
        }
    }
    NSArray *items = [self allItemsFromEntity];
    if (callback != nil) {
        callback(items);
    }
}

- (void)saveManagedObjectWithItem:(NSDictionary*)item forEntityName:(NSString*)entityName {
    
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_context];
    [managedObject setValue:item[@"ID"] forKey:@"itemID"];
    [managedObject setValue:item[@"ImageID"] forKey:@"imageID"];
    [managedObject setValue:item[@"Title"] forKey:@"title"];
    [managedObject setValue:item[@"UserID"] forKey:@"userID"];
    [managedObject setValue:item[@"UserName"] forKey:@"userName"];
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://challenge.superfling.com/photos/%@", item[@"ImageID"]];
    [managedObject setValue:imageUrl forKey:@"imageUrl"];
    NSError *error;
    [_context save:&error];
}

- (NSArray*)allItemsFromEntity {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:MNEntityName];
    NSError *error = nil;
    NSArray *items = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        return items;
    }
    return nil;
}

- (void)deleteAllItems {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:MNEntityName];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [_persistentCoordinator executeRequest:deleteRequest withContext:_context error:&deleteError];
}

- (NSManagedObjectContext*)managedObjectContext {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    return context;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSPersistentStoreCoordinator *psc = [appDelegate persistentStoreCoordinator];
    return psc;
}

- (NSArray*)arrayRepresentationOfData:(NSData*)data {
    if (data != nil) {
        NSError *error;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return array;
    }
    return nil;
}

@end
