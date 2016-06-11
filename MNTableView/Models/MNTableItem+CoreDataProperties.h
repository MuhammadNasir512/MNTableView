//
//  MNTableItem+CoreDataProperties.h
//  MNTableView
//
//  Created by Muhammad Nasir on 10/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MNTableItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MNTableItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *imageID;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *itemID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *userName;

@end

NS_ASSUME_NONNULL_END
