//
//  MNTableViewWireframe.m
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "MNTableViewWireframe.h"
#import "MNTableViewPresenter.h"
#import "ViewController.h"

@interface MNTableViewWireframe ()
@property (nonatomic, strong) ViewController *viewController;
@end

@implementation MNTableViewWireframe

- (UIViewController*)mainScreenViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyBoard instantiateInitialViewController];
    _viewController = (ViewController*)viewController;
    _viewController.presenter = [self presenter];
    return viewController;
}

- (MNTableViewPresenter*)presenter {
    MNTableViewPresenter *presenter = [MNTableViewPresenter new];
    return presenter;
}

@end
