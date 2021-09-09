//
//  DYVideoCell.m
//  DYVideoCellDemo
//
//  Created by git on 2021/9/4.
//

#import "DYVideoCell.h"

@interface DYVideoCell()

@property (nonatomic,strong) UILabel *textLab;

@end

@implementation DYVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    self.textLab.text = [NSString stringWithFormat:@"当前第 %zd 个Cell",currentIndex];
}


- (void)setupUI
{
    [self.contentView addSubview:self.textLab];
    _textLab.frame = CGRectMake(100, 300, 200, 50);
}

- (UILabel *)textLab
{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.font = [UIFont boldSystemFontOfSize:25];
    }
    return _textLab;
}

@end
