//
//  ViewController.h
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNTableViewPresenter;
@class MNTableItem;

@interface ViewController : UIViewController
@property (nonatomic, strong) MNTableViewPresenter *presenter;
@end

