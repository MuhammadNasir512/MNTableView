//
//  MNDataController.h
//  MNTableView
//
//  Created by Muhammad Nasir on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDataController : NSObject
- (void)loadDataWithCallback:(void (^)(NSData *data))callback;
@end
