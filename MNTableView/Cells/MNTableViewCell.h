//
//  MNTableViewCell.h
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNTableViewCell : UITableViewCell
- (void)reloadCellWithDataItem:(id)item;
- (void)reloadImage:(UIImage*)image;
- (void)updateBackgroundFrameWithOffset:(CGFloat)offset;
@end
