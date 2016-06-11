//
//  ViewController.m
//  MNTableView
//
//  Created by Ali, Muhammad on 08/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "ViewController.h"
#import "MNTableViewPresenter.h"
#import "MNTableViewCell.h"
#import "MNTableItem.h"
#import "UIImage+MNImageResize.h"

static NSString *const CELL_ID = @"MNTableViewCell";
static NSString *const KeyOperation = @"KeyOperation";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _cellHeight;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *runningOperations;
@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [_imageCache removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = 180.0f;

    [self setupOperationQueuesAndCache];
    [self setupTableView];
    [self reloadUI];
}

- (void)reloadUI {
    [_refreshControl endRefreshing];
    
    __weak typeof(self) weakSelf = self;
    [_presenter loadDataWithCallback:^(NSArray *items) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.items = items;
        [strongSelf.tableView reloadData];
    }];
}

- (void)setupTableView {
    [_tableView registerClass:[MNTableViewCell class] forCellReuseIdentifier:CELL_ID];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadUI) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    _refreshControl = refreshControl;
}

- (void)setupOperationQueuesAndCache {
    _runningOperations = [[NSMutableArray alloc] initWithCapacity:0];
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 40;
    _imageCache = [[NSCache alloc] init];
    _imageCache.countLimit = 40;
}

- (NSDictionary*)operationWithItem:(MNTableItem*)item {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"KeyImageId = %@", item.imageID];
    NSArray *filteredArray = [_runningOperations filteredArrayUsingPredicate:filter];
    NSDictionary *cachedItem = [filteredArray firstObject];
    return cachedItem;
}

- (void)loadImageWithItem:(MNTableItem*)item atIndexPath:(NSIndexPath *)indexPath maxSize:(CGSize)maxSize {
    __weak typeof(self) weakSelf = self;
    __block typeof(item) blockItem = item;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    operation.qualityOfService = NSQualityOfServiceUserInteractive;
    [operation addExecutionBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSURL *url = [NSURL URLWithString:blockItem.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage resizeImage:[UIImage imageWithData:data] constraintToSize:maxSize];
        
        if (image != nil) {
            [strongSelf.imageCache setObject:image forKey:blockItem.imageUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MNTableViewCell *cell = (MNTableViewCell*)[[strongSelf tableView] cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [cell reloadImage:image];
                }
            });
        }
    }];
    
    [operation setCompletionBlock:^{
        NSDictionary *operationItem = [self operationWithItem:blockItem];
        [_runningOperations removeObject:operationItem];
    }];
    
    NSDictionary *runningOpItem = [[NSDictionary alloc] initWithObjectsAndKeys:operation, KeyOperation, item.imageID, @"KeyImageId", nil];
    [_runningOperations addObject:runningOpItem];
    [_imageOperationQueue addOperation:operation];
}

#pragma Mark Parallax Effects

- (void)updateBackgroundFrameForCell:(MNTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    CGRect cellRect = [_tableView rectForRowAtIndexPath:indexPath];
    CGRect cellPositionOnScreen = [_tableView convertRect:cellRect toView:_tableView.superview];
    CGFloat cellOffset = cellPositionOnScreen.origin.y + cellPositionOnScreen.size.height;
    CGFloat tableViewHeight = _tableView.bounds.size.height + cellPositionOnScreen.size.height;
    CGFloat cellOffsetFactor = cellOffset / tableViewHeight;
    [cell updateBackgroundFrameWithOffset:cellOffsetFactor];
}

#pragma Mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        cell = [[MNTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MNTableItem *item = (MNTableItem*)_items[indexPath.row];
    [cell reloadCellWithDataItem:item];
    
    UIImage *imageFromCache = [_imageCache objectForKey:item.imageUrl];
    if (imageFromCache) {
        [cell reloadImage:imageFromCache];
    }
    else {
        CGFloat maxW = CGRectGetWidth(tableView.bounds) * 1.5f;
        CGFloat maxH = CGRectGetHeight(tableView.bounds) * 1.5f;
        [self loadImageWithItem:item atIndexPath:indexPath maxSize:CGSizeMake(maxW, maxH)];
    }
    return cell;
}

#pragma Mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MNTableItem *item = (MNTableItem*)_items[indexPath.row];
    NSDictionary *operationItem = [self operationWithItem:item];
    NSBlockOperation *operation = (NSBlockOperation*)operationItem[KeyOperation];
    if (operation.executing) {
        [operation cancel];
        [_runningOperations removeObject:operationItem];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateBackgroundFrameForCell:(MNTableViewCell *)cell atIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        NSArray *indexPathsVisible = [_tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in indexPathsVisible) {
            MNTableViewCell *cell = (MNTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
            [self updateBackgroundFrameForCell:cell atIndexPath:indexPath];
        }
    }
}

@end
