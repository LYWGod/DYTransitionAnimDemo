//
//  ViewController.m
//  DYVideoCellDemo
//
//  Created by git on 2021/9/4.
//

#import "ViewController.h"
#import "DYVideoViewController.h"
#import "ScalePresentAnimation.h"
#import "ScaleDismissAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "MineLoveOrCreatCell.h"
#import <Masonry/Masonry.h>


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIViewControllerTransitioningDelegate>

/** 记录数据源 */
@property (nonatomic,strong) NSMutableArray *recordDataSource;
/** collectionView数据源 */
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger      pageIndex;
@property (nonatomic, assign) NSInteger      pageSize;
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    DYVideoViewController *videoVC = [[DYVideoViewController alloc] init];
//    [self.navigationController pushViewController:videoVC animated:YES];
}


#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  section == 1 ? 9 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MineLoveOrCreatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MineLoveOrCreatCell.class) forIndexPath:indexPath];
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor redColor] : [UIColor blueColor];
    cell.titleStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectIndex = indexPath.row;
    
   
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    
    DYVideoViewController *controller = [[DYVideoViewController alloc] initWithVideoData:dataArray currentIndex:indexPath.row pageIndex:_pageIndex pageSize:_pageSize awemeType:0];
   
    controller.transitioningDelegate = self;

    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [_swipeLeftInteractiveTransition wireToViewController:controller];
    
    [self presentViewController:controller animated:YES completion:nil];
   
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipeLeftInteractiveTransition.interacting ? _swipeLeftInteractiveTransition : nil;
}


#pragma mark - UI
- (void)setupUI
{
    
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(120);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
        
    _pageIndex = 1;
    _pageSize = 10;
    
    
    _scalePresentAnimation = [[ScalePresentAnimation alloc] init];
    _scaleDismissAnimation = [[ScaleDismissAnimation alloc] init];
    _swipeLeftInteractiveTransition = [[SwipeLeftInteractiveTransition alloc] init];

}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = (ScreenWidth - 24 - 12) / 3;
        CGFloat height = width * 148 / 113;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 6.0f;
        layout.minimumInteritemSpacing = 6.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MineLoveOrCreatCell class] forCellWithReuseIdentifier:NSStringFromClass(MineLoveOrCreatCell.class)];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);

    }
    return _collectionView;
}


@end
