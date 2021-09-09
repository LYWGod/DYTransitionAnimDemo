//
//  DYVideoViewController.h
//  DYVideoCellDemo
//
//  Created by git on 2021/9/4.
//

#import <UIKit/UIKit.h>

#define StatusBarTouchBeginNotification @"StatusBarTouchBeginNotification"


typedef NS_ENUM(NSUInteger, AwemeType) {
    AwemeWork        = 0,
    AwemeFavorite    = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoViewController : UIViewController

@property (nonatomic, assign) NSInteger                         currentIndex;

@property (nonatomic, strong) UITableView *tableView;

-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type;

@end

NS_ASSUME_NONNULL_END
