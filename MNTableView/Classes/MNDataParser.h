//
//  MNDataParser.h
//  MNTableView
//
//  Created by Muhammad Nasir on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDataParser : NSObject
- (void)parseData:(NSData*)data callback:(void (^)(NSArray *items))callback;
@end
