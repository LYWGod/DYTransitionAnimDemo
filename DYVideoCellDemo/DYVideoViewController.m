//
//  DYVideoViewController.m
//  DYVideoCellDemo
//
//  Created by git on 2021/9/4.
//

#import "DYVideoViewController.h"
#import "DYVideoCell.h"


//size
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface DYVideoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger                         pageIndex;
@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, strong) NSMutableArray                   *data;
@property (nonatomic, strong) NSMutableArray                   *awemes;
@property (nonatomic, assign) float sliderTouchEnded;

@end

@implementation DYVideoViewController


-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type{
    
    self = [super init];
    if(self) {
        
        _currentIndex = currentIndex;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _awemeType = type;
        
        _awemes = [data mutableCopy];
        _data = [[NSMutableArray alloc] initWithObjects:[_awemes objectAtIndex:_currentIndex], nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:StatusBarTouchBeginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpView];
}

- (void)setUpView {
    self.view.layer.masksToBounds = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight * 3)];
    _tableView.contentInset = UIEdgeInsetsMake(ScreenHeight, 0, ScreenHeight * 1, 0);
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:DYVideoCell.class forCellReuseIdentifier:NSStringFromClass(DYVideoCell.class)];
    
//    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:3];
//    __weak __typeof(self) wself = self;
//    [_loadMore setOnLoad:^{
//        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
//    }];
//    [_tableView addSubview:_loadMore];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.tableView];
        self.data = self.awemes;
        [self.tableView reloadData];
        
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_tableView.layer removeAllAnimations];
//    NSArray<DYVideoCell *> *cells = [_tableView visibleCells];
//    for(DYVideoCell *cell in cells) {
//        [cell startLoadingPlayItemAnim:NO];
//    }
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"currentIndex"];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //屏幕
//    DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    [cell.player removeVideo];
}

#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    DYVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DYVideoCell.class) forIndexPath:indexPath];
    cell.currentIndex = indexPath.row;
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor redColor] : [UIColor blueColor];
    return cell;
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        NSInteger lastIndex = self.currentIndex;
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        if(translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
            //UITableView滑动到指定cell
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            if (lastIndex == self.currentIndex) {
                
            }else{
                //取消上一个播放器
                DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:0]];
//                [cell.player removeVideo];
            }
            
        } completion:^(BOOL finished) {
            //UITableView可以响应其他滑动手势
            scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
}

- (void)DYVideoCell:(DYVideoCell *)cell sliderTouchEnded:(float)value
{
    _sliderTouchEnded = value;
}

#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
//        _isCurPlayerPause = NO;
        //获取当前显示的cell
        DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        
//        if (_sliderTouchEnded) {
//
//        }else{
//
//        }
//        [cell.player setCurrentVideoProgressValue:30 onSuperView:cell.playerSuperView withUrl:cell.model.url];
//        self.player.isAutoPlay = YES;
//        [self.player startPlay:url];
        
//        [cell.player playVideoWithView:cell.playerSuperView url:cell.model.url];
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    if(!_isCurPlayerPause) {
//        [cell.player resumePlay];
//    }
}

- (void)applicationEnterBackground {
    DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//    _isCurPlayerPause = ![cell.player isPlaying];
//    [cell.player pausePlay];
}



- (void)dealloc {
    NSLog(@"======== dealloc =======");
    DYVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    [cell.player removeVideo];
}


@end
