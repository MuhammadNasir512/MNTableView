//
//  MNTableViewPresenter.m
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "MNTableViewPresenter.h"
#import "MNDataController.h"
#import "MNDataParser.h"

@interface MNTableViewPresenter ()
@property (nonatomic, strong) MNDataController *dataController;
@property (nonatomic, strong) MNDataParser *dataParser;
@end

@implementation MNTableViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataController = [MNDataController new];
        _dataParser = [MNDataParser new];
    }
    return self;
}

- (void)loadDataWithCallback:(void (^)(NSArray *items))success {
    
    __weak typeof(self) weakSelf = self;
    [_dataController loadDataWithCallback:^(NSData *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataParser parseData:data callback:^(NSArray *items) {
            if (success != nil) {
                success(items);
            }
        }];
    }];
}

@end
