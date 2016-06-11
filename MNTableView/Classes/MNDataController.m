//
//  MNDataController.m
//  MNTableView
//
//  Created by Muhammad Nasir on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "MNDataController.h"

@interface MNDataController ()
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *apiURLString;
@end

@implementation MNDataController

- (instancetype)init {
    self = [super init];
    if (nil != self) {
        _apiURLString = @"http://challenge.superfling.com";
    }
    return self;
}

- (void)loadDataWithCallback:(void (^)(NSData *data))callback {
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSURL *url = [NSURL URLWithString:strongSelf.apiURLString];
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock" ofType:@"json"];
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(data);
        });
    });
}

@end
