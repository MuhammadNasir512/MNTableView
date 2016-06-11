//
//  MNTableViewPresenter.h
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNTableViewPresenter : NSObject
- (void)loadDataWithCallback:(void (^)(NSArray *items))success;
@end
