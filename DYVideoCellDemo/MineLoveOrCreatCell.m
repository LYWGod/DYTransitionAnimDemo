//
//  MineLoveOrCreatCell.m
//  payment
//
//  Created by git on 2021/7/29.
//

#import "MineLoveOrCreatCell.h"
//#import "LoveOrCreatRecordsModel.h"
#import <SDWebImage.h>
#import <Masonry.h>


#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface MineLoveOrCreatCell()

/** 状态按钮 */
@property (nonatomic, strong) UILabel *statusLab;

@end

@implementation MineLoveOrCreatCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}


- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.statusLab.text = titleStr;
}

- (void)setupSubViews
{
    [self.contentView addSubview:self.statusLab];

    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - 懒加载




- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.font = [UIFont systemFontOfSize:25.0f];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.textColor = [UIColor blackColor];
    }
    return _statusLab;
}

@end
